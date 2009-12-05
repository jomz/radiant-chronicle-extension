module Admin::PreviewHelper
  def live_page_url(page)
    site_preview_url(:live, page)
  end

  def dev_page_url(page)
    site_preview_url(:dev, page)
  end
  
  def site_preview_url(mode, page)
    page = mode == :dev ? page.current_dev : page.current_live
    protocol = (@controller || self).request.protocol
    host = (@controller || self).request.host
    host = case mode
    when :dev
      Radiant::Config['dev.host'] || ("dev." + host)
    when :live
      Radiant::Config['live.host'] || host
    end
    port = (@controller || self).request.port
    port = ([80, 443].include?(port.to_i)) ? "" : ":#{port}"
    protocol + host + port + page.url
  end
end