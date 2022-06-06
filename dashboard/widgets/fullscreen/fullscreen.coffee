class Dashing.Fullscreen extends Dashing.Widget

  ready: ->
    $(document).keypress =>
      if event.charCode is 102
        @requestFullscreen()

  requestFullscreen: ->
    elem = $('body')[0]
    if elem.requestFullscreen
      elem.requestFullscreen()
    else if elem.msRequestFullscreen
      elem.msRequestFullscreen()
    else if elem.mozRequestFullScreen
      elem.mozRequestFullScreen()
    else if elem.webkitRequestFullscreen
      elem.webkitRequestFullscreen()