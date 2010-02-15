module Chronicle::HelperExtensions
  def self.included(base)
    base.class_eval do
      include InstanceMethods
      alias_method_chain :save_model_button, :publication unless defined? save_model_button_without_publication
      alias_method_chain :save_model_and_continue_editing_button, :view_page unless defined? save_model_and_continue_editing_button_without_view_page
    end
  end
  
  module InstanceMethods
    def save_model_button_with_publication(model, options = {})
      html = save_model_button_without_publication(model, options)
      if model.class.versioned? && model.versioning_enabled?
        html += " and "
        html += check_box_tag 'publish', '1', false
        html += label_tag "publish", "publish", :class => 'publisher'
      end
      html
    end

    def save_model_and_continue_editing_button_with_view_page(model, options = {})
      html = check_box_tag 'continue', '1', false
      html += label_tag "continue", "continue editing"
      if model.is_a? Page
        html += check_box_tag 'view_after_saving', '1', session[:view_after_saving]
        html += label_tag "view_after_saving", "preview page"
      end
      html
    end
  end
  
end

