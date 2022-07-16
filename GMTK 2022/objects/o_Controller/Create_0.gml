new_room = false;

instance_create_layer(0,0,layer,o_DebugManager);
instance_create_layer(0,0,layer,o_PauseManager);
instance_create_layer(0,0,layer,o_GridManager);
instance_create_layer(0,0,layer,o_UIManager);
room_change(r_1);



perform_step = function(){
	if (new_room)
	{
		new_room = false;
		instance_create_layer(0,0,layer,o_Camera);
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
		key_pause = keyboard_check_pressed(vk_escape);
		if (key_pause) o_PauseManager.pause_toggle();
	}
	if (debug_mode)
	{
		key_restart = keyboard_check_pressed(ord("R"));
		if (key_restart) game_restart();
	}
}