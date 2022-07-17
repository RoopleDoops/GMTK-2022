perform_step = function(){
	if (global.input_enabled) && ((keyboard_check_pressed(vk_anykey)) || (mouse_check_button_pressed(mb_any)))
	{
		room_change(r_Upgrade);
	}
}