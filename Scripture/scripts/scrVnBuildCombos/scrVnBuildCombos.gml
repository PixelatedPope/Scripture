function scrVnBuildCombos() {
	setSpeakerBoy = sndGirl.close+evSetSpeaker.event(VN_BOY) + sndBoy.open
	setSpeakerGirl = sndBoy.close+evSetSpeaker.event(VN_GIRL) + sndGirl.open
	boyNameOniisan = 
		bold.open +
			"Onii-san" +
		bold.close
	
	boyNameKanji = 
		bold.open +
			rotateFade.open + 
				"<BoyBounce>虎<60><BoyBounce>太<60><BoyBounce>郎<60>" + 
			bold.close + 
		rotateFade.close

	boyNameHiragana = 
		bold.open +
			rotateFade.open +
				"こたろう" + bold.close +
			rotateFade.close +
		bold.close
		
	boyNameRomaji = 
		bold.open +
			"Kotarou" +
		bold.close
	
	girlName = 
		bold.open + 
			"Yumi" +
		bold.close
}