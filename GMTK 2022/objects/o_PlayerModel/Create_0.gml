scale_struct = scale_create();
hat_sprite = o_UpgradeManager.get_hat_sprite();
astruct_body = animate_create(o_UpgradeManager.get_body_sprite());
dir = 0;

depth = -500;
hand_dist_x = UNIT*0.25;
hand_dist_y = UNIT*0.25;
hand_sprite = s_Hand01;
hand_yoffset = -4;
hand_x = floor(x+16);
hand_y = floor(BBOX_MIDDLE-16);
boot_sprite = s_Boot01;

draw_scalex = 2;
draw_scaley = 2;

perform_step = function(){
	animate_step(astruct_body);
	scale_step(scale_struct,SCALE_MED);	
}