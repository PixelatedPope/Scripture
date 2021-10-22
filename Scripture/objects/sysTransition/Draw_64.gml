/// @description 
if(state == State.wait) exit;

if(state == State.out) {
	outEffect.drawGui(timer/outLength);
} else {
	inEffect.drawGui(1 - timer/inLength)
}
  