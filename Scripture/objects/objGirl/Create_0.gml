/// @description 
event_inherited()
key = "Girl"
startXOff = -500;
sysEvents.addListener(id, Event.changeEmotion, function(_options) {
	if(_options.target != key) return;
	setEmotion(_options.emotion);
});