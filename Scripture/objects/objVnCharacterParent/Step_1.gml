/// @description 
if(keyboard_check_pressed(vk_right)) {
	emotionTimer = 0;
	emotionOffReset()
	currentEmotion++;
}
if(keyboard_check_pressed(vk_left)) {
	emotionTimer = 0;
	emotionOffReset()
	currentEmotion--;
}

currentEmotion = clamp(currentEmotion,Emotion.normal, Emotion.annoyed)