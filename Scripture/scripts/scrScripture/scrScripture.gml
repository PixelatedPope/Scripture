global.__scripCache = {};
global.__scripText = {};
global.__scripOptions = {};
global.__scripString = "";

#region Scripture Constructors
function __scriptureChar(_char, _style={}) constructor{
	char = _char;
	style = _style; 
	steps = 0;
	
	width = string_width(char);
	height = string_height(char);
	
	draw = function(_x, _y){
		steps++;
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

function __scriptureText() constructor {
	totalWidth = 0;
	text = [];
	typePos = 0;
	
	getHeight = function() {
		var _start = __scriptureGetCurrentLine(),
				_count = global.__scripOptions.maxLines,
				_height = 0;
		for(var _i = _start; _i < _start + _count; _i++) {
			if(_i >= array_length(text))
				return _height;
			_height += text[_i].height + global.__scripOptions.lineSpacing;
		}
		return _height;
	}
	
	getTotalHeight = function() {	
		var _height = 0;
		for(var _i = 0; _i < array_length(text); _i++){
			_height += text[_i].height + global.__scripOptions.lineSpacing;
		}
		
		return _height;
	}
	
	progressType = function(_amount) {
		typePos+=_amount;	
	}
}

#endregion

#region Scripture Interal Functions 

function __scriptureParseText(_string) {
	var _result = new __scriptureText();
	var _curWidth = 0;
	var _curLine = new __scriptureLine();
	_result.text[0] = _curLine;
	var _lastSpace = 0;
	while(string_length(_string) > 0) {
		var _char = string_char_at(_string,0);
		_string = string_delete(_string,1,1);
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
		if(_curWidth > global.__scripOptions.maxWidth) {
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
	
	return _result;
}

function __scriptureApplyVAlign(_y) {
	var _options = global.__scripOptions,
			_text = global.__scripText;
	switch(_options.vAlign) {
		case fa_top:    return _y;
		
		case fa_middle: return _y - (_options.maxLines <= 0 
																 ? _text.getTotalHeight() / 2 - _options.lineSpacing / 2
																 : _text.getHeight() / 2  - _options.lineSpacing / 2); 
																 
		case fa_bottom: return _y - (_options.maxLines <= 0 
																 ? _text.getTotalHeight()
																 : _text.getHeight()) + _options.lineSpacing; 
	}	
}

function __scriptureApplyHAlign(_x, _line) {
	switch(global.__scripOptions.hAlign) {
		case fa_left: return _x;
		case fa_center: return _x - _line.width / 2; break;
		case fa_right: return _x - _line.width; break;
	}	
}

function __scriptureGetCachedText(_string, _options) {
	global.__scripString = _string;
	global.__scripOptions = _options;
	var _parsedText = global.__scripCache[$ _options.cacheKey];
	if(_parsedText == undefined) {
		_parsedText = __scriptureParseText(_string)
		global.__scripCache[$ _options.cacheKey] = _parsedText;
	}
	
	global.__scripText = _parsedText;
}

function __scriptureGetPageCount(_text = global.__scripText, _options = global.__scripOptions) {
	return 	floor(array_length(_text.text) / _options.maxLines);
}

function __scriptureGetCurrentLine() {
	return 	min( global.__scripOptions.currentPage,__scriptureGetPageCount()) * global.__scripOptions.maxLines;
}

function __scriptureIsPageFinished(_cur) {
	//Be very sure when you clean up this logic, idiot.
	var _length = array_length(global.__scripText.text);	
	if(_length <= _cur) return true;
	
	var _isPaginated = global.__scripOptions.maxLines > 0;
	var _curLineNum = _cur - __scriptureGetCurrentLine();
	var _linePerPage = global.__scripOptions.maxLines;
		
	return _isPaginated ? _curLineNum >= _linePerPage : _length <= _cur;
}

function __scriptureIsTyping() {
	return global.__scripOptions.typeSpeed > 0;	
}

#endregion

function scripture_advance_page(_options){
	var _text = global.__scripCache[$ _options.cacheKey];
	if(_text == undefined) return;
	if(_options.currentPage < __scriptureGetPageCount(_text,_options )){
		_options.currentPage++;
		_text.typePos = 0;
		return true;
	}
	return false;
}

function draw_scripture(_x, _y, _string, _options){
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	__scriptureGetCachedText(_string, _options)
	if(__scriptureIsTyping())
		global.__scripText.progressType(_options.typeSpeed);

	var	_drawX,
			_text = global.__scripText.text,
			_pos = 0,
		  _drawY = __scriptureApplyVAlign(_y);
	
	for(var _l = __scriptureGetCurrentLine(); !__scriptureIsPageFinished(_l); _l++) {
		_drawX = __scriptureApplyHAlign(_x, _text[_l]);
		var _lineHeight = _text[_l].height;
		for(var _c = 0; _c < array_length(_text[_l].text); _c++) {
			if(__scriptureIsTyping() && _pos >= global.__scripText.typePos) return;
			
			_char = _text[_l].text[_c];
			_drawX += _char.draw(_drawX,_drawY);
			if(_char.height > _lineHeight) 
				_lineHeight = _char.height;
			_pos++;
		}
		_drawY += _lineHeight + _options.lineSpacing;
	}
	
	return global.__scripText;
}