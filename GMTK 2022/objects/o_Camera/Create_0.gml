#macro SCREEN_SHAKE o_Camera.camera_screen_shake(15,1)

movement_create();

xTo = x;
yTo = y;

cam = view_camera[0];
camera_set_view_size(cam,GAME_WIDTH,GAME_HEIGHT);
cam_width = view_get_wport(cam);
cam_height = view_get_hport(cam);

cam_x_half = camera_get_view_width(cam)/2;
cam_y_half = camera_get_view_height(cam)/2;

cam_x_buffer = 32;
cam_y_buffer = 32;

shake_x = 0;
shake_y = 0;
shake_power = 0;
shake_time = 0;
shake_freq = 0;
shake_freq_max = 2;

follow = o_Player;
move_accel = 0.05;

camera_snap = function(){
	if (instance_exists(follow))
	{
		var _px = follow.x;
		var _py = follow.y;
		x = _px;
		y = _py;
		xTo = x;
		yTo = y;
	}
}

camera_screen_shake = function(_dur,_power){
	shake_time = _dur;
	shake_power = _power;
}

perform_step = function(){
	if (shake_time > 0) 
	{
		shake_time -= 1;
		if (shake_freq > 0) shake_freq -= 1;
		else
		{
			shake_freq = shake_freq_max;
			if (shake_x == 0) shake_x = choose(-shake_power,shake_power);
			else shake_x = -shake_x;
			if (shake_y == 0) shake_y = choose(-shake_power,shake_power);
			else shake_y = -shake_y;
		}
	}
	if (shake_time == 0) {shake_x = 0; shake_y = 0; shake_power = 0;}
	
	if (instance_exists(follow))
	{
		// Must round these or camera will lerp back and forth between one pixel when near target
		xTo = round(((follow.x*2) + o_Cursor.x)/3);
		yTo = round(((follow.y*2) + o_Cursor.y)/3);
		x_move = lerp(x,xTo,move_accel)-x;
		y_move = lerp(y,yTo,move_accel)-y;
	}
	
	x_move = clamp(x_move+x_knock,-TERM_VELOC,TERM_VELOC);
	x_move_bank += x_move;
	var _x_move = sign(x_move_bank) * abs(floor(x_move_bank));
	x_move_bank -= _x_move;
	x_knock = 0;
	
	y_move = clamp(y_move+y_knock,-TERM_VELOC,TERM_VELOC);
	y_move_bank += y_move;
	var _y_move = sign(y_move_bank) * abs(floor(y_move_bank));
	y_move_bank -= _y_move;
	y_knock = 0;
	
	x = x + _x_move;
	y = y + _y_move;
	
	x = clamp(x,0,room_width) + shake_x;
	y = clamp(y,0,room_height)  + shake_y;
	
	
	#region Old camera
	//if (instance_exists(follow))
	//{
	//	xTo = ((follow.x*2) + mouse_x)/3;
	//	yTo = ((follow.y*2) + mouse_y)/3;
	//}
	
	//x = lerp(x,xTo,move_accel)+shake_x;
	//y = lerp(y,yTo,move_accel)+shake_y;
	#endregion
	
	camera_set_view_pos(cam,round(x-cam_x_half),round(y-cam_y_half));
}