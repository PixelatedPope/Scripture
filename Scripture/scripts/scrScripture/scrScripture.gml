//*************************************************************************
// Hi!  Welcome to Scripture!  Make sure you know what you are doing before
// making any changes in this file. The consequences could be dire!
//
// - Pixelated Pope
//*************************************************************************

#region Globals and Macros
global.__scripChapter = {};
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
#endregion

#region Scripture Constructors
function __scriptureTextBox() constructor {
	__hAlign = fa_left;
	__vAlign = fa_top;
	__lineBreakWidth = 0;
	__verseBreakHeight = 0;
	__typeSpeed = 0;
	__lineSpacing = 0;
	__forceLineBreaks = false;
	__built = false;
	__defaultStyle = undefined;
	__inVerseBreak = false;
	__isPaused = false;
	__verseAdvanceDelay = -1;
	__chapter = undefined;
	__currentDelay = 0;
	__nextVerseReady = false;
	
	maxWidth = undefined;
	maxHeight = undefined;
	__verseDimensions = undefined;
	__verseCount = undefined
	
	__autoAdvanceVerse = function(_currentVerse) {
		if(!__inVerseBreak && (__verseCount <=  1 || !_currentVerse.__isComplete || !global.__scripChapter.__canIncVerse())) return;
		if(__verseAdvanceDelay >= 0) {
			__verseAdvanceDelay--;
			if(__verseAdvanceDelay == -1)
				if(__inVerseBreak)
					__inVerseBreak = false;
				else
					gotoNextPage(false);

			return;
		}

		var _delay = _currentVerse.__getVerseAdvanceDelay();
		if(_delay	>= 0)
			__verseAdvanceDelay	= _delay;
	}
	
	///@func build(string);
	build = function(_string) {
		__built = true;
		var _chapter = __scriptureBuildChapter(_string, self);
		var _verseDimensions = []
		var _widestVerseWidth = 0;
		var _tallestVerseHeight = 0;
		for(var _i = 0; _i < _chapter.__getVerseCount(); _i++){
			var _width = _chapter.__verses[_i].__width;
			var _height = _chapter.__verses[_i].__height;
			if(_width > _widestVerseWidth)
				_widestVerseWidth = _width;
			if(_height > _tallestVerseHeight)
				_tallestVerseHeight = _height;
			array_push(_verseDimensions, {width: _width, height: _height});
		}
	
		maxWidth = _widestVerseWidth;
		maxHeight = _tallestVerseHeight;
		__verseDimensions = _verseDimensions;
		__verseCount = _chapter.__getVerseCount();
		__chapter = _chapter;
		return self
	}
	
	///@func setAlignment(halign, valign)
	setAlignment = function(_hAlign, _vAlign) {
		__hAlign = _hAlign;
		__vAlign = _vAlign;
		return self
	}
	
	///@func setSize(width, height, [line spacing = 0], [force line breaks = false]
	setSize = function(_maxWidth, _maxHeight, _lineSpacing = 0, _forceLineBreaks = false) {
		__lineBreakWidth = _maxWidth;
		__verseBreakHeight = _maxHeight;
		__lineSpacing = _lineSpacing;
		__forceLineBreaks = _forceLineBreaks;
		return self
	}
	
	///@func setTypeSpeed(characters per step)
	setTypeSpeed = function(_typeSpeed) {
		__typeSpeed = _typeSpeed;
		return self
	}
	
	///@func setDefaultStyle(style key)
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
	
	///@func getPageAdvanceDelay()
	getPageAdvanceDelay = function() {
		return __verseAdvanceDelay;	
	}
	
	///@func getAllPageDimensions()
	getAllPageDimensions = function() {
		return __verseDimensions;	
	}
	
	///@func getCurrentPageDimensions()
	getCurrentPageDimensions = function() {
		return __verseDimensions[__chapter.__curVerse];
	}
	
	///@func getCurrentPage()
	getCurrentPage = function() {
		return __chapter.__curVerse;	
	}
	
	///@func getNextPageIsReady()
	getNextPageIsReady = function() {
		return 	__nextVerseReady;
	}
	
	///@func gotoNextPage([shortcut animations = true])
	gotoNextPage = function(_shortcutAnimations = true) {
		if(__inVerseBreak) {
			__inVerseBreak = false;
			__verseAdvanceDelay = -1
			return false;
		}
		var _curVerse = __chapter.__getCurrentVerse();
		if(_curVerse.__isComplete) {
			__verseAdvanceDelay = -1;
			return __chapter.__incVerse();
		}

		_curVerse.__finishVerse(_shortcutAnimations)   
		return true;
	}

	///@func gotoPrevPage([reset = true])
	gotoPrevPage = function(_reset = true) {
		__verseAdvanceDelay = -1;
		__chapter.__decVerse(_reset);
	}

	///@func gotoPage(page, [reset = true])
	gotoPage = function(_verse, _reset = true) {
		if(_verse < 0 || _verse >= __verseCount) return;
		__verseAdvanceDelay = -1;
		__chapter.__setCurrentVerse(_verse,_reset);
	}
	
	///@func setPaused(isPaused)
	setPaused = function(_isPaused) {
		__isPaused = _isPaused;	
	}	
	
	///@func getIsPaused()
	getIsPaused = function() {
		return __isPaused;
	}	
	
	///@func draw(x,y)
	draw = function(_x, _y) {
		if(!__built) {
			throw("Need to call \"build()\" on textbox before drawing.");	
		}
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		global.__scripTextbox = self;
		global.__scripChapter = __chapter;
		var _currentVerse = __chapter.__getCurrentVerse();
		_currentVerse.__draw(_x, _y);
		draw_set_alpha(1);
	
		__nextVerseReady = _currentVerse.__isComplete || __inVerseBreak;
		__autoAdvanceVerse(_currentVerse);
	}
}

function __scriptureStyle(_style = {}) constructor {
	type = __SCRIPTURE_TYPE_STYLE
	//Return a duplicate of the given style with new key
	color = _style[$ "color"] == undefined ? c_white : _style.color;
	sprite = _style[$ "sprite"] == undefined ? undefined: _style.sprite;
	imageSpeed = _style[$ "imageSpeed"] == undefined ? 1: _style.imageSpeed;
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
	__style = _style;
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
	__onDrawBeginSteps = [];
	__onDrawEndSteps = [];
	__wasSkipped = false;
	__resetSteps = function () {
		__wasSkipped = false;
		__onDrawBeginSteps = [];
		__onDrawEndSteps = [];
	}
	__skip = function(_line) {
		__wasSkipped = true;
		__onDrawBeginSteps = [];
		__onDrawEndSteps = [];
		__draw(-__SCRIPTURE_SKIP_VAL,-__SCRIPTURE_SKIP_VAL, 0, _line);
	}
	__executeOnDrawBegin = function(_x, _y,  _index) {
		for(var _i = 0; _i < array_length(__style.onDrawBegin); _i++) {
			if(array_length(__onDrawBeginSteps) < _i+1) __onDrawBeginSteps[_i] = __wasSkipped ? __SCRIPTURE_SKIP_VAL : 0; 
			var _breakChain = __style.onDrawBegin[_i](_x, _y, __style, self, __onDrawBeginSteps[_i], _index)
			__onDrawBeginSteps[_i] += !global.__scripTextbox.__isPaused;
			if(_breakChain)	break;
		}
	}
	
	__executeOnDrawEnd = function(_x, _y,  _index) {
		for(var _i = 0; _i < array_length(__style.onDrawEnd); _i++) {
			if(array_length(__onDrawEndSteps) < _i+1) __onDrawEndSteps[_i] = __wasSkipped ? __SCRIPTURE_SKIP_VAL : 0; 
			var _breakChain = __style.onDrawEnd[_i](_x, _y, __style, self, __onDrawEndSteps[_i], _index)
			__onDrawEndSteps[_i] += !global.__scripTextbox.__isPaused;
			if(_breakChain)	break;
		}
	}
}

function __scriptureChar(_char, _style = new __scriptureStyle()) constructor {
	type = SCRIPTURE_TYPE_CHAR
	char = _char;
	isSpace = _char == " ";
	__scriptureBuildElement(_style);
	draw_set_font(__style.font);
	width = string_width(char) * xScale + __style.kerning;
	height = string_height(char) * yScale;
	centerX = width / 2;
	centerY = height / 2;
	color = __style.color;
	
	__draw = function(_x, _y, _index, _line) {
		var _drawX = floor(_x + centerX) + xOff;
		var _drawY = floor(_y + centerY) + yOff;
		
		switch(__style.textAlign) {
			case fa_top: break;
			case fa_middle: _drawY += floor(_line.__height/2 - centerY); break;
			case fa_bottom: _drawY += floor(_line.__height - centerY * 2); break;
		}
		
		draw_set_font(__style.font);
		draw_set_color(__style.color);
		draw_set_alpha(alpha * __style.alpha);
		
		__executeOnDrawBegin(_drawX, _drawY, _index);
		
		_drawX += __style.xOff;
		_drawY += __style.yOff;
		
		draw_set_font(__style.font);
		draw_set_color(__style.color);
		draw_set_alpha(alpha * __style.alpha);
		draw_text_transformed(_drawX, _drawY, char, xScale * __style.xScale, yScale * __style.yScale, __style.angle);
		
		__executeOnDrawEnd(_drawX, _drawY, _index);

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
	imageSpeed = _active.imageSpeed;
	image = 0;
	isSpace = false;
	speed = sprite_get_speed_type(sprite) == spritespeed_framespergameframe 
																				 ? sprite_get_speed(sprite) 
																				 : sprite_get_speed(sprite) / room_speed;
	__scriptureBuildElement(_active)
	__style = _active;
	width = sprite_get_width(sprite) * xScale + __style.kerning;
	height = sprite_get_height(sprite) * yScale;
	centerX = width/2;
	centerY = height/2;
	
	__draw = function(_drawX, _drawY, _index) {
		__executeOnDrawBegin(_drawX, _drawY, _index);

		draw_sprite_ext(sprite, image, 
										_drawX + __style.xOff + centerX, _drawY + __style.yOff + centerY, 
										xScale * __style.xScale, yScale * __style.yScale, 
										__style.angle, __style.color, alpha * __style.alpha);
		
		__executeOnDrawEnd(_drawX, _drawY, _index);
		
		image += speed * imageSpeed * !global.__scripTextbox.__isPaused;
		return width;
	}
}

function __scriptureEvent(_func, _delay = undefined, _canSkip = true, _arguments = []) constructor {
	type = __SCRIPTURE_TYPE_EVENT;
	__event = _func;
	__arguments = _arguments;
	isSpace = false;
	__style = {
		speedMod: 1, 
		pageAdvanceDelay: global.__scripActiveStyle.pageAdvanceDelay
	};
	__ran = false;
	__wasSkipped = false;
	__canSkip = _canSkip;
	__delay = _delay;
	__skip = function(_line){
		__wasSkipped = true;	
		__draw();
	}
	__draw = function(){
		if(__ran) return 0;
		__ran = true;
		__event(__arguments);
		if(__delay == undefined) return 0;
		if(__delay > 0) 
			global.__scripTextbox.__currentDelay = __delay;
		else
			global.__scripTextbox.__inVerseBreak = true;
		return 0;
	}
}

function __scriptureLine() constructor {
	__width = 0;
	__height = 0;
	__characters = [];
	__isComplete = false;
	__lastSpace = undefined;
	__typePos = 0;
	__delay = __scriptureIsTyping();
	__getCharacterCount = function(){return array_length(__characters)}
	
	__draw = function(_x, _y, _verse) {
		var _eventCount = 0;
		for(var _c = 0; _c < __getCharacterCount(); _c++) {
			if(!__isComplete && __scriptureIsTyping() && _c > __typePos && _c > 0) { //Delay Countdown
				if(global.__scripTextbox.__currentDelay > 0) {
					global.__scripTextbox.__currentDelay--;
					return false;
				}
				if(!global.__scripTextbox.__isPaused && !global.__scripTextbox.__inVerseBreak) { //Paused or InPageBreak
					__typePos += global.__scripTextbox.__typeSpeed * __characters[_c-1].__style.speedMod;
					_eventCount += __characters[_c].type == __SCRIPTURE_TYPE_EVENT;
				}
				return false;
			}
			_eventCount += __characters[_c].type == __SCRIPTURE_TYPE_EVENT;
			_x += __characters[_c].__draw(_x, _y, _c - _eventCount, self);
		}
		if(__delay > 0) {
			__delay -= __getCharacterCount() == 0 ? 1 : __characters[__getCharacterCount()-1].__style.speedMod;
			return false;	
		}
		__isComplete = true;
		return true;
	}
	
	__reset = function(){
		__isComplete = false;
		__typePos = 0;
		__delay = __scriptureIsTyping();
		for(var _i = 0; _i < __getCharacterCount(); _i++) {
			var _char = __characters[_i];
			
			switch(_char.type) {
				case __SCRIPTURE_TYPE_EVENT:
					_char.__ran = false;
				break;
				case SCRIPTURE_TYPE_IMG:
					_char.image = 0;
				default:
					_char.__resetSteps();
			}
		}
	}
	
	__endAnimations = function() {
		for(var _c = 0; _c < __getCharacterCount(); _c++) {
			var _char = __characters[_c];
			if(_char.type == __SCRIPTURE_TYPE_EVENT && _char.__canSkip) {
				_char.__ran = true;
				continue; 
			}
			_char.__skip(self)
		}
	}
	
	__trimWhiteSpace = function() {
		while(__getCharacterCount() != 0 && __characters[0].type == SCRIPTURE_TYPE_CHAR && __characters[0].isSpace)
			array_delete(__characters, 0, 1);
		
		while(__getCharacterCount() > 1 && __characters[__getCharacterCount() - 1].type == SCRIPTURE_TYPE_CHAR && __characters[__getCharacterCount() - 1].isSpace)
			array_delete(__characters, __getCharacterCount()-1,1);
	}
	
	__addElement = function(_newElement) {
		if(_newElement.type != __SCRIPTURE_TYPE_EVENT)
			__width += _newElement.width;
		array_push(__characters, _newElement);
		return _newElement;
	}
	
	__addElements = function(_elements) {
		for(var _i = 0; _i < array_length(_elements); _i++) {
			array_push(__characters, _elements[_i]);	
		}
		__calcWidth();
	}
	
	__addHyphen = function(_hyphen){
		array_push(__characters,_hyphen);
		__width += _hyphen.width;
		__lastSpace = __getCharacterCount();
	}
	
	__addSpace = function(){
		if(__getCharacterCount() == 0) return;
		
		var _space = new __scriptureChar(" ", new __scriptureStyle(global.__scripActiveStyle));
		array_push(__characters,_space);
		__width += _space.width;
		__lastSpace = __getCharacterCount();
	}
	
	__calcWidth = function(){
		__trimWhiteSpace();
		__width = 0;
		for(var _i = 0; _i < __getCharacterCount(); _i++) {
			var _char = __characters[_i];
			if(_char.type == __SCRIPTURE_TYPE_EVENT) continue;
			
			__width += _char.width;
		}
		return __width;
	}
	
	__calcHeight = function(){
		__trimWhiteSpace();	
		__height = 0;
		for(var _i = 0; _i < __getCharacterCount(); _i++) {
			var _char = __characters[_i];
			if(_char.type == __SCRIPTURE_TYPE_EVENT) continue;

			if(_char.height > __height) 
				__height = _char.height;
		}
		if(__height == 0)
			__height = string_height("QWERTYUIOPASDFGHJKLZXCVBNM<>,./;'[]{}:\"?");
		return __height;
	}
	
	__calcDimensions = function(){
		__calcWidth();
		__calcHeight();
	}
	
	__checkForWrap = function() {
		var _textbox = global.__scripTextbox;
		var _result = {
			__didWrap: false, 
			__leftovers: [], 
			__leftoverHeight: 0};
		if(_textbox.__lineBreakWidth <= 0 || __width <= _textbox.__lineBreakWidth) return _result
		
		var _lastSpace = _textbox.__forceLineBreaks ? 0 : __lastSpace;
		if(__lastSpace == undefined && _textbox.__forceLineBreaks == false) return _result
		var _length = _textbox.__forceLineBreaks ? 0 : __getCharacterCount() - __lastSpace;
		_result.__didWrap = true;
		array_copy(_result.__leftovers, 0, __characters, _lastSpace, _length);
		array_delete(__characters, _lastSpace, _length);
		
		var _maxHeight = 0;
		for(var _i = 0; _i < array_length(_result.__leftovers); _i++) {
			var _h =_result.__leftovers[_i].height;
			if(_h > _maxHeight) _maxHeight = _h;
		}
		_result.__leftoverHeight = _maxHeight;
		return _result
	}
	
	__findNextInVerseBreak = function(){
		for(var _i = __typePos; _i < __getCharacterCount(); _i++) {
			var _char = __characters[_i];
			if( _char.type == __SCRIPTURE_TYPE_EVENT && _char.__delay <= 0)
				return _i;
		}
		return _i;
	}
	
	__forceComplete = function() {
		var _pos = __findNextInVerseBreak();
		if(_pos < __getCharacterCount()) {
			__typePos = _pos;
			return false;
		}
		__isComplete = true;
		__typePos = 10000000;
		__delay = 0;
		return true;
	}
}

function __scriptureVerse() constructor {
	__width = 0;
	__height = 0;
	__linePos = 0;
	__isComplete = false;
	__lines = [];
	__draw = function(_x, _y) {
		var	_drawX,
		    _drawY = __scriptureApplyVAlign(_y);
	
		for(var _i = 0; _i < __getLineCount(); _i++) {
			if(!__isComplete && __scriptureIsTyping() && _i > __linePos) return false;
			
			var _curLine = __lines[_i];
			_drawX = __scriptureApplyHAlign(_x, _curLine);
			if(!_curLine.__draw(_drawX, _drawY)) return false;
			
			if(__linePos == _i) 
				__linePos++;
			_drawY += _curLine.__height + global.__scripTextbox.__lineSpacing;
		}
		__isComplete = true;
		global.__scripTextbox.__currentDelay = 0;
		return true;
	}
	
	__getLineCount = function() {return array_length(__lines);}
	
	__finishVerse = function(_shortcutAnims) {
		for(var _i = 0; _i < __getLineCount(); _i++) {
			if(!__lines[_i].__forceComplete()) return;
			if(_shortcutAnims) {
				__lines[_i].__endAnimations();
			}
		}
		__isComplete = true;
		__linePos = __getLineCount();
	}
	
	__reset = function() {
		__isComplete = false;
		for(var _i = 0; _i < __getLineCount(); _i++) {
			__lines[_i].__reset();	
		}
	}
	
	__calcHeight = function() {
		__height = 0;
		for(var _i = 0; _i < __getLineCount(); _i++) {
			__height += __lines[_i].__calcHeight() + (_i > 0 ? global.__scripTextbox.__lineSpacing : 0);
		}

		return __height;
	}
	
	__calcWidth = function() {
		__width = 0;
		for(var _i = 0; _i < __getLineCount(); _i++) {
			var _width = __lines[_i].__calcWidth();
			if(_width > __width)
				__width = _width;
		}
		return __width;
	}
	
	__addLine = function() {
		var _newLine = new __scriptureLine();
		array_push(__lines, _newLine)
		return _newLine;
	}
	
	__getVerseLastCharacter = function() {
		var _lastLine = __lines[__getLineCount()-1]
		return _lastLine.__characters[_lastLine.__getCharacterCount()-1]		
	}
	
	__getVerseAdvanceDelay = function(_character = __getVerseLastCharacter()){
		return _character.__style.pageAdvanceDelay;
	}
}

function __scriptureChapter() constructor {
	__width = 0;
	__height = 0;
	__verses = [];
	__curVerse = 0;
	__getVerseCount = function() { return array_length(__verses) };
	__getCurrentVerse = function() { return __verses[__curVerse] };
	__inVerseBreak = false;
	__calcHeight = function() {	
		__height = 0;
		for(var _i = 0; _i < __getVerseCount(); _i++) {
			var _height = __verses[_i].__calcHeight();
			if(_height > __height)
				__height = _height;
		}
		return __height;
	}
	
	__calcWidth = function() {
		__width = 0; 
		for(var _i = 0; _i < __getVerseCount(); _i++) {
			var _width = __verses[_i].__calcWidth();
			if(_width > __width)
				__width = _width;
		}
		return __width;
	}
	
	__calcDimensions = function() {
		__calcHeight();
		__calcWidth();
	}
	
	__getCurVerseHeight = function() {
		return __verses[__curVerse].__height;	
	}
	
	__getCurVerseWidth = function() {
		return __verses[__curVerse].__width;	
	}
	
	__resetFromVerse = function(_verse) {
		for(var _i = max(0,_verse); _i < __getVerseCount(); _i++) {
			__verses[_i].__reset();	
		}
	}
	
	__setCurrentVerse = function(_verse, _reset = false) {
		var _prevVerse = __curVerse;
		__curVerse = clamp(_verse,0,__getVerseCount()-1);
		__verseAdvanceDelay = -1;
		if(_reset && _prevVerse >= __curVerse)
			__resetFromVerse(__curVerse);
	}
	
	__canIncVerse = function() {
		return __curVerse + 1 < __getVerseCount()
	}
	
	__incVerse = function() {
		if(!__canIncVerse()) return false;
		__setCurrentVerse(__curVerse + 1)
		return true;
	}
	
	__decVerse = function(_reset = false) {
		if(__curVerse - 1 < 0) return false;
		__setCurrentVerse(__curVerse - 1, _reset)	
		return true;
	}
	
	__addVerse = function() {
		var _verse = new __scriptureVerse();
		array_push(__verses, _verse);
		return _verse;
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
		 _char == global.__scripColor ||
		 _char == global.__scripEndTag) return true;
	return false
}

function __scriptureXYParse(_tagContent) {
	var _x = "";
	while(string_char_at(_tagContent, 1) != ",") {
		_x+=string_char_at(_tagContent, 1);
		_tagContent = string_delete(_tagContent, 1, 1);
	}
	_tagContent = string_delete(_tagContent, 1, 1);
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	var _y = "";
	while(_tagContent != "") {
		_y+=string_char_at(_tagContent, 1);
		_tagContent = string_delete(_tagContent, 1, 1);
	}
	
	return {x: real(_x), y: real(_y)};
}

function __scriptureMultiParse(_tagContent) {
	var _space = string_pos(" ", _tagContent);
	if(_space == 0) return [];
	var _arguments = string_delete(_tagContent, 1, _space);
	var _array = [];
	while(_arguments != "") {
		var _arg = "";
		_arguments = __scriptureStringTrimWhiteSpace(_arguments);
		while(string_char_at(_arguments, 1) != "," && _arguments != ""){
			_arg += string_char_at(_arguments, 1);
			_arguments = string_delete(_arguments, 1, 1);
		}
		_arguments = string_delete(_arguments, 1, 1);
		array_push(_array,_arg);
	}
	return _array;
}

function __scriptureCheckForInlineStyle(_tagContent, _curLine) {
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	if(!__scriptureIsInlineSignifier(_tagContent)) return false;
	var _symbol = string_char_at(_tagContent, 1);
	_tagContent = string_delete(_tagContent, 1, 1);
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	var _newStyle = new __scriptureStyle(global.__scripActiveStyle);
	_newStyle.onDrawBegin = function(){};
	_newStyle.onDrawEnd = function(){};
	
	switch(_symbol) {
		case global.__scripEndTag:
			__scriptureDequeueStyle();
			return false;
		case global.__scripColor:
			var _color = scripture_hex_to_color(_tagContent)
			_newStyle.color = _color;
			break;
		break;
		case global.__scripImage:
			var _val = asset_get_index(_tagContent);
			_curLine.__addElement(new __scriptureImg({sprite: _val}))
			return false;
		case global.__scripFont:
			var _val = asset_get_index(_tagContent);
			_newStyle.font = _val;
			break;
		case global.__scripKerning: 
			var _val = real(_tagContent);
			_newStyle.kerning = _val;
			break;
		case global.__scripScale: 
			var _val = __scriptureXYParse(_tagContent);
			_newStyle.xScale = _val.x;
			_newStyle.yScale = _val.y;
			break;
		case global.__scripOff:
			var _val = __scriptureXYParse(_tagContent);
			_newStyle.xOff = _val.x;
			_newStyle.yOff = _val.y;
			break;
		case global.__scripAngle:
			var _val = real(_tagContent);
			_newStyle.angle = _val;
			break;
		case global.__scripAlpha:
			var _val = real(_tagContent);
			_newStyle.alpha = _val;
			break;
		case global.__scripAlign:
			var _val;
			switch(_tagContent) {
				case "fa_top": _val = fa_top; break;
				case "fa_middle":
				case "fa_center": _val = fa_middle; break;
				case "fa_bottom": _val = fa_bottom; break;
			}
			_newStyle.textAlign = _val;
			break;
		case global.__scripSpeed:
			var _val = real(_tagContent);
			_newStyle.speedMod = max(.0001, _val);
			break;
	}
	__scripturePushStyleToStyleStack(_newStyle);
	return false;
}

function __scriptureGetTagKey(_tag) {
	var _space = string_pos(" ", _tag);
	if(_space == 0) return _tag;
	var _key = string_delete(_tag, _space, 1000);
	return _key;
}

function __scriptureHandleTag(_string, _curLine) {
	var _tagContent = "";
	var _isClosingTag = string_char_at(_string, 1) == global.__scripEndTag;
	if(_isClosingTag)
		_string = string_delete(_string, 1, 1);
		
	while(string_char_at(_string, 1) != global.__scripCloseTag) {
		_tagContent += string_char_at(_string, 1);
		_string = string_delete(_string, 1, 1);
		
		if(string_char_at(_string, 1) == global.__scripOpenTag || string_length(_string) == 0)
			throw("Unclosed Tag Found/n Check your shit, yo.");	
	}
	_string = string_delete(_string, 1, 1);
	
	var _key = __scriptureGetTagKey(_tagContent)
	
	var _style = global.__scripStyles[$ _key];
	if(_style == undefined) {
		if(__scriptureCheckForInlineStyle(_tagContent, _curLine)) 
			return _string;

		try {
			var _amount = real(_tagContent);
			_curLine.__addElement(new __scriptureEvent(function(){}, _amount, false))
		} catch(_ex){
			show_debug_message(_ex);
			show_debug_message("Tag: " + _tagContent + " not a valid style, doofus.");
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
						
		case SCRIPTURE_TYPE_IMG: 
			_curLine.__addElement(new __scriptureImg(_style)); 
		break;
		case __SCRIPTURE_TYPE_EVENT: 
			var _arguments = __scriptureMultiParse(_tagContent)
			_curLine.__addElement(new __scriptureEvent(_style.__event, undefined, _style.__canSkip, _arguments)); 
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
		var _styleKey = global.__scripStyleStack[_i][$ "key"];
    if(_styleKey != undefined && _styleKey == _key) return _i;
  }
  return -1;
}

function __scriptureDequeueStyle(_key = undefined) {
	if(array_length(global.__scripStyleStack) <= 1) return;
	
	var _index = _key == undefined ? array_length(global.__scripStyleStack) - 1 : __scriptureFindStyleIndex(_key);
	if(_index == -1) return;
	
	array_delete(global.__scripStyleStack,_index, 1);
	__scriptureRebuildActiveStyle();
}

function __scripturePushStyleToStyleStack(_style) {
	array_push(global.__scripStyleStack,_style);
	__scriptureRebuildActiveStyle();
}

function __scriptureEnqueueStyle(_key) {
  var _style = global.__scripStyles[$ _key];
  if(_style == undefined) return;
		
  var _index = __scriptureFindStyleIndex(_key);
  if(_index != -1) return;
		
  __scripturePushStyleToStyleStack(_style);
}

function __scriptureLineWillForceNewVerse(_curVerse, _wrapResult){
	if(global.__scripTextbox.__verseBreakHeight <= 0) return false;
	
	return _curVerse.__height + global.__scripTextbox.__lineSpacing + _wrapResult.__leftoverHeight >= global.__scripTextbox.__verseBreakHeight; 
}

function __scriptureHandleWrapAndPagination(_curLine, _curVerse, _forceNewLine = false, _forceNewVerse = false) {
	var _wrapResult = _curLine.__checkForWrap();
	if(_forceNewLine || _forceNewVerse || _wrapResult.__didWrap) {
		_curVerse.__calcHeight();
		if(_forceNewVerse || __scriptureLineWillForceNewVerse(_curVerse, _wrapResult)) {
			_curVerse = global.__scripChapter.__addVerse();
		} 
		
		_curLine = _curVerse.__addLine();
		_curLine.__addElements(_wrapResult.__leftovers);
	}
	
	return {__curLine: _curLine, __curVerse: _curVerse};
}

function __scriptureBuildChapter(_string, _textbox) {
	global.__scripTextbox = _textbox;
	global.__scripStyleStack = [];
	if(__defaultStyle == undefined)
		__scriptureEnqueueStyle(__SCRIPTURE_DEFULT_STYLE_KEY);
	else
		__scripturePushStyleToStyleStack(__defaultStyle);
	global.__scripChapter = new __scriptureChapter();
	var _curVerse = global.__scripChapter.__addVerse();
	var _curLine = _curVerse.__addLine();
	
	while(string_length(_string) > 0) {
		var _char = string_char_at(_string,0);
		_string = string_delete(_string, 1, 1);
		var _forceNewLine = false;
		var _forceNewVerse = false;
		switch(_char) {
			case "\r": _forceNewVerse = true; break;			
			case "\n": _forceNewLine = true; break;
			case global.__scripOpenTag: _string = __scriptureHandleTag(_string, _curLine); break;
			case "-":	_curLine.__addHyphen(new __scriptureChar(_char, new __scriptureStyle(global.__scripActiveStyle))) break;
			case " ": _curLine.__addSpace() break;			
			default: _curLine.__addElement(new __scriptureChar(_char, new __scriptureStyle(global.__scripActiveStyle)))
		}
		
		//Handle Wrapping
		var _wrapResult = __scriptureHandleWrapAndPagination(_curLine, _curVerse, _forceNewLine, _forceNewVerse);
		_curLine = _wrapResult.__curLine;
		_curVerse = _wrapResult.__curVerse;
	}
	
	global.__scripChapter.__calcDimensions();
	return global.__scripChapter;
}

function __scriptureApplyVAlign(_y) {
	var _textbox = global.__scripTextbox,
			_chapter = global.__scripChapter;
	switch(_textbox.__vAlign) {
		case fa_top:    return _y;
		case fa_middle: return _y - floor(_chapter.__getCurVerseHeight() / 2 - _textbox.__lineSpacing / 2)
		case fa_bottom: return _y - floor(_chapter.__getCurVerseHeight()) + _textbox.__lineSpacing; 
	}	
}

function __scriptureApplyHAlign(_x, _line) {
	switch(global.__scripTextbox.__hAlign) {
		case fa_left: return _x;
		case fa_center: return floor(_x - _line.__width / 2); break;
		case fa_right: return _x - _line.__width; break;
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
		__event: _func,
		__canSkip: _canSkip
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

		for(var _i = 0; _i < argument_count; _i++) {
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

///@func scripture_create_textbox();
function scripture_create_textbox(){
	return new __scriptureTextBox()
}

///@func scripture_hex_to_color(hex color)
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