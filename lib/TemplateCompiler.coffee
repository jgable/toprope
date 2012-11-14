fs = require "fs"

hogan = require "hogan.js"

class TemplateCompiler
	# Builds a new TemplateCompiler with the specified compiler function or uses hogan.compile
	constructor: (@compiler, @asString) ->
		@asString = !!@asString
		@compiler ||= (args...) ->
			hogan.compile args...

	# Returns a function that can be called with data to return the template result.
	compileString: (templateStr) ->
		if @asString
			@compiler templateStr, {@asString}
		else 
			@compiler templateStr

	# Calls the callback with an optional error and the compiled template result as the second parameter
	compileFile: (filePath, done) ->
		fs.readFile filePath, (err, contents) =>
			return done err if err

			# TODO: Wrap compile in try/catch?
			done null, (@compileString contents.toString())

	_loadFile: (loadFilePath, origFilePath, loadDone) ->
		@compileFile loadFilePath, (err, compiled) =>
			return loadDone err if err
			
			result = {}

			name = @_getTemplateNameFromFilePath loadFilePath, origFilePath
			result[name] = compiled

			loadDone null, result

	_loadDirectory: (loadDirPath, origFilePath, loadDirDone) =>

		# Prime our results and curr path index.
		results = []
		currPathIdx = 0

		# Fix up our directory path to be copacetic
		loadDirPath += "/" unless loadDirPath.slice(-1) is "/"
		
		# Read the entries in the directory
		fs.readdir loadDirPath, (err, paths) =>
			# Bug out if an error occured
			return loadDirDone err if err

			# The callback for loading the items in the directory
			loadedCallback = (err, result) =>
				# Bug out if an error occured
				return loadDirDone err if err

				# Push an array of results, or a single result
				if result.length
					results.push single for single in result
				else 
					results.push result

				currPathIdx++

				# Bug out if done with all the paths.
				unless currPathIdx < paths.length
					# Take our array of results and build a single object from it
					toReturn = {}
					for result in results
						for own key,val of result
							toReturn[key] = val

					return loadDirDone null, toReturn
				
				# Get the current path from our paths
				currPath = paths[currPathIdx]

				# Skip files if they have a leading "." (hidden)
				return loadedCallback(null, []) if currPath.slice(0, 1) == "."

				# Load this path of the directory and process the results
				@_loadFileOrDirectory "#{loadDirPath}#{currPath}", origFilePath, loadedCallback

			
			firstPath = paths[currPathIdx]
			# Skip hidden files until we get a valid one
			while currPathIdx < paths.length and firstPath.slice(0, 1) == "." 
				currPathIdx++
				firstPath = paths[currPathIdx]

			# Bug out if we went through a directory with only hidden files
			unless currPathIdx < paths.length and firstPath
				return loadDirDone null, {}

			# Let's light this candle
			@_loadFileOrDirectory "#{loadDirPath}#{firstPath}", origFilePath, loadedCallback

	_loadFileOrDirectory: (fileOrDirPath, origFilePath, doneFileOrDir) ->
		# Get info about the file path (is it a dir or file?)
		fs.stat fileOrDirPath, (err, stat) =>
			return doneFileOrDir err if err

			if stat?.isDirectory() 
				@_loadDirectory fileOrDirPath, origFilePath, doneFileOrDir
			else 
				@_loadFile fileOrDirPath, origFilePath, doneFileOrDir

	_getTemplateNameFromFilePath: (nameFilePath, filePath) ->
		nameFilePath
			.replace(filePath, '')
			.replace('/', '_')

	# Compiles all the files and directories recursively and calls the callback with errors and results.
	compileDirectory: (filePath, done) ->

		unless filePath.slice(-1) == "/"
			filePath += "/"
		
		@_loadDirectory filePath, filePath, done

module.exports = TemplateCompiler