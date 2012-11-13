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



