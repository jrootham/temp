#  Gruntfile for base code for Polyglot

module.exports = (grunt)->
  grunt.loadNpmTasks "grunt-coffeelint"
  grunt.loadNpmTasks "grunt-cafe-mocha"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-clean"
  
  grunt.registerTask "default",["clean", "coffeelint", "coffee", "cafemocha"]
  
  grunt.initConfig
    clean: ["test", "bin"]
      
    coffeelint:
      app:["*.coffee"]

    coffee:
      bin:
        files: [
          src: ["*.coffee", "!*.spec.coffee", "!Gruntfile.coffee"]
          dest: "bin/"
          cwd: "."
          expand: true
          ext: ".js"
        ]
        
      test:
        files: [
          src: ["*.spec.coffee"]
          dest: "test/"
          cwd: "."
          expand: true
          ext: ".spec.js"
        ]

    cafemocha:
      src: "test/*.js"
  

