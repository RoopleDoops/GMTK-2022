if (shader_time > 0) shader_draw_color_flash();
scale_draw(scale_struct,x,y);
shader_reset();

draw_hp();

if (global.db_path)
{
	draw_set_color(c_blue);
	draw_path(path,path_drawx,path_drawy,false);
	draw_set_color(c_aqua);
	draw_rectangle(pathx-1,pathy-1,pathx+1,pathy+1,false);
}

if (global.db_draw)
{
	draw_set_color(c_purple);
	draw_set_alpha(0.5);
	draw_rectangle(hbox_left(),hbox_top(),hbox_right(),hbox_bottom(),false);
	draw_set_alpha(1);
}