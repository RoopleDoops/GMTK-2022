event_inherited();
enum E_STATE
{
	IDLE,
	CHASE,
	RECOIL,
	DIE
}


movement_create();
move_speed = UNIT/32;
move_accel = 0.1;
dir = 0;
state = E_STATE.CHASE;
path = path_add();
pathx = 0;
pathy = 0;
path_prog = 0;
path_incr = 0;
path_drawx = 0;
path_drawy = 0;
path_time = 0;
path_time_max = 15;

perform_step = function(){
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
			dir = point_direction(_x,_y,_px,_py);
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
	var _vx = lengthdir_x(move_speed,dir);
	var _vy = lengthdir_y(move_speed,dir);
	x_move = lerp(x_move,_vx,move_accel);
	y_move = lerp(y_move,_vy,move_accel);
	
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
		}
}

