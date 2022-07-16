enum UPGRADE_STATE
{
	ON,
	OFF
}

enum U_A1
{
	HEALTH,
	SPEED,
	DAMAGE,
	RATE,
	HAT,
	TORSO,
	SFX
}
enum U_A2
{
	TEXT,
	VALUE
}

upgrade_array = [];
upgrade_array[U_A1.HEALTH][U_A2.TEXT] = "HEALTH";
upgrade_array[U_A1.SPEED][U_A2.TEXT] = "SPEED";
upgrade_array[U_A1.DAMAGE][U_A2.TEXT] = "DAMAGE";
upgrade_array[U_A1.RATE][U_A2.TEXT] = "FIRE\nRATE";
upgrade_array[U_A1.HAT][U_A2.TEXT] = "HAT";
upgrade_array[U_A1.TORSO][U_A2.TEXT] = "TORSO";
upgrade_array[U_A1.SFX][U_A2.TEXT] = "SFX";
	upgrade_array[U_A1.HEALTH][U_A2.VALUE] = 1;
	upgrade_array[U_A1.SPEED][U_A2.VALUE] = 1;
	upgrade_array[U_A1.DAMAGE][U_A2.VALUE] = 1;
	upgrade_array[U_A1.RATE][U_A2.VALUE] = 1;
	upgrade_array[U_A1.HAT][U_A2.VALUE] = 1;
	upgrade_array[U_A1.TORSO][U_A2.VALUE] = 1;
	upgrade_array[U_A1.SFX][U_A2.VALUE] = 1;
a_size = array_length(upgrade_array);
array_font = f_Pixel;

#region Menu
state = UPGRADE_STATE.OFF;
draw_alpha = 0;
alpha_accel = 0.05;
menu_width = GAME_WIDTH;
menu_height = GAME_HEIGHT;
menu_color = col_grey4;
menu_padx = UNIT*2;
menu_spacex = (menu_width - (menu_padx*2)) / (a_size-1);
menu_texty = menu_height - (UNIT*3);
dice_holey = menu_height - (UNIT*2);
#endregion


upgrade_start = function(){
	state = UPGRADE_STATE.ON;
}

upgrade_end = function(){
	state = UPGRADE_STATE.OFF;
}

upgrade_get_value = function(_attribute){
	return upgrade_array[_attribute][U_A2.VALUE];
}

draw_menu_bg = function(){
	draw_set_alpha(draw_alpha);
	draw_set_color(menu_color);
	draw_rectangle(0,0,menu_width,menu_height,false);
	draw_set_alpha(1);
}

draw_array = function(){
#region
	draw_set_alpha(draw_alpha);
	draw_set_color(col_white);
	draw_set_font(array_font);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	for (var _i = 0; _i < a_size; _i+=1)
	{
		var _string = upgrade_array[_i][U_A2.TEXT];
		var _x = menu_padx + (_i * menu_spacex);
		draw_text(_x,menu_texty,_string);
		draw_sprite(s_DiceHole,0,_x,dice_holey);
	}
	draw_set_alpha(1);
#endregion
}

perform_step = function(){
	switch (state)
	{
		case UPGRADE_STATE.ON:
			draw_alpha = lerp(draw_alpha,1,alpha_accel);
		break;
		
		case UPGRADE_STATE.OFF:
			draw_alpha = lerp(draw_alpha,0,alpha_accel);
		break;
	}
}