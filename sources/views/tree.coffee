class Tree extends Monocle.View

  constructor: ->
    super
    @append @model

  doNothing: (event) ->
    do event.preventDefault
    do event.stopPropagation


class __View.TreeFile extends Tree

  events: "doubleTap": "open"
  template: "<span>{{name}}</span>"

  open: (event) ->
    target = $$(event.target)
    target.closest("nav[data-control=tree]").find(".active").removeClass("active")
    target.closest("span").addClass("active")
    console.debug @model.fullPath
    fileSystem.readFile @model.fullPath, (code) ->
      console.error "Code -->", code

    @doNothing event


class __View.TreeFolder extends Tree

  events: "tap": "toggle"
  template: '<abbr>{{name}}</abbr><nav data-folder="{{fullPath}}" class="collapsed"></nav>'

  toggle: (event) ->
    if event.target.nodeName is "ABBR"
      $$(event.target.nextSibling).toggleClass "collapsed"
      @doNothing event
