cam = view_camera[0];
camera_set_view_size(cam,GAME_WIDTH,GAME_HEIGHT);
cam_width = view_get_wport(cam);
cam_height = view_get_hport(cam);

cam_x_half = camera_get_view_width(cam)/2;
cam_y_half = camera_get_view_height(cam)/2;

follow = o_Player;
move_accel = 0.1;

camera_snap = function(){
	x = follow.x;
	y = follow.y;
}

perform_step = function(){
	var _px = x;
	var _py = y;
	if (instance_exists(follow))
	{
		_px = follow.x;
		_py = follow.y;
	}
	
	x = lerp(x,_px,move_accel);
	y = lerp(y,_py,move_accel);
	
	camera_set_view_pos(cam,x-cam_x_half,y-cam_y_half);
}