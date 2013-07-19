class MainCtrl extends Monocle.Controller

  _instance : null

  elements:
    "aside"               : "aside"
    "section"             : "sections"

  events:
    "tap [data-action=aside]" : "onToggleAside"
    "tap [data-control=files] a, article"        : "onFile"

  constructor: ->
    super
    # _instance = ace.edit "col-1"
    # _instance = ace.edit "col-2"
    # _instance = ace.edit "col-3"
    # _instance.setTheme "ace/theme/monokai"

    console.error @sections
    new __View.Column model: a: "1"

  onToggleAside: (event) ->
    @aside.toggleClass "active"

  onFile: (event) ->
    el = Monocle.Dom(event.currentTarget)
    el.addClass("active").siblings().removeClass "active"
    el.parent("section").addClass("active").siblings().removeClass "active"

$$ ->
  __Controller.Main = new MainCtrl "body"
