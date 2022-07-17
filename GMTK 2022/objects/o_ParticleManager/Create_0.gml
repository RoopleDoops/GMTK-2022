#macro PARTICLE_CONFETTI o_ParticleManager.

part_sys = part_system_create();
part_system_depth(part_sys,-10000);

part_confetti = part_type_create();
var _part = part_confetti;
	part_type_shape(_part,pt_shape_pixel);
	part_type_color1(_part,c_white);
	part_type_alpha2(_part,1,0);
	part_type_direction(_part,0,359,0,0);
	part_type_speed(_part,1,1,-.001,0);
	part_type_life(_part,100,100);
	
//get_a_color = function(){
//	var _rand = irandom(
//	return col_red1;
//	return col_blue1;
//	return col_green1;
//	return col_yellow1;
//	return col_purple1;
//}

//make_confetti = function(){
//	var _num = 64;
//	for (var _i = 0; _i < _num; _i += 1)
//	{
		
//	}
	
//}