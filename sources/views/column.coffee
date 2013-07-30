class __View.Column extends Monocle.View

  EXTENSION   : rc.Constants.EXTENSION

  files       : null
  currentFile : null
  currentIndex: null

  ace         : null
  article     : null
  nav         : null

  container   : "body"

  template: """
    <section class="{{#first}}active{{/first}}" id="column_{{index}}">
      <header>
        {{#first}}
        <button data-action="aside">.\\\\</button>
        {{/first}}
        <nav data-control="files"></nav>
      </header>
      <article></article>
    </section>
  """

  events:
    "click nav > a"                     : "onNav"
    "click article"                     : "onArticle"
    "click [data-action=remove_column]" : "onRemove"
    # "dragstart [data-control=files] > a": "onDragStart"
    "dragenter [data-control=files]"    : "onDragEnter"
    "dragover [data-control=files]"     : "onDragOver"
    "drop [data-control=files]"         : "onDrop"


  elements:
    "[data-control=files]"              : "files"

  constructor: ->
    super
    @files = []
    @currentFile = null
    @currentIndex = null
    @append @model
    @nav = @el.find "[data-control=files]"
    @article = @el.find "article"

  # EVENTS
  onNav: (event) ->
    __Controller.Columns.active @model.index

    el = Monocle.Dom event.target
    index = el.attr("data-index").replace("file-", "")
    @_showTab index

  onArticle: (event) -> __Controller.Columns.active @model.index

  onRemove: (event) -> @remove()

  onDragStart: (event) ->
    console.error event.target
    event.originalEvent.dataTransfer.setData "Text", "pe"

  onDragEnter: (event) ->
    _prevent event
    console.error "ode"
    @files.addClass "Prueba"

  onDragOver: (event) -> _prevent event

  onDrop: (event) ->
    _prevent event
    console.error "od", event.originalEvent.dataTransfer.getData "Text"

  _prevent = (event) ->
    do event.preventDefault
    do event.stopPropagation
    false

  # PUBLIC METHODS
  active: -> @el.addClass "active"

  deactive: -> @el.removeClass "active"

  openFile: (file) ->
    index = @_getFileIndex file
    if index is -1
      @files.push file
      index = @files.length - 1
      @_appendNavArticle file, index

    @_showTab index

  saveFile: () ->
    @nav.find("[data-index=file-#{@currentIndex}]").removeClass "unsaved"
    alert "call to save"


  # PRIVATE METHOS
  _getFileIndex: (file_to_search) ->
    i = 0
    for file in @files
      if file.uid is file_to_search.uid then return i
      i++
    return -1

  _appendNavArticle: (file_data, index) ->
    html = """<a href="#" class="active" data-index="file-#{index}" draggable>#{file_data.name}</a>"""
    @nav.append Monocle.Dom html
    article = document.createElement("article")
    article.setAttribute("data-index", "file-#{index}")
    @el[0].appendChild(article)
    @_initAce article, file_data

  _showTab: (index) ->
    @currentIndex = index
    @currentFile = @files[index]
    selector = "[data-index=file-#{index}]"
    @el.children(selector).removeClass("hidden").siblings().addClass("hidden")
    @nav.find(selector).addClass("active").siblings().removeClass("active")
    do __Controller.Aside.hide

  _initAce: (article, file_data) ->
    file_data.ace = ace.edit article
    file_data.ace.setTheme "ace/theme/monokai"
    file_data.ace.setShowInvisibles true
    file_data.ace.setDisplayIndentGuides false
    file_data.ace.setFontSize "11px"
    file_data.ace.setPrintMarginColumn 80
    file_data.ace.setBehavioursEnabled true
    language = @EXTENSION[file_data.extension] or "text"
    file_data.ace.getSession().setMode "ace/mode/#{language}"
    file_data.ace.setValue file_data.code
    file_data.ace.clearSelection()
    self = @
    file_data.ace.getSession().getDocument().on "change", (data) ->
      self.nav.find(".active").addClass "unsaved"
