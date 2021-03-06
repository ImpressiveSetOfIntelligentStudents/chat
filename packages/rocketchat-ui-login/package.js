Package.describe({
	name: 'rocketchat:ui-login',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.versionsFrom('1.2.1');
	api.use([
		'ecmascript',
		'templating',
		'coffeescript',
		'underscore',
		'rocketchat:lib@0.0.1'
	]);

	api.addFiles('login/footer.html', 'client');
	api.addFiles('login/form.html', 'client');
	api.addFiles('login/header.html', 'client');
	api.addFiles('login/intro.html', 'client');
	api.addFiles('login/layout.html', 'client');
	api.addFiles('login/services.html', 'client');
	api.addFiles('login/social.html', 'client');

	api.addFiles('username/layout.html', 'client');
	api.addFiles('username/username.html', 'client');

	api.addFiles('login/footer.coffee', 'client');
	api.addFiles('login/form.coffee', 'client');
	api.addFiles('login/header.coffee', 'client');
	api.addFiles('login/services.coffee', 'client');
	api.addFiles('login/social.coffee', 'client');
	api.addFiles('username/username.coffee', 'client');
	api.addFiles(['username/fastlogin.html', 'username/fastlogin.js'], 'client');
});
