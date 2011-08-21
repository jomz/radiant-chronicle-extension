module Chronicle::Interface
  def self.included(base)
    base.class_eval {
      before_filter :add_chronicle_stylesheet, :only => [:index, :edit, :new, :create, :update]
      before_filter :add_chronicle_javascript, :only => [:edit, :new, :create, :update]
      include InstanceMethods
      helper 'admin/timeline'
    }
  end
  
  module InstanceMethods
    def add_chronicle_stylesheet
      include_stylesheet 'admin/chronicle'
      include_stylesheet 'admin/jquery.cluetip'
    end
    def add_chronicle_javascript
      include_javascript 'admin/jquery-1.4.2.min'
      include_javascript 'admin/jquery-cluetip/jquery.cluetip.min'
      include_javascript 'admin/chronicle'
    end
  end
end