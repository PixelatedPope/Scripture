/*#region System Variables and Functions

global.__scriptureStyleLibrary = {};
global.__scriptureActiveStyles = [];
global.__scriptureCache = {};

function __scriptureStyleEnqueue(_key){
	var _style = global.__scriptureStyleLibrary[$ _key];
	if(_style == undefined) return;
	array_push(global.__scriptureActiveStyles,_style);
}

function __scriptureStyleFindIndex(_key){
	for(var _i = 0; _i < array_length(global.__scriptureActiveStyles); _i++) {
		if(global.__scriptureActiveStyles[_i].key == _key) return _i;
	}
	return -1;
}

function __scriptureStyleDequeue(_key){
	var _index = __scriptureStyleFindIndex(_key);
	if(_index == -1) return;
	array_delete(global.__scriptureActiveStyles,_index,1);
}

function __scriptureGetDefaultStyle(){
	return {
		color: c_white,
		alpha: 1,
		font: -1,
		kerning: 0,
		xoff: 0,
		yoff: 0
	}
}

function __scriptureHandleTag(_text, _pos) {
	_pos++;
	var _key = "";
	var _char = string_char_at(_text, _pos);
	var _isCloseTag = _char == "/";
	if(_isCloseTag) {
		_pos++;
		_char = string_char_at(_text,_pos);
	}
	while(_char != ">") {
		if(_char == " ") continue;
		
		_key += _char;		
		_pos++;
		_char = string_char_at(_text, _pos);
	}
	show_debug_message("Found " + (_isCloseTag ? "closing " : "")+"tag: "+_key);
	if(_isCloseTag)
		__scriptureStyleDequeue(_key);
	else
		__scriptureStyleEnqueue(_key);
	
	return _pos;
}

function __scriptureBuildActiveStyle(){
	var _activeStyle = __scriptureGetDefaultStyle()
	for(var _i = 0; _i < array_length(global.__scriptureActiveStyles); _i++) {
		var _style = global.__scriptureActiveStyles[_i];
		var _props = variable_struct_get_names(_style)
		for(var _j = 0; _j < array_length(_props); _j++) {
			var _prop = _props[_j];
			if(_prop == "key") continue;
			_activeStyle[$ _prop] = _style[$ _prop];
		}
	}
	return _activeStyle
}

function __scriptureParse(_text) {
	var _array = [];
	var _activeStyle = __scriptureGetDefaultStyle();
	
	//Line Wrapping and Spacing
	var _lastBreakPos = 0;
	var _lineWidth = 0;
	
	for(var _i = 1; _i <= string_length(_text); _i++) {
		var _char = string_char_at(_text, _i);
		if(_char == "<" && (_i == 1 || string_char_at(_text, _i-1)!="\\")) {
				_i = __scriptureHandleTag(_text, _i);
				_activeStyle = __scriptureBuildActiveStyle();
		} else {
			draw_set_font(_activeStyle.font);
			
			if(_char == " ")
				_lastBreakPos = _i;
			
			var _charStruct = {
				char: _char, 
				width: string_width(_char),
				height: string_height(_char),
				kerning: _activeStyle.kerning,
				yoff: _activeStyle.yoff,
				xoff: _activeStyle.xoff,
				color: _activeStyle.color,
				alpha: _activeStyle.alpha,
				font: _activeStyle.font
			}
			
			_lineWidth += _charStruct.width + _charStruct.kerning;
			if(_lineWidth > 200) {
				var _dist = (_i - _lastBreakPos);
				var _pos = array_length(_array)-_dist;
				_array[_pos] = { char:"◄" };
				_lineWidth = 0;
				for(_pos++; _pos < array_length(_array); _pos++){
					_lineWidth += _array[_pos].width + _array[_pos].kerning;
				}
			}
			
			array_push(_array,_charStruct);
		}
	}
	return _array;
}

#endregion

///@func scripture_draw(x, y, text, sep, width);
function scripture_draw(_x, _y, _text, _sep, _w) {
	var _startX = _x;
	var _parsed = global.__scriptureCache[$ string(_x)+string(_y)];
	if(_parsed == undefined) {
		_parsed = __scriptureParse(_text);
		 global.__scriptureCache[$ string(_x)+string(_y)] = _parsed;
	} 
	
	for(var _i = 0; _i < array_length(_parsed); _i++) {
		var _char = _parsed[ _i];
		if(_char.char == "◄") {
			_x = _startX;
			_y += _sep;
			continue;
		} 
		draw_set_color(_char.color);
		draw_set_alpha(_char.alpha);
		draw_set_font(_char.font);
		draw_text(_x,_y+_char.yoff,_char.char);
		_x += _char.width + _char.kerning;
		draw_set_alpha(1);
		
	}
}

function scripture_define_style(_key, _style) {
	_style.key = _key;
	global.__scriptureStyleLibrary[$ _key] = _style
}

//@func scripture_clear_cache()
function scripture_clear_cache(){
	global.__scriptureCache = {};	
}