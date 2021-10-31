/// @description
timer = 0;
typeSpeed = 0;
length = room_speed * 8;
spin = scripture_register_style("Spin",{
	onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
		
		var _length = room_speed * 2;
		if((_steps div _length) mod 2 == 0) {
			var _scale = twerp(TwerpType.inout_quad,0,360,_steps/_length, true);
			_style.xScale = dcos(_scale);
		} else if(_steps mod (30 + _index * 2) == 0) {
			instance_create_depth(_x+random_range(-15,15),
														_y+random_range(-20,20),
														-100,
														objFxSprite);
		}
			
		draw_set_color(c_black);
		draw_set_alpha(.5);
		draw_text_transformed(_x, _y+twerp(TwerpType.out_back,0,5,_steps/10),_base.char,_style.xScale*1.2,_style.yScale*1.2,0);
	}
});

scripture = scripture_register_style("Scripture", {
		font: fntScripture,
		kerning: 20,
		speedMod: .1,
		color: make_color_rgb(255,234,163),
		onDrawBegin: function(_x, _y, _style, _base, _steps){
			var _length = room_speed;
			return _steps < _length;
		},
		onDrawEnd: function(_x, _y, _style, _base, _steps, _index) {
			var _length = room_speed;
			if(_steps < _length) {
				var _prog = _steps / _length;
				var _scale = twerp(TwerpType.out_cubic, 1, 1.5, _prog);
				var _alpha = lerp(1, 0, _prog);
				var _offDir = lerp(180,0,_index / 8);
				var _maxOff =  lengthdir_x(twerp(TwerpType.out_cubic,0,50,_prog), _offDir);
				gpu_set_blendmode(bm_add);
				var _count = 20;
				for(var _i = 1; _i < _count; _i++) {
					var _xOff = lerp(0,_maxOff, _i/_count);
					draw_set_alpha(_alpha * (_i/_count))
					var _tempScale = twerp(TwerpType.out_quad,1, _scale, _i/_count);
					draw_text_transformed(_x + _xOff, _y, _base.char, _tempScale, _tempScale,0);
				}
				gpu_set_blendmode(bm_normal);
			}
		}
	});
testString = scripture.open + spin.open +"SCRIPTURE";
textbox = scripture_create_textbox()
	.build(testString)
	.setAlignment(fa_center, fa_middle)
	.setTypeSpeed(typeSpeed);
