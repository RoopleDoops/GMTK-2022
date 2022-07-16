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

perform_step = function(){
	if (instance_exists(follow))
	{
		//if (x < follow.x - cam_x_buffer) xTo = follow.x-cam_x_buffer;
		//else if (x > follow.x + cam_x_buffer) xTo = follow.x+cam_x_buffer;
		//if (y < follow.y - cam_y_buffer) yTo = follow.y-cam_y_buffer;
		//else if (y > follow.y + cam_y_buffer) yTo = follow.y+cam_y_buffer;
		xTo = ((follow.x*3) + mouse_x)/4;
		yTo = ((follow.y*3) + mouse_y)/4;
	}
	
	x = lerp(x,xTo,move_accel);
	y = lerp(y,yTo,move_accel);
	
	
	camera_set_view_pos(cam,x-cam_x_half,y-cam_y_half);
}