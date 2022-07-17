event_inherited();
change_sprite = s_Enemy2Hit;
friendly_sprite = s_Friendly2;
move_speed_base = UNIT/20;
move_speed = move_speed_base;
charge_speed = UNIT/10;
charge_time_max = 300;

collision_enemy_x = function(_x_move){
	if (place_meeting(x+_x_move,y,o_Enemy)) { x_move = 0; wall_hit(); return 0;}
	else return _x_move;
}

collision_enemy_y = function(_y_move){
	if (place_meeting(x,y+_y_move,o_Enemy)) { y_move = 0; wall_hit(); return 0;}
	else return _y_move;
}

wall_hit = function(){
	if (state == E_STATE.CHARGE) 
	{
		x_move = -x_move*0.75;
		y_move = -y_move *0.75;
		next_state(E_STATE.RECOIL);
	}
	else squash_scale(scale_struct,1.1,0.9);
}

player_in_sights = function(_x,_y,_px,_py){
	dir = point_direction(_x,_y,_px,_py);
	next_state(E_STATE.CHARGE);
}