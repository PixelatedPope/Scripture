///@func audio_play_sound_unique(snd, priority, loops, [wait = false], [random pitch range = 0])
function audio_play_sound_unique(_snd,_priority,_loops,_wait = false, _pitchRange = 0){
	if(audio_is_playing(_snd)) {
		if(_wait) 
			return;
		else
			audio_stop_sound(_snd);
	}
	var _inst = audio_play_sound(_snd, _priority, _loops)
	audio_sound_pitch(_inst,random_range(1-_pitchRange,1+_pitchRange))
}