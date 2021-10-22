/// @description 
if(state == State.wait) exit;

timer++;
if(state == State.out) {
	outEffect.step(timer/outLength);
	
	if(timer >= outLength)
		room_goto(targetRoom);  
 
} else {
	inEffect.step(1 - timer/inLength)
	if(timer >= inLength) {
		sysEvents.raiseEvent(Event.transitionDone);
		state = State.wait;  
	}
}
  