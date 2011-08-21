module Chronicle::HelperExtensions
  def self.included(base)
    base.class_eval do
      include InstanceMethods
      include Admin::TimelineHelper
      alias_method_chain :save_model_button, :publication unless defined? save_model_button_without_publication
      alias_method_chain :save_model_and_continue_editing_button, :view_page unless defined? save_model_and_continue_editing_button_without_view_page
    end
  end
  
  module InstanceMethods
    def save_model_button_with_publication(model, options = {})
      html = save_model_button_without_publication(model, options)
      if model.class.versioned? && model.versioning_enabled?
        html += I18n.t('chronicle.and') + " "
        html += check_box_tag 'publish', '1', false
        html += label_tag "publish", I18n.t('chronicle.publish'), :class => 'publisher'
      end
      html
    end

    def save_model_and_continue_editing_button_with_view_page(model, options = {})
      if model.class.versioned? && model.versioning_enabled?
        html = check_box_tag 'continue', '1', false
        html += label_tag "continue", I18n.t('chronicle.continue_editing')
      else
        save_model_and_continue_editing_button_without_view_page(model)
      end
      html
    end
  end
  
end

