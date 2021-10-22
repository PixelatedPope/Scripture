/// @description 
if(state == State.wait) exit;

if(state == State.out) {
	outEffect.draw(timer/outLength);
} else {
	inEffect.draw(1 - timer/inLength)
}
  