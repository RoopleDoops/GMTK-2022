

// Get input
key_click = 0;
key_clicked = 0;
held_dice = noone;

get_input = function(){
	key_click = mouse_check_button(mb_left);
	key_clicked = mouse_check_button_released(mb_left);
	
	x = round(mouse_x);
	y = round(mouse_y);
}

perform_step = function(){
	get_input();
	
	
	if (key_click)
	{
		if (held_dice == noone)
		{
			var _dice = instance_place(x,y,o_Dice);
			if (_dice != noone) && (_dice.state != DICE_STATE.LOCKED)
			{
				held_dice = _dice;
				held_dice.dice_pickup();
			}
		}
	}
	else if (held_dice != noone)
	{
		held_dice.dice_drop();
		held_dice = noone;
	}
	else if (key_clicked)
	{
		var _button = o_UpgradeManager.collision_button(x,y);
		if (_button)
		{
			o_UpgradeManager.roll_dice();
		}
	}
}