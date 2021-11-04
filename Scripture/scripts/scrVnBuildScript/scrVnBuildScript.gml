function scrVnBuildScript() {
	scrVnBuildSprites();
	scrVnBuildStyles();
	scrVnBuildEvents();
	scrVnBuildCombos();
	
	var _text = ""
		+ setSpeakerGirl
			+ evSetEmotion.event(VN_GIRL,EMOTION_SCARED)
			+ "Hello?<30>  Onii-san?<0> Where are you?"
			+ evSlideInCharacter.event(VN_GIRL)
			+ "\r" + evSnapSlide.event(VN_GIRL) 
			+ evSetEmotion.event(VN_GIRL,EMOTION_ANGRY)
			+ shout.open
				+ "\nONIIIIIIIIII-SAAAAAAAAAN!!!!!!\r"
			+ shout.close
		+ setSpeakerBoy
		+ "Yumi?"
		+ evChangeName.event(VN_GIRL,1)
		+ evSetEmotion.event(VN_GIRL, EMOTION_SHOCKED)
		+ wait(60) + "\r"
		+ setSpeakerGirl
		+ evSetEmotion.event(VN_GIRL, EMOTION_SMILE)
		+ bold.open
			+ colorful.open
				+ "\n"+sprHeart+sprHeart+sprHeart+"  ONII-SAN!  "+sprHeart+sprHeart+sprHeart
				+ evSlideInCharacter.event(VN_BOY)
				+ "\r"
			+ colorful.close
		+ bold.close
		+ evSetEmotion.event(VN_BOY, EMOTION_ANNOYED)
		+ setSpeakerBoy
			+ "<s 4>Will you cut it out with the weeb crap?<30> Stop Calling me \""+boyNameOniisan+"\"!  My name is <30>" 
			+ evChangeName.event(VN_BOY, 1)
			+ boyNameKanji + "!!<s 1>\r" 
		+ evSnapSlide.event(VN_BOY)
		+ evSetEmotion.event(VN_GIRL,EMOTION_SAD)
		+ setSpeakerGirl 
			+ sprCry + sprCry + sprCry + sprCry + sprCry +"I can't read <#3333FF>kanji<#FFFFFF>...\r" 
		+ setSpeakerBoy 
		+ evSetEmotion.event(VN_BOY,EMOTION_NORMAL) 
		+ "Whatever.  It's read "+boyNameRomaji + evChangeName.event(VN_BOY, 2) + ".<60>  But don't worry about it."+ evSetEmotion.event(VN_GIRL, EMOTION_NORMAL) + "<30> We should probably worry more about where we are right now.\r"
		+ colorful.open + 
			"MORE DEMO(s?) COMING SOME POINT IN THE FUTURE MAYBE!"
	return _text;
}