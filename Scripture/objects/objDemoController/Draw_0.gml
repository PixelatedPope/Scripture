/// @description
draw_set_valign(fa_bottom);
draw_set_halign(fa_center);

draw_set_font(-1);
draw_set_color(c_gray);
draw_set_halign(fa_right)
draw_text(room_width - 5, room_height - 5, string(fps_real) + "\n" + string(fps));