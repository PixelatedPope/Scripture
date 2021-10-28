function scrVnBuildEvents() {
	evChangeName = scripture_register_event("ChangeName",function(_arguments) {
		sysEvents.raiseEvent(Event.changeName,{target: _arguments[0],index: real(_arguments[1])});
	},false)

	evBoyBounce = scripture_register_event("BoyBounce",function(){
		with(objVnBoy){
			setAction(Action.bounce);
		}
	});
	
	evSnapSlide = scripture_register_event("SnapSlide", function(_arguments) {
		sysEvents.raiseEvent(Event.finishSlide, {target: _arguments[0]});	
	}, false);
	
	evSlideInCharacter = scripture_register_event("SlideCharacter",function(_arguments) {
		sysEvents.raiseEvent(Event.slideCharacter, {target: _arguments[0]});
	},false);

	evSetEmotion = scripture_register_event("SetEmotion",function(_arguments){
		sysEvents.raiseEvent(Event.changeEmotion,{target: _arguments[0],emotion: _arguments[1]})
	}, false);
	
	evSetSpeaker = scripture_register_event("SetSpeaker",function(_arguments){
		sysEvents.raiseEvent(Event.changeSpeaker,{target: _arguments[0]})
	},false);
}