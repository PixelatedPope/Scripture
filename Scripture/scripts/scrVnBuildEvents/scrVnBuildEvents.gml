function scrVnBuildEvents() {
	evChangeName = scripture_register_event("ChangeName",function(_arguments) {
		sysEvents.raiseEvent(Event.changeName,{target: _arguments[0]});
	},false)

	evBoyBounce = scripture_register_event("BoyBounce",function(){
		with(objVnBoy){
			setState(State.bounce);
		}
	});

	evSetEmotion = scripture_register_event("SetEmotion",function(_arguments){
		sysEvents.raiseEvent(Event.changeEmotion,{target: _arguments[0],emotion: _arguments[1]})
	});
	
	evSetSpeaker = scripture_register_event("SetSpeaker",function(_arguments){
		sysEvents.raiseEvent(Event.changeSpeaker,{target: _arguments[0]})
	});
}