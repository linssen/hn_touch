module.exports = (grunt) ->

    grunt.initConfig

        paths:
            styles: "./static/styles/"
            scripts: "./static/scripts/"

        concat:
            scripts:
                files:
                    "<%= paths.scripts %>dist/hn.js": [
                        "<%= paths.scripts %>libs/underscore/underscore.js"
                        "<%= paths.scripts %>libs/jquery/jquery.js"
                        "<%= paths.scripts %>libs/handlebars/handlebars.js"
                        "<%= paths.scripts %>libs/**/*.js"
                        "<%= paths.scripts %>build/*.js"
                        "<%= paths.scripts %>templates/build/*.hbs"
                    ]
        uglify:
            scripts:
                files:
                    "<%= paths.scripts %>dist/hn.js": [
                        "<%= paths.scripts %>libs/underscore/underscore.js"
                        "<%= paths.scripts %>libs/jquery/jquery.js"
                        "<%= paths.scripts %>libs/handlebars/handlebars.js"
                        "<%= paths.scripts %>libs/**/*.js"
                        "<%= paths.scripts %>build/*.js"
                        "<%= paths.scripts %>templates/build/*.hbs"
                    ]
        coffee:
            scripts:
                files: [
                    expand: true
                    cwd: "<%= paths.scripts %>"
                    src: ["*.coffee"]
                    dest: "<%= paths.scripts %>build/"
                    ext: ".js"
                ]
        sass:
            styles:
                files:
                    "<%= paths.styles %>dist/screen.css": [
                        "<%= paths.styles %>screen.scss"
                    ]
        handlebars:
            templates:
                options:
                    namespace: "app.templates"
                    processName: (filename) ->
                        return filename
                            .replace(/.*\/([\w-]+)\.hbs$/, '$1')
                files:
                    "<%= paths.scripts %>templates/build/hn.hbs": [
                        "<%= paths.scripts %>templates/*.hbs"
                    ]

        watch:
            coffee:
                files: ["<%= paths.scripts %>*.coffee"]
                tasks: ["coffee", "concat"]
            styles:
                files: ["<%= paths.styles %>*.scss"]
                tasks: ["sass"]
            handlebars:
                files: ["<%= paths.scripts %>templates/*.hbs"]
                tasks: ["handlebars", "concat"]

    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-concat"
    grunt.loadNpmTasks "grunt-contrib-sass"
    grunt.loadNpmTasks "grunt-contrib-handlebars"
    grunt.loadNpmTasks "grunt-contrib-uglify"

    grunt.registerTask "default", ["coffee", "sass", "handlebars", "concat"]