class __View.Resource extends Monocle.View

  template: """
    {{#isFolder}}
    <abbr>{{name}}</abbr>
    <nav data-action="open" data-folder="{{path}}" class="collapsed"></nav>
    {{/isFolder}}

    {{^isFolder}}
    <span data-action="open">{{name}}</span>
    {{/isFolder}}
  """
  events:
    "click " : "onTap"

  constructor: ->
    super
    @append @model

  onTap: (event) ->
    do event.preventDefault
    do event.stopPropagation

    if @model.isFolder
      Monocle.Dom(event.target).next("nav").toggleClass "collapsed"
    else
      target = Monocle.Dom(event.target)
      fileSystem.getFile @model.path, __Controller.Main.onFileLoad

