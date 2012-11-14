TopRope
=======

A handlebars template compiler for directories using [hogan.js](http://twitter.github.com/hogan.js/), and renderer for express.

## Install

`npm install toprope`

## Usage

TopRope is meant to be used in conjunction with express to render your compiled templates to a view in an isolated script tag.

express = require "express"
topRope = require "toprope"

myApp = express()

topRope (err, scriptTag) ->
  app.listen 3000, (err) -> 
  	console.log "Listening on 3000, Ctrl-C to exit"

## License

Created by [Jacob Gable](http://jacobgable.com).  Licensed under the MIT License; no attribution required.