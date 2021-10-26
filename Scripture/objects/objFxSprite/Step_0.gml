/// @description 
timer++;
image_alpha = lerp(1, 0, timer/life);
image_xscale = lerp(xScale, 0, timer/life);
image_yscale = lerp(yScale, 0, timer/life);
if(timer > life)
	instance_destroy();