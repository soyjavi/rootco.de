@fileSystem = do ->

  IGNORE_FOLDERS = [".git", "node_modules"]
  IGNORE_FILES = [".DS_Store"]

  CACHED_FILES = []

  importItems = (items, container) ->
    _readFolder([item.webkitGetAsEntry()], container) for item in items

  readFile = (file, callback) ->
    cachedObject = CACHED_FILES[file]
    unless cachedObject.lodaded
      entry = cachedObject.entry
      entry.file (file) ->
        reader = new FileReader()
        reader.onloadend = (e) ->
          cachedObject.lodaded = true
          cachedObject.code = this.result
          callback.call callback, this.result
        reader.readAsText(file)
    else
      callback.call callback, cachedObject.code

  save = (fullPath, code) ->
    CACHED_FILES[fullPath].code = code

  _readFolder = (entries, parentNode) ->
    for entry in entries
      if entry.isDirectory and entry.name not in IGNORE_FOLDERS
        new __View.TreeFolder model: entry, container: parentNode
        container = document.querySelector "[data-folder='#{entry.fullPath}']"
        _handleFolderEntities entry.createReader(), container
      else if entry.isFile and entry.name not in IGNORE_FILES
        CACHED_FILES[entry.fullPath] = {loaded: false, entry: entry, code: ""}
        new __View.TreeFile model: entry, container: parentNode

  _handleFolderEntities = (directoryReader, parentNode) ->
    entries = []
    readEntries = ->
      directoryReader.readEntries (results) ->
        unless results.length
          do entries.sort
          _readFolder entries, parentNode
        else
          entries = entries.concat(Array::slice.call(results or []), 0)
          setTimeout readEntries, 10
      , _fsErrorHandler
    do readEntries

  _fsErrorHandler = (err) ->
    msg = "[FS Error] --> An error occured: "
    switch err.code
      when FileError.NOT_FOUND_ERR then       msg += "File or directory not found"
      when FileError.NOT_READABLE_ERR then    msg += "File or directory not readable"
      when FileError.PATH_EXISTS_ERR then     msg += "File or directory already exists"
      when FileError.TYPE_MISMATCH_ERR then   msg += "Invalid filetype"
      else msg += "Unknown Error (check chrome security)"
    console.error msg




  importItems: importItems
  readFile: readFile
  save: save
  log: -> console.log CACHED_FILES
