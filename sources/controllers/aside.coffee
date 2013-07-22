class AsideCtrl extends Monocle.Controller

  elements:
    "div[data-control=tree]": "filesTree"

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
      if entry.isDirectory then folders.push(entry)
      else if entry.isFile then files.push(entry)

    folders.sort()
    files.sort()
    for folder in folders
      new __View.TreeFolder model: folder, container: parentNode
      _handleFolderEntities(folder.createReader(), _readFolder, $$("[data-folder=#{folder.name}]")[0])
    for file in files
      new __View.TreeFile model: file, container: parentNode


    # new __View.Tree model: {folders: folders, files: files}, container: parentNode
    # for folder in folders
    #   _handleFolderEntities(folder.createReader(), _readFolder, $$("[data-folder=#{folder.name}]")[0])

  _handleFolderEntities = (directoryReader, callback, parentNode) ->
    entries = []
    readEntries = ->
      directoryReader.readEntries (results) ->
        unless results.length
          entries.sort()
          callback entries, parentNode
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
    msg = "An error occured: "
    switch err.code
      when FileError.NOT_FOUND_ERR then       msg += "File or directory not found"
      when FileError.NOT_READABLE_ERR then    msg += "File or directory not readable"
      when FileError.PATH_EXISTS_ERR then     msg += "File or directory already exists"
      when FileError.TYPE_MISMATCH_ERR then   msg += "Invalid filetype"
      else msg += "Unknown Error"
    console.error "[ERROR] ---> ", msg


$$ ->
  __Controller.Aside = new AsideCtrl "aside"

