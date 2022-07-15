function room_change(_room = room_next(room)){
	room_goto(_room);
	if (instance_exists(o_GridManager))
	{
		with (o_GridManager)
		{
			new_grid = true;
		}
	}
}