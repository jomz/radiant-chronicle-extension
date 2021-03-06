require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../shared/resource_controller'

describe Admin::LayoutsController do
  dataset :users, :layouts
  
  it_should_behave_like("versioned resource controller")
  
  before :each do
    login_as :admin
  end

  describe "editing a layout" do
    integrate_views
    
    before :each do
      @layout = layouts(:main)
      @layout.update_attributes(:content => "foobar", :status_id => Status[:draft].id)
    end
    
    def do_get
      get :edit, :id => @layout.id
    end
    
    it "should load the latest version of the layout" do
      do_get
      assigns[:layout].content.should == "foobar"
    end
  end
end