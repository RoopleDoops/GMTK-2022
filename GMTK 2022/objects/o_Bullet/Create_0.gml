// Inherit the parent event
event_inherited();

movement_create();
depth = -(y+UNIT/2);
move_speed = UNIT/8;
damage = 1;

bullet_destroy = function(){
	instance_destroy();	
}

perform_step = function(){
#region movement
	var _array = movement_calculate();
	var _x_move = _array[AXIS.X];
	var _y_move = _array[AXIS.Y];
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
			bullet_destroy();
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
			bullet_destroy();
		}
	
	#endregion
	
	// Drawing
	depth = -(y+UNIT/2);
}
