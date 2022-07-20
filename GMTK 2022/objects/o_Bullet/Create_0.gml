// Inherit the parent event
event_inherited();

movement_create();
start_depth = 0;
depth = start_depth;
draw_angle = 0;
move_speed = 4;
damage = 1;
splash_damage = 0;
water_part_num = 8;
splash_range = 48;
splash_knock = 4;
knock = 0;
col_yoffset = 8;

bullet_destroy = function(){
	bullet_splash_damage();
	o_ParticleManager.make_water(x,y,water_part_num);
	instance_destroy();	
}

bullet_splash_damage = function(){
	if (splash_damage > 0)
	{
		var _list = ds_list_create();
		var _enemynum = collision_circle_list(x,y,splash_range,o_Enemy,false,false,_list,false);
		for (var _i = 0; _i < _enemynum; _i += 1)
		{
			var _enemy = _list[| _i];
			var _dmg = splash_damage;
			var _partnum = water_part_num;
			var _splashknock = splash_knock;
			var _x = x;
			var _y = y;
			with (_enemy)
			{
				if (!collision_line_tile_impassable(_x,_y,x,y,LAYER_WALL_TILES))
				{
					var _dir = point_direction(_x,_y,x,y);
					x_knock += lengthdir_x(_splashknock,_dir);
					y_knock += lengthdir_y(_splashknock,_dir);
					if (_dmg > 0) 
					{
						health_change(-_dmg);
						o_ParticleManager.make_water(x,y,_partnum);
					}
				}
			}
		}
		ds_list_destroy(_list);
	}
}

perform_step = function(){
#region movement
	var _array = movement_calculate();
	var _x_move = _array[AXIS.X];
	var _y_move = _array[AXIS.Y];
	// Collision
	// X
		if (!collision_point_tile_impassable(x+_x_move,y+col_yoffset,LAYER_WALL_TILES))
		|| (!collision_point_tile_impassable(x+_x_move,y,LAYER_WALL_TILES))
		{
			x += _x_move;
		}
		else
		{
			while (!collision_point_tile_impassable(x+sign(_x_move),y+col_yoffset,LAYER_WALL_TILES))
			|| (!collision_point_tile_impassable(x+sign(_x_move),y,LAYER_WALL_TILES))
			{
				x += sign(_x_move);
			}
			x_move = 0;
			bullet_destroy();
		}
	// Y
		if (!collision_point_tile_impassable(x,y+_y_move+col_yoffset,LAYER_WALL_TILES))
		|| (!collision_point_tile_impassable(x,y+_y_move,LAYER_WALL_TILES))
		{
			y += _y_move;
		}
		else
		{
			while (!collision_point_tile_impassable(x,y+sign(_y_move)+col_yoffset,LAYER_WALL_TILES))
			|| (!collision_point_tile_impassable(x,y+sign(_y_move),LAYER_WALL_TILES))
			{
				y += sign(_y_move);
			}
			y_move = 0;
			bullet_destroy();
		}
	
	#endregion
	
	// Drawing
	depth = lerp(start_depth,-y,0.05);
}
