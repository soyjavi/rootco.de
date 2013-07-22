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
    console.error "openFile", @model
    @doNothing event


class __View.TreeFolder extends Tree
  events: "tap": "toogle"
  template: '<abbr data-folder="{{name}}">{{name}}</abbr>'
  toogle: (event) ->
    console.error "toogle folder", @model
    @doNothing event




# class __View.Tree extends Monocle.View

#   events:
#     "doubleTap span": "openFile"
#     "tap abbr": "toggleFolder"

#   template: """
#     <nav>
#         {{#folders}}
#         <abbr data-folder="{{name}}">{{name}}</abbr>
#         {{/folders}}
#         {{#files}}
#         <span>{{name}}</span>
#         {{/files}}
#     </nav>
#   """

#   constructor: ->
#     super
#     @append @model

#   toggleFolder: (event) ->
#     _doNothing event
#     console.error "toggleFolder", @model

#   openFile: (event) ->
#     _doNothing event
#     console.error "openFile", @model

#   _doNothing = (event) ->
#     do event.preventDefault
#     do event.stopPropagation

