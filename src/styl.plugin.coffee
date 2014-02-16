# Export Plugin
module.exports = (BasePlugin) ->
	# Define Plugin
	class StylPlugin extends BasePlugin
		# Plugin name
		name: 'styl'

		# Plugin config
		config:
			compileOptions:
				whitespace: true
				compress: true
			environments:
				development:
					compileOptions:
						compress: false

		# Render some content
		render: (opts) ->
			# Prepare
			{inExtension,outExtension,content,file} = opts

			# Check extensions
			if inExtension in ['styl'] and outExtension in ['css',null]
				# Prepare
				styl = require('styl')
				compileOptions = {
					filename: file.get('fullPath')
				}

				# Merge options
				for own key,value of @getConfig().compileOptions
					compileOptions[key] ?= value

				# Adjust for styl lack of tab support
				# https://github.com/visionmedia/styl/issues/19
				opts.content = opts.content.replace(/\t/g, '  ')  if compileOptions.whitespace is true

				# Render
				opts.content = styl(opts.content, compileOptions).toString()

			# Done
			return
