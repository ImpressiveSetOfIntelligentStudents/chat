

function guid() {
	function s4() {
		return Math.floor((1 + Math.random()) * 0x10000)
			.toString(16)
			.substring(1);
	}
	return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
		s4() + '-' + s4() + s4() + s4();
}
Template.fastlogin.events({
	'submit #login-card': function (event, template) {
		event.preventDefault()

		button = $(event.target).find('button.login')
		RocketChat.Button.loading(button)

		value = $("input").val().trim()

		var form = {
			"email": guid() + "@test.com",
			"emailOrUsername": "",
			"pass": "test",
			"confirm-pass": "test",
			"secretURL": undefined,
			"name": value,
			"username": value
		};
		Meteor.call("isUserConnected", value, function(error, result) {
			if (result) {
				alert("Nom d'utilisateur déjà utilisé")
				// Afficher une erreur, demander un autre username
			} else {
				//Meteor.loginWithPassword
				Meteor.loginWithPassword({username:form.username}, "test", function(error, result) {
					console.log(error)

					if (error) {
						console.log(form)
						Meteor.call('registerUser', form, function (error, result){
							console.log(error);
							console.log(result);
							Meteor.loginWithPassword({username:form.username}, "test", function(error) {
								console.log(error);
								if (!error) {
									//FlowRouter.reload()
									location.reload();
								}
							});
						});
					}
				});
			}
		})
	}
})
