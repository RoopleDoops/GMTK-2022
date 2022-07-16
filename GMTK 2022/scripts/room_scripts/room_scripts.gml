function room_change(_room = room_next(room)){
	room_goto(_room);
	o_Controller.new_room= true;
}