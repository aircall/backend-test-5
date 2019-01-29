module CallsHelper

  def human_choice_name(choice)
    case choice.to_sym
    when :forwarding
      I18n.t('.calls.forwarding')
    when :voice_recording
      I18n.t('.calls.voice_recording')
    else
      I18n.t('.calls.other')
    end
  end
end
