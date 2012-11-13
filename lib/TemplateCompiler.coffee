# A library for compiling handlebars templates and outputting them on the page.

hogan = require "hogan.js"

class TemplateCompiler
	# Builds a new TemplateCompiler with the specified compiler function or uses hogan.compile
	constructor: (@compiler) ->
		@compiler ||= (args...) ->
			hogan.compile args...

	# Returns a function that can be called with data to return the template result.
	compileString: (templateStr) ->
		@compiler templateStr

	# Calls the callback with an optional error and the compiled template result as the second parameter
	compileFile: (filePath, done) ->

	# Compiles all the files and directories recursively and calls the callback with errors and results.
	compileDirectory: (filePath, done) ->

module.exports = TemplateCompiler