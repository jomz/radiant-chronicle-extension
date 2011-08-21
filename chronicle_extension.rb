# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class ChronicleExtension < Radiant::Extension
  version "2.0"
  description "Keeps historical versions of pages and allows drafts of published pages."
  url "http://github.com/jgarber/radiant-chronicle-extension/"

  ::MAX_VERSIONS_VISIBLE_IN_TIMELINE = 14

  def activate
    require 'chronicle/diff'
    ActiveRecord::Base.send :include, Chronicle::Versioned      # defines Class.versioned? method to complement Class#versioning_emabled?
    ActiveRecord::Base::VersionsProxyMethods.class_eval { include Chronicle::VersionsProxyMethods }
    ActiveRecord::Associations::AssociationCollection.class_eval { include Chronicle::AssociationCollectionExtensions }
    Version.class_eval { include Chronicle::VersionExtensions }
    Page.class_eval do 
      include Chronicle::PageExtensions
      include Chronicle::Tags
    end
    PagePart.class_eval { include Chronicle::PagePartExtensions }
    Snippet.class_eval { include Chronicle::SimpleModelExtensions }
    Layout.class_eval { include Chronicle::SimpleModelExtensions }

    Admin::ResourceController.class_eval { include Chronicle::ResourceControllerExtensions }
    Admin::PagesController.class_eval { include Chronicle::Interface }
    Admin::SnippetsController.class_eval { include Chronicle::Interface }
    Admin::LayoutsController.class_eval { include Chronicle::Interface }

    ApplicationHelper.send :include, Chronicle::HelperExtensions

    admin.page.edit.add :form_bottom, "admin/timeline", :before => "edit_buttons"
    admin.page.edit.add :main, 'admin/version_diff_popup'
    admin.page.edit.add :main, 'open_preview_window'
    admin.snippet.edit.add :form_bottom, "admin/timeline", :before => "edit_buttons"
    admin.snippet.edit.add :main, 'admin/version_diff_popup'
    admin.layout.edit.add :form_bottom, "admin/timeline", :before => "edit_buttons"
    admin.layout.edit.add :main, 'admin/version_diff_popup'

    tab 'Content' do
      add_item 'History', '/admin/versions/', :visibility => [:all]
    end
  end

end
