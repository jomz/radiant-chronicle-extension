require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/versions/summary" do
  dataset :versions
  
  describe "first version" do
    before do
      @version = pages(:updated_by_existing).versions.first
      assigns[:version] = @version
      render 'admin/versions/summary'
    end
    
    it "should display the created_by name instead of the updated_by name" do
      response.should have_selector("span.version-author", :content => "Admin")
    end
    
  end

  describe "second version" do
    before do
      @version = pages(:updated_by_existing).versions.current
      @version.instance.stub!(:updated_at).and_return 1.hour.ago
      assigns[:version] = @version
      render 'admin/versions/summary'
    end 
  
    it "should display the version number" do
      response.should have_selector("div.popup_title", :content => "Version 2")
    end
  
    it "should display the author" do
      response.should have_selector("span.version-author", :content => "Existing")
    end
  
    it "should display the update time in abbreviated form" do
      response.should have_selector("abbr", :content => "about 1 hour ago")
    end
  
    it "should display the status" do
      response.should have_selector("span.version-status", :content => "published")
    end
    
    it "should display the diff link" do
      response.should have_selector("a.diff-link")
    end
  end
  
  it "should display the update time in extended form in abbr title" do
    @version = pages(:updated_by_existing).versions.current
    @version.instance.stub!(:updated_at).and_return Time.utc(2009,1,1,13,57)
    assigns[:version] = @version
    render 'admin/versions/summary'
    
    response.should have_selector("abbr", :title => "Thu Jan 01 13:57:00 UTC 2009")
  end
end
