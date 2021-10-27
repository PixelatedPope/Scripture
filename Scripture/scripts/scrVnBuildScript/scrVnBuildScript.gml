function scrVnBuildScript() {
	scrVnBuildSprites();
	scrVnBuildStyles();
	scrVnBuildEvents();
	scrVnBuildCombos();

	
	var _text = "" 
		+ rant.open 
			+ " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque non turpis volutpat, porttitor nunc eget, faucibus justo. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam non velit id est molestie lobortis. Ut eget metus sit amet augue imperdiet laoreet eget ac odio. Morbi gravida varius enim a volutpat. Morbi placerat eu nisl in bibendum. Ut sollicitudin, ipsum vitae cursus feugiat, mi dui sagittis metus, ut commodo lectus purus ut massa. Donec in sodales leo, vitae convallis mi. In quis mi ut dui ullamcorper faucibus at sed magna. Nam vehicula fringilla rutrum. Suspendisse ac hendrerit leo. Proin gravida metus erat, in elementum lectus molestie accumsan. Duis scelerisque porta accumsan.Etiam porta condimentum leo, vitae pellentesque enim venenatis sit amet. Quisque cursus, augue sit amet dapibus rhoncus, metus tortor ornare sapien, eu cursus neque velit quis nulla. Nunc mattis consequat sem, at vulputate tortor bibendum non. Cras rhoncus purus est, a vestibulum lectus porta eget. Morbi malesuada quam quis commodo dignissim. Etiam nisl metus, pulvinar vitae dignissim nec, scelerisque consequat elit. Praesent ut faucibus felis. Nam placerat nibh in erat vestibulum, sit amet tempus est pulvinar. Vestibulum ut risus leo. Cras blandit pretium orci a volutpat. In bibendum cursus turpis id gravida. \r" 
		+ rant.close
		+ setSpeakerGirl 
			+ "Hello?  Onii-san?  Where are you?"
			+ evSlideInCharacter.event(VN_GIRL)
			+ "\r" + evSnapSlide.event(VN_GIRL) 
			+ evSetEmotion.event(VN_GIRL,EMOTION_ANGRY)
			+ shout.open
				+ "\nONIIIIIIIIIIII-SAAAAAAAAAAAN!!!!!!\r"
			+ shout.close
		+ setSpeakerBoy
		+ "Yumi?\r"
		+ evChangeName.event(VN_GIRL,1)
		+ evSetEmotion.event(VN_GIRL, EMOTION_SHOCKED)
		+ wait(60) 
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
			+ "<s 4>Will you cut it out with the weeb crap?<30> Stop Calling me \""+boyNameOniisan+"\"!  My name is " 
			+ evChangeName.event(VN_BOY, 1)
			+ boyNameKanji + "!!<s 1>\r" 
		+ evSnapSlide.event(VN_BOY)
		+ evSetEmotion.event(VN_GIRL,EMOTION_SAD)
		+ setSpeakerGirl 
			+ sprCry + sprCry + sprCry + sprCry + sprCry +"I can't read <#3333FF>kanji<#FFFFFF>...\r" 
		+setSpeakerBoy 
		+evSetEmotion.event(VN_BOY,EMOTION_NORMAL) 
		+ "Whatever.  It's read "+boyNameRomaji + evChangeName.event(VN_BOY, 3) + ".<60>  But don't worry about it."+ evSetEmotion.event(VN_GIRL, EMOTION_NORMAL) + "<30> We should probably worry more about where we are right now.\r" 		
		
		
	return _text;
}