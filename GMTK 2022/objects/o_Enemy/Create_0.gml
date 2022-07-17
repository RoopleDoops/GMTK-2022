event_inherited();
enum E_STATE
{
	IDLE,
	CHASE,
	CHARGE,
	RECOIL,
	DIE
}


movement_create();
move_speed_base = 1.2;
charge_speed = UNIT/16;
move_speed = move_speed_base;
move_accel = 0.05;
dir = 0;
state = E_STATE.IDLE;
hp_max = 100;
hp = hp_max;

idle_time_max = 90
; // time to wait before moving towards player
idle_time = idle_time_max;

hbox_lo = 0;
hbox_ro = 0;
hbox_to = 20;
hbox_bo = 0;
// Hitbox
hbox_left = function(){
	return bbox_left - hbox_lo;
}

hbox_right = function(){
	return bbox_right + hbox_ro;
}

hbox_top = function(){
	return bbox_top - hbox_to;	
}

hbox_bottom = function(){
	return bbox_bottom + hbox_bo;	
}

// Recoil
recoil_time_max = 60;
recoil_time = recoil_time_max;

// Charge
charge_time_max = 90;
charge_time = charge_time_max;

// Pathing
path = path_add();
pathx = 0;
pathy = 0;
path_prog = 0;
path_incr = 0;
path_drawx = 0;
path_drawy = 0;
path_time = 0;
path_time_max = 15;

// Drawing
change_sprite = s_EnemyHit;
friendly_sprite = s_Friendly;
shader_create_color_flash();
shader_color = [0.0, 0.0, 1.0, 0.5];
scale_struct = scale_create();
hp_alpha_max = 0.9;
hp_alpha = 0;
hp_alpha_accel = 0.2;
hp_draw_time = 0;
hp_draw_time_max = 300;
hp_yoffset = -(UNIT+UNIT/2);
hp_width_max = UNIT/2;
hp_height = UNIT/8;
hp_color_border = col_white;
hp_color_bar = col_blue3;

draw_hp = function(){
	if (hp_alpha > 0)
	{
		draw_set_alpha(hp_alpha);
		draw_set_color(hp_color_bar);
		var _xstart = x-(hp_width_max/2)
		draw_rectangle(_xstart,y+hp_yoffset,_xstart+(1-hp/hp_max)*(hp_width_max),y+hp_yoffset+hp_height,false);
		draw_set_color(hp_color_border);
		draw_rectangle(_xstart,y+hp_yoffset,x+(hp_width_max/2),y+hp_yoffset+hp_height,true);
		draw_set_alpha(1);
	}
}

next_state = function(_state){
#region
	switch(_state)
	{
		case E_STATE.CHASE:
			move_speed = move_speed_base;
			path_time = 0;
			state = _state;
		break;
		case E_STATE.CHARGE:
			charge_time = charge_time_max;
			move_speed = charge_speed;
			state = _state;
		break;
		case E_STATE.RECOIL:
			move_speed = move_speed_base;
			squash_scale(scale_struct,0.8,1.2);
			recoil_time = recoil_time_max;
			state = _state;
		break;
		case E_STATE.IDLE:
			state = _state;
		break;
	}
#endregion
}

idle_step = function(){
	if (idle_time > 0) idle_time -= 1;
	else next_state(E_STATE.CHASE);
	x_move = lerp(x_move,0,move_accel);
	y_move = lerp(y_move,0,move_accel);	
}

player_in_sights = function(_x,_y,_px,_py){
	dir = point_direction(_x,_y,_px,_py);
}

collision_enemy_x = function(_x_move){
	if (place_meeting(x+_x_move,y,o_Enemy)) { x_move = 0; return 0;}
	else return _x_move;
}

collision_enemy_y = function(_y_move){
	if (place_meeting(x,y+_y_move,o_Enemy)) { y_move = 0; return 0;}
	else return _y_move;
}

charge_step = function(){
	if (charge_time > 0) charge_time -=1;
	else
	{
		next_state(E_STATE.CHASE);
	}
	enemy_movement_math();
}

enemy_movement_math = function(){
	var _vx = lengthdir_x(move_speed,dir);
	var _vy = lengthdir_y(move_speed,dir);
	x_move = lerp(x_move,_vx,move_accel);
	y_move = lerp(y_move,_vy,move_accel);	
}

chase_step = function(){
#region
	// Pathfinding
	if (path_time > 0) path_time -= 1;
	if (instance_exists(o_Player))
	{
		var _px = o_Player.x;
		var _py = o_Player.y;
		var _x = BBOX_CENTER;
		var _y = BBOX_MIDDLE;
		if (path_time == 0) 
		&& (!collision_line_tile_impassable(bbox_left,y,_px,_py,LAYER_WALL_TILES))
		&& (!collision_line_tile_impassable(bbox_right,y,_px,_py,LAYER_WALL_TILES))
		&& (!collision_line_tile_impassable(x,bbox_top,_px,_py,LAYER_WALL_TILES))
		&& (!collision_line_tile_impassable(x,bbox_bottom,_px,_py,LAYER_WALL_TILES))
		{
			player_in_sights(_x,_y,_px,_py);
		}
		else
		{
			var _path_success = true;
			if (path_time == 0)
			{
				path_time = path_time_max;
				var _path_success = mp_grid_path(global.grid,path,_x,_y,_px,_py,true);
				path_incr = move_speed*2 / path_get_length(path);
				path_prog = 0;
			}
			if (_path_success)
			{
				if (path_prog >= 0.99)
				{
					path_incr = move_speed*2 / path_get_length(path);
					path_prog = path_incr;
				}
				else
				{
					path_prog += path_incr;
				}
				pathx = path_get_x(path,path_prog);
				pathy = path_get_y(path,path_prog);
				dir = point_direction(_x,_y,pathx,pathy);
				path_drawx = _x;
				path_drawy = _y;
			}
		}
	}
	else next_state(E_STATE.IDLE);
	enemy_movement_math();
#endregion
}

recoil_step = function(){
	x_move = lerp(x_move,0,move_accel);
	y_move = lerp(y_move,0,move_accel);
	if (recoil_time > 0) recoil_time -=1;
	else
	{
		next_state(E_STATE.CHASE);
	}
}

wall_hit = function(){
	squash_scale(scale_struct,1.1,0.9);
}

health_change = function(_amount){
	hp_draw_time = hp_draw_time_max;
	hp_alpha = hp_alpha_max;
	shader_time = shader_time_max;
	squash_scale(scale_struct,1.2,0.8);
	hp += _amount;
	hp = max(hp,0);
	if (hp <= 0) enemy_destroy();	
}

enemy_destroy = function(){
	var _friendly = instance_create_depth(x,y,depth,o_Friendly);
	_friendly.image_xscale = image_xscale;
	_friendly.sprite_setup(change_sprite,friendly_sprite);
	o_EnemyManager.enemy_count_update();
	instance_destroy();	
}

perform_step = function(){
	
	#region State Machine
		switch (state)
		{
			case E_STATE.CHASE:chase_step();break;
			case E_STATE.CHARGE:charge_step();break;
			case E_STATE.RECOIL:recoil_step();break;
			case E_STATE.IDLE:idle_step();break;
		}
	#endregion
	
	var _move_array = movement_calculate();
	var _x_move = _move_array[AXIS.X];
	var _y_move = _move_array[AXIS.Y];
	
	_x_move = collision_enemy_x(_x_move);
	_y_move = collision_enemy_y(_y_move);
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
			wall_hit();
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
			wall_hit();
		}
	
	// Bullet collision
	var _list = ds_list_create();
	var _bulletnum = collision_rectangle_list(hbox_left(),hbox_top(),hbox_right(),hbox_bottom(),o_Bullet,false,false,_list,false);
	var _damage = 0;
	for (var _i = 0; _i < _bulletnum; _i += 1)
	{
		_bullet = _list[| _i];
		var _bdmg = _bullet.damage;
		_damage += _bdmg;
		_bullet.bullet_destroy();
	}
	if (_damage > 0) health_change(-_damage);
	
	// Player Collision
	if ((state == E_STATE.CHASE) || (state == E_STATE.CHARGE)) && (place_meeting(x,y,o_Player))
	{
		next_state(E_STATE.RECOIL);
		o_Player.health_change(-1);
	}
	
	// Drawing
	if (shader_time > 0) shader_time -=1;
	if (hp_draw_time > 0) hp_draw_time -= 1;
	else hp_alpha = lerp(hp_alpha,0,hp_alpha_accel);
	scale_step(scale_struct,SCALE_MED);
	if (angle_dir_hori(dir) != image_xscale)
	{
		squash_scale(scale_struct,1.1,0.9);
		image_xscale = angle_dir_hori(dir);
	}
	depth = -y;
}

