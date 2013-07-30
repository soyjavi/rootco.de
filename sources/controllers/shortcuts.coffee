class ShortcutsCtrl extends Monocle.Controller

  _shortcut = false

  BINDINGS =
    49: "column_1"
    50: "column_2"
    51: "column_3"

    66: "aside"
    67: "command"
    70: "find"
    77: "maximize"
    78: "new"
    79: "open"
    83: "save"

  events:
    "keydown": "onKeydown"

  onKeydown: (event) ->
    key = event.keyCode
    unless _shortcut then _isShortcut key
    if _shortcut and key of BINDINGS
      _shortcut = false
      do event.preventDefault
      do @["_#{BINDINGS[key]}"]
    else if _shortcut
      console.error key

  # PRIVATE METHODS
  _column_1: -> __Controller.Columns.number 1
  _column_2: -> __Controller.Columns.number 2
  _column_3: -> __Controller.Columns.number 3
  _aside: -> do __Controller.Aside.toggle

  _command: -> console.log "SHORTCUT: _command"

  _find: -> console.log "SHORTCUT: _find"

  _maximize: -> console.log "SHORTCUT: _maximize"

  _new: -> console.log "SHORTCUT: _new"
  _open: -> console.log "SHORTCUT: _open"
  _save: -> console.log "SHORTCUT: _save"

  _isShortcut = (key) ->
    _shortcut = if key is 91 or key is 17 then true else false

$ ->
  __Controller.Shortcuts = new ShortcutsCtrl "body"
