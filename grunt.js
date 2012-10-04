module.exports = function (grunt) {
  'use strict';

	var parts = [
		'prologue',
		'prototypes',
		'activation',
		'adaptation',
		'composition',
		'namespaces',
		'contexts',
		'epilogue' ];

	var _ = grunt.utils._;

	grunt.initConfig({

		pkg: '<json:package.json>',

		meta: {
			banner: '/* ' + [
				'<%= pkg.title %> v<%= pkg.version %>',
				'<%= pkg.homepage %>',
				'Copyright © <%= grunt.template.today("yyyy") %> <%= pkg.copyright %>',
				'Licensed under <%= _.toSentence(_(pkg.licenses).pluck("type")) %>'
			].join('\n   ') + ' */'
		},

		concat: {
			lib: {
				src: [ '<banner>', 'build/<%= pkg.name %>.js' ],
				dest: 'dist/<%= pkg.name %>.js'
			},
			test: {
				src: [ '<banner>', 'build/<%= pkg.name %>-tests.js' ],
				dest: 'test/<%= pkg.name %>-tests.js'
			}
		},

		min: {
			lib: {
				src: ['<banner:meta.banner>', '<config:concat.lib.dest>'],
				dest: 'dist/<%= pkg.name %>.min.js'
			}
		},

		coffee: {
			lib: {
				src: _.map(parts, function (p) { return 'src/' + p + '.coffee'; }),
				dest: 'build/<%= pkg.name %>.js'
			},
			contexts: {
				src: 'src/contexts/',
				dest: 'dist/contexts/'
			},
			test: {
				src: _.map(parts, function (p) { return 'test/src/' + p + '.coffee'; }),
				dest: 'build/<%= pkg.name %>-tests.js'
			}
		},

		qunit: {
			files: ['test/index.html']
		},

		lint: {
			files: ['grunt.js']
		},

		watch: {
			files: [
				'<config:coffee.lib.src>',
				'<config:coffee.test.src>',
				'<config:qunit.files>'
			],
			tasks: 'targets'
		},

		jshint: {
			options: {
				boss: true,
				browser: true,
				curly: true,
				eqeqeq: true,
				eqnull: true,
				immed: true,
				latedef: true,
				newcap: true,
				noarg: true,
				sub: true,
				undef: true
			},
			globals: {
				exports: true,
				module: false
			}
		},

		docco: {
			src: [ 'src/*.coffee' ]
		},

		clean: {
			folder: [ "build/" ]
		},

		server: {
			port: 4000,
			base: '.'
		},

		reload: {
			port: 8000,
			proxy: {
				host: 'localhost',
				port: 4000
			}
		}
	});

	grunt.loadTasks('.tasks/');

	grunt.loadNpmTasks('grunt-clean');
	grunt.loadNpmTasks('grunt-docco');
	grunt.loadNpmTasks('grunt-reload');

	// Generation
	grunt.registerTask('libs', 'coffee:lib concat:lib min:lib coffee:contexts');
	grunt.registerTask('docs', 'docco');
	grunt.registerTask('tests', 'coffee:test concat:test');
	grunt.registerTask('targets', 'libs tests docs');

	// Commands
	grunt.registerTask('test', 'libs tests qunit');
	grunt.registerTask('default', 'targets lint qunit');
};
