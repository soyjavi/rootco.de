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
  ace: null
  article: null
  nav: null

  container: "body"

  events:
    "click nav > a" : "_onNavClick"
    "hold nav > a"  : "_closeFile"
    "click article" : "_onArticleClick"

  template: """
    <section class="{{#first}}active{{/first}}">
      <header>
        {{#first}}
        <button data-action="aside">.\\\\</button>
        {{/first}}
        <nav data-control="files"></nav>
      </header>
      <article id="ace-{{index}}"></article>
    </section>
  """

  constructor: ->
    super
    @files = []
    @ace = null
    @append @model
    @nav = @el.find "[data-control=files]"
    @article = @el.find "article"
    @_initAce @model.index

  openFile: (file) ->
    file_index = @_getFileIndex file
    if file_index is -1
      @_addFileNav file
      @files.push file
      file_index = @files.length - 1

    @_setActiveNav file_index
    @_showFileCode file

  _closeFile: () ->
    el = Monocle.Dom event.target
    file_index = el.attr("data-index").replace("file-", "")
    @files.splice(file_index, 1)
    el.remove()
    do @_recalcNavIndexes
    file = @files[parseInt(file_index, 10)]
    if file
      @_setActiveNav file_index
      @_showFileCode file
    else
      do @_setActiveNav
      @ace.setValue ""

  _recalcNavIndexes: ->
    i = 0
    @nav.find("a").each -> @setAttribute "data-index", "file-#{i++}"

  _setActiveNav: (file_index) ->
    @nav.find("a").removeClass "active"
    if file_index? then @nav.find("[data-index=file-#{file_index}]").addClass "active"

  _getFileIndex: (file_to_search) ->
    i = 0
    for file in @files
      if file.uid is file_to_search.uid then return i
      i++
    return -1

  _addFileNav: (model, index) ->
    html = """<a href="#" class="active" data-index="file-#{@files.length}">#{model.name}</a>"""
    @nav.append Monocle.Dom html

  _showFileCode: (file) ->
    @ace.setValue file.code
    @_setMode file.extension
    @ace.clearSelection()
    do __Controller.Aside.hide

  _onNavClick: (event) ->
    el = Monocle.Dom event.target
    el.addClass("active").siblings().removeClass("active")
    file_index = el.attr("data-index").replace("file-", "")
    file = @files[parseInt(file_index, 10)]
    @_showFileCode file

  _onArticleClick: (event) ->
    do __Controller.Aside.hide
    __Controller.Main.setActiveColumn @model.index

  _initAce: (id) ->
    @ace = ace.edit "ace-#{id}"
    @ace.setTheme "ace/theme/monokai"
    @ace.setShowInvisibles true
    @ace.setDisplayIndentGuides false
    @ace.setFontSize "12px"
    @ace.setPrintMarginColumn 80
    @ace.setBehavioursEnabled true

  _setMode: (extension) ->
    language = ACE_EXT_LANG[extension] or "text"
    mode = "ace/mode/#{language}"
    @ace.getSession().setMode mode
