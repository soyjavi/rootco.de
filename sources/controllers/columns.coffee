class ColumnsCtrl extends Monocle.Controller

  _columns = []
  _active  = null

  events:
    "click [data-action=aside]"               : "onToggleAside"

  constructor: ->
    super
    __Model.Column.bind "create", @bindColumnCreate
    __Model.Column.bind "destroy", @bindColumnDestroy
    do _add
    do __Controller.Aside.show

  # EVENTS
  onToggleAside: -> do __Controller.Aside.toggle

  bindColumnCreate: (column) =>
    _columns.push new __View.Column model: column
    @active column.index

  bindColumnDestroy: (column) =>
    _columns.splice column.index, 1
    @active _columns.length - 1

  # PUBLIC methods
  number: (value) ->
    current = _columns.length
    if current < value
      do _add for i in [value...current]
    else if current > value
      do _remove for i in [value...current]

  active: (index) ->
    column.deactive() for column in _columns
    _active  = _columns[index]
    _active .active()

  openFile: (model) -> _active.openFile model

  saveFile: ->
    console.log "Could be ... SAVE"
    if @_active then do @_active.saveFile


  # PRIVATE methods
  _add = ->
    is_first = if _columns.length is 0 then true else false
    __Model.Column.create index: _columns.length, first: is_first
    do __Controller.Aside.hide

  _remove = ->
    _columns[_columns.length - 1].remove()
    do __Controller.Aside.hide

$ ->
  __Controller.Columns = new ColumnsCtrl "body"
