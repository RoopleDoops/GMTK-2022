function room_initialize(){
	instance_create_depth(0,0,-16000,o_DebugManager);
	instance_create_depth(0,0,-16000,o_PauseManager);
	room_goto(r_1);
}