class Tree extends Monocle.View

  constructor: ->
    super
    @append @model

  doNothing: (event) ->
    do event.preventDefault
    do event.stopPropagation
