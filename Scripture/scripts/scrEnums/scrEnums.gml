enum State {
	stand,
	walk,
	wait,
	out,
	in,
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
	finishSlide,
	changeSpeaker,
	changeEmotion,
	changeName,
}

enum Action {
	wait,
	bounce
}
