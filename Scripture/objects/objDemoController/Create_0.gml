show_debug_overlay(true)

scripture_build_example_styles();
//scripture_set_tag_characters("[","]");
scripture_set_default_style("bold");

testString = "<colors><squiggle>Lorem ipsum<slow down> dolor</slow down> sit amet, consectetur adipiscing elit. Nullam finibus ante eu elementum malesuada. Duis nec diam sit amet nisl tempus lobortis nec a lorem. Aliquam erat volutpat. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla sed sapien efficitur, posuere felis sed, vulputate arcu. Vestibulum nec turpis vel lacus laoreet posuere. Morbi id purus suscipit, ultrices erat non, suscipit quam. Phasellus sed neque risus. Nunc sed mollis metus, eu rhoncus leo. Curabitur sit amet ex in turpis maximus semper vel vel tellus. Donec quis lectus in ex efficitur egestas vel et nunc. Donec ac blandit massa. Sed semper purus elit, sed ultrices felis elementum a. ";
width = 200
height = 400

instance_create_depth(10,10,0,objExampleText1)
.options = scripture_build_options(undefined,fa_center,fa_middle,1,width,0,5,false);