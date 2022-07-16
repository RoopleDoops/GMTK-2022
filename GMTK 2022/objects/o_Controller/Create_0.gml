new_room = false;
depth = -15000;
instance_create_depth(0,0,depth,o_DebugManager);
instance_create_depth(0,0,depth,o_PauseManager);
instance_create_depth(0,0,depth,o_GridManager);
instance_create_depth(0,0,depth-100,o_UIManager);
instance_create_depth(0,0,depth,o_Transition);
room_change(r_1);

enable_input = function(){
	global.input_enabled = true;
}


room_reset = function(_dur = FADE_TO_DUR,_color = FADE_COLOR,_wait = 60){
#region Room Reset
	o_PauseManager.pause_start();
	global.input_enabled = false;
	// Pass room to o_Transition and start fade
	o_Transition.room_to = room;
	o_Transition.fade_to(_dur,_color,_wait);
#endregion
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
		key_pause = keyboard_check_pressed(vk_escape);
		if (key_pause) o_PauseManager.pause_toggle();
	}
	if (debug_mode)
	{
		key_restart = keyboard_check_pressed(ord("R"));
		if (key_restart) game_restart();
	}
}