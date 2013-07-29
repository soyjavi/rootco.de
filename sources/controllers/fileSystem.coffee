@fileSystem = do ->

  IGNORE_RESOURCES =  [".git", "node_modules", ".DS_Store"]

  read = (items, container) ->
    _getResources([item.webkitGetAsEntry()], container) for item in items


  getFile = (path, callback) ->
    resource = __Model.Resource.findBy "path", path
    unless resource.loaded
      resource.entry.file (file) ->
        reader = new FileReader()
        reader.onloadend = (event) ->
          resource.loaded = true
          resource.code = @result
          resource.save()
          callback.call __Controller.Main, resource
        reader.readAsText file
    else
      callback.call __Controller.Main, resource


  _getResources = (resources, parentNode) ->
    for resource in resources
      if resource.name not in IGNORE_RESOURCES
        attributes =
          name      : resource.name
          path      : resource.fullPath
          isFolder  : resource.isDirectory
          entry     : resource
          loaded    : false
          extension : if resource.isFile then resource.name.split(".").slice(-1)[0]

        model = __Model.Resource.create attributes
        new __View.Resource model: model, container: parentNode

        if resource.isDirectory
          container = Monocle.Dom("[data-folder='#{attributes.path}']")[0]
          _readFolder resource, container


  _readFolder = (folder, parentNode) ->
    reader = folder.createReader()
    entries = []
    readEntries = ->
      reader.readEntries (results) ->
        unless results.length
          do entries.sort
          _getResources entries, parentNode
        else
          entries = entries.concat(Array::slice.call(results or []), 0)
          setTimeout readEntries, 10
      , _onError
    do readEntries


  _onError = (error) ->
    message = "[FS Error] --> An error occured: "
    switch error.code
      when FileError.NOT_FOUND_ERR then       message += "File or directory not found"
      when FileError.NOT_READABLE_ERR then    message += "File or directory not readable"
      when FileError.PATH_EXISTS_ERR then     message += "File or directory already exists"
      when FileError.TYPE_MISMATCH_ERR then   message += "Invalid filetype"
      else message += "Unknown Error (check chrome security)"
    console.error message

  read        : read
  getFile     : getFile
