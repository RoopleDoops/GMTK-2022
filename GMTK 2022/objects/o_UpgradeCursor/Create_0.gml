

// Get input
key_click = 0;
held_dice = noone;

get_input = function(){
	key_click = mouse_check_button(mb_left);
	
	x = floor(mouse_x);
	y = floor(mouse_y);
}

perform_step = function(){
	get_input();
	
	
	if (key_click)
	{
		if (held_dice == noone)
		{
			var _dice = instance_place(x,y,o_Dice);
			if (_dice != noone)
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
}