new_room = true;
instance_create_depth(0,0,0,o_DebugManager);
instance_create_depth(0,0,0,o_PauseManager);
instance_create_depth(0,0,0,o_GridManager);
instance_create_depth(0,0,0,o_UIManager);
instance_create_depth(0,0,0,o_UpgradeManager);
instance_create_depth(0,0,0,o_Transition);



get_next_room = function(){
	switch (global.level)
	{
		case 2:
			return r_L1;
		break;
		case 3:
			return r_L2;
		break;
		case 4:
			return r_L3;
		break;
		case 5:
			return r_L4;
		break;
		case 6:
			return r_L5;
		break;
		default:
			show_debug_message("No case for global.level at "+string(global.level));
			return r_Title;
		break;
	}
}

enable_input = function(){
	global.input_enabled = true;
}

start_new_room = function(){
	new_room = true;	
}

room_reset = function(){
	room_change(r_Upgrade);
}

perform_step = function(){
	if (new_room)
	{
		new_room = false;
		instance_create_depth(0,0,depth,o_Camera);
		o_Camera.camera_snap();
		if (instance_exists(o_GridManager))
		{
			with (o_GridManager)
			{
				new_grid = true;
			}
		}
	}
	if (global.input_enabled)
	{
		//key_pause = keyboard_check_pressed(vk_escape);
		//if (key_pause) o_PauseManager.pause_toggle();
	}
	if (debug_mode)
	{
		key_restart = keyboard_check_pressed(ord("R"));
		if (key_restart) room_reset();
	}
}

room_goto(START_ROOM);