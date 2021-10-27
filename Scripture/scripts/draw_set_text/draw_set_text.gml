///@func draw_set_text(halign, valign, [color], [font])
function draw_set_text(_ha, _va, _col = draw_get_color(), _font = draw_get_font()){
  draw_set_halign(_ha);
  draw_set_valign(_va);
  draw_set_color(_col);
  draw_set_font(_font);
}