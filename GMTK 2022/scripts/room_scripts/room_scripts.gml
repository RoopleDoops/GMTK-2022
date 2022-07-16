function room_change(_room = room_next(room)){
	o_UIManager.hide_ui();
	o_PauseManager.pause_start();
	global.input_enabled = false;
	// Pass room to o_Transition and start fade
	o_Transition.room_to = _room;
	o_Transition.fade_to();
}