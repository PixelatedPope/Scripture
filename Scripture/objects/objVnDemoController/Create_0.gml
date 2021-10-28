/// @description 
girlX = 289;
boyX = 965;
offScreen = 1000;

instance_create_depth(0,0,0,sysEvents);
instance_create_depth(0,0,0,objVnTextbox);
instance_create_depth(0,0,0,objDemoToolbar);
instance_create_depth(boyX + offScreen,665,0,objVnBoy);
instance_create_depth(girlX - offScreen,665,0,objVnGirl);
layer_depth("Fade",VN_FADE);

state = State.in;
stateTimer = 0;
setAction = function(_state){
	state = _state;
	stateTimer = 0;
}

sysEvents.addListener(id, Event.slideCharacter, function(_options) {
	if(_options.target == VN_BOY) {
		setAction(State.boyIn);	
	} else {
		setAction(State.girlIn);	
	}
});

sysEvents.addListener(id, Event.finishSlide, function(_options) {
	if((_options.target == VN_GIRL && state == State.girlIn) || (_options.target == VN_BOY && State.boyIn)) {
		stateTimer = 100000;	
	}
});

#region particles
global.vnPartSystemLower = part_system_create()
part_system_depth(global.vnPartSystemLower,VN_PART_SYSTEM_LOWER)
global.vnPartSystemUpper = part_system_create()
part_system_depth(global.vnPartSystemUpper,VN_PART_SYSTEM_UPPER)


global.fireCounterClockwise =  part_type_create();
part_type_shape(global.fireCounterClockwise, pt_shape_smoke);
part_type_size(global.fireCounterClockwise, 0.50, 1, 0.10, 0);
part_type_orientation(global.fireCounterClockwise, 0, 360, 5, 0, 0);
part_type_color3(global.fireCounterClockwise, 0, 4227327, 33023);
part_type_alpha3(global.fireCounterClockwise, 1, 1, 0);
part_type_blend(global.fireCounterClockwise, 1);
part_type_life(global.fireCounterClockwise, 20, 40);
part_type_speed(global.fireCounterClockwise, 2, 4, 0.10, 0);
part_type_direction(global.fireCounterClockwise, 75, 105, 0, 5);

global.fireClockwise =  part_type_create();
part_type_shape(global.fireClockwise, pt_shape_smoke);
part_type_size(global.fireClockwise, 0.50, 1, 0.05, 0);
part_type_orientation(global.fireClockwise, 0, 360, -5, 0, 0);
part_type_color3(global.fireClockwise, 0, 4227327, 33023);
part_type_alpha3(global.fireClockwise, 1, 1, 0);
part_type_blend(global.fireClockwise, 1);
part_type_life(global.fireClockwise, 20, 40);
part_type_speed(global.fireClockwise, 2, 4, 0.10, 0);
part_type_direction(global.fireClockwise, 89, 91, 0, 5);

global.rain = part_type_create();
part_type_shape(global.rain, pt_shape_line);
part_type_size(global.rain, 0.50, 1, 0, 0);
part_type_scale(global.rain, 3, 0.25);
part_type_orientation(global.rain, 270, 270, 0, 0, 0);
part_type_color3(global.rain, c_white, c_white, c_white);
part_type_alpha3(global.rain, 1, 0.50, 0);
part_type_blend(global.rain, 0);
part_type_life(global.rain, 60, 60);
part_type_speed(global.rain, 0, 3, 0, 0);
part_type_direction(global.rain, 270, 270, 0, 0);
part_type_gravity(global.rain, 2, 270);

global.surprise = part_type_create();
part_type_shape(global.surprise, pt_shape_line);
part_type_size(global.surprise, 1, 1, 0, 0.10);
part_type_scale(global.surprise, 1, 1.50);
part_type_orientation(global.surprise, 0, 0, 0, 0, 1);
part_type_color3(global.surprise, 16777215, 16777215, 16777215);
part_type_alpha3(global.surprise, 0, 1, 1);
part_type_blend(global.surprise, 0);
part_type_life(global.surprise, 40, 40);
part_type_speed(global.surprise, 25, 25, -2, 0);
part_type_direction(global.surprise, 59, 115, 0, 0);
part_type_gravity(global.surprise, 0, 0);

global.note = part_type_create();
part_type_sprite(global.note, sprNote, 0, 0, 1);
part_type_size(global.note, 1, 1, 0, 0);
part_type_scale(global.note, .75, .75);
part_type_orientation(global.note, -30, 30, 0, 10, 0);
part_type_color1(global.note, c_white);
part_type_alpha3(global.note, 1, 1, 0);
part_type_blend(global.note, 1);
part_type_life(global.note, 30, 50);
part_type_speed(global.note, 8, 10, 0, 0);
part_type_direction(global.note, 45, 135, 0, 0);
part_type_gravity(global.note, 0.20, 270);

global.go = part_type_create();
part_type_sprite(global.go, sprGogo, 1, 0, 0);
part_type_scale(global.go, .75, .75);
part_type_orientation(global.go, -15, 15, 0, 0, 0);
part_type_color1(global.go, c_white);
part_type_alpha3(global.go, 1, 1, 0);
part_type_blend(global.go, 1);
part_type_life(global.go, 50, 60);
part_type_speed(global.go, 0, 0, 0, 4);
part_type_direction(global.go, 63, 118, 0, 10);
#endregion