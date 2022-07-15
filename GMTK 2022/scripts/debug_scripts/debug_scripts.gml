function debug_draw(){
	if (global.db_draw)
	{
		draw_set_font(f_Pixel);
		draw_set_color(c_white);
		draw_set_halign(fa_left);
		draw_text(x-UNIT/2,y+UNIT/4,"X: "+string(x)+", Y: "+string(y));
		draw_text(x-UNIT/2,y+UNIT/2,"x_move: "+string_format(x_move,2,2)+", y_move: "+string_format(y_move,2,2));
	}
}