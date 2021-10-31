//*************************************************************************
// Hi!  Welcome to Scripture!  Make sure you know what you are doing before
// making any changes in this file. The consequences could be dire!
//
// - Pixelated Pope
//*************************************************************************

global.__scripStory = {};
global.__scripTextbox = {};
global.__scripString = "";
global.__scripStyles = {};
global.__scripProtectedKeys = ["default", __SCRIPTURE_DEFULT_STYLE_KEY];
global.__scripStyleStack = [];
global.__scripActiveStyle = {};

#macro SCRIPTURE_TYPE_IMG 1
#macro SCRIPTURE_TYPE_CHAR 2
#macro __SCRIPTURE_TYPE_STYLE 3
#macro __SCRIPTURE_TYPE_EVENT 4
#macro __SCRIPTURE_DEFULT_STYLE_KEY "defaultStyle"
#macro __SCRIPTURE_SKIP_VAL 10000

//Global Tag Definitions
//You can change these here or use the available function.
global.__scripOpenTag = "<"
global.__scripCloseTag = ">"
global.__scripEndTag = "/"

global.__scripColor = "#"
global.__scripImage = "I"
global.__scripFont = "F"
global.__scripKerning = "K"
global.__scripScale = "S"
global.__scripOff = "O"
global.__scripAngle = "a"
global.__scripAlpha = "A"
global.__scripAlign = "L"
global.__scripSpeed = "s"

#region Scripture Constructors
function __scriptureTextBox() constructor {
	__hAlign = fa_left;
	__vAlign = fa_top;
	__lineBreakWidth = 0;
	__pageBreakHeight = 0;
	__typeSpeed = 0;
	__lineSpacing = 0;
	__forceLineBreaks = false;
	__built = false;
	__defaultStyle = undefined;
	
	
	__inPageBreak = false;
	__isPaused = false;
	nextPageReady = false;
	currentDelay = 0;
	pageAdvanceDelay = -1;
	maxWidth = undefined;
	maxHeight = undefined;
	pageDimensions = undefined;
	pageCount = undefined
	__story = undefined
	
	build = function(_string) {
		__built = true;
		var _story = __scriptureBuildStory(_string, self);
		var _pageDimensions = []
		var _widestPageWidth = 0;
		var _tallestPageHeight = 0;
		for(var _i = 0; _i < _story.getPageCount(); _i++){
			var _width = _story.pages[_i].width;
			var _height = _story.pages[_i].height;
			if(_width > _widestPageWidth)
				_widestPageWidth = _width;
			if(_height > _tallestPageHeight)
				_tallestPageHeight = _height;
			array_push(_pageDimensions, {width: _width, height: _height});
		}
	
		maxWidth = _widestPageWidth;
		maxHeight = _tallestPageHeight;
		pageDimensions = _pageDimensions;
		pageCount = _story.getPageCount();
		__story = _story;
		return self
	}
	
	setAlignment = function(_hAlign, _vAlign) {
		__hAlign = _hAlign;
		__vAlign = _vAlign;
		return self
	}
	
	setSize = function(_maxWidth, _maxHeight, _lineSpacing = 0, _forceLineBreaks = false) {
		__lineBreakWidth = _maxWidth;
		__pageBreakHeight = _maxHeight;
		__lineSpacing = _lineSpacing;
		__forceLineBreaks = _forceLineBreaks;
		return self
	}
	
	setTypeSpeed = function(_typeSpeed) {
		__typeSpeed = _typeSpeed;
		return self
	}
	
	
	setDefaultStyle = function(_defaultStyle) {
		if(_defaultStyle != undefined) {
			var _style = global.__scripStyles[$ _defaultStyle];
			if(_style != undefined) {
				__defaultStyle = new __scriptureStyle(_style);
				__defaultStyle.key = "textboxDefaultStyle";
			}
		}
		return self
	}
	
	getCurrentPageSize = function() {
		return pageDimensions[__story.curPage];
	}
	
	getCurrentPage = function() {
		return __story.curPage;	
	}
	
	gotoPageNext = function(_shortcutAnimations = true) {
		if(__inPageBreak) {
			__inPageBreak = false;
			pageAdvanceDelay = -1
			return false;
		}
		var _curPage = __story.getCurrentPage();
		if(_curPage.__isComplete) {
			pageAdvanceDelay = -1;
			return __story.incPage();
		}

		_curPage.finishPage(_shortcutAnimations)   
		return true;
	}

	gotoPagePrev = function(_reset = true) {
			pageAdvanceDelay = -1;
		__story.decPage(_reset);
	}

	gotoPage = function(_page, _reset = true) {
		if(_page < 0 || _page >= pageCount) return;
			pageAdvanceDelay = -1;
		__story.setCurrentPage(_page,_reset);
	}
	
	setPaused = function(_isPaused) {
		__isPaused = _isPaused;	
	}
	
	__autoAdvancePage = function(_currentPage) {
		if(!__inPageBreak && (pageCount <=  1 || !_currentPage.__isComplete || !global.__scripStory.canIncPage())) return;
		if(pageAdvanceDelay >= 0) {
			pageAdvanceDelay--;
			if(pageAdvanceDelay == -1)
				if(__inPageBreak)
					__inPageBreak = false;
				else
					gotoPageNext(false);

			return;
		}

		var _delay = _currentPage.getPageAdvanceDelay();
		if(_delay	>= 0)
			pageAdvanceDelay	= _delay;
	}
	
	///@func draw(x,y)
	draw = function(_x, _y) {
		if(!__built) {
			throw("Need to call \"build()\" on textbox before drawing.");	
		}
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		global.__scripTextbox = self;
		global.__scripStory = __story;
		var _currentPage = __story.getCurrentPage();
		_currentPage.draw(_x, _y);
		draw_set_alpha(1);
	
		nextPageReady = _currentPage.__isComplete || __inPageBreak;
		__autoAdvancePage(_currentPage);
	}
}

function __scriptureStyle(_style = {}) constructor {
	type = __SCRIPTURE_TYPE_STYLE
	//Return a duplicate of the given style with new key
	color = _style[$ "color"] == undefined ? c_white : _style.color;
	sprite = _style[$ "sprite"] == undefined ? undefined: _style.sprite;
	font = _style[$ "font"] == undefined ? -1 : _style.font;
	speedMod = _style[$ "speedMod"] == undefined ? 1 : _style.speedMod;
	kerning = _style[$ "kerning"] == undefined ? 0 : _style.kerning;
	xScale = _style[$ "xScale"] == undefined ? 1 : _style.xScale;
	yScale = _style[$ "yScale"] == undefined ? 1 : _style.yScale;
	xOff = _style[$ "xOff"] == undefined ? 0 : _style.xOff;
	yOff = _style[$ "yOff"] == undefined ? 0 : _style.yOff;
	angle = _style[$ "angle"] == undefined ? 0 : _style.angle;
	alpha = _style[$ "alpha"] == undefined ? 1 : _style.alpha;
	textAlign = _style[$ "textAlign"] == undefined ? fa_middle : _style.textAlign;
	pageAdvanceDelay = _style[$ "pageAdvanceDelay"] == undefined ? -1 : _style.pageAdvanceDelay;
	onDrawBegin = _style[$ "onDrawBegin"] == undefined ? function(){} : _style.onDrawBegin;
	onDrawEnd = _style[$ "onDrawEnd"] == undefined ? function(){} : _style.onDrawEnd;
}

global.__scripStyles.defaultStyle = new __scriptureStyle();
global.__scripStyles.defaultStyle.key = __SCRIPTURE_DEFULT_STYLE_KEY;

function __scriptureBuildElement(_style) {
	style = _style;
	xScale = _style.xScale;
	yScale = _style.yScale;
	xOff = _style.xOff;
	yOff = _style.yOff;
	alpha = _style.alpha;
	_style.xScale = 1;
	_style.yScale = 1;
	_style.xOff = 0;
	_style.yOff = 0;
	_style.alpha = 1;
	onDrawBeginSteps = [];
	onDrawEndSteps = [];
	wasSkipped = false;
	resetSteps = function(){
		wasSkipped = false;
		onDrawBeginSteps = [];
			onDrawEndSteps = [];
	}
	skip = function(_line){
		wasSkipped = true;
		onDrawBeginSteps = [];
		onDrawEndSteps = [];
		draw(-100000,-100000, 0, _line);
	}
	executeOnDrawBegin = function(_x, _y,  _index) {
		for(var _i = 0; _i < array_length(style.onDrawBegin); _i++) {
			if(array_length(onDrawBeginSteps) < _i+1) onDrawBeginSteps[_i] = wasSkipped ? __SCRIPTURE_SKIP_VAL : 0; 
			var _breakChain = style.onDrawBegin[_i](_x, _y, style, self, onDrawBeginSteps[_i], _index)
			onDrawBeginSteps[_i] += !global.__scripTextbox.__isPaused;
			if(_breakChain)	break;
		}
	}
	
	executeOnDrawEnd = function(_x, _y,  _index) {
		for(var _i = 0; _i < array_length(style.onDrawEnd); _i++) {
			if(array_length(onDrawEndSteps) < _i+1) onDrawEndSteps[_i] = wasSkipped ? __SCRIPTURE_SKIP_VAL : 0; 
			var _breakChain = style.onDrawEnd[_i](_x, _y, style, self, onDrawEndSteps[_i], _index)
			onDrawEndSteps[_i] += !global.__scripTextbox.__isPaused;
			if(_breakChain)	break;
		}
	}
}

function __scriptureChar(_char, _style = new __scriptureStyle()) constructor {
	type = SCRIPTURE_TYPE_CHAR
	char = _char;
	isSpace = _char == " ";
	__scriptureBuildElement(_style);
	draw_set_font(style.font);
	width = string_width(char) * xScale + style.kerning;
	height = string_height(char) * yScale;
	centerX = width / 2;
	centerY = height / 2;
	color = style.color;
	
	draw = function(_x, _y, _index, _line) {
		var _drawX = floor(_x + centerX) + xOff;
		var _drawY = floor(_y + centerY) + yOff;
		
		switch(style.textAlign) {
			case fa_top: break;
			case fa_middle: _drawY += floor(_line.height/2 - centerY); break;
			case fa_bottom: _drawY += floor(_line.height - centerY * 2); break;
		}
		
		draw_set_font(style.font);
		draw_set_color(style.color);
		draw_set_alpha(alpha * style.alpha);
		
		executeOnDrawBegin(_drawX, _drawY, _index);
		
		_drawX += style.xOff;
		_drawY += style.yOff;
		
		draw_set_font(style.font);
		draw_set_color(style.color);
		draw_set_alpha(alpha * style.alpha);
		draw_text_transformed(_drawX, _drawY, char, xScale * style.xScale, yScale * style.yScale, style.angle);
		
		executeOnDrawEnd(_drawX, _drawY, _index);

		return width;
	}
}

function __scriptureImg(_style) constructor {
	type = SCRIPTURE_TYPE_IMG;
	var _active = new __scriptureStyle(global.__scripActiveStyle)
	var _keys = variable_struct_get_names(_style);
	for(var _i = 0; _i < array_length(_keys); _i++) {
		_active[$ _keys[_i]] = _style[$ _keys[_i]];	
	}
	
	sprite = _active.sprite;
	image = 0;
	isSpace = false;
	speed = sprite_get_speed_type(sprite) == spritespeed_framespergameframe 
																				 ? sprite_get_speed(sprite) 
																				 : sprite_get_speed(sprite) / room_speed;
	__scriptureBuildElement(_active)
	style = _active;
	width = sprite_get_width(sprite) * xScale + style.kerning;
	height = sprite_get_height(sprite) * yScale;
	centerX = width/2;
	centerY = height/2;
	
	draw = function(_drawX, _drawY, _index) {
		executeOnDrawBegin(_drawX, _drawY, _index);

		draw_sprite_ext(sprite, image, 
										_drawX + style.xOff + centerX, _drawY + style.yOff + centerY, 
										xScale * style.xScale, yScale * style.yScale, 
										style.angle, style.color, alpha * style.alpha);
		
		executeOnDrawEnd(_drawX, _drawY, _index);
		
		image += speed * !global.__scripTextbox.__isPaused;
		return width;
	}
}

function __scriptureEvent(_func, _delay = undefined, _canSkip = true, _arguments = []) constructor {
	type = __SCRIPTURE_TYPE_EVENT;
	event = _func;
	arguments = _arguments;
	isSpace = false;
	style = {
		speedMod:1, pageAdvanceDelay: 
		global.__scripActiveStyle.pageAdvanceDelay
	};
	ran = false;
	wasSkipped = false;
	canSkip = _canSkip;
	delay = _delay;
	skip = function(_line){
		wasSkipped = true;	
		draw();
	}
	draw = function(){
		if(ran) return 0;
		ran = true;
		event(arguments);
		if(delay == undefined) return 0;
		if(delay > 0) 
			global.__scripTextbox.currentDelay = delay;
		else
			global.__scripTextbox.__inPageBreak = true;
		return 0;
	}
}


function __scriptureLine() constructor {
	width = 0;
	height = 0;
	characters = [];
	__isComplete = false;
	lastSpace = undefined;
	getLength = function() { return array_length(characters) };
	typePos = 0;
	delay = __scriptureIsTyping();
	getCharacterCount = function(){return array_length(characters)}
	
	draw = function(_x, _y, _page) {
		var _eventCount = 0;
		for(var _c = 0; _c < getLength(); _c++) {
			if(!__isComplete && __scriptureIsTyping() && _c > typePos && _c > 0) { //Delay Countdown
				if(global.__scripTextbox.currentDelay > 0) {
					global.__scripTextbox.currentDelay--;
					return false;
				}
				if(!global.__scripTextbox.__isPaused && !global.__scripTextbox.__inPageBreak) { //Paused or InPageBreak
					typePos += global.__scripTextbox.__typeSpeed * characters[_c-1].style.speedMod;
					_eventCount += characters[_c].type == __SCRIPTURE_TYPE_EVENT;
				}
				return false;
			}
			_eventCount += characters[_c].type == __SCRIPTURE_TYPE_EVENT;
			_x += characters[_c].draw(_x, _y, _c - _eventCount, self);
		}
		if(delay > 0) {
			delay -= getLength() == 0 ? 1 : characters[getLength()-1].style.speedMod;
			return false;	
		}
		__isComplete = true;
		return true;
	}
	
	reset = function(){
		__isComplete = false;
		typePos = 0;
		delay = __scriptureIsTyping();
		for(var _i = 0; _i < getLength(); _i++) {
			var _char = characters[_i];
			
			switch(_char.type) {
				case __SCRIPTURE_TYPE_EVENT:
					_char.ran = false;
				break;
				case SCRIPTURE_TYPE_IMG:
					_char.image = 0;
				default:
					_char.resetSteps();
			}
		}
	}
	
	endAnimations = function() {
		for(var _c = 0; _c < getLength(); _c++) {
			var _char = characters[_c];
			if(_char.type == __SCRIPTURE_TYPE_EVENT && _char.canSkip) {
				_char.ran = true;
				continue; 
			}
			_char.skip(self)
		}
	}
	
	trimWhiteSpace = function(){
		while(array_length(characters) != 0 && (characters[0].type == SCRIPTURE_TYPE_CHAR && characters[0].char == " "))
			array_delete(characters[0],0,1);
		
		while(array_length(characters) > 1 && (characters[array_length(characters)-1].type == SCRIPTURE_TYPE_CHAR && characters[array_length(characters)-1].char == " "))
			array_delete(characters,array_length(characters)-1,1);
	}
	
	addElement = function(_newElement) {
		if(_newElement.type != __SCRIPTURE_TYPE_EVENT)
			width += _newElement.width;
		array_push(characters, _newElement);
		return _newElement;
	}
	
	addElements = function(_elements) {
		for(var _i = 0; _i < array_length(_elements); _i++) {
			array_push(characters, _elements[_i]);	
		}
		calcWidth();
	}
	
	addHyphen = function(_hyphen){
		array_push(characters,_hyphen);
		width += _hyphen.width;
		lastSpace = getLength();
	}
	
	addSpace = function(){
		if(getLength() == 0) return;
		
		var _space = new __scriptureChar(" ", new __scriptureStyle(global.__scripActiveStyle));
		array_push(characters,_space);
		width += _space.width;
		lastSpace = getLength();
	}
	
	calcWidth = function(){
		trimWhiteSpace();
		width = 0;
		for(var _i = 0; _i < array_length(characters); _i++) {
			var _char = characters[_i];
			if(_char.type == __SCRIPTURE_TYPE_EVENT) continue;
			
			width += _char.width;
		}
		return width;
	}
	
	calcHeight = function(){
		trimWhiteSpace();	
		height = 0;
		for(var _i = 0; _i < array_length(characters); _i++) {
			var _char = characters[_i];
			if(_char.type == __SCRIPTURE_TYPE_EVENT) continue;

			if(_char.height > height) 
				height = _char.height;
		}
		if(height == 0)
			height = string_height("QWERTYUIOPASDFGHJKLZXCVBNM<>,./;'[]{}:\"?");
		return height;
	}
	
	calcDimensions = function(){
		calcWidth();
		calcHeight();
	}
	
	checkForWrap = function() {
		var _textbox = global.__scripTextbox;
		var _result = {didWrap: false, leftovers: [], leftoverHeight: 0};
		if(_textbox.__lineBreakWidth <= 0 || width <= _textbox.__lineBreakWidth) return _result
		
		var _lastSpace = _textbox.__forceLineBreaks ? 0 : lastSpace;
		if(lastSpace == undefined && _textbox.__forceLineBreaks == false) return _result
		var _length = _textbox.__forceLineBreaks ? 0 : getLength() - lastSpace;
		_result.didWrap = true;
		array_copy(_result.leftovers, 0, characters, _lastSpace, _length);
		array_delete(characters, _lastSpace, _length);
		
		var _maxHeight = 0;
		for(var _i = 0; _i < array_length(_result.leftovers); _i++) {
			var _h =_result.leftovers[_i].height;
			if(_h > _maxHeight) _maxHeight = _h;
		}
		_result.leftoverHeight = _maxHeight;
		return _result
	}
	
	findNextInPageBreak = function(){
		for(var _i = typePos; _i < getCharacterCount(); _i++) {
			var _char = characters[_i];
			if( _char.type == __SCRIPTURE_TYPE_EVENT && _char.delay <= 0)
				return _i;
		}
		return _i;
	}
	
	forceComplete = function() {
		var _pos = findNextInPageBreak();
		if(_pos < getCharacterCount()) {
			typePos = _pos;
			return false;
		}
		__isComplete = true;
		typePos = 10000000;
		delay = 0;
		return true;
	}
}

function __scripturePage() constructor {
	width = 0;
	height = 0;
	linePos = 0;
	__isComplete = false;
	lines = [];
	draw = function(_x, _y) {
		var	_drawX,
		    _drawY = __scriptureApplyVAlign(_y);
	
		for(var _i = 0; _i < getLineCount(); _i++) {
			if(!__isComplete && __scriptureIsTyping() && _i > linePos) return false;
			
			var _curLine = lines[_i];
			_drawX = __scriptureApplyHAlign(_x, _curLine);
			if(!_curLine.draw(_drawX, _drawY)) return false;
			
			if(linePos == _i) 
				linePos++;
			_drawY += _curLine.height + global.__scripTextbox.__lineSpacing;
		}
		__isComplete = true;
		global.__scripTextbox.currentDelay = 0;
		return true;
	}
	
	getLineCount = function() {return array_length(lines);}
	
	finishPage = function(_shortcutAnims) {
		for(var _i = 0; _i < getLineCount(); _i++) {
			if(!lines[_i].forceComplete()) return;
			if(_shortcutAnims) {
				lines[_i].endAnimations();
			}
		}
		__isComplete = true;
		linePos = getLineCount();
	}
	
	reset = function() {
		__isComplete = false;
		for(var _i = 0; _i < getLineCount(); _i++) {
			lines[_i].reset();	
		}
	}
	
	calcHeight = function() {
		height = 0;
		for(var _i = 0; _i < getLineCount(); _i++) {
			height += lines[_i].calcHeight() + (_i > 0 ? global.__scripTextbox.__lineSpacing : 0);
		}

		return height;
	}
	
	calcWidth = function() {
		width = 0;
		for(var _i = 0; _i < getLineCount(); _i++) {
			var _width = lines[_i].calcWidth();
			if(_width > width)
				width = _width;
		}
		return width;
	}
	
	addLine = function() {
		var _newLine = new __scriptureLine();
		array_push(lines, _newLine)
		return _newLine;
	}
	
	getPageLastCharacter = function() {
		var _lastLine = lines[getLineCount()-1]
		return _lastLine.characters[_lastLine.getCharacterCount()-1]		
	}
	
	getPageAdvanceDelay = function(_character = getPageLastCharacter()){
		return _character.style.pageAdvanceDelay;
	}
}

function __scriptureStory() constructor {
	width = 0;
	height = 0;
	pages = [];
	curPage = 0;
	getPageCount = function() { return array_length(pages) };
	getCurrentPage = function() { return pages[curPage] };
	__inPageBreak = false;
	calcHeight = function() {	
		height = 0;
		for(var _i = 0; _i < getPageCount(); _i++) {
			var _height = pages[_i].calcHeight();
			if(_height > height)
				height = _height;
		}
		return height;
	}
	
	calcWidth = function() {
		width = 0; 
		for(var _i = 0; _i < getPageCount(); _i++) {
			var _width = pages[_i].calcWidth();
			if(_width > width)
				width = _width;
		}
		return width;
	}
	
	calcDimensions = function() {
		calcHeight();
		calcWidth();
	}
	
	getCurPageHeight = function() {
		return pages[curPage].height;	
	}
	
	getCurPageWidth = function() {
		return pages[curPage].width;	
	}
	
	resetFromPage = function(_page) {
		for(var _i = max(0,_page); _i < getPageCount(); _i++) {
			pages[_i].reset();	
		}
	}
	
	setCurrentPage = function(_page, _reset = false) {
		var _prevPage = curPage;
		curPage = clamp(_page,0,getPageCount()-1);
		pageAdvanceDelay = -1;
		if(_reset && _prevPage >= curPage)
			resetFromPage(curPage);
	}
	
	canIncPage = function() {
		return curPage+1 < getPageCount()
	}
	
	incPage = function() {
		if(!canIncPage()) return false;
		setCurrentPage(curPage+1)
		return true;
	}
	
	decPage = function(_reset = false) {
		if(curPage-1 < 0) return false;
		setCurrentPage(curPage-1,_reset)	
		return true;
	}
	
	addPage = function() {
		var _page = new __scripturePage();
		array_push(pages, _page);
		return _page;
	}
}

#endregion

#region Scripture Interal Functions 

function __scriptureStyleNameIsProtected(_key) {
	for(var _i = 0; _i < array_length(global.__scripProtectedKeys); _i++) {
		if(_key == global.__scripProtectedKeys[_i]) {
			throw("Attempted to use a protected Scripture Tag.  Sorry.")
		}
	}
}

function __scriptureStringTrimWhiteSpace(_string) {
	while(string_char_at(_string,1) == " ")
		_string = string_delete(_string, 1, 1);
		
	while(string_char_at(_string, string_length(_string)) == " ")
		_string = string_delete(_string, string_length(_string), 1)
		
	return _string;
}

function __scriptureIsInlineSignifier(_tagContent) {
	var _char = string_char_at(_tagContent,1);
	if(_char == global.__scripImage ||
		 _char == global.__scripFont ||
		 _char == global.__scripKerning ||
		 _char == global.__scripScale ||
		 _char == global.__scripOff ||
		 _char == global.__scripAngle ||
		 _char == global.__scripAlpha ||
		 _char == global.__scripAlign ||
		 _char == global.__scripSpeed ||
		 _char == global.__scripColor) return true;
	return false
}

function __scriptureXYParse(_tagContent) {
	var _x = "";
	while(string_char_at(_tagContent,1) != ",") {
		_x+=string_char_at(_tagContent,1);
		_tagContent = string_delete(_tagContent,1,1);
	}
	_tagContent = string_delete(_tagContent,1,1);
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	var _y = "";
	while(_tagContent != "") {
		_y+=string_char_at(_tagContent,1);
		_tagContent = string_delete(_tagContent,1,1);
	}
	
	return {x: real(_x), y: real(_y)};
}

function __scriptureMultiParse(_tagContent) {
	var _space = string_pos(" ", _tagContent);
	if(_space == 0) return [];
	var _arguments = string_delete(_tagContent,1,_space);
	var _array = [];
	while(_arguments != "") {
		var _arg = "";
		_arguments = __scriptureStringTrimWhiteSpace(_arguments);
		while(string_char_at(_arguments,1) != "," && _arguments != ""){
			_arg+=string_char_at(_arguments,1);
			_arguments = string_delete(_arguments,1,1);
		}
		_arguments = string_delete(_arguments,1,1);
		array_push(_array,_arg);
	}
	return _array;
}

function __scriptureCheckForInlineStyle(_tagContent, _curLine) {
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	if(!__scriptureIsInlineSignifier(_tagContent)) return false;
	var _symbol = string_char_at(_tagContent,1);
	_tagContent = string_delete(_tagContent,1,1);
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	var _active = global.__scripActiveStyle;
	switch(_symbol) {
		case global.__scripColor:
			var _color = scripture_hex_to_color(_tagContent)
			_active.color = _color;
			return true;
		break;
		case global.__scripImage:
			var _val = asset_get_index(_tagContent);
			_curLine.addElement(new __scriptureImg({sprite: _val}))
			return true;
		case global.__scripFont:
			var _val = asset_get_index(_tagContent);
			_active.font = _val;
			return true;
		case global.__scripKerning: 
			var _val = real(_tagContent);
			_active.kerning = _val;
			return true;
		case global.__scripScale: 
			var _val = __scriptureXYParse(_tagContent);
			_active.xScale = _val.x;
			_active.yScale = _val.y;
			return true;
		case global.__scripOff:
			var _val = __scriptureXYParse(_tagContent);
			_active.xOff = _val.x;
			_active.yOff = _val.y;
			return true;
		case global.__scripAngle:
			var _val = real(_tagContent);
			_active.angle = _val;
			return true;
		case global.__scripAlpha:
			var _val = real(_tagContent);
			_active.alpha = _val;
			return true;
		case global.__scripAlign:
			var _val;
			switch(_tagContent) {
				case "fa_top": _val = fa_top; break;
				case "fa_middle":
				case "fa_center": _val = fa_middle; break;
				case "fa_bottom": _val = fa_bottom; break;
			}
			_active.textAlign = _val;
			return true;
		case global.__scripSpeed:
			var _val = real(_tagContent);
			_active.speedMod = max(.0001, _val);
			return true;
	}
	
	return false; //this should never happen...
}

function __scriptureGetTagKey(_tag) {
	var _space = string_pos(" ", _tag);
	if(_space == 0) return _tag;
	var _key = string_delete(_tag,_space,1000);
	return _key;
}

function __scriptureHandleTag(_string, _curLine) {
	var _tagContent = "";
	var _isClosingTag = string_char_at(_string,1) == global.__scripEndTag;
	if(_isClosingTag)
		_string = string_delete(_string,1,1);
		
	while(string_char_at(_string,1) != global.__scripCloseTag) {
		_tagContent += string_char_at(_string,1);
		_string = string_delete(_string,1,1);
		
		if(string_char_at(_string,1) == global.__scripOpenTag || string_length(_string) == 0)
			throw("Unclosed Tag Found/n Check your shit, yo.");	
	}
	_string = string_delete(_string,1,1);
	
	var _key = __scriptureGetTagKey(_tagContent)
	
	var _style = global.__scripStyles[$ _key];
	if(_style == undefined) {
		if(__scriptureCheckForInlineStyle(_tagContent, _curLine)) 
			return _string;

		try {
			var _amount = real(_tagContent);
			_curLine.addElement(new __scriptureEvent(function(){},_amount, false))
		} catch(_ex){
			show_debug_message(_ex);
			show_debug_message("Tag: "+_tagContent+" not a valid style, doofus.");
		}
		
		return _string;
	}
	switch(_style.type) {
		case __SCRIPTURE_TYPE_STYLE:
			if(_isClosingTag) {
				__scriptureDequeueStyle(_tagContent);
				break;
			}
			__scriptureEnqueueStyle(_tagContent);
		break;
						
		case SCRIPTURE_TYPE_IMG: _curLine.addElement(new __scriptureImg(_style)); break;
		case __SCRIPTURE_TYPE_EVENT: 
			var _arguments = __scriptureMultiParse(_tagContent)
			_curLine.addElement(new __scriptureEvent(_style.event, undefined, _style.canSkip, _arguments)); 
		break;
	}
	

	return _string;
}

function __scriptureRebuildActiveStyle() {
	var _style = {
		onDrawBegin: [], 
		onDrawEnd: []
	};
	for(var _i = 0; _i < array_length(global.__scripStyleStack); _i++) {
		var _stackStyle = global.__scripStyleStack[_i];
		var _props = variable_struct_get_names(_stackStyle)
    for(var _j = 0; _j < array_length(_props); _j++) {
      var _prop = _props[_j];
      if(_prop == "key") continue;
			if(_prop == "onDrawBegin") {
				array_push(_style.onDrawBegin, _stackStyle.onDrawBegin);
			} else if(_prop == "onDrawEnd") {
				array_push(_style.onDrawEnd, _stackStyle.onDrawEnd);
			} else {
				_style[$ _prop] = _stackStyle[$ _prop];
			}
    }
	}
	global.__scripActiveStyle = _style;
}

function __scriptureFindStyleIndex(_key){
  for(var _i = 0; _i < array_length(global.__scripStyleStack); _i++) {
    if(global.__scripStyleStack[_i].key == _key) return _i;
  }
  return -1;
}

function __scriptureDequeueStyle(_key) {
	if(array_length(global.__scripStyleStack) <= 1) return;
	
  var _index = __scriptureFindStyleIndex(_key);
  if(_index == -1) return;
  array_delete(global.__scripStyleStack,_index,1);
	__scriptureRebuildActiveStyle();
}

function __scripturePushArrayToStyleStack(_style) {
	array_push(global.__scripStyleStack,_style);
	__scriptureRebuildActiveStyle();
}

function __scriptureEnqueueStyle(_key) {
  var _style = global.__scripStyles[$ _key];
  if(_style == undefined) return;
		
  var _index = __scriptureFindStyleIndex(_key);
  if(_index != -1) return;
		
  __scripturePushArrayToStyleStack(_style);
}

function __scriptureLineWillForceNewPage(_curPage, _wrapResult){
	if(global.__scripTextbox.__pageBreakHeight <= 0) return false;
	
	return _curPage.height + global.__scripTextbox.__lineSpacing + _wrapResult.leftoverHeight >= global.__scripTextbox.__pageBreakHeight; 
}

function __scriptureHandleWrapAndPagination(_curLine, _curPage, _forceNewLine = false, _forceNewPage = false) {
	var _wrapResult = _curLine.checkForWrap();
	if(_forceNewLine || _forceNewPage || _wrapResult.didWrap) {
		_curPage.calcHeight();
		if(_forceNewPage || __scriptureLineWillForceNewPage(_curPage, _wrapResult)) {
			_curPage = global.__scripStory.addPage();
		} 
		
		_curLine = _curPage.addLine();
		_curLine.addElements(_wrapResult.leftovers);
	}
	
	return {curLine: _curLine, curPage: _curPage};
}

function __scriptureBuildStory(_string, _textbox) {
	global.__scripTextbox = _textbox;
	global.__scripStyleStack = [];
	if(__defaultStyle == undefined)
		__scriptureEnqueueStyle(__SCRIPTURE_DEFULT_STYLE_KEY);
	else
		__scripturePushArrayToStyleStack(__defaultStyle);
	global.__scripStory = new __scriptureStory();
	var _curPage = global.__scripStory.addPage();
	var _curLine = _curPage.addLine();
	
	while(string_length(_string) > 0) {
		var _char = string_char_at(_string,0);
		_string = string_delete(_string,1,1);
		var _forceNewLine = false;
		var _forceNewPage = false;
		switch(_char) {
			case "\r": _forceNewPage = true; break;			
			case "\n": _forceNewLine = true; break;
			case global.__scripOpenTag: _string = __scriptureHandleTag(_string, _curLine); break;
			case "-":	_curLine.addHyphen(new __scriptureChar(_char, new __scriptureStyle(global.__scripActiveStyle))) break;
			case " ": _curLine.addSpace() break;			
			default: _curLine.addElement(new __scriptureChar(_char, new __scriptureStyle(global.__scripActiveStyle)))
		}
		
		//Handle Wrapping
		var _wrapResult = __scriptureHandleWrapAndPagination(_curLine, _curPage, _forceNewLine, _forceNewPage);
		_curLine = _wrapResult.curLine;
		_curPage = _wrapResult.curPage;
	}
	
	global.__scripStory.calcDimensions();
	return global.__scripStory;
}

function __scriptureApplyVAlign(_y) {
	var _textbox = global.__scripTextbox,
			_story = global.__scripStory;
	switch(_textbox.__vAlign) {
		case fa_top:    return _y;
		case fa_middle: return _y - floor(_story.getCurPageHeight() / 2 - _textbox.__lineSpacing / 2)
		case fa_bottom: return _y - floor(_story.getCurPageHeight()) + _textbox.__lineSpacing; 
	}	
}

function __scriptureApplyHAlign(_x, _line) {
	switch(global.__scripTextbox.__hAlign) {
		case fa_left: return _x;
		case fa_center: return floor(_x - _line.width / 2); break;
		case fa_right: return _x - _line.width; break;
	}	
}

function __scriptureIsTyping(_textbox = global.__scripTextbox) {
	return _textbox.__typeSpeed > 0;	
}

#endregion

	
function scripture_register_style(_key, _style) {
	if(string_count(" ", _key) >= 1) 
		throw("Style Keys cannot contains spaces");
	__scriptureStyleNameIsProtected(_key)
	
	_style.key = _key;
	_style.type = __SCRIPTURE_TYPE_STYLE;
	global.__scripStyles[$ _key] = _style;
	return {
		key: _key,
		open: global.__scripOpenTag+_key+global.__scripCloseTag,
		close: global.__scripOpenTag+global.__scripEndTag+_key+global.__scripCloseTag
	}		
}

function scripture_register_sprite(_key, _sprite, _style) {
	if(string_count(" ", _key) >= 1) 
		throw("Sprite Keys cannot contains spaces");
	__scriptureStyleNameIsProtected(_key)
	
	if(!sprite_exists(_sprite)) {
		show_debug_message("That's not a sprite, dude.")
		return;
	}
	_style.key = _key;
	_style.type = SCRIPTURE_TYPE_IMG;
	_style.sprite = _sprite;
	
	global.__scripStyles[$ _key] = _style;
	return global.__scripOpenTag + _key + global.__scripCloseTag;
}

function scripture_register_event(_key, _func, _canSkip = true) {
	if(string_count(" ",_key) >= 1) 
		throw("Event Keys cannot contains spaces");
		
	
	global.__scripStyles[$ _key] = {
		key: _key,
		type: __SCRIPTURE_TYPE_EVENT,
		event: _func,
		canSkip: _canSkip
	}
	return {
		key: _key,
		event: function() {
			var _string = global.__scripOpenTag + key +" ";
			for(var _i = 0; _i < argument_count; _i++) {
				_string += string(argument[_i]) + (_i == argument_count -1 ? "" : ",")
			}
			_string +=  global.__scripCloseTag
			return _string;
		}
	}
}

function scripture_set_tag_characters(_start = global.__scripOpenTag, 
	_end = global.__scripCloseTag,
	_close = global.__scripEndTag,
	_color = global.__scripColor,
	_image = global.__scripImage,
  _font = global.__scripFont,
  _kerning = global.__scripKerning,
	_scale = global.__scripScale,
	_offStart = global.__scripOff,
	_angle = global.__scripAngle,
	_alpha = global.__scripAlpha,
	_align = global.__scripAlign,
	_speedMod = global.__scripSpeed) {

		for(var _i = 0; _i< argument_count; _i++) {
			var _arg = argument[_i];
			if(string_length(_arg) != 1) throw("Tags must be a single character only");
			for(var _j = 0; _j < argument_count; _j++) {
				if(_j == _i) continue;
				if(argument[_j] == _arg) throw("Tags must be unique");
			}
		}
	
		global.__scripOpenTag = _start;
		global.__scripCloseTag = _close;
		global.__scripCloseTag = _end;
		global.__scripColor = _color;
		global.__scripImage = _image;
		global.__scripFont = _font;
		global.__scripKerning = _kerning;
		global.__scripScale = _scale;
		global.__scripOff = _offStart;
		global.__scripAngle = _angle;
		global.__scripAlpha = _alpha;
		global.__scripAlign = _align;
		global.__scripSpeed = _speedMod;
}

function scripture_create_textbox(){
	return new __scriptureTextBox()
}

function scripture_hex_to_color(_hexString) {
	///CONVERSION CODE BASED ON SCRIPTS FROM GMLscripts.com
	///GMLscripts.com/license
	///XOT is a GameMaker Community Legend.  Don't disrespect.
	_hexString = string_lower(_hexString);
	var _dec = 0;
 
  var _dig = "0123456789abcdef";
  var _len = string_length(_hexString);
  for (var _pos = 1; _pos <= _len; _pos++) {
      _dec = _dec << 4 | (string_pos(string_char_at(_hexString, _pos), _dig) - 1);
  }
 
  var _col = (_dec & 16711680) >> 16 | (_dec & 65280) | (_dec & 255) << 16;
  return _col;
}