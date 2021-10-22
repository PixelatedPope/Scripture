if(room != targetRoom) exit;
sysEvents.raiseEvent(Event.transitionRoomStart);
state = State.in;
timer = -delay;
fadeOut = false;