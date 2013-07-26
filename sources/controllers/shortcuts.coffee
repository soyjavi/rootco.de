@shortcutListener = do ->

  _controlPressed = false

  _isControl = (keyCode) ->
    keyCode is 91 or keyCode is 17

  _save = (event) ->
    __Controller.Main.saveCurrentFile()
    do event.preventDefault

  Monocle.Dom(document.body).on "keydown", (e) ->
    if _isControl(e.keyCode) then _controlPressed = true
    else if _controlPressed
      if e.keyCode is 83 then _save(e)

  Monocle.Dom(document.body).on "keyup", (e) ->
    if _isControl(e.keyCode) then _controlPressed = false
