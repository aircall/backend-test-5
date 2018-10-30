App.call = App.cable.subscriptions.create "CallChannel",
  connected: ->
    console.log("CallChannel connected")

  disconnected: ->
    console.log("CallChannel disconnected")

  received: (data) ->
    if ($("#row#{data['id']}").length > 0)
      $("#row#{data['id']}").replaceWith(data['call'])
      $("#row#{data['id']}").addClass("updated")
    else
      $("tr:last").after(data['call'])
      $("#row#{data['id']}").addClass("updated")
