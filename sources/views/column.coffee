class __View.Column extends Monocle.View

  _ace: null

  container: "body"

  template: """
  <section class="active">
    <header>
        <nav data-control="files">
          <a href="#">.gitignore</a>
          <a href="#" class="unsaved">gruntfile.coffee</a>
          <a href="#" class="active">
            pair.coffee
            <img class="avatar speaking" src="images/inigo.jpg" />
            <img class="avatar" src="images/ina.jpg" />
          </a>
          <a href="#">package.json</a>
        </nav>
    </header>

    <article id="col-x">class __Model.Cat extends Monocle.Animal
      @fields "name", "type", "created_at"</article>
  </section>
  """

  constructor: ->
    super
    @append @model

    _ace = ace.edit "col-x"
    # _ace.setTheme "ace/theme/chaos"
    _ace.setTheme "ace/theme/monokai"
    _ace.setShowInvisibles true
    _ace.setDisplayIndentGuides false
    _ace.setFontSize "12px"
    _ace.setPrintMarginColumn 80
    _ace.setBehavioursEnabled true
    # _ace.setKeyboardHandler require("ace/keyboard/emacs").handler
    _ace.getSession().setMode "ace/mode/coffee"
