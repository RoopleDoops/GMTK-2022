function room_initialize(){
	instance_create_depth(0,0,-16000,o_DebugManager);
	instance_create_depth(0,0,-16000,o_PauseManager);
	instance_create_depth(0,0,-16000,o_GridManager);
	room_change(r_1);
}