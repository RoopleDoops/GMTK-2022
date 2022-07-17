

part_sys = part_system_create();
part_system_depth(part_sys,-10000);

part_confetti = part_type_create();
var _part = part_confetti;
	part_type_shape(_part,pt_shape_pixel);
	part_type_size(_part,2,2,0,0);
	part_type_color1(_part,c_white);
	part_type_alpha3(_part,1,1,0);
	part_type_direction(_part,0,359,0,0);
	part_type_speed(_part,1,1,-.001,0);
	part_type_life(_part,100,100);
	
part_sparkle = part_type_create();
var _part = part_sparkle;
	part_type_shape(_part,pt_shape_pixel);
	part_type_size(_part,2,2,0,0);
	part_type_color1(_part,col_yellow1);
	part_type_alpha3(_part,1,1,0);
	part_type_direction(_part,0,359,0,0);
	part_type_speed(_part,2,2,-.004,0);
	part_type_life(_part,50,50);
	
get_a_color = function(){
	var _rand = irandom(4);
	switch (_rand)
	{
		case 0: return col_red1; break;
		case 1: return col_blue1; break;
		case 2: return col_green1; break;
		case 3: return col_yellow1; break;
		case 4: return col_purple1; break;
	}
}

make_sparkle = function(_x,_y)
{
	var _num = 16;
	part_particles_create(part_sys,_x,_y,part_sparkle,_num);
}

make_confetti = function(){
	if (instance_exists(o_Player))
	{
		var _x = o_Player.x;
		var _y = o_Player.y;
	}
	else
	{
		var _x = 0;
		var _y = 0;
	}
	var _num = 32;
	for (var _i = 0; _i < _num; _i += 1)
	{
		part_type_color1(part_confetti,get_a_color());
		part_particles_create(part_sys,_x-32,_y,part_confetti,1);
		part_particles_create(part_sys,_x+32,_y,part_confetti,1);
		part_particles_create(part_sys,_x,_y-32,part_confetti,1);
		part_particles_create(part_sys,_x,_y+32,part_confetti,1);
	}
}