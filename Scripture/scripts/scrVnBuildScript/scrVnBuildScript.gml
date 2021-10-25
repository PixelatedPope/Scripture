function scrVnBuildScript() {
	scrVnBuildSprites();
	scrVnBuildStyles();
	scrVnBuildEvents();
	scrVnBuildCombos();
	var _text = "" +
		setSpeakerGirl + 
			"Hello?  Onii-san?  Where are you?"+ 
			evSlideInCharacter.event(VN_GIRL) +
			"\r" + wait(120) + evSnapSlide.event(VN_GIRL) + 
			evSetEmotion.event(VN_GIRL,EMOTION_ANGRY) +
			shout.open +
				"\nONIIIIIIIIIIII-SAAAAAAAAAAAN!!!!!!\r"+ 
			shout.close +
		setSpeakerBoy +
		"Yumi?\r" +
		evChangeName.event(VN_GIRL) +
		evSetEmotion.event(VN_GIRL, EMOTION_SHOCKED) +
		wait(60) + 
		setSpeakerGirl +
		evSetEmotion.event(VN_GIRL, EMOTION_SMILE) +
		bold.open +
			colorful.open +
				"\n"+sprHeart+sprHeart+sprHeart+"  ONII-SAN!  "+sprHeart+sprHeart+sprHeart + 
				evSlideInCharacter.event(VN_BOY) +
				"\r" +
			colorful.close +
		bold.close +
		evSetEmotion.event(VN_BOY, EMOTION_ANNOYED) +
		setSpeakerBoy +
			"<s 2>Will you cut it out with the weeb crap?<30> Stop Calling me \""+boyNameOniisan+"\"!<30> My name is " + 
			evChangeName.event(VN_BOY) +
			boyNameKanji + "<s 1>\r"  +
		evSnapSlide.event(VN_BOY) +
		evSetEmotion.event(VN_GIRL,EMOTION_SAD) +
		setSpeakerGirl +
			sprCry + sprCry + sprCry + sprCry + sprCry +"I can't read <#3333FF>kanji<#FFFFFF>...\r" +
		setSpeakerBoy +
		evSetEmotion.event(VN_BOY,EMOTION_NORMAL) +
			"It's fine. <30>Don't worry about it."+ evSetEmotion.event(VN_GIRL, EMOTION_NORMAL) + "<30> Anyway where are we?\r"
		
		
		
		
	return _text;
}