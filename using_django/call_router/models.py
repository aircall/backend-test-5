from django.db import models


CALL_INCOMING = "INCOMING"
CALL_RECORDING = "RECORDING"
CALL_REDIRECTED = "REDIRECTED"
CALL_MESSAGE_LEFT = "MESSAGE_LEFT"

CALL_STATUSES = [
    CALL_INCOMING,
    CALL_RECORDING,
    CALL_REDIRECTED,
    CALL_MESSAGE_LEFT,
]


class Call(models.Model):
    call_sid = models.CharField(max_length=200, db_index=True, unique=True)
    status = models.CharField(max_length=20)
    added = models.DateTimeField(db_index=True, auto_now_add=True)
    caller = models.CharField(max_length=20)
    audio_message_url = models.TextField(null=True)
    audio_message_duration = models.DurationField(null=True)
    input_sequence = models.TextField(blank=True, default="")

    def __str__(self):
        return f"Call {self.call_sid} from {self.caller} at {self.added}"
