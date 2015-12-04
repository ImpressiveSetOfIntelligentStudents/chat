Meteor.methods
	registerUser: (formData) ->
		if RocketChat.settings.get('Accounts_RegistrationForm') is 'Disabled'
			throw new Meteor.Error 'registration-disabled', 'User registration is disabled'

		else if RocketChat.settings.get('Accounts_RegistrationForm') is 'Secret URL' and (not formData.secretURL or formData.secretURL isnt RocketChat.settings.get('Accounts_RegistrationForm_SecretURL'))
			throw new Meteor.Error 'registration-disabled', 'User registration is only allowed via Secret URL'

		userData =
			username: formData.username
			email: formData.email
			password: formData.pass

		userId = Accounts.createUser userData
		RocketChat.models.Users.setUserActive userId, true
		profile = {}

		RocketChat.models.Users.setProfile userId, profile
		RocketChat.models.Users.setName userId, formData.username
		return userId
