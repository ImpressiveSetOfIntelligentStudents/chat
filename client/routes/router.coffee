Blaze.registerHelper 'pathFor', (path, kw) ->
	return FlowRouter.path path, kw.hash

BlazeLayout.setRoot 'body'


FlowRouter.subscriptions = ->
	Tracker.autorun =>
		RoomManager.init()
		@register 'userData', Meteor.subscribe('userData')
		@register 'activeUsers', Meteor.subscribe('activeUsers')
		@register 'admin-settings', Meteor.subscribe('admin-settings')


FlowRouter.route '/',
	name: 'index'

	action: ->
		BlazeLayout.render 'main', {center: 'loading'}
		if not Meteor.userId()
			return FlowRouter.go 'home'

		Tracker.autorun (c) ->
			if FlowRouter.subsReady() is true
				Meteor.defer ->
					if Meteor.user().defaultRoom?
						room = Meteor.user().defaultRoom.split('/')
						FlowRouter.go room[0], {name: room[1]}
					else
						FlowRouter.go 'home'
				c.stop()


FlowRouter.route '/login',
	name: 'login'

	action: ->
		FlowRouter.go 'home'


FlowRouter.route '/home',
	name: 'home'

	action: ->
		RocketChat.TabBar.reset()
		BlazeLayout.render 'main', {center: 'home'}
		KonchatNotification.getDesktopPermission()


FlowRouter.route '/account/:group?',
	name: 'account'

	action: (params) ->
		RocketChat.TabBar.closeFlex()
		RocketChat.TabBar.resetButtons()

		unless params.group
			params.group = 'Preferences'
		params.group = _.capitalize params.group, true
		BlazeLayout.render 'main', { center: "account#{params.group}" }


FlowRouter.route '/history/private',
	name: 'privateHistory'

	subscriptions: (params, queryParams) ->
		@register 'privateHistory', Meteor.subscribe('privateHistory')

	action: ->
		Session.setDefault('historyFilter', '')
		BlazeLayout.render 'main', {center: 'privateHistory'}



FlowRouter.route '/room-not-found/:type/:name',
	name: 'room-not-found'

	action: (params) ->
		Session.set 'roomNotFound', {type: params.type, name: params.name}
		BlazeLayout.render 'main', {center: 'roomNotFound'}

FlowRouter.route '/fxos',
	name: 'firefox-os-install'

	action: ->
		BlazeLayout.render 'fxOsInstallPrompt'

FlowRouter.route '/register/:hash',
	name: 'register-secret-url'
	action: (params) ->
		if RocketChat.settings.get('Accounts_RegistrationForm') is 'Secret URL'
			Meteor.call 'checkRegistrationSecretURL', params.hash, (err, success) ->
				if success
					Session.set 'loginDefaultState', 'register'
					BlazeLayout.render 'main', {center: 'home'}
					KonchatNotification.getDesktopPermission()
				else
					BlazeLayout.render 'blankLayout', { render: 'invalidSecretURL' }
		else
			BlazeLayout.render 'blankLayout', { render: 'invalidSecretURL' }
