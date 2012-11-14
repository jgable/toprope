should = require "should"

PageRenderer = require "../lib/PageRenderer"

describe "PageRenderer", ->
	renderer = null

	beforeEach ->
		renderer = new PageRenderer(process.cwd() + "/test/templates/one")

	it "can get a string version of the compiled templates", (done) ->
		renderer.getCompiledTemplates (err, compiled) ->
			throw err if err

			# There's not really a good way to test this.
			should.exist compiled

			done()

	it "can render a script tag", (done) ->
		renderer.renderScriptTag (err, scriptTag) ->
			throw err if err

			# There's not really a good way to test this.
			should.exist scriptTag



			done()
