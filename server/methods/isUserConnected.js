Meteor.methods({
	"isUserConnected": function(username) {
		var users = Meteor.users.find({username:username}).fetch()
		console.log(users);
		return users.length == 1 && users[0].status == "online";
	}
})

Meteor.methods({
	"createIfNotExist": function(type, name, users) {
		if (! RocketChat.models.Rooms.findOneByNameAndType(name, type)) {
			Meteor.call("createChannel", name, []);
		}
	}
})


