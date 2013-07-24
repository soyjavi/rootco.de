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


class __View.Column extends Monocle.View

  container: "body"

  events:
    "click nav > a" : "_onNavClick"
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

  showFile: (file) ->
    @nav.find("a").removeClass "active"
    file_index = @_getFileIndex file
    if file_index is -1
      @_addFileNav file
      @files.push file
    else @nav.find("[data-index=file-#{file_index}]").addClass "active"
    @_showFileCode file

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
    @article.addClass "ace_focus"

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
    if ACE_EXT_LANG[extension]
      mode = "ace/mode/#{ACE_EXT_LANG[extension]}"
      @ace.getSession().setMode mode
    else console.error "extension/language not defined"
