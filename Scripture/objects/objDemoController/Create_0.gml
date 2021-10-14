show_debug_overlay(true)
randomize();
scripture_build_example_styles();

//scripture_set_tag_characters("[","]");
//scripture_set_default_style("bold");

//testString = "<bold>consectetur adipiscing elit. Nullam finibus ante eu elementum malesuada. Duis nec diam sit amet nisl tempus lobortis nec a lorem. Aliquam erat volutpat. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla sed sapien efficitur, posuere felis sed, vulputate arcu. Vestibulum nec turpis vel lacus laoreet posuere. Morbi id purus suscipit, ultrices erat non, suscipit quam. Phasellus sed neque risus. Nunc sed mollis metus, eu rhoncus leo. Curabitur sit amet ex in turpis maximus semper vel vel tellus. Donec quis lectus in ex efficitur egestas vel et nunc. Donec ac blandit massa. Sed semper purus elit, sed ultrices felis elementum a. ";
testString = //"<* fntBold><# 00FF00> <@ 0  ,  -25> This <@0  ,-15> is <@0, 0> Green<#FFFFFF>\n<+ .01>And this <^.25>is <^0.1>white<+1>\n<#FF0000><^1><? fa_top>And this is<$ 5> <! sprCoin ><$1> red."
	wait(60) + 
		welcomeTo.open +
			outline.open + 
				"WELCOME TO\n" + wait(60) +
			outline.close +
		welcomeTo.close + 
	scripture.open + 
		"SCRIPTURE" + 
	scripture.close + "\n" + 
	wait(30) +
	rainbow.open + 
		flyIn.open  +  
			coin +" "+ underline.open + "SIMPLY HEAVENLY TEXT" + underline.close + " " + coin + 
		flyIn.close + 
	rainbow.close + "\b" +
	welcomeTo.open + 
		outline.open + 
			bleep.open + 
				rainbow.open +
					excite.open + 
						"Coming Soon...";
						



instance_create_depth(room_width / 2,room_height/ 2,0,objExampleText1)
.textbox = scripture_build_textbox(1000, 0, fa_center, fa_middle, 1, 0);