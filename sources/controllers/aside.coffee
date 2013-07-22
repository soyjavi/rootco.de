class AsideCtrl extends Monocle.Controller

  elements:
    "nav[data-control=tree]": "filesTree"

  events:
    "dragover [data-control=fileDrop]": "onFilesDragover"
    "dragenter [data-control=fileDrop]": "onFilesDragenter"
    "drop [data-control=fileDrop]": "onFilesDropped"

  onFilesDropped: (event) ->
    _doNothing event
    for item in event.dataTransfer.items
      _readFolder [item.webkitGetAsEntry()], @filesTree[0]

  onFilesDragover: (event) ->
    _doNothing event

  onFilesDragenter: (event) ->
    _doNothing event

  _readFolder = (entries, parentNode) ->
    files = []
    folders = []
    for entry in entries
      if entry.isDirectory
        new __View.TreeFolder model: entry, container: parentNode
        container = document.querySelector "[data-folder='#{entry.fullPath}']"
        _handleFolderEntities entry.createReader(), container
      else if entry.isFile
        new __View.TreeFile model: entry, container: parentNode

  _handleFolderEntities = (directoryReader, parentNode) ->
    entries = []
    readEntries = ->
      directoryReader.readEntries (results) ->
        unless results.length
          entries.sort()
          _readFolder entries, parentNode
        else
          entries = entries.concat(Array::slice.call(results or []), 0)
          do readEntries
      , _fsErrorHandler
    do readEntries

  _doNothing = (event) ->
    do event.preventDefault
    do event.stopPropagation
    false

  _fsErrorHandler = (err) ->
    msg = "[FS Error] --> An error occured: "
    switch err.code
      when FileError.NOT_FOUND_ERR then       msg += "File or directory not found"
      when FileError.NOT_READABLE_ERR then    msg += "File or directory not readable"
      when FileError.PATH_EXISTS_ERR then     msg += "File or directory already exists"
      when FileError.TYPE_MISMATCH_ERR then   msg += "Invalid filetype"
      else msg += "Unknown Error (check chrome security)"
    console.error msg


$$ ->
  __Controller.Aside = new AsideCtrl "aside"

