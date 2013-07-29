class __View.Column extends Monocle.View

  EXTENSION:
    coffee    : "coffee"
    js        : "javascript"
    py        : "python"
    html      : "html"
    css       : "css"
    jade      : "jade"
    php       : "php"
    json      : "json"
    jsp       : "jsp"
    less      : "less"
    styl      : "stylus"
    txt       : "text"
    xml       : "xml"
    rb        : "ruby"
    sh        : "batchfile"

  files       : null
  currentFile : null
  currentIndex: null

  ace         : null
  article     : null
  nav         : null

  container   : "body"

  events:
    "click nav > a"                      : "onNav"
    "click article"                      : "onArticle"
    "click [data-action='remove_column']": "onRemove"

  template: """
    <section class="{{#first}}active{{/first}}" id="column_{{index}}">
      <header>
        {{#first}}
        <button data-action="aside">.\\\\</button>
        {{/first}}
        <nav data-control="files"></nav>
        {{^first}}
        <button data-action="remove_column">X</button>
        {{/first}}
      </header>
      <article></article>
    </section>
  """

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
    __Controller.Main.activeColumn @model.index
    el = Monocle.Dom event.target
    index = el.attr("data-index").replace("file-", "")
    @_showTab index

  onArticle: (event) ->
    __Controller.Main.activeColumn @model.index
    do __Controller.Aside.hide

  onRemove: (event) ->
    @remove()


  # PUBLIC METHODS
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
    html = """<a href="#" class="active" data-index="file-#{index}">#{file_data.name}</a>"""
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
    file_data.ace.setFontSize "12px"
    file_data.ace.setPrintMarginColumn 80
    file_data.ace.setBehavioursEnabled true
    language = @EXTENSION[file_data.extension] or "text"
    file_data.ace.getSession().setMode "ace/mode/#{language}"
    file_data.ace.setValue file_data.code
    file_data.ace.clearSelection()
    self = @
    file_data.ace.getSession().getDocument().on "change", (data) ->
      self.nav.find(".active").addClass "unsaved"
