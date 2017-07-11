fs = require 'fs'
coffee_reactify = require 'coffee-reactify'
metaserve_js_browserify = require 'metaserve-js-browserify'
through = require 'through'
require('node-cjsx').transform()

VERBOSE = process.env.METASERVE_VERBOSE?

unliterate = (file) ->
    data = ''

    write = (buf) ->
        data += buf
        return

    end = ->
        lines = data.split '\n'
            .filter (line) ->
                line.indexOf('    ') == 0
        data = lines.join '\n'
        @queue data
        @queue null
        return

    return through write, end

module.exports =
    ext: 'litcoffee'

    default_config:
        content_type: 'application/javascript'
        browserify:
            extensions: ['.coffee', '.litcoffee']
        browserify_shim: false
        uglify: false

    compile: (filename, config, context, cb) ->
        console.log '[LitCoffeeReactifyCompiler.compile]', filename, config if VERBOSE

        config.beforeBundle = (bundler) ->
            bundler = bundler
                .transform(unliterate)
                .transform(coffee_reactify)
            return bundler

        metaserve_js_browserify.compile filename, config, context, cb

