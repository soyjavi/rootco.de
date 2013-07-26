ACE_EXT_LANG =
  "coffee"  : "coffee"
  "js"      : "javascript"
  "py"      : "python"
  "html"    : "html"
  "css"     : "css"
  "jade"    : "jade"
  "php"     : "php"
  "json"    : "json"
  "jsp"     : "jsp"
  "less"    : "less"
  "styl"    : "stylus"
  "txt"     : "text"
  "xml"     : "xml"
  "rb"      : "ruby"
  "sh"      : "batchfile"


class __View.Column extends Monocle.View

  files: null
  currentFile: null
  currentIndex: null

  ace: null
  article: null
  nav: null

  container: "body"

  events:
    "click nav > a" : "_onNavClick"
    # "hold nav > a"  : "_closeFile"
    "click article" : "_onArticleClick"

  template: """
    <section class="{{#first}}active{{/first}}" id="column_{{index}}">
      <header>
        {{#first}}
        <button data-action="aside">.\\\\</button>
        <button data-action="add_column"> + </button>
        {{/first}}
        <nav data-control="files"></nav>
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

  openFile: (file) ->
    index = @_getFileIndex file
    if index is -1
      @files.push file
      index = @files.length - 1
      @_appendNavArticle file, index

    @_showTab index

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

  _onNavClick: (event) ->
    __Controller.Main.setActiveColumn @model.index
    el = Monocle.Dom event.target
    index = el.attr("data-index").replace("file-", "")
    @_showTab index

  _onArticleClick: (event) ->
    __Controller.Main.setActiveColumn @model.index
    do __Controller.Aside.hide

  _initAce: (article, file_data) ->
    file_data.ace = ace.edit article
    file_data.ace.setTheme "ace/theme/monokai"
    file_data.ace.setShowInvisibles true
    file_data.ace.setDisplayIndentGuides false
    file_data.ace.setFontSize "12px"
    file_data.ace.setPrintMarginColumn 80
    file_data.ace.setBehavioursEnabled true
    language = ACE_EXT_LANG[file_data.extension] or "text"
    file_data.ace.getSession().setMode "ace/mode/#{language}"
    file_data.ace.setValue file_data.code
    file_data.ace.clearSelection()
    self = @
    file_data.ace.getSession().getDocument().on "change", (data) ->
      self.nav.find(".active").addClass "unsaved"

  saveFile: () ->
    @nav.find("[data-index=file-#{@currentIndex}]").removeClass "unsaved"
    alert "call to save"


