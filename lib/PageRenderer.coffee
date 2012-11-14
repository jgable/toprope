
TemplateCompiler = require "./TemplateCompiler"

class PageRenderer
	constructor: (@templatesRoot = "#{process.cwd()}/public/templates", @compiler = new TemplateCompiler null, true) ->

	getCompiledTemplates: (done) -> 
		@compiler.compileDirectory @templatesRoot, done

	renderScriptTag: (done) ->
		@getCompiledTemplates (err, compiled) ->
			done err if err

			makeLine = (key, templ) ->
				"\"#{key}\": #{templ}"

			lines = (makeLine key, val for own key,val of compiled).join ",\n\t"

			done null, 
			"""
			<script type="text/javascript">
				var APPLICATION_TEMPLATES = {
					#{lines}
				};
			</script>
			"""

module.exports = PageRenderer
		

