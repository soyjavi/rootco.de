
# 10 MB
STORAGE_TO_REQUEST = 10*1024*1024

@LocalFileSystem = do ->

  worker = null

  FSInit = (fs) ->
    worker = new Worker("javascripts/fs_worker.js")
    worker.onmessage = (e) ->
      console.debug "Worker message :: ", e.data

  $$ ->

    _storageAllowed = ->
      window.requestFileSystem = window.requestFileSystem or window.webkitRequestFileSystem
      window.requestFileSystem window.PERSISTENT, STORAGE_TO_REQUEST, FSInit, ( -> @ )

    _storageDenied = ->
      console.error 'Local File Storage denied'

    window.storageInfo = window.webkitStorageInfo or window.storageInfo
    window.storageInfo.requestQuota window.PERSISTENT, STORAGE_TO_REQUEST, _storageAllowed, _storageDenied


  createFolder: (path) ->
    worker.postMessage action: "create_folder", path: path

  deleteFolder: (path) ->
    worker.postMessage action: "delete_folder", path: path

  readFolder: (path) ->
    worker.postMessage action: "read_folder", path: path

  saveFile: (filepath, content) ->
    worker.postMessage action: "save_file", path: filepath, content: content

  deleteFile: (filepath) ->
    worker.postMessage action: "delete_file", path: filepath

  readFile: (filepath) ->
    worker.postMessage action: "read_file", path: filepath





