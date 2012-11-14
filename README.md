TopRope [![Build Status](https://secure.travis-ci.org/jgable/toprope.png)](http://travis-ci.org/jgable/toprope)
=======

A handlebars template compiler for directories using [hogan.js](http://twitter.github.com/hogan.js/), and renderer for express.

## Install

`npm install toprope`

## Usage

TopRope is meant to be used in conjunction with express to render your compiled templates to a view in an isolated script tag.

### In your node.js express app

    express = require "express"
    topRope = require "toprope"
    
    myApp = express()
    
    topRope process.cwd() + "/public/templates", (err, scriptTag) ->
      app.listen 3000, (err) -> 
      	console.log "Listening on 3000, Ctrl-C to exit"

This will compile all the templates in your /public/templates directory.

### In your view (jade templates example)

	<script src="http://twitter.github.com/hogan.js/builds/2.0.0/hogan-2.0.0.js"></script>
    != templates()

This will output a `<script>` tag containing the `APPLICATION_TEMPLATES` variable with your templates.

### Rendering your template

    var hoganed = new Hogan.Template(APPLICATION_TEMPLATES["someTemplate.hbs"]),
        html = hoganed.render({ data: "something" });

First we have to 'Hoganize' the template then call render on it.

## License

Created by [Jacob Gable](http://jacobgable.com).  Licensed under the MIT License; no attribution required.