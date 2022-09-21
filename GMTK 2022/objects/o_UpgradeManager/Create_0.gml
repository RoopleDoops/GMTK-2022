enum UPGRADE_STATE
{
	ON,
	OFF,
	ROLLING
}

enum U_A1
{
	HEALTH = 0,
	SPEED = 1,
	GUN,
	HAT,
	BODY,
	SFX
}
enum U_A2
{
	ROW,
	TEXT,
	VALUE,
	SLOTTED,
	DICE_ID,
	ROLLED
}

// SOUND
roll_sound = sfx_diceRoll;
roll_sound_playing = noone;
put_sound = sfx_dicePut;
put_sound_playing = noone;

depth = 0;
upgrade_array = [];
upgrade_array[U_A1.HEALTH][U_A2.TEXT] = "HEALTH";
upgrade_array[U_A1.SPEED][U_A2.TEXT] = "SPEED";
upgrade_array[U_A1.GUN][U_A2.TEXT] = "GUN";
upgrade_array[U_A1.HAT][U_A2.TEXT] = "HAT";
upgrade_array[U_A1.BODY][U_A2.TEXT] = "BODY";
upgrade_array[U_A1.SFX][U_A2.TEXT] = "SFX";
a_size = array_length(upgrade_array);
// Row
for (var _i = 0; _i < a_size; _i += 1)
{
	if (_i < 3) upgrade_array[_i][U_A2.ROW] = 0;
	else upgrade_array[_i][U_A2.ROW] = 1;
}
	
upgrade_array_reset = function(_slotreset = true){
	// Value
	for (var _i = 0; _i < a_size; _i += 1)
	{
		// Style initiates at 0 or 2
		if (upgrade_array[_i][U_A2.ROW] == 1)
		{
			// sound starts at 2
			if (_i == U_A1.SFX) upgrade_array[_i][U_A2.VALUE] = 2;
			// Clothes at 0
			else upgrade_array[_i][U_A2.VALUE] = 0;
		}
		// Others at 1
		else upgrade_array[_i][U_A2.VALUE] = 1;
	}
	if (_slotreset)
	{
		// Dice SLOT
		for (var _i = 0; _i < a_size; _i += 1)
		{
			upgrade_array[_i][U_A2.SLOTTED] = 0;
		}
	}
	// ROLLED
	// Dice
	for (var _i = 0; _i < a_size; _i += 1)
	{
		upgrade_array[_i][U_A2.ROLLED] = 0;
	}	
}
upgrade_array_reset();


cursor = noone;
model = noone;

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
pattern_xscale = ceil(room_width / sprite_get_width(pattern_sprite));
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
	sidebar2_item_sprite = s_Player00;
	
	// Button
	button_sprite = s_UIButton;
	button_index = 0;
	button_time_max = 5;
	button_time = 0;
	sidebar_button_x = sidebar_x;
	sidebar_button_y = floor(sidebar_y2 + (sidebar_yscale * sprite_get_height(sidebar_sprite)) - UNIT);
	sidebar_button_yscale = sprite_get_height(sidebar_sprite)/UNIT;
	button_text_x = sidebar_button_x + (sidebar_xscale*sprite_get_width(sidebar_sprite))/2;
	button_text_y = sidebar_button_y + (sidebar_button_yscale*sprite_get_height(sidebar_sprite))/2;
	button_text = "Roll the dice!";
	button_text_color = make_color_rgb(80,48,48);
#endregion

#region BODY SPRITE ASSIGNMENTS
	get_body_sprite = function(){
	var _val = upgrade_array[U_A1.BODY][U_A2.VALUE];
	switch (_val)
	{
		case 0:
			return s_Player00;
		break;
		case 1:
			return s_Player01;
		break;
		case 2:
			return s_Player02;
		break;
		case 3:	
			return s_Player03;
		break;
		case 4:
			return s_Player04;
		break;
		case 5:
			return s_Player05;
		break;
		case 6:
			return s_Player06;
		break;
	}
	}
#endregion

#region HAT SPRITE ASSIGNMENTS
	get_hat_sprite = function(){
	var _val = upgrade_array[U_A1.HAT][U_A2.VALUE];
	switch (_val)
	{
		case 0:
			return s_Hat00;
		break;
		case 1:
			return s_Hat01;
		break;
		case 2:
			return s_Hat02;
		break;
		case 3:	
			return s_Hat03;
		break;
		case 4:
			return s_Hat04;
		break;
		case 5:
			return s_Hat05;
		break;
		case 6:
			return s_Hat06;
		break;
	}
	}
#endregion

#region GUN SPRITE ASSIGNMENTS
	get_gun_sprite = function(){
	var _val = upgrade_array[U_A1.GUN][U_A2.VALUE];
	switch (_val)
	{
		case 1: return s_Hand01;break;
		case 2: return s_Hand02;break;
		case 3:	return s_Hand03;break;
		case 4: return s_Hand04;break;
		case 5:	return s_Hand05;break;
		case 6: return s_Hand06;break;
	}
	}
#endregion

#region GUN SPRITE ASSIGNMENTS
	get_sfx = function(){
	var _val = upgrade_array[U_A1.SFX][U_A2.VALUE];
	switch (_val)
	{
		case 1: return sfx_gun01; break;
		case 2: return sfx_gun02; break;
		case 3:	return sfx_gun03; break;
		case 4: return sfx_gun04; break;
		case 5:	return sfx_gun05; break;
		case 6: return sfx_gun06; break;
	}
	}
#endregion

#region BOOT SPRITE ASSIGNMENTS
	get_boot_sprite = function(){
	var _val = upgrade_array[U_A1.SPEED][U_A2.VALUE];
	switch (_val)
	{
		case 6: return s_Boot06;break;
		default: return s_Boot01;break;
	}
	}
#endregion

create_player_model = function(){
	model = instance_create_depth(sidebar2_item_x,sidebar2_item_y,depth,o_PlayerModel);
	with (model) squash_scale(1.2,0.8);
}

update_player_model = function(_array_slot){
	var _sprite = noone;
	if (_array_slot == U_A1.HAT) var _sprite = get_hat_sprite(); 
	else if (_array_slot == U_A1.BODY) var _sprite = get_body_sprite();
	else if (_array_slot == U_A1.GUN) var _sprite = get_gun_sprite();
	else if (_array_slot == U_A1.SPEED) var _sprite = get_boot_sprite(); 
	with (model)
	{
		squash_scale(scale_struct,1.2,0.8);
		if (_array_slot == U_A1.HAT) hat_sprite = _sprite;
		else if (_array_slot == U_A1.BODY) animate_set_sprite(astruct_body,_sprite);
		else if (_array_slot == U_A1.GUN) hand_sprite = _sprite;
		else if (_array_slot == U_A1.SPEED) boot_sprite = _sprite;
	}
}

#region Rolling variables
rolling_time = 0;
rolling_time_space = 60;
rolling_time_final = 90;
#endregion

collision_button = function(_x,_y){
#region
	var _bl = sidebar_button_x;
	var _br = GAME_WIDTH;
	var _bt = sidebar_button_y;
	var _bb = menu_height;
	var _slot_count = 0;
	if (point_in_rectangle(_x,_y,_bl,_bt,_br,_bb))
	{
		button_index = 1;
		button_time = button_time_max;
		for (var _i = 0; _i < a_size; _i += 1)
		{
			if (upgrade_array[_i][U_A2.SLOTTED] == true) _slot_count += 1;
		}
		// Click accepted
		if (_slot_count == global.dice_num) 
		{
			return true;
		}
		// Dice not all placed
		else 
		{
			audio_play_sound(sfx_uiBad,50,false);
			var _dicenum = instance_number(o_Dice);
			for (var _i = 0; _i < _dicenum; _i += 1)
			{
				var _dice = instance_find(o_Dice,_i);
				if (_dice.slot == -1) _dice.dice_emphasize();
			}
		}
	}
#endregion
}

fill_slot = function(_slot,_id){
	upgrade_array[_slot][U_A2.SLOTTED] = true;
	upgrade_array[_slot][U_A2.DICE_ID] = _id;
}

roll_dice = function(){
	if (state != UPGRADE_STATE.ROLLING)
	{
		// Destroy cursor
		if (instance_exists(cursor)) instance_destroy(cursor);
		var _sfx = roll_sound_playing
		if (audio_exists(_sfx)) && (audio_is_playing(_sfx))
		{
			audio_stop_sound(_sfx)
		}
		roll_sound_playing = audio_play_sound(roll_sound,50,false);
		var _dicenum = instance_number(o_Dice);
		for (var _i = 0; _i < _dicenum; _i += 1)
		{
			var _dice = instance_find(o_Dice,_i);
			_dice.dice_lock();
		}
		rolling_count = 0;
		rolling_time = rolling_time_space;
		state = UPGRADE_STATE.ROLLING;
	}
}


upgrade_start = function(){
	//upgrade_array_reset(false); // do not reset slots
	upgrade_array_reset();
	create_player_model();
	state = UPGRADE_STATE.ON;
	create_dice();
	//remember_dice();
	cursor = instance_create_depth(floor(mouse_x),floor(mouse_y),DEPTH_CURSOR,o_UpgradeCursor);
}

upgrade_end = function(){
	state = UPGRADE_STATE.OFF;
	room_change(o_Controller.get_next_room());
}

upgrade_get_value = function(_attribute){
	var _val = upgrade_array[_attribute][U_A2.VALUE];
	return _val;
}

create_slot_array = function(){
#region
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
#endregion
}
create_slot_array();

update_slot_filled = function(_slot,_boolean){
	upgrade_array[_slot][U_A2.SLOTTED] = _boolean;	
}

collision_slot_array = function(_x1,_y1,_x2,_y2){
#region
	var _size = array_length(slot_array);
	for (var _i = 0; _i < _size; _i += 1)
	{
		var _x = slot_array[_i][AXIS.X];
		var _y = slot_array[_i][AXIS.Y];
		var _closed_slot = upgrade_array[_i][U_A2.SLOTTED];
		if (point_in_rectangle(_x,_y,_x1-32,_y1-32,_x2+32,_y2+32)) && (!_closed_slot)
		{
			var _sfx = put_sound_playing
			if (audio_exists(_sfx)) && (audio_is_playing(_sfx))
			{
				audio_stop_sound(_sfx)
			}
			put_sound_playing = audio_play_sound(put_sound,50,false);
			update_slot_filled(_i,true);
			return _i;
		}
		else if (_i == _size - 1) return -1;
	}
#endregion
}

get_slot_x = function(_slot){
	return slot_array[_slot][AXIS.X];
}

get_slot_y = function(_slot){
	return slot_array[_slot][AXIS.Y];
}


create_dice = function(){
#region
	for (var _i = 0; _i < global.dice_num; _i += 1)
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
	// Auto assign once at 6 dice
	if (global.dice_num == 6)
	{
		var _dicenum = instance_number(o_Dice);
		for (var _i = 0; _i < _dicenum; _i += 1)
		{
			_dice = instance_find(o_Dice,_i);
			var _x = get_slot_x(_i);
			var _y = get_slot_y(_i);
			with (_dice)
			{
				x = _x;
				y = _y;
				dice_drop();
			}
		}
	}
#endregion
}

remember_dice = function(){
	var _dicequeue = ds_queue_create();
	var _dicenum = instance_number(o_Dice);
	for (var _i = 0; _i < _dicenum; _i += 1)
	{
		var _dice = instance_find(o_Dice,_i);
		ds_queue_enqueue(_dicequeue,_dice);
	}	
	var _slotnum = 6;
	for (var _i = 0; _i < _slotnum; _i += 1)
	{
		if (upgrade_array[_i][U_A2.SLOTTED] == true)
		{
			upgrade_array[_i][U_A2.SLOTTED] = false;
			var _dice = ds_queue_dequeue(_dicequeue);
			var _x = get_slot_x(_i);
			var _y = get_slot_y(_i);
			with (_dice)
			{
				x = _x;
				y = _y;
				dice_drop();
			}
		}
	}
	ds_queue_destroy(_dicequeue);
}

draw_menu_bg = function(){
#region
	draw_set_color(menu_color);
	draw_rectangle(0,0,menu_width,menu_height,false);
	draw_sprite_ext(pattern_sprite,0,0,0,pattern_xscale,1,0,image_blend,draw_alpha);
	draw_sprite_ext(pattern_sprite,0,0,menu_height-pattern_height,pattern_xscale,1,0,image_blend,draw_alpha);
#endregion
}

draw_array = function(){
#region
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
			// Increment _i
			_i += 1;
		}
	}
	// Draw Header text
	draw_set_color(text_color)
	draw_set_font(header_font);
	draw_text(header_x,menu_texty_row1+header_yoffset,"COMBAT");
	draw_text(header_x,menu_texty_row2+header_yoffset,"STYLE");
#endregion
}

draw_sidebar = function(){
#region
	draw_sprite_ext(sidebar_sprite,0,sidebar_x,sidebar_y1,sidebar_xscale,sidebar_yscale,0,image_blend,draw_alpha);
	draw_sprite_ext(sidebar_sprite,0,sidebar_x,sidebar_y2,sidebar_xscale,sidebar2_yscale,0,image_blend,draw_alpha);
	// Draw text
	draw_set_color(sidebar_text_color);
	draw_set_font(array_font);
	draw_text(sidebar1_text_x,sidebar1_text_y,sidebar1_text);
	draw_text(sidebar2_text_x,sidebar2_text_y,sidebar2_text);
	// draw sidebar dice
	//draw sidebar player
	//draw_sprite_ext(sidebar2_item_sprite,0,sidebar2_item_x,sidebar2_item_y,2,2,0,image_blend,draw_alpha);
	//Button
	draw_sprite_ext(button_sprite,button_index,sidebar_button_x,sidebar_button_y,sidebar_xscale,sidebar_button_yscale,0,image_blend,draw_alpha);
	draw_set_color(button_text_color);
	draw_text(button_text_x,button_text_y,button_text);
#endregion
}

perform_step = function(){
	switch (state)
	{
		case UPGRADE_STATE.ON:
			draw_alpha = lerp(draw_alpha,1,alpha_accel);
		break;
		
		case UPGRADE_STATE.ROLLING:
			draw_alpha = lerp(draw_alpha,1,alpha_accel);
			if (rolling_count < global.dice_num)
			{
				if (rolling_time > 0) rolling_time -= 1;
				else
				{
					for (var _i = rolling_count; _i < a_size; _i += 1)
					{
						if (upgrade_array[_i][U_A2.SLOTTED])
						{
							if (upgrade_array[_i][U_A2.ROLLED] == false)
							{
								upgrade_array[_i][U_A2.ROLLED] = true;
								var _dice_id = upgrade_array[_i][U_A2.DICE_ID];
								break;
							}
						}
					}
					with (_dice_id)
					{
						dice_emphasize();
						var _roll = anim_struct.anim_index + 1;
						if (slot < 3) && (_roll == 1)
						{
							// Reroll 1's on first row only (one time)
							var _newroll = irandom_range(1,6);
							anim_struct.anim_index = _newroll - 1;
							_roll = _newroll;
						}
						var _slot = slot;
					}
					switch (_roll)
					{
						case 1: var _sound = sfx_gun01; break;
						case 2: var _sound = sfx_dice02; break;
						case 3: var _sound = sfx_dice03; break;
						case 4: var _sound = sfx_dice04; break;
						case 5: var _sound = sfx_dice05; break;
						case 6: var _sound = sfx_dice06; break;
					}
					audio_play_sound(_sound,50,false);
					upgrade_array[_slot][U_A2.VALUE] = _roll;
					update_player_model(_slot);
					rolling_count += 1;
					if (rolling_count == global.dice_num) rolling_time = rolling_time_final;
					else rolling_time = rolling_time_space;
				}
			}
			else 
			{
				if (rolling_time > 0) rolling_time -=1;
				else upgrade_end();
			}
		break;
		
		case UPGRADE_STATE.OFF:
			draw_alpha = lerp(draw_alpha,0,alpha_accel);
		break;
	}
	if (button_time > 0) button_time -= 1;
	else button_index = 0;
}