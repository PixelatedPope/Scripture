show_debug_overlay(true)
randomize();
scripture_build_example_styles();

//testString = "<#00FF00>Green<#FFFFFF> <I sprCoin> <F fntBold>Bold<F fntDefault> <S 1,3>Scaled Up Y<S 3,1> Scaled Up X<S 1,1> <O -20,-20>up 20, left 20<O 0,0>"
//testString += "<a 45>Skewed <arrow> <a 0>  <A .25>barely visible<A 1> <L fa_bottom>bottom aligned<L fa_middle> <K 20>This Text Is Super Spaced Out<K 0> <s .1>this text types very slowly."
testString = 
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
			coin +" "+ underline.open + "SIMPLE, HEAVENLY TEXT" + underline.close + " " + coin + 
		flyIn.close + 
	rainbow.close + "\b" +
	welcomeTo.open + 
		outline.open + 
			bleep.open + 
				rainbow.open +
					excite.open + 
						"Coming Soon...";
						
//testString = "short page\b" + "wide page a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a\b" + "Tall Page \n1\n2\n3\n4\n5\n6\n7\n8\n9\n10"
instance_create_depth(room_width / 2,room_height/ 2,0,objExampleText1)
.textbox = scripture_build_textbox(testString, 500, 150, fa_center, fa_middle, 1, 0);