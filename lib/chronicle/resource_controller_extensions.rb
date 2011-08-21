module Chronicle::ResourceControllerExtensions
  def self.included(base)
    base.class_eval do
      alias_method_chain :load_model, :version
      alias_method_chain :clear_model_cache, :draft_awareness
      before_filter :set_status, :only => [:create, :update]
    end
  end
  
  def load_model_with_version
    model = load_model_without_version
    unless %w(remove destroy).include?(action_name) ||
      (action_name == "update" && params["page"] && params["page"]["status_id"].to_i >= Status[:published].id)
        self.model = case
        when params[:version] && version = model.versions.get_version(params[:version].to_i)
          flash[:notice] = I18n.t('chronicle.loaded_version_click_save', :version => version.number)
          version.instance
        when model.respond_to?(:current) && model.respond_to?(:versions)
          # check for both 'current' and 'versions' methods because some other extensions use the current
          # method.  The reader extension is known to do this, but there may be others
          model.current
        else
          model
        end
    end
  end
  
  def clear_model_cache_with_draft_awareness
    # Don't clear the cache if it's unpublished
    # (but do if it's unversioned)
    if !model.respond_to?(:status_id) || model.status_id >= Status[:published].id
      clear_model_cache_without_draft_awareness
    end
  end
  
  def set_status
    if model.respond_to?(:status_id)
      params[model_symbol][:status_id] = params[:publish] ? Status['Published'].id : Status['Draft'].id
    end
  end
end