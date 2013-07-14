class MainCtrl extends Monocle.Controller

  elements:
    "aside"               : "aside"
    "section"             : "sections"

  events:
    "tap [data-action=aside]" : "onToggleAside"
    "tap [data-control=files] a, article"        : "onFile"

  onToggleAside: (event) ->
    @aside.toggleClass "active"

  onFile: (event) ->
    el = Monocle.Dom(event.currentTarget)
    el.addClass("active").siblings().removeClass "active"
    el.parent("section").addClass("active").siblings().removeClass "active"

$$ ->
  __Controller.Main = new MainCtrl "body"
