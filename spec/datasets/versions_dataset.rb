class VersionsDataset < Dataset::Base
  uses :home_page, :users
  
  def load
    create_versioned_page "Published", :published_at => 1.minute.ago
    create_versioned_page "Draft", :status_id => Status[:draft].id
    create_versioned_page "Page with Draft", :published_at => 1.minute.ago do
      create_version :status_id => Status[:draft].id
    end
    create_versioned_page "Page with Reviewed" do
      create_version :status_id => Status[:reviewed].id
    end
    create_versioned_page "Reviewed", :status_id => Status[:reviewed].id
    create_versioned_page "Hidden", :status_id => Status[:hidden].id
    create_versioned_page "Published with many versions", :published_at => 1.minute.ago do
      create_version
      create_version
    end
    create_versioned_page "Draft with many versions", :status_id => Status[:draft].id do
      create_version
      create_version
    end
    create_versioned_page "Updated by existing" do
      UserActionObserver.current_user = users(:existing)
      create_version :published_at => 2.minutes.ago
#      create_version :published_at => 1.minute.ago
    end
    create_versioned_page "Archive", :class_name => "ArchivePage"
    create_versioned_page "File Not Found" do
      create_version :status_id => Status[:draft].id, :title => "Draft File Not Found"
    end
  end
  
  helpers do
    def create_versioned_page(name, attributes={}, &block)
      UserActionObserver.current_user = users(:admin)
      create_page(name, attributes) do
        create_default_versioned_part(name, attributes)
        create_version
        block.call if block_given?
      end
    end
    def create_default_versioned_part(name, attributes={})
      symbol = name.symbolize
      body = attributes.delete(:body) || name
      if pages(symbol).parts.empty?
        create_page_part "#{name}_body".symbolize, :name => "body", :content => body + ' body.', :page_id => page_id(symbol)
      end
    end
    def create_version(attributes={})
      page = Page.find(@current_page_id)
      page.update_attributes(attributes)
      page
    end
  end
  
end