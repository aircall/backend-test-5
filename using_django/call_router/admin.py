from django.contrib import admin

# Register your models here.
from call_router.models import Call
from django.utils.html import format_html


@admin.register(Call)
class CallAdmin(admin.ModelAdmin):
    # Columns to show in the admn view
    list_display = (
        'call_sid',
        'status',
        'added',
        'caller',
        'show_audio_message_url',
        'audio_message_duration',
        'input_sequence',
    )

    # Special display for audio file
    def show_audio_message_url(self, call):
        if call.audio_message_url:
            return format_html(f"""
            <audio controls>
                <source src="{call.audio_message_url}" type="audio/wav">
                Your browser does not support the audio element.
            </audio>""")
        return ""

    show_audio_message_url.allow_tags = True
    show_audio_message_url.short_description = 'Voice message'

    # Block call object edition
    readonly_fields = (
        'call_sid',
        'status',
        'added',
        'caller',
        'audio_message_url',
        'audio_message_duration',
        'input_sequence',
    )

    actions = None

    def has_add_permission(self, request):
        return False

    # Allow viewing objects but not actually changing them.
    def has_change_permission(self, request, obj=None):
        return (request.method in ['GET', 'HEAD'] and
                super().has_change_permission(request, obj))

    def has_delete_permission(self, request, obj=None):
        return False

