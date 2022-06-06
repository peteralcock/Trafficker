class Dashing.SlackPresence extends Dashing.Widget

  ready: ->
    super

  onData: (data) ->
    node = $(@node)
    node.removeClass('status-active status-away status-dnd status-offline')
    node.addClass "status-#{data.presence_class}"