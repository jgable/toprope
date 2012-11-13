should = require "should"

TemplateCompiler = require "../lib/TemplateCompiler"

describe "TemplateCompiler", ->
	compiler = null

	beforeEach ->
		compiler = new TemplateCompiler

	it "exists", ->
		should.exist compiler

	it "compiles strings", ->
		compiled = compiler.compileString "<p>Something Crazy named {{name}}</p>"

		should.exist compiled

		result = compiled.render { name: "Jacob" }

		result.should.equal "<p>Something Crazy named Jacob</p>"


