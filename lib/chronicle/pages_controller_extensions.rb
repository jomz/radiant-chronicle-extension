module Chronicle::PagesControllerExtensions
  def self.included(base)
    base.class_eval {
      helper 'admin/timeline'
      include Admin::TimelineHelper
    }
  end
end