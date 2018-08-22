module Webhookable
extend ActiveSupport::Concern

  def set_xml_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render plain: response.text
  end

end