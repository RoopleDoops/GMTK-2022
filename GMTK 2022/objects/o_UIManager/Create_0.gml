enum HP_A
{
	DRAW,
	LIFE
}

offset_x = UNIT/4;
offset_y = UNIT/4;
space_x = UNIT/2;
hp_max = 6;
hp = hp_max;
// Initialize health array
health_array = [];
for (var _i = 0; _i < hp_max; _i += 1)
{
	health_array[_i] = _i;
}
health_sprite = s_UIHealth

update_health_array = function(){
	var _size = array_length(health_array);
	for (var _i = 0; _i < _size; _i += 1)
	{
		health_array[_i] = _i;
		if (_i <= hp_max) health_array[_i][HP_A.DRAW] = true;
		else health_array[_i][HP_A.DRAW] = false;
		if (_i <= hp-1) health_array[_i][HP_A.LIFE] = 0;
		else health_array[_i][HP_A.LIFE] = 1;
	}
}
// Initialize
update_health_array();

update_health = function(){
	// Get player health
	hp_max = o_Player.hp_max;
	hp = o_Player.hp;
	update_health_array();
}

draw_health = function(){
	var _size = array_length(health_array);
	for (var _i = 0; _i < _size; _i += 1)
	{
		if (health_array[_i][HP_A.DRAW])
		{
			var _x = offset_x + (_i*space_x);
			var _y = offset_y;
			draw_sprite_ext(health_sprite,health_array[_i][HP_A.LIFE],_x,_y,1,1,0,image_blend,image_alpha);
			show_debug_message("Drawing UI Health at: "+string(_x)+", "+string(_y));
		}
	}
}



perform_step = function(){
	
}