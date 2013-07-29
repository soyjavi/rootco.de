class MainCtrl extends Monocle.Controller

  _columns      : []
  _activeColumn : null

  elements:
    "aside"               : "aside"
    "section"             : "sections"

  events:
    "click [data-action=aside]"               : "onToggleAside"
    "click [data-action=add_column]"          : "onAddColumn"

  constructor: ->
    super
    @_addColumn true

  # EVENTS
  onFileLoad: (fileModel) ->
    do event.preventDefault
    do event.stopPropagation
    @_activeColumn.openFile fileModel

  onToggleAside: ->
    do __Controller.Aside.toggle

  onAddColumn: (event) ->
    do @_addColumn
    do __Controller.Aside.hide


  # PUBLIC METHODS
  activeColumn: (index) ->
    @_activeColumn = @_columns[index - 1]
    col.el.removeClass "active" for col in @_columns
    @_activeColumn.el.addClass "active"

  # PRIVATE METHODS
  _addColumn: (first = false) ->
    column = __Model.Column.create index: @_columns.length + 1, first: first
    @_columns.push new __View.Column model: column
    @activeColumn column.index

  _saveCurrentFile: () ->
    do @_activeColumn.saveFile

$ ->
  __Controller.Main = new MainCtrl "body"
