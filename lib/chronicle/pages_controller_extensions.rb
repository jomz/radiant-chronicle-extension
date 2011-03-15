module Chronicle::PagesControllerExtensions
  def self.included(base)
    base.class_eval {
      helper 'admin/preview'
      include Admin::PreviewHelper
    }
  end
end