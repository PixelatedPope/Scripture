function scrVnBuildScript() {
	scrVnBuildSprites();
	scrVnBuildStyles();
	scrVnBuildEvents();
	scrVnBuildCombos();
	var _text = "" +
		sndGirl.open + 
			"Hello?  Onii-san?  Where are you?\r"+ 
			evSlideInCharacter.event(VN_GIRL) +
			wait(120) +
			evSetEmotion.event(VN_GIRL,EMOTION_ANGRY) +
			shout.open +
				"\nONIIIIIIIIIIII-SAAAAAAAAAAAN!!!!!!\r"+ 
			shout.close +
		sndGirl.close +
		evSetSpeaker.event(VN_BOY) +
		"Yumi?\r" +
		evChangeName.event(VN_GIRL) +
		evSetEmotion.event(VN_GIRL, EMOTION_SHOCKED) +
		wait(60) + 
		evSetSpeaker.event(VN_GIRL) +
		evSetEmotion.event(VN_GIRL, EMOTION_SMILE) +
		bold.open +
			colorful.open +
				"\n"+sprHeart+sprHeart+sprHeart+"  ONII-SAN!  "+sprHeart+sprHeart+sprHeart+"\r" +
			colorful.close +
		bold.close +
		evSetSpeaker.event(VN_BOY) +
		"Will you cut it out with the weeb crap? <30> Stop Calling me \""+boyNameOniisan+"\"!<30> My name is " + 
		evChangeName.event(VN_BOY) + 
		boyNameKanji + "\r" +
		evSetEmotion.event(VN_GIRL,EMOTION_SAD);
		
		
	return _text;
}