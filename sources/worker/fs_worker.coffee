
fs = @webkitRequestFileSystemSync(PERSISTENT, 10 * 1024 * 1024)


#======================== Files ==============================

FileHandler = do ->

  getEntry = (filepath, create = false) ->
    path_split = filepath.split("/")
    path = path_split.slice(0, -1).join("/")
    dirEntry = FolderHandler.getEntry(path)
    return null unless dirEntry
    filename = path_split.slice(-1)
    entry = null
    try entry = dirEntry.getFile(filename, create: create)
    entry

  read = (filepath) ->
    fileEntry = getEntry(filepath)
    unless fileEntry
      postMessage ""
      return
    file = fileEntry.file()
    reader = new FileReader()
    reader.onloadend = (e) -> postMessage @result
    reader.readAsText file

  save = (filepath, content) ->
    fileEntry = getEntry(filepath, true)
    unless fileEntry then postMessage false
    else
      writer = fileEntry.createWriter()
      blob = new Blob([content], type: "text/plain")
      writer.write blob
      postMessage true

  remove = (filepath) ->
    fileEntry = getEntry(filepath)
    if fileEntry
      fileEntry.remove()
      postMessage true
    else postMessage false

  read: read
  save: save
  remove: remove


#======================== Folders ==============================

FolderHandler = do ->
  getEntry = (path) ->
    entry = null
    try entry = fs.root.getDirectory(path, create: false)
    entry

  read = (path) ->
    paths = []
    dirEntry = getEntry(path)
    return [] unless dirEntry
    dirReader = dirEntry.createReader()
    _read = (dirReader) ->
      entries = dirReader.readEntries()
      i = 0
      while entry = entries[i++]
        paths.push entry.toURL()
        _read entry.createReader() if entry.isDirectory
        i++

    _read dirReader
    postMessage paths

  create = (path) ->
    _create = (dirEntry, folders) ->
      return unless folders.length
      folders = folders.slice(1) if folders[0] is "." or folders[0] is ""
      dirEntry = dirEntry.getDirectory(folders[0], create: true)
      _create dirEntry, folders.slice(1) if folders.length

    _create fs.root, path.split("/")
    postMessage true

  remove = (path) ->
    entry = getEntry(path)
    if entry
      entry.removeRecursively()
      postMessage true
    else postMessage false

  getEntry: getEntry
  read: read
  create: create
  remove: remove


#======================== Worker events ==============================

@onmessage = (e) ->
  data = e.data
  switch data.action
    when "read_folder"
      FolderHandler.read data.path
    when "create_folder"
      FolderHandler.create data.path
    when "delete_folder"
      FolderHandler.remove data.path
    when "read_file"
      FileHandler.read data.path
    when "save_file"
      FileHandler.save data.path, data.content
    when "delete_file"
      FileHandler.remove data.path

