// Draw Screen Color
var _xedge = GAME_WIDTH/2;
var _yedge = GAME_HEIGHT/2;
draw_set_color(color);
draw_set_alpha(alpha);
draw_rectangle(-_xedge,-_yedge,room_width+_xedge,room_height+_yedge,false);
draw_set_alpha(1);