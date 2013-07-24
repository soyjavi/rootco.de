class MainCtrl extends Monocle.Controller

  _columns: []
  _activeColumn: null

  elements:
    "aside"               : "aside"
    "section"             : "sections"

  events:
    "click [data-action=aside]"               : "onToggleAside"
    "click [data-action=add_column]"          : "addColumn"

  constructor: ->
    super
    @addColumn true

  onFileLoad: (fileModel) ->
    _doNothing event
    unless @_columns.length then @addColumn true
    @_activeColumn.openFile fileModel

  onToggleAside: -> __Controller.Aside.toggle()

  addColumn: (first = false) ->
    @_activeColumn = new __View.Column model: {index: @_columns.length + 1, first: first}
    @_columns.push @_activeColumn
    @setActiveColumn @_columns.length

  setActiveColumn: (column_index) ->
    @_activeColumn = @_columns[column_index - 1]
    col.el.removeClass "active" for col in @_columns
    @_activeColumn.el.addClass "active"

  _doNothing = (event) ->
    do event.preventDefault
    do event.stopPropagation
    false

$$ ->
  __Controller.Main = new MainCtrl "body"
