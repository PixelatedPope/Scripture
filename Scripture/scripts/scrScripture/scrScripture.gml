global.__scriptureCache = {};

/*
var _options = {
	cacheKey:"test",
	hAlign: fa_left,
	vAlign: fa_top,
	//typingPos: -1, //-1 for all
	maxWidth: 200,
	//lineSpacing: 0,
	//maxLines: -1,
	//currentPage: 0
}
*/

function __scriptureChar(_char, _style={}) constructor{
	char = _char;
	style = _style; 
	steps = 0;
	//TODO: setfont
	width = string_width(char);
	height = string_height(char);
	draw = function(_x, _y){
		draw_text(_x, _y, char);
		return width;
	} //:width
}

function __scriptureLine() constructor {
	width = 0;
	height = 0;
	text = [];
	trimWhiteSpace = function(){
		while(array_length(text) != 0 && text[0].char == " ")
			array_delete(text[0],0,1);
		
		while(array_length(text) > 1 && text[array_length(text)-1].char == " ")
			array_delete(text,array_length(text)-1,1);
			
	}
	
	calcDimensions = function(){
		trimWhiteSpace();
		width = 0;
		for(var _i = 0; _i < array_length(text); _i++) {
			var _char = text[_i];
			width += _char.width;
			if(_char.height > height) height = _char.height;
		}
		if(height == 0)
			height = string_height("QWERTYUIOPASDFGHJKLZXCVBNM<>,./;'[]{}:\"?");
	}
	
}

function __scriptureParseText(_text,_options) {
	var _result = {
		totalWidth: 0,
		totalHeight: 0,
		text: [],
		getHeight: function(_start, _count) {
			var _height = 0;
			for(var _i = _start; _i < _start + _count; _i++) {
				if(_i >= array_length(text))
					return _height;
				_height += text[_i].height;
			}
			return _height;
		}
	};
	var _curWidth = 0;
	var _curLine = new __scriptureLine();
	_result.text[0] = _curLine;
	var _lastSpace = 0;
	
	while(string_length(_text) > 0) {
		var _char = string_char_at(_text,0);
		_text = string_delete(_text,1,1);
		switch(_char) {
			case "\n": 
				var _newLine = new __scriptureLine();
				array_push(_result.text,_newLine);
				_curLine.calcDimensions()
				_curWidth = 0;
				_curLine = _newLine;
				continue;
			break;
			case "<": break;//{_text,tag} = __scriptureHandleTag;
			
			case " ":
				var _currentLength = array_length(_curLine.text);
				if(_currentLength == 0) continue;
				
				var _space = new __scriptureChar(_char)
				array_push(_curLine.text,_space);
				_curWidth += _space.width;
				_lastSpace = _currentLength+1;
			break;
			
			default: //Character
				var _newChar = new __scriptureChar(_char);
				_curWidth += _newChar.width;
				array_push(_curLine.text, _newChar);
		}
		
		//Handle Wrapping
		if(_curWidth > _options.maxWidth) {
			var _newLine = new __scriptureLine();
			array_push(_result.text,_newLine);
			var _length = array_length(_curLine.text) - _lastSpace;
			array_copy(_newLine.text, 0, _curLine.text, _lastSpace, _length);
			array_delete(_curLine.text, _lastSpace, _length);
			
			_curLine.calcDimensions();
			if(_result.totalWidth < _curLine.width) 
				_result.totalWidth = _curLine.width;
			
			var _lastSpace = 0;
			_curLine = _newLine;
			_curLine.calcDimensions()
			_curWidth = _curLine.width;
		}
	}
	
	_curLine.calcDimensions();
	if(_result.totalWidth < _curLine.width) 
		_result.totalWidth = _curLine.width;
	_result.totalHeight = 0;
	for(var _i = 0; _i < array_length(_result.text); _i++){
		_result.totalHeight += _result.text[_i].height;
	}
	
	return _result;
}

#macro __scriptureCurrentLine	min(_options.currentPage,_pageCount) * _options.maxLines

function draw_scripture(_x, _y, _string, _options){
	var _parsedText = global.__scriptureCache[$ _options.cacheKey];
	if(_parsedText == undefined) {
		_parsedText = __scriptureParseText(_string, _options)
		global.__scriptureCache[$ _options.cacheKey] = _parsedText;
	}
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _text = _parsedText.text;
	var _drawY;
	var _drawX;
	var _pos = 0;
	var _pageCount = floor(array_length(_text) / _options.maxLines)-1;
	switch(_options.vAlign) {
		case fa_top: _drawY = _y; break;
		case fa_bottom: _drawY = _y - (_options.maxLines == 0 ? _parsedText.totalHeight : _parsedText.getHeight(__scriptureCurrentLine,_options.maxLines)); break;
		case fa_middle:  _drawY = _y - (_options.maxLines == 0 ? _parsedText.totalHeight / 2 : _parsedText.getHeight(__scriptureCurrentLine,_options.maxLines)); break;
	}
	
	
	for(var _l = __scriptureCurrentLine; _l < array_length(_text) && _l - __scriptureCurrentLine < _options.maxLines; _l++) {
		switch(_options.hAlign) {
			case fa_left: _drawX = _x; break;
			case fa_right: _drawX = _x - _text[_l].width; break;
			case fa_center: _drawX = _x - _text[_l].width / 2; break;
		}
		//var _startX = _drawX;
		//var _startY = _drawY;
		var _lineHeight = _text[_l].height;
		for(var _c = 0; _c < array_length(_text[_l].text); _c++) {
			if(_options.typePos != -1 && _pos >= _options.typePos) return;
			_char = _text[_l].text[_c];
			_drawX += _char.draw(_drawX,_drawY);
			if(_char.height > _lineHeight) _lineHeight = _char.height;
			_pos++;
		}
		_drawY += _lineHeight + _options.lineSpacing;
		//draw_rectangle(_startX, _startY, _drawX, _drawY,true);
		//draw_rectangle(_startX, _startY, _startX + _text[_l].width, _startY + _text[_l].height,true);
	}
}