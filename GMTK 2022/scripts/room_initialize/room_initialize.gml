function room_initialize(){
	with (o_GridManager)
	{
		grid_create();
		grid_update();
	}
	var _name = room_get_name(room);
	var _prefix = string_char_at(_name,3);
	switch (_prefix)
	{
		case "L":
			instance_create_depth(0,0,0,o_EnemyManager);
		break;
		default:
		break;
	}
}