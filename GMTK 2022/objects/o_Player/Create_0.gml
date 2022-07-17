enum P_STATE
{
	IDLE,
	DEAD
}

movement_create();
move_speed = UNIT/32 + (UNIT/64 * (o_UpgradeManager.upgrade_get_value(U_A1.SPEED)));
move_hori = 0;
move_vert = 0;
move_accel = 0.05;
dir = 0;
state = P_STATE.IDLE;

// Health
hp_max = o_UpgradeManager.upgrade_get_value(U_A1.HEALTH);
hp = hp_max;
i_time = 0;
i_time_max = 90;
o_UIManager.update_health();

// Shooting
gun = o_UpgradeManager.upgrade_get_value(U_A1.GUN);
switch (gun)
{
	case 1: // SQUIRT GUN
		shoot_cd = 20;
		shoot_speed = 4;
		shoot_damage = 15;
		shoot_knock = 0;
		shoot_spread = 16;
		shoot_size = 1;
		shoot_sprite = s_Bullet;
		shoot_num = 1;
		shoot_shake = 0;
		shoot_shake_dur = 0;
	break;
	case 2: // PISTOL
		shoot_cd = 20;
		shoot_speed = 4;
		shoot_damage = 15;
		shoot_knock = 0;
		shoot_spread = 12;
		shoot_size = 1;
		shoot_sprite = s_Bullet;
		shoot_num = 1;
		shoot_shake = 0;
		shoot_shake_dur = 0;
	break;
	case 3: // SHOTGUN
		shoot_cd = 45;
		shoot_speed = 4;
		shoot_damage = 15;
		shoot_knock = 0.5;
		shoot_spread = 0;
		shoot_size = 1;
		shoot_sprite = s_BulletSmall;
		shoot_num = 5;
		shoot_shake = 0;
		shoot_shake_dur = 0;
	break;
	case 4: // MACHINE GUN
		shoot_cd = 5;
		shoot_speed = 4;
		shoot_damage = 8;
		shoot_knock = 0;
		shoot_spread = 24;
		shoot_size = 1;
		shoot_sprite = s_BulletSmall;
		shoot_num = 1;
		shoot_shake = 0;
		shoot_shake_dur = 0;
	break;
	case 5: // SNIPER
		shoot_cd = 60;
		shoot_speed = 24;
		shoot_damage = 50;
		shoot_knock = 4;
		shoot_spread = 0;
		shoot_size = 2;
		shoot_sprite = s_Bullet;
		shoot_num = 1;
		shoot_shake = 1;
		shoot_shake_dur = 10;
	break;
	case 6: // CANNON
		shoot_cd = 90;
		shoot_speed = 2.5;
		shoot_damage = 100;
		shoot_knock = 8;
		shoot_spread = 0;
		shoot_size = 3;
		shoot_sprite = s_BulletBig;
		shoot_num = 1;
		shoot_shake = 2;
		shoot_shake_dur = 15;
	break;
	default: // EDGE CASE
		show_debug_message("o_Player gun type out of range!");
		shoot_cd = 25;
		shoot_speed = 4;
		shoot_damage = 15;
		shoot_knock = 0;
		shoot_spread = 16;
		shoot_size = 1;
		shoot_sprite = s_Bullet;
		shoot_num = 1;
		shoot_shake = 0;
		shoot_shake_dur = 0;
	break;
		
}
shoot_time = 0;

// Drawing
hat_sprite = o_UpgradeManager.get_hat_sprite();
astruct_body = animate_create(o_UpgradeManager.get_body_sprite());
alpha = 1;
shader_create_color_flash();
shader_color = [1.0, 0.0, 0.0, 0.5];
shader_time_max = 15;
scale_struct = scale_create();
hand_behind = false;
hand_dist_x = UNIT*0.25;
hand_dist_y = UNIT*0.25;
hand_sprite = o_UpgradeManager.get_gun_sprite();
boot_sprite = o_UpgradeManager.get_boot_sprite();
hand_x = x;
hand_y = y;
hand_yoffset = -4;
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
		i_time = 0;
		alpha = 1;
		shader_time = 0;
		squash_scale(scale_struct,1,1);
		o_Controller.room_reset();
		state = P_STATE.DEAD;
		depth = -14001;
	}
}

player_win = function(){
	if (state != P_STATE.DEAD)
	{
		i_time = 0;
		alpha = 1;
		shader_time = 0;
		squash_scale(scale_struct,1,1);
		state = P_STATE.DEAD;
	}
}

health_change = function(_amount){
	if (i_time == 0)
	{
		o_Camera.camera_screen_shake(15,1);
		i_time = i_time_max;
		alpha = 0.5;
		shader_time = shader_time_max;
		squash_scale(scale_struct,1.2,0.8);
		hp += _amount;
		hp = max(hp,0);
		o_UIManager.update_health();
		if (hp <= 0) player_destroy();	
	}
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
	var _acc = irandom_range(-shoot_spread,shoot_spread);
	var _dir = dir;//point_direction(x,BBOX_MIDDLE,hand_x,hand_y);
	var _shootx = barrel_x;
	var _shooty = barrel_y;
	var _shootdmg = shoot_damage;
	var _shootsize = shoot_size;
	var _shootsprite = shoot_sprite;
	var _bnum = shoot_num;
	for (var _i = 0; _i < _bnum; _i += 1)
	{
		switch (_i)
		{
			case 0: var _ang = 0; break;
			case 1: var _ang = 15; break;
			case 2: var _ang = 30; break;
			case 3: var _ang = -15; break;
			case 4: var _ang = -30; break;
			default: var _ang = 0; break;
		}
		var _bullet = instance_create_depth(_shootx,_shooty,depth,o_Bullet);
		with (_bullet)
		{
			sprite_index = _shootsprite;
			image_xscale = _shootsize;
			image_yscale = _shootsize;
			draw_angle = _dir+_acc+_ang;
			x_move = lengthdir_x(_speed,draw_angle);
			y_move = lengthdir_y(_speed,draw_angle);
			damage = _shootdmg;
		}
	}
	
	// Shake
	if (shoot_shake > 0) o_Camera.camera_screen_shake(shoot_shake_dur,shoot_shake);
	
	// Knockback
	x_knock += -lengthdir_x(shoot_knock,_dir);
	y_knock += -lengthdir_y(shoot_knock,_dir);
}

update_hand_position = function(){
	dir = point_direction(x,BBOX_MIDDLE,get_cursor_x(),get_cursor_y()-hand_yoffset);
	if (within_range(dir,50,130)) hand_behind = true;
	else hand_behind = false;
	hand_angle = dir;
	hand_x = floor(x+lengthdir_x(hand_dist_x,dir));
	hand_y = floor(BBOX_MIDDLE+hand_yoffset+lengthdir_y(hand_dist_y,dir));
	barrel_x = floor(x+lengthdir_x(hand_dist_x+12,dir));
	barrel_y = floor(BBOX_MIDDLE+hand_yoffset-2+lengthdir_y(20,dir));
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
		if (i_time > 0) i_time -=1;
		else alpha = 1;
		if (shader_time > 0) shader_time -= 1;
		animate_step(astruct_body);
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