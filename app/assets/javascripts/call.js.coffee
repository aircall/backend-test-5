App.call = App.cable.subscriptions.create "CallChannel",
  received: (data, action) ->
    unless data.content.blank?
      if data.action == 'create'
        $('tbody').append(JST["templates/call"]({call: data.content}));
      else
        $("#call_#{data.content.id}").replaceWith(JST["templates/call"]({call: data.content}));
