enum UPGRADE_STATE
{
	ON,
	OFF
}

enum U_A1
{
	HEALTH,
	SPEED,
	GUN,
	HAT,
	TORSO,
	SFX
}
enum U_A2
{
	ROW,
	TEXT,
	VALUE,
	DICE
}

upgrade_array = [];
upgrade_array[U_A1.HEALTH][U_A2.TEXT] = "HEALTH";
upgrade_array[U_A1.SPEED][U_A2.TEXT] = "SPEED";
upgrade_array[U_A1.GUN][U_A2.TEXT] = "GUN";
upgrade_array[U_A1.HAT][U_A2.TEXT] = "HAT";
upgrade_array[U_A1.TORSO][U_A2.TEXT] = "TORSO";
upgrade_array[U_A1.SFX][U_A2.TEXT] = "SFX";
a_size = array_length(upgrade_array);
	// Row
	for (var _i = 0; _i < a_size; _i += 1)
	{
		if (_i < 3) upgrade_array[_i][U_A2.ROW] = 0;
		else upgrade_array[_i][U_A2.ROW] = 1;
	}
	// Value
	for (var _i = 0; _i < a_size; _i += 1)
	{
		upgrade_array[_i][U_A2.VALUE] = 1;
	}
	// Dice
	for (var _i = 0; _i < a_size; _i += 1)
	{
		upgrade_array[_i][U_A2.DICE] = 0;
	}




#region Menu
state = UPGRADE_STATE.OFF;
draw_alpha = 0;
alpha_accel = 0.05;
menu_width = GAME_WIDTH-(UNIT*4);
menu_height = GAME_HEIGHT;
menu_color = make_color_rgb(80,48,48);
menu_padx = UNIT*2;
menu_spacex = floor((menu_width - (menu_padx*2)) / ((a_size/2)-1));
menu_texty_row1 = floor(UNIT*2.5);
menu_texty_row2 = floor(menu_height - (menu_texty_row1));

pattern_sprite = s_MenuPattern;
pattern_xscale = ceil(menu_width / sprite_get_width(pattern_sprite));
pattern_height = sprite_get_height(pattern_sprite);

// Header
header_font = f_PixelBig;
header_x = floor(menu_width/2);
header_yoffset = -UNIT*0.8;

// Text
array_font = f_Pixel;
text_color = make_color_rgb(173,121,92);
dice_hole_yoffset = UNIT*0.8;

// Sidebar
sidebar_sprite = s_UIBox;
sidebar_x = menu_width;
sidebar_y1 = 0;
sidebar_y2 = menu_height/2;
sidebar_xscale = (GAME_WIDTH-menu_width)/sprite_get_width(sidebar_sprite);
sidebar_yscale = menu_height/2/sprite_get_height(sidebar_sprite);
#endregion


upgrade_start = function(){
	state = UPGRADE_STATE.ON;
}

upgrade_end = function(){
	state = UPGRADE_STATE.OFF;
}

upgrade_get_value = function(_attribute){
	return upgrade_array[_attribute][U_A2.VALUE];
}

draw_menu_bg = function(){
	draw_set_alpha(draw_alpha);
	draw_set_color(menu_color);
	draw_rectangle(0,0,menu_width,menu_height,false);
	draw_set_alpha(1);
	draw_sprite_ext(pattern_sprite,0,0,0,pattern_xscale,1,0,image_blend,image_alpha);
	draw_sprite_ext(pattern_sprite,0,0,menu_height-pattern_height,pattern_xscale,1,0,image_blend,image_alpha);
}

draw_array = function(){
#region
	draw_set_alpha(draw_alpha);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	// initialize start of array
	var _i = 0;
	for (var _iy = 0; _iy < 2; _iy += 1)
	{
		for (var _ix = 0; _ix < (a_size/2); _ix+=1)
		{
			// draw text
					draw_set_font(array_font);
				draw_set_color(text_color);
				var _string = upgrade_array[_i][U_A2.TEXT];
				var _x = floor(menu_padx + (_ix * menu_spacex));
				if (upgrade_array[_i][U_A2.ROW] == 0) var _y = menu_texty_row1;
				else var _y = menu_texty_row2;
				draw_text(_x,_y,_string);
			// draw dice
				var _dicex = _x;
				var _dicey = _y + dice_hole_yoffset
				draw_sprite(s_DiceHole,0,_dicex,_dicey);
				if (upgrade_array[_i][U_A2.DICE]) 
				{
					draw_sprite(s_Dice,0,_dicex,_dicey);
				}
			// Increment _i
			_i += 1;
		}
	}
	// Draw Header text
	draw_set_color(text_color)
	draw_set_font(header_font);
	draw_text(header_x,menu_texty_row1+header_yoffset,"COMBAT");
	draw_text(header_x,menu_texty_row2+header_yoffset,"STYLE");
	draw_set_alpha(1);
#endregion
}

draw_sidebar = function(){
	draw_sprite_ext(s_UIBox,0,sidebar_x,sidebar_y1,sidebar_xscale,sidebar_yscale,0,image_blend,image_alpha);
	draw_sprite_ext(s_UIBox,0,sidebar_x,sidebar_y2,sidebar_xscale,sidebar_yscale,0,image_blend,image_alpha);
	
}

perform_step = function(){
	switch (state)
	{
		case UPGRADE_STATE.ON:
			draw_alpha = lerp(draw_alpha,1,alpha_accel);
		break;
		
		case UPGRADE_STATE.OFF:
			draw_alpha = lerp(draw_alpha,0,alpha_accel);
		break;
	}
}