
var _styleStruct = {
	color: c_white,
	font: -1,
	speedMod: 1,
	kerning: 0,
	xScale: 1,
	yScale: 1,
	xOff: 0,
	yOff: 0,
	angle: 0,
	alpha: 1,
	textAlign: fa_middle,
	onDrawBegin: function(_x, _y, _style, _base, _steps){},
	onDrawEnd: function(_x, _y, _style, _base, _steps){}
}

styleBasic = scripture_register_style("Basic",_styleStruct)

styleSpooky = scripture_register_style("spooky", _styleStruct);
myString = 
	"The call is coming from "
		+ styleSpooky.open 
			+ "INSIDE THE HOUSE"
		+ styleSpooky.close
	". You should probably get out, eh?"


myString = 
	"<#FFFFFF>Please bring me <F fntBold>one <#00FF00>Green<//> apple.<//>"

myTextbox = scripture_create_textbox()
myTextbox.setSize(400,200)
myTextbox.setTypeSpeed(.1)
myTextbox.build("Hello.  My name is Scripture.  I'm a fancy text engine.");


myTextbox.draw(x, y);

myString = "The call is coming from <spooky>INSIDE THE HOUSE</spooky>." +
					 "You should probably get out, eh?"
					 
					 
					 
coin = scripture_register_sprite("coin",sprCoin, {});
myString = "You need 5 <coin> coins to enter." 

coins = scripture_register_sprite("coin",sprCoin, {})+" coins";
myString = "You need 5 " + coins + " to enter." 