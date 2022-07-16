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

depth = 0;
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


cursor = noone;

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
	sidebar2_yscale = ((menu_height/2)-sprite_get_height(sidebar_sprite))/sprite_get_height(sidebar_sprite);

	// Text
	sidebar_text_color = make_color_rgb(80,48,48);
	sidebar1_text = "1. Click & drag each\ndie to an open slot.";
	sidebar1_text_x = floor(sidebar_x + (sidebar_xscale * sprite_get_width(sidebar_sprite) / 2));
	sidebar1_text_y = floor(sidebar_y1 + UNIT*0.75);
	sidebar2_text = "2. Click the button\nto roll the dice!";
	sidebar2_text_x = floor(sidebar_x + (sidebar_xscale * sprite_get_width(sidebar_sprite) / 2));
	sidebar2_text_y = floor(sidebar_y2 + UNIT*0.75);

	// Dice
	sidebar1_item_padx = UNIT;
	sidebar1_item_pady = UNIT*2;
	sidebar1_item_spacex = UNIT;
	sidebar1_item_spacey = UNIT;
	sidebar1_extra_spacey = UNIT/4;
	
	// Player
	sidebar2_item_x = floor(sidebar_x + (sidebar_xscale * sprite_get_width(sidebar_sprite) / 2));
	sidebar2_item_y = floor(sidebar_y2 + (sidebar_yscale * sprite_get_height(sidebar_sprite) / 2) + UNIT*1);
	sidebar2_item_sprite = s_Player;
	
	// Button
	sidebar_button_x = sidebar_x;
	sidebar_button_y = floor(sidebar_y2 + (sidebar_yscale * sprite_get_height(sidebar_sprite)) - UNIT);
	sidebar_button_yscale = sprite_get_height(sidebar_sprite)/UNIT;
	button_text_x = sidebar_button_x + (sidebar_xscale*sprite_get_width(sidebar_sprite))/2;
	button_text_y = sidebar_button_y + (sidebar_button_yscale*sprite_get_height(sidebar_sprite))/2;
	button_text = "Roll the dice!";
#endregion


upgrade_start = function(){
	state = UPGRADE_STATE.ON;
	create_dice();
	cursor = instance_create_depth(floor(mouse_x),floor(mouse_y),DEPTH_CURSOR,o_UpgradeCursor);
}

upgrade_end = function(){
	state = UPGRADE_STATE.OFF;
	if (instance_exists(cursor)) instance_destroy(cursor);
}

upgrade_get_value = function(_attribute){
	return upgrade_array[_attribute][U_A2.VALUE];
}

create_slot_array = function(){
	slot_array = [];
	// initialize start of array
	var _i = 0;
	for (var _iy = 0; _iy < 2; _iy += 1)
	{
		for (var _ix = 0; _ix < (a_size/2); _ix+=1)
		{
			// Get initial x/y
				var _x = floor(menu_padx + (_ix * menu_spacex));
				if (upgrade_array[_i][U_A2.ROW] == 0) var _y = menu_texty_row1;
				else var _y = menu_texty_row2;
			// get dice x/y based off of x/y
				var _dicex = _x;
				var _dicey = _y + dice_hole_yoffset
				slot_array[_i][AXIS.X] = _dicex;
				slot_array[_i][AXIS.Y] = _dicey;
			// Increment _i
			_i += 1;
		}
	}
}
create_slot_array();

update_slot_filled = function(_slot,_boolean){
	upgrade_array[_slot][U_A2.DICE] = _boolean;	
}

collision_slot_array = function(_x1,_y1,_x2,_y2){
	var _size = array_length(slot_array);
	for (var _i = 0; _i < _size; _i += 1)
	{
		var _x = slot_array[_i][AXIS.X];
		var _y = slot_array[_i][AXIS.Y];
		var _closed_slot = upgrade_array[_i][U_A2.DICE];
		if (point_in_rectangle(_x,_y,_x1,_y1,_x2,_y2)) && (!_closed_slot)
		{
			update_slot_filled(_i,true);
			return _i;
		}
		else if (_i == _size - 1) return -1;
	}
}

get_slot_x = function(_slot){
	return slot_array[_slot][AXIS.X];
}

get_slot_y = function(_slot){
	return slot_array[_slot][AXIS.Y];
}


create_dice = function(){
	for (var _i = 0; _i < global.level; _i += 1)
	{
		if (_i < 3) 
		{
			var _x = sidebar_x + sidebar1_item_padx + (_i * sidebar1_item_spacex);
			if (_i == 1) var _y = sidebar_y1 + sidebar1_item_pady + sidebar1_extra_spacey;
			else var _y = sidebar_y1 + sidebar1_item_pady;
		}
		else 
		{
			var _x = sidebar_x + sidebar1_item_padx + ((_i-3) * sidebar1_item_spacex);
			if (_i == 4) var _y = sidebar_y1 + sidebar1_item_pady + sidebar1_item_spacey + sidebar1_extra_spacey;
			else var _y = sidebar_y1 + sidebar1_item_pady + sidebar1_item_spacey;
		}
		instance_create_layer(_x,_y,"L_Dice",o_Dice);
	}
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
	draw_sprite_ext(sidebar_sprite,0,sidebar_x,sidebar_y1,sidebar_xscale,sidebar_yscale,0,image_blend,image_alpha);
	draw_sprite_ext(sidebar_sprite,0,sidebar_x,sidebar_y2,sidebar_xscale,sidebar2_yscale,0,image_blend,image_alpha);
	// Draw text
	draw_set_color(sidebar_text_color);
	draw_set_font(array_font);
	draw_text(sidebar1_text_x,sidebar1_text_y,sidebar1_text);
	draw_text(sidebar2_text_x,sidebar2_text_y,sidebar2_text);
	// draw sidebar dice
	//draw sidebar player
	draw_sprite_ext(sidebar2_item_sprite,0,sidebar2_item_x,sidebar2_item_y,2,2,0,image_blend,image_alpha);
	//Button
	draw_sprite_ext(sidebar_sprite,0,sidebar_button_x,sidebar_button_y,sidebar_xscale,sidebar_button_yscale,0,image_blend,image_alpha);
	draw_text(button_text_x,button_text_y,button_text);
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