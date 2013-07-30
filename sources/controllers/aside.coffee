class AsideCtrl extends Monocle.Controller

  elements:
    "nav[data-control=resources]"        : "resources"

  events:
    "dragover [data-control=resources]"  : "onFilesDragover"
    "dragenter [data-control=resources]" : "onFilesDragenter"
    "drop [data-control=resources]"      : "onFilesDropped"

  onFilesDropped: (event) ->
    _prevent event
    fileSystem.read event.originalEvent.dataTransfer.items, @resources[0]

  onFilesDragover: (event) -> _prevent event

  onFilesDragenter: (event) -> _prevent event

  show: -> @el.addClass "active"

  hide: -> @el.removeClass "active"

  toggle: -> @el.toggleClass "active"

  # PRIVATE
  _prevent = (event) ->
    do event.preventDefault
    do event.stopPropagation
    false

$ ->
  __Controller.Aside = new AsideCtrl "aside"
