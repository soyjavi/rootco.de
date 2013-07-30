class AsideCtrl extends Monocle.Controller

  elements:
    "nav[data-control=resources]"        : "resources"
    "input[type=file]"                   : "input"

  events:
    "dragover [data-control=resources]"  : "onFilesDragover"
    "dragenter [data-control=resources]" : "onFilesDragenter"
    "drop [data-control=resources]"      : "onFilesDropped"

    "change input[type=file]"            : "onFilesSelected"

  # EVENTS
  onFilesDropped: (event)  ->
    _prevent event
    console.error event.originalEvent.dataTransfer.items
    fileSystem.read event.originalEvent.dataTransfer.items, @resources[0]

  onFilesDragover: (event) -> _prevent event

  onFilesDragenter: (event) -> _prevent event

  onFilesSelected: (event) ->
    console.error event.target.files, event.target.webkitEntries, event.target.entries

    # fileSystem.read event.target.webkitEntries, @resources[0]

    for file in event.target.files
      console.error file, file.webkitRelativePath, file.webkitFullPath


    # for file in event.target.files
    #   # continue unless file.type.match "image.*"
    #   # reader = new FileReader()
    #   # reader.onload = (e) -> $$("#").attr "src", e.target.result
    #   # reader.readAsDataURL file
    #   console.error file


  # PUBLIC Methods
  show: -> @el.addClass "active"

  hide: -> @el.removeClass "active"

  toggle: -> @el.toggleClass "active"

  import: ->
    @input.trigger "click"

  # PRIVATE
  _prevent = (event) ->
    do event.preventDefault
    do event.stopPropagation
    false

$ ->
  __Controller.Aside = new AsideCtrl "aside"
