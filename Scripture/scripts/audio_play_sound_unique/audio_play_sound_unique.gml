///@func audio_play_sound_unique(snd, priority, loops, [wait = false], [pitch lower range = 1], [_pitchUpper = 1])
function audio_play_sound_unique(_snd,_priority,_loops,_wait = false, _pitchLower = 1, _pitchUpper){
	if(audio_is_playing(_snd)) {
		if(_wait) 
			return;
		else
			audio_stop_sound(_snd);
	}
	var _inst = audio_play_sound(_snd, _priority, _loops)
	audio_sound_pitch(_inst,random_range(_pitchLower,_pitchUpper))
}