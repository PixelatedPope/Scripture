function scrVnBuildScript() {
	scrVnBuildSprites();
	scrVnBuildStyles();
	scrVnBuildEvents();
	scrVnBuildCombos();

	var _text = ""
	_text +=
		"Hello?  Onii-san?  Where are you?"+ 
		evSetSpeaker.event(VN_BOY) + 
		evSetEmotion.event(VN_BOY,Emotion.angry) + 
		"Stop Calling me \""+boyNameOniisan+"\"!<60> My name is " + 
		evChangeName.event(VN_BOY, 1) + 
		boyNameKanji + "<120> And don't you forget it!" +
		evSetEmotion.event(VN_GIRL,EMOTION_SAD);
	return _text;
}