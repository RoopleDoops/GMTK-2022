movement_create();
move_speed = 2;
move_hori = 0;
move_vert = 0;
move_accel = 0.05;

// Input
	key_left = 0;
	key_right = 0;
	key_up = 0;
	key_down = 0;
	key_shoot = 0;

get_input = function(){
	key_left = keyboard_check_direct(ord("A"));
	key_right = keyboard_check_direct(ord("D"));
	key_up = keyboard_check_direct(ord("W"));
	key_down = keyboard_check_direct(ord("S"));
	
	move_hori = key_right - key_left;
	move_vert = key_down - key_up;
}

perform_step = function(){
	get_input();
	
	#region movement
	x_move = lerp(x_move,move_hori*move_speed,move_accel);
	y_move = lerp(y_move,move_vert*move_speed,move_accel);
	
	var _array = movement_calculate();
	
	// Collision
	
	x += _array[AXIS.X];
	y += _array[AXIS.Y];
	#endregion
}