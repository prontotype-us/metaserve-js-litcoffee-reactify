fs = require 'fs'
coffee_reactify = require 'coffee-reactify'
metaserve_js_browserify = require 'metaserve-js-browserify'
require('node-cjsx').transform()

VERBOSE = process.env.METASERVE_VERBOSE?

module.exports =
    ext: 'litcoffee'

    default_config:
        content_type: 'application/javascript'
        browserify:
            extensions: ['.coffee', '.litcoffee']
            literate: true
        browserify_shim: false
        uglify: false

    compile: (filename, config, context, cb) ->
        console.log '[LitCoffeeReactifyCompiler.compile]', filename, config if VERBOSE

        config.beforeBundle = (bundler) ->
            bundler = bundler.transform(coffee_reactify)
            return bundler

        metaserve_js_browserify.compile filename, config, context, cb

