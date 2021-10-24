enum State {
	stand,
	walk,
	wait,
	out,
	in,
	bounce,
	girlIn,
	boyIn
}

enum Event {
	transitionRoomStart,
	transitionStarted,
	transitionDone,
	transitionRoomEnd,
	slideInDone,
	slideCharacter,
	changeSpeaker,
	changeEmotion,
	changeName,
}

enum Action {
	wait,
	bounce
}
