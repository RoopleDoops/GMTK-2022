perform_step = function(){
	if (global.input_enabled) && (mouse_check_button_pressed(mb_any))
	{
		room_change(r_Upgrade);
	}
}