/* Context Traits
   https://github.com/tagae/context-traits
   Copyright © 2012 UCLouvain */

module.exports = function(grunt) {

  'use strict';

	function isDir(path) {
		return path.charAt(path.length-1) == '/';
	}

	grunt.registerMultiTask('coffee', 'Compile CoffeeScript files', function() {
		var taskDone = this.async();
		var files = this.file.src;
		var target = this.file.dest;
		var options = {
			cmd: 'coffee',
			args: [ '--compile' ]
		};
		if(isDir(target)) {
			options.args.push('--output');
			options.args.push(target);
		}
		else {
			options.args.push('--join');
			options.args.push(target);
		}
		if(!Array.isArray(files)) {
			files = grunt.file.expand(files);
		}
		if(files.length > 0) {
			options.args = options.args.concat(files);
			grunt.log.writeln("CoffeeScript: compiling " + files.join(', '));
			grunt.utils.spawn(options, function (error, result, code) {
				if(error) {
					grunt.log.error("CoffeeScript error: " + error);
				}
				else {
					if(isDir(target)) {
						grunt.log.writeln('CoffeeScript: output went to ' + target);
					}
					else {
						grunt.log.writeln('CoffeeScript produced ' + target);
					}
				}
				taskDone();
			});
		}
		else {
			grunt.error("CoffeeScript: No input specified.");
			taskDone();
		}
	});

};
