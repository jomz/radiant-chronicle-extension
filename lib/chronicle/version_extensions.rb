module Chronicle::VersionExtensions
  # Return an instance of the versioned ActiveRecord model with the attribute
  # values and page parts of this version.  Initializes it just like #find so 
  # you can compare objects.
  def instance(reload=false)
    if reload || @instance.nil?
      attributes = YAML::load( self.yaml )
      associations = (attributes.keys - versionable.class.column_names).map {|k| [k,attributes[k]] }

      obj = versionable.class.send(:instantiate, attributes)
      associations.each do |var_name,var_value|
        obj.__send__( "#{var_name}=", var_value )
      end
      @instance = obj
    end
    @instance
  end
  
  def saved_by
    instance.updated_by || instance.created_by
  end
  
  def current?
    versionable.versions.current.number == self.number
  end
  alias_method :current_dev?, :current?
  
  def current_live?
    current_live = versionable.versions.find(:first, :conditions => "status_id >= #{Status[:published].id}", :order => 'number DESC')
    current_live && (current_live.number == self.number)
  end
  
  def only_visible_in_dev_mode?
    status_id < Status[:published].id
  end
  
  def diff
    if previous
      previous.instance.diff(self.instance)
    else
      self.instance.diff
    end
  end
end