function scrVnBuildCombos() {
	setSpeakerBoy = sndGirl.close+evSetSpeaker.event(VN_BOY) + sndBoy.open
	setSpeakerGirl = sndBoy.close+evSetSpeaker.event(VN_GIRL) + sndGirl.open
	boyNameOniisan = "Onii-san"
	
	boyNameKanji = 
		bold.open +
			rotateFade.open + 
				"<BoyBounce>虎<35><BoyBounce>太<35><BoyBounce>郎<35>" + 
			bold.close + 
		rotateFade.close
		
	boyNameRomaji = "Kotarou"
	
	girlName = "Yumi"
}