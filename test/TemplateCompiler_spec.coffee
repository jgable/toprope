should = require "should"

TemplateCompiler = require "../lib/TemplateCompiler"

describe "TemplateCompiler", ->
	compiler = null
	testData = { name: "Jacob" }

	beforeEach ->
		compiler = new TemplateCompiler

	it "exists", ->
		should.exist compiler

	it "compiles strings", ->
		compiled = compiler.compileString "<p>Something Crazy named {{name}}</p>"

		should.exist compiled

		result = compiled.render testData

		result.should.equal "<p>Something Crazy named #{testData.name}</p>"

	it "compiles files", (done) ->
		filePath = process.cwd() + "/test/templates/template1.hbs"
		compiler.compileFile filePath, (err, compiled) ->
			throw err if err

			should.exist compiled

			result = compiled.render testData

			result.should.equal "<h1>#{testData.name}</h1>"

			done()

	it "compiles one depth level directories", (done) ->
		filePath = process.cwd() + "/test/templates/one"
		compiler.compileDirectory filePath, (err, result) ->
			throw err if err

			should.exist result

			should.exist result["templatea.hbs"]
			should.exist result["templateb.hbs"]

			rendered = result["templatea.hbs"].render testData
			rendered.should.equal "<a>Jacob</a>"

			rendered = result["templateb.hbs"].render testData
			rendered.should.equal "<b>Jacob</b>"

			done()

	it "compiles two depth level directories", (done) ->
		filePath = process.cwd() + "/test/templates"
		compiler.compileDirectory filePath, (err, result) ->
			throw err if err

			should.exist result

			templates = [
				"template1.hbs"
				"template2.hbs"
				"template3.hbs"
				"one_templatea.hbs"
				"one_templateb.hbs"
				"two_templatec.hbs"
				"two_templated.hbs"
			]

			templateCount = 0
			for own templateName,templateFunc of result
				templateCount++
				(templateName in templates).should.equal true, templateName

			templateCount.should.equal templates.length

			rendered = result["template1.hbs"].render testData
			rendered.should.equal "<h1>Jacob</h1>"

			rendered = result["one_templateb.hbs"].render testData
			rendered.should.equal "<b>Jacob</b>"

			rendered = result["two_templatec.hbs"].render testData
			rendered.should.equal "<c>Jacob</c>"			

			done()

	it "skips hidden files", ->
		# This is shown by the two depth level test
		true


