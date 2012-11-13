fs = require "fs"

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
		fs.readFile filePath, (err, contents) =>
			return done err if err

			# TODO: Wrap compile in try/catch?
			done null, (@compileString contents.toString())

	# Compiles all the files and directories recursively and calls the callback with errors and results.
	compileDirectory: (filePath, done) ->

module.exports = TemplateCompiler