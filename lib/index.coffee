PageRenderer = require "./PageRenderer"

init = (templatesRoot, done) ->
	renderer = new PageRenderer templatesRoot

	renderer.renderScriptTag (err, scriptTag) ->
		throw err if err

		global.templates = -> scriptTag

		done null, scriptTag

module.exports = init


