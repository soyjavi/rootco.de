class AsideCtrl extends Monocle.Controller

  elements:
    "nav[data-control=tree]": "filesTree"

  events:
    "dragover [data-control=fileDrop]": "onFilesDragover"
    "dragenter [data-control=fileDrop]": "onFilesDragenter"
    "drop [data-control=fileDrop]": "onFilesDropped"

  onFilesDropped: (event) ->
    _doNothing event
    fileSystem.importItems event.dataTransfer.items, @filesTree[0]

  onFilesDragover: (event) -> _doNothing event

  onFilesDragenter: (event) -> _doNothing event

  show:   -> @el.addClass "active"
  hide:   -> @el.removeClass "active"
  toggle: -> @el.toggleClass "active"

  _doNothing = (event) ->
    do event.preventDefault
    do event.stopPropagation
    false


$$ ->
  __Controller.Aside = new AsideCtrl "aside"

