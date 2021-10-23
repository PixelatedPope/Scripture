/// @description 
currentEmotion = Emotion.normal;
emotionTimer = 0;
startXOff = 0;
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

state = State.in;
stateTimer = 0;
setState = function(_state) {
	state = _state;
	stateTimer = 0;
}
#macro EMOTION_NORMAL "normal"
#macro EMOTION_SMILE "smile"
#macro EMOTION_SHOCKED "shocked"
#macro EMOTION_SAD "sad"
#macro EMOTION_ANGRY "angry"
#macro EMOTION_SCARED	"scared"
#macro EMOTION_ANNOYED "annoyed"

enum Emotion{
	blank,
	normal,
	smile,
	shocked,
	sad,
	scared,
	annoyed,
	angry,
	count,
}