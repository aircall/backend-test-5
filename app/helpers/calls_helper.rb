module CallsHelper

  def human_scenario_name(number)
    case number
    when 1
      I18n.t('.calls.forwarded')
    when 2
      I18n.t('.calls.voice_message')
    else
      I18n.t('.calls.other')
    end
  end
end
