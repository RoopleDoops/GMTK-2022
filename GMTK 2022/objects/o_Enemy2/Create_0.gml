event_inherited();
pushable = false;
change_sprite = s_Enemy2Hit;
friendly_sprite = s_Friendly2;
move_speed_base = UNIT/20;
move_speed = move_speed_base;
charge_speed = UNIT/10;
charge_time_max = 300;

collision_enemy_x = function(_x_move){
	var _list = ds_list_create();
	var _num = instance_place_list(x+_x_move,y,o_Enemy,_list,false);
	for (var _i = 0; _i < _num; _i += 1)
	{
		var _enemy = _list[| _i];
		var _pushdir = point_direction(x,y,_enemy.x,_enemy.y);
		var _pushforce = _x_move;
		with (_enemy)
		{
			if (pushable) x_knock += lengthdir_x(_pushforce,_pushdir);
		}
	}
	ds_list_destroy(_list);
	return _x_move;
}

collision_enemy_y = function(_y_move){
	var _list = ds_list_create();
	var _num = instance_place_list(x,y+_y_move,o_Enemy,_list,false);
	for (var _i = 0; _i < _num; _i += 1)
	{
		var _enemy = _list[| _i];
		var _pushdir = point_direction(x,y,_enemy.x,_enemy.y);
		var _pushforce = _y_move;
		with (_enemy)
		{
			if (pushable) y_knock += lengthdir_y(_pushforce,_pushdir);
		}
	}
	ds_list_destroy(_list);
	return _y_move;
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