module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    meta:
      package: "package",
      banner : """
        /* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("m/d/yyyy") %>
           <%= pkg.homepage %>
           Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */

        """
    # =========================================================================

    source:
      fsWorker: "sources/worker/fs_worker.coffee"
      coffee: [
        "sources/*.coffee",
        "sources/models/*.coffee",
        "sources/views/*.coffee",
        "sources/controllers/*.coffee"]
      stylus: [
        "sources/stylesheets/app.*.styl"
      ]
      jade: [
        "sources/jades/*.jade"]
      themes: [
        "sources/stylesheets/theme/theme.flatland.styl"]

    components:
      js: [
        "components/quojs/quo.js",
        "components/monocle/monocle.js",
        "components/hope/hope.js",
        "components/device.js/device.js"]

    # =========================================================================
    coffee:
      fsWorker: files: "<%=meta.package%>/javascripts/fs_worker.debug.js": "<%= source.fsWorker %>"
      core: files: "<%=meta.package%>/javascripts/<%=pkg.name%>.<%=pkg.version%>.debug.js": "<%= source.coffee %>"

    uglify:
      options: compress: false, banner: "<%= meta.banner %>"
      core: files: "<%=meta.package%>/javascripts/<%=pkg.name%>.<%=pkg.version%>.js": "<%=meta.package%>/javascripts/<%=pkg.name%>.<%=pkg.version%>.debug.js"
      fsWorker: files: "<%=meta.package%>/javascripts/fs_worker.js": "<%=meta.package%>/javascripts/fs_worker.debug.js"

    stylus:
      core:
        options: compress: false, import: ["__init"]
        files: "<%=meta.package%>/stylesheets/<%=pkg.name%>.<%=pkg.version%>.css": '<%=source.stylus%>'
      themes:
        # options: compress: false, import: ["__init"]
        files: "<%=meta.package%>/stylesheets/<%=pkg.name%>.theme.flatland.css": '<%=source.themes%>'

    concat:
      js:
        src: "<%= components.js %>", dest: "<%=meta.package%>/javascripts/<%=pkg.name%>.components.js"

    jade:
      compile:
        options: data: debug: true
        files:   "<%=meta.package%>/index.html": "<%= source.jade %>"

    watch:
      coffee:
        files: ["<%= source.coffee %>", "<%= source.fsWorker %>"]
        tasks: ["coffee", "uglify"]
      stylus:
        files: ["<%= source.stylus %>", "<%= source.themes %>"]
        tasks: ["stylus"]
      jade:
        files: ["<%= source.jade %>"]
        tasks: ["jade"]
      components:
        files: ["<%= components.js %>"]
        tasks: ["concat"]


  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-jade"
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", [ "concat", "coffee", "uglify", "stylus", "jade"]
