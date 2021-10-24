/// @description 
currentEmotion = Emotion.normal;
emotionTimer = 0;
key = "";
depth = VN_CHARACTER_DEPTH;
emotionOffReset = function() {
	emotionOff = {x: 0, y: 0, angle: 0, color: c_white};
}
emotionOffReset();

setEmotion = function(_emotionString){
	emotionTimer = 0;
	switch(_emotionString) {
		case EMOTION_NORMAL: currentEmotion = Emotion.normal; break;
		case EMOTION_SMILE: currentEmotion = Emotion.smile; break;
		case EMOTION_SHOCKED: currentEmotion = Emotion.shocked; break;
		case EMOTION_SAD: currentEmotion = Emotion.sad; break;
		case EMOTION_ANGRY: currentEmotion = Emotion.angry; break;
		case EMOTION_SCARED:	currentEmotion = Emotion.scared; break;
		case EMOTION_ANNOYED: currentEmotion = Emotion.annoyed; break;
	}
}

action = Action.wait;
actionTimer = 0;
setState = function(_state) {
	action = _state;
	actionTimer = 0;
}
actionOffReset = function() {
	actionOff = {x: 0, y: 0, angle: 0, color: c_white};
}
actionOffReset();