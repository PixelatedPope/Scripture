show_debug_overlay(true)
randomize();
scripture_build_example_styles();
//scripture_set_tag_characters("[","]");
//scripture_set_default_style("bold");

//testString = "<bold>consectetur adipiscing elit. Nullam finibus ante eu elementum malesuada. Duis nec diam sit amet nisl tempus lobortis nec a lorem. Aliquam erat volutpat. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla sed sapien efficitur, posuere felis sed, vulputate arcu. Vestibulum nec turpis vel lacus laoreet posuere. Morbi id purus suscipit, ultrices erat non, suscipit quam. Phasellus sed neque risus. Nunc sed mollis metus, eu rhoncus leo. Curabitur sit amet ex in turpis maximus semper vel vel tellus. Donec quis lectus in ex efficitur egestas vel et nunc. Donec ac blandit massa. Sed semper purus elit, sed ultrices felis elementum a. ";
testString = 
	wait(60)+ bleep.open + welcomeTo.open+"WELCOME TO\n<60>"+welcomeTo.close + bleep.close + 
	scripture.open + "SCRIPTURE" + scripture.close + "\n" + wait(30) +
	flyIn.open  +  rainbow.open + coin +" "+ underline.open + "advanced text rendering" + underline.close + " " + coin + rainbow.close  + flyIn.close;


instance_create_depth(room_width / 2,room_height/ 2,0,objExampleText1)
.options = scripture_build_options(undefined, fa_center, fa_middle, 1, 1000, -20, 0);