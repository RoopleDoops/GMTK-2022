movement_create();
move_speed = UNIT/16;
move_hori = 0;
move_vert = 0;
move_accel = 0.05;

// Shooting
shoot_time = 0;
shoot_cd = 15;
shoot_speed = UNIT/8;

// Drawing
hand_distance = UNIT*0.5;
hand_sprite = s_Hand;
hand_x = x;
hand_y = y;

// Input
	key_left = 0;
	key_right = 0;
	key_up = 0;
	key_down = 0;
	key_shoot = 0;

get_input = function(){
	key_left = keyboard_check_direct(ord("A"));
	key_right = keyboard_check_direct(ord("D"));
	key_up = keyboard_check_direct(ord("W"));
	key_down = keyboard_check_direct(ord("S"));
	key_shoot = mouse_check_button(mb_left);
	
	move_hori = key_right - key_left;
	move_vert = key_down - key_up;
}

process_shoot = function(){
	if (shoot_time > 0) shoot_time -=1;
	else
	{
		shoot_time = shoot_cd;
		if (key_shoot) shoot_bullet();		
	}
}

shoot_bullet = function(){
	var _speed = shoot_speed;
	var _dir = point_direction(BBOX_CENTER,BBOX_MIDDLE,hand_x,hand_y);
	var _bullet = instance_create_depth(hand_x,hand_y,depth,o_Bullet);
	with (_bullet)
	{
		x_move = lengthdir_x(_speed,_dir);
		y_move = lengthdir_y(_speed,_dir);
	}
}

update_hand_position = function(){
	var _dir = point_direction(BBOX_CENTER,BBOX_MIDDLE,get_cursor_x(),get_cursor_y());
	hand_x = floor(BBOX_CENTER+lengthdir_x(hand_distance,_dir));
	hand_y = floor(BBOX_MIDDLE+lengthdir_y(hand_distance,_dir));
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
		
	#endregion
}