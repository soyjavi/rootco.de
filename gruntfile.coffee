module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    meta:
      temp   : "build",
      package: "package",
      banner : """
        /* <%= pkg.name %> v<%= pkg.version %> - <%= grunt.template.today("m/d/yyyy") %>
           <%= pkg.homepage %>
           Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> - Licensed <%= _.pluck(pkg.license, "type").join(", ") %> */

        """
    # =========================================================================

    source:
      coffee: [
        "sources/*.coffee",
        "sources/modules/*.coffee",
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
      workers: [
        "sources/workers/*.coffee"]

    components:
      js: [
        "components/jquery/jquery.js",
        "components/monocle/monocle.js",
        "components/hope/hope.js",
        "components/device.js/device.js"]

    # =========================================================================
    coffee:
      core: files: "<%=meta.temp%>/<%=pkg.name%>.js": "<%= source.coffee %>"
      workers: files: "<%=meta.temp%>/workers/filesystem.js": "<%= source.workers %>"

    uglify:
      options: compress: false, banner: "<%= meta.banner %>"
      core: files: "<%=meta.package%>/javascripts/<%=pkg.name%>.<%=pkg.version%>.js": "<%=meta.temp%>/<%=pkg.name%>.js"
      workers: files: "<%=meta.package%>/javascripts/workers/filesystem.js": "<%=meta.temp%>/workers/filesystem.js"

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
        files: ["<%= source.coffee %>"]
        tasks: ["coffee:core", "uglify:core"]
      stylus:
        files: ["<%= source.stylus %>", "<%= source.themes %>"]
        tasks: ["stylus"]
      jade:
        files: ["<%= source.jade %>"]
        tasks: ["jade"]
      workers:
        files: ["<%= source.workers %>"]
        tasks: ["coffee:workers", "uglify:workers"]
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
