currentTracker = undefined

@openRoom = (type, name) ->
	Session.set 'openedRoom', null
#	creationRoom =  Meteor.setTimeout ->
#			Meteor.call "createChannel", FlowRouter.getParam "name", [], (e,r) ->
#				console.log e
#				console.log r
#		,4000
	query =
		t: type
		name: name
	if type isnt 'd'
		Meteor.call "createIfNotExist", type, name, (e,r) ->
			if e
				console.log(e)

	Meteor.defer ->
		currentTracker = Tracker.autorun (c) ->
			if RoomManager.open(type + name).ready() isnt true
				BlazeLayout.render 'main', {center: 'loading'}
				return

			currentTracker = undefined
			c.stop()

			query =
				t: type
				name: name

			if type is 'd'
				delete query.name
				query.usernames =
					$all: [name, Meteor.user()?.username]

			room = ChatRoom.findOne(query)
			if not room?
				###Session.set 'roomNotFound', {type: type, name: name}
				BlazeLayout.render 'main', {center: 'roomNotFound'}###
				return

			mainNode = document.querySelector('.main-content')
			if mainNode?
				for child in mainNode.children
					mainNode.removeChild child if child?
				roomDom = RoomManager.getDomOfRoom(type + name, room._id)
				mainNode.appendChild roomDom
				if roomDom.classList.contains('room-container')
					roomDom.querySelector('.messages-box > .wrapper').scrollTop = roomDom.oldScrollTop

			Session.set 'openedRoom', room._id

			Session.set 'editRoomTitle', false
			RoomManager.updateMentionsMarksOfRoom type + name
			Meteor.setTimeout ->
				readMessage.readNow()
			, 2000
			# KonchatNotification.removeRoomNotification(params._id)

			if Meteor.Device.isDesktop()
				setTimeout ->
					$('.message-form .input-message').focus()
				, 100

			RocketChat.TabBar.resetButtons()
			RocketChat.TabBar.addButton({ id: 'message-search', i18nTitle: t('Search'), icon: 'octicon octicon-search', template: 'messageSearch', order: 1 })
			if type is 'd'
				RocketChat.TabBar.addButton({ id: 'members-list', i18nTitle: t('User_Info'), icon: 'octicon octicon-person', template: 'membersList', order: 2 })
			else
				RocketChat.TabBar.addButton({ id: 'members-list', i18nTitle: t('Members_List'), icon: 'octicon octicon-organization', template: 'membersList', order: 2 })
			RocketChat.TabBar.addButton({ id: 'uploaded-files-list', i18nTitle: t('Room_uploaded_file_list'), icon: 'octicon octicon-file-symlink-directory', template: 'uploadedFilesList', order: 3 })

			# update user's room subscription
			if ChatSubscription.findOne({rid: room._id})?.open is false
				Meteor.call 'openRoom', room._id

			RocketChat.callbacks.run 'enter-room', ChatSubscription.findOne({rid: room._id})
