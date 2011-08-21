module Admin::TimelineHelper
  
  def marker_for_version(version)
    case
    when version.only_visible_in_dev_mode? && version.current?
      marker(:dev)
    when version.current?
      marker("dev-and-live")
    when version.current_live?
      marker(:live)
    end
  end
  
  def marker(type)
    type = type.to_s
    link_to image_tag("/images/admin/chronicle/#{type}.png", :class => "marker", :id => "#{type}-marker"), "#", :class => "version-link"
  end
  
  def version_icon(version)
    data_url = summary_admin_version_path(version)
    icon = tag(:img, :id=>"version-#{version.number}-icon", :src=>"/images/admin/chronicle/#{version.instance.status.name.downcase}.png", :class=>"timeline-icon")
    link_to icon, admin_version_path(version), :rel => data_url, :class => "version-link"
  end
  
  def working_version_node
    content_tag(:li, :id => "working-version") do
      tag(:img, :id=>"working-version-icon", :src=>"/images/admin/chronicle/working.png", :class=>"timeline-icon") + 
      marker(:this)
    end
  end
  
  def versions_for_timeline
    @versions_for_timeline ||= version_model.versions_with_limit(MAX_VERSIONS_VISIBLE_IN_TIMELINE)
  end
  
  def version_class(index)
    if (index+1) == versions_for_timeline.size
      "beginning"
    else
      ''
    end
  end
  
  def version_model
    (@version && @version.instance) || model
  end
end
