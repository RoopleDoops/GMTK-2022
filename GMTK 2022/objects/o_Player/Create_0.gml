enum P_STATE
{
	IDLE,
	DEAD
}

movement_create();
move_speed = UNIT/16 + (o_UpgradeManager.upgrade_get_value(U_A1.SPEED)/2);
move_hori = 0;
move_vert = 0;
move_accel = 0.05;
dir = 0;
state = P_STATE.IDLE;

// Health
hp_max = 1 + o_UpgradeManager.upgrade_get_value(U_A1.HEALTH);
hp = hp_max;
o_UIManager.update_health();

// Shooting
shoot_time = 0;
shoot_cd = 15;
shoot_speed = UNIT/8;
shoot_damage = 1;
shoot_knock = UNIT/128;

// Drawing
scale_struct = scale_create();
hand_behind = false;
hand_dist_x = UNIT*0.25;
hand_dist_y = UNIT*0.25;
hand_sprite = s_Hand;
hand_x = x;
hand_y = y;
hand_yoffset = -4;
shoot_xoffset = 11;
shoot_yoffset = -2;
hand_angle = 0;
debug = false;
dir_change_cd = 0;
dir_change_cd_max = 10;

// Input
	key_left = 0;
	key_right = 0;
	key_up = 0;
	key_down = 0;
	key_shoot = 0;

get_input = function(){
	if (global.input_enabled)
	{
		key_left = keyboard_check_direct(ord("A"));
		key_right = keyboard_check_direct(ord("D"));
		key_up = keyboard_check_direct(ord("W"));
		key_down = keyboard_check_direct(ord("S"));
		key_shoot = mouse_check_button(mb_left);
	}
	else
	{
		key_left = 0;
		key_right = 0;
		key_up = 0;
		key_down = 0;
		key_shoot = 0;
	}
	
	move_hori = key_right - key_left;
	move_vert = key_down - key_up;
	
	if (debug_mode)
	{
		if (keyboard_check_pressed(ord("O")))
		{
			debug = !debug;
			show_debug_overlay(debug);
		}
		if (keyboard_check_pressed(ord("M")))
		{
			global.db_draw = !global.db_draw;
		}
		if (keyboard_check_pressed(ord("P")))
		{
			global.db_path = !global.db_path;
		}
	}
}

player_destroy = function(){
	if (state != P_STATE.DEAD)
	{
		squash_scale(scale_struct,1,1);
		o_Controller.room_reset();
		state = P_STATE.DEAD;
		depth = -14001;
	}
}

health_change = function(_amount){
	squash_scale(scale_struct,1.2,0.8);
	hp += _amount;
	hp = max(hp,0);
	o_UIManager.update_health();
	if (hp <= 0) player_destroy();	
}

process_shoot = function(){
	if (shoot_time > 0) shoot_time -=1;
	if (key_shoot) && (shoot_time == 0)
	{
		shoot_time = shoot_cd;
		shoot_bullet();		
	}
}

shoot_bullet = function(){
	squash_scale(scale_struct,1.1,0.9);
	var _speed = shoot_speed;
	var _dir = dir;//point_direction(x,BBOX_MIDDLE,hand_x,hand_y);
	var _shootx = hand_x ;//+ lengthdir_x(shoot_xoffset,_dir);
	var _shooty = hand_y ;//+ lengthdir_y(shoot_yoffset,_dir);
	var _bullet = instance_create_depth(_shootx,_shooty,depth,o_Bullet);
	var _shootdmg = shoot_damage;
	with (_bullet)
	{
		x_move = lengthdir_x(_speed,_dir);
		y_move = lengthdir_y(_speed,_dir);
		damage = _shootdmg;
	}
	// Knockback
	//x_knock += -lengthdir_x(shoot_knock,_dir);
	//y_knock += -lengthdir_y(shoot_knock,_dir);
}

update_hand_position = function(){
	dir = point_direction(x,BBOX_MIDDLE,get_cursor_x(),get_cursor_y()-hand_yoffset);
	if (within_range(dir,50,130)) hand_behind = true;
	else hand_behind = false;
	hand_angle = dir;
	hand_x = floor(x+lengthdir_x(hand_dist_x,dir));
	hand_y = floor(BBOX_MIDDLE+hand_yoffset+lengthdir_y(hand_dist_y,dir));
}

#region Create Cursor
	my_cursor = instance_create_depth(mouse_x,mouse_y,DEPTH_CURSOR,o_Cursor);
#endregion

get_cursor_x = function(){
	var _x = floor(my_cursor.x);
	return _x;
}

get_cursor_y = function(){
	var _y = floor(my_cursor.y);
	return _y;
}

perform_step = function(){
	get_input();
	
	#region Movement
	x_move = lerp(x_move,move_hori*move_speed,move_accel);
	y_move = lerp(y_move,move_vert*move_speed,move_accel);
	
	var _move_array = movement_calculate();
	var _x_move = _move_array[AXIS.X];
	var _y_move = _move_array[AXIS.Y];
	// Collision
	// X
		if (!place_meeting_tile_impassable(x+_x_move,y,LAYER_WALL_TILES))
		{
			x += _x_move;
		}
		else
		{
			while (!place_meeting_tile_impassable(x+sign(_x_move),y,LAYER_WALL_TILES))
			{
				x += sign(_x_move);
			}
			x_move = 0;
		}
	// Y
		if (!place_meeting_tile_impassable(x,y+_y_move,LAYER_WALL_TILES))
		{
			y += _y_move;
		}
		else
		{
			while (!place_meeting_tile_impassable(x,y+sign(_y_move),LAYER_WALL_TILES))
			{
				y += sign(_y_move);
			}
			y_move = 0;
		}
	#endregion
	
	update_hand_position();
	process_shoot();
	#region Drawing
		scale_step(scale_struct,SCALE_MED);
		if (dir_change_cd > 0) dir_change_cd -= 1;
		if (image_xscale != angle_dir_hori(dir)) 
		{
			if (dir_change_cd <= 0)
			{
				dir_change_cd = dir_change_cd_max;
				squash_scale(scale_struct,1.2,0.8);
			}
			image_xscale = angle_dir_hori(dir);
		}
		depth = -y;
	#endregion
}