perform_step = function(){
	if (global.input_enabled) && (keyboard_check_pressed(vk_anykey))
	{
		room_change(r_Upgrade);
	}
}