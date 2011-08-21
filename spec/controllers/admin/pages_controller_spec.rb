require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../shared/resource_controller'

describe Admin::PagesController do
  dataset :versions

  it_should_behave_like("versioned resource controller")

  before :each do
    login_as :existing
  end
  
  describe "editing a page" do
    integrate_views
    
    before(:each) do
      @page = pages(:published)
      @page.save # version 1
      @page.title = "Draft of First"
      @page.status = Status[:draft]
      @page.save # version 2
    end
    
    it "should load the current version for editing" do
      get :edit, :id => @page.id
      
      assigns[:page].title.should == @page.current.title
      assigns[:page].lock_version.should == @page.current.lock_version
    end
    
    it "should load a specified version for editing" do
      get :edit, :id => @page.id, :version => 1
      
      assigns[:page].title.should == @page.versions.first_version.instance.title
      assigns[:page].lock_version.should == @page.current.lock_version
    end
  end
  
  describe "saving a page" do
    it "should clear the page cache when a page is saved with the publish flag set" do
      Radiant::Cache.should_receive(:clear)
      put :update, :id => page_id(:published), :publish => "1", :page => {:breadcrumb => 'Foo'}
    end
    
    # it "should clear the page cache when a hidden page is saved" do
    #   Radiant::Cache.should_receive(:clear)
    #   put :update, :id => page_id(:home), :page => {:breadcrumb => 'Homepage', "status_id"=>Status[:hidden].id.to_s}
    # end
        
    it "should not clear the page cache when a page is saved without the publish flag set" do
      Radiant::Cache.should_not_receive(:clear)
      put :update, :id => page_id(:home), :page => {:breadcrumb => 'Homepage'}
    end
    
    # it "should not clear the page cache when a reviewed page is saved" do
    #   Radiant::Cache.should_not_receive(:clear)
    #   put :update, :id => page_id(:home), :page => {:breadcrumb => 'Homepage', "status_id"=>Status[:reviewed].id.to_s}
    # end
  end
  
  describe "deleting a page" do
    integrate_views
    
    before :each do
      @page = pages(:published)
      @page.update_attributes(:title => "current", :status_id => Status[:draft].id)
    end
    
    it "should load the live version of the page" do
      get :remove, :id => @page.id
      assigns[:page].title.should_not =~ /current/
    end
    
    it "should be destroyed" do
      delete :destroy, :id => @page.id
      get :edit, :id => @page.id
      flash[:notice].should =~ /could not be found/
    end
  end
  
  def params_for_page(page)
    {"slug"=>page.slug, "class_name"=>page.class_name, "title"=>page.title, "breadcrumb"=>page.breadcrumb, "lock_version"=>page.lock_version, "parts_attributes"=>[{"name"=>"body", "filter_id"=>"", "content"=>"test"}], "status_id"=>page.status_id, "layout_id"=>page.layout_id, "parent_id"=>page.parent_id}
  end
end