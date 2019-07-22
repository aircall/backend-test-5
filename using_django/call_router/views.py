from datetime import timedelta

from django.urls import reverse
from django_twilio.decorators import twilio_view
from twilio.twiml.voice_response import VoiceResponse, Gather

from call_router.models import Call, CALL_INCOMING, CALL_REDIRECTED, CALL_RECORDING, CALL_MESSAGE_LEFT


@twilio_view
def incoming(request):
    """Respond to incoming phone calls with a digits menu."""

    call_sid = request.POST["CallSid"]
    caller = request.POST["Caller"]

    if not Call.objects.filter(call_sid=call_sid).exists():
        call = Call(call_sid=call_sid, status=CALL_INCOMING, caller=caller)
        call.save()

    # Start our TwiML response
    response = VoiceResponse()

    # Gather the user inputs
    gather = Gather(num_digits=1, action=reverse('gather'), timeout=30)
    gather.say("Press 1 to be redirected to Raphaël. Press 2 to leave a message.")
    response.append(gather)

    # If the user doesn't select an option, redirect them into a loop
    response.redirect(reverse('incoming'))

    return response


@twilio_view
def gather(request):
    """Processes results from the <Gather> prompt from /incoming"""
    # Start our TwiML response
    response = VoiceResponse()

    # If Twilio's request to our app included already gathered digits, process them
    if 'Digits' in request.POST:
        # Get which digit the caller chose
        choice = request.POST['Digits']

        call_sid = request.POST["CallSid"]
        call = Call.objects.get(call_sid=call_sid)
        call.input_sequence = call.input_sequence + choice

        # Take actions depending on the caller's choice
        if choice == '1':
            call.status = CALL_REDIRECTED
            call.save()

            response.say('Redirecting to Raphaël!')
            response.dial(number="+33 6 45 45 12 36")
            return response
        elif choice == '2':
            call.status = CALL_RECORDING
            call.save()

            response.say('Please leave your message after the beep. Press star to finish your message')
            response.record(
                action=reverse("record"),
                trim=True,
                play_beep=True,
                finish_on_key='*'
            )
            # End the call with <Hangup>
            response.hangup()
            return response
        else:
            call.save()
            # If the caller didn't choose 1 or 2, apologize
            response.say("Sorry, I don't understand that choice.")

    # If the user didn't choose 1 or 2 (or anything), send them back to the menu
    response.redirect(reverse('incoming'))

    return response


@twilio_view
def record(request):
    """Receive the record data"""
    response = VoiceResponse()

    # Fetch the call object
    call_sid = request.POST["CallSid"]
    call = Call.objects.get(call_sid=call_sid)

    duration_in_seconds = int(request.POST["RecordingDuration"])

    # Save call data
    call.audio_message_url = request.POST["RecordingUrl"]
    call.audio_message_duration = timedelta(seconds=duration_in_seconds)
    call.status = CALL_MESSAGE_LEFT
    call.save()

    # Say goodbye
    response.say('Your message has been registered! Thank you and goodbye.')
    response.hangup()
    return response
