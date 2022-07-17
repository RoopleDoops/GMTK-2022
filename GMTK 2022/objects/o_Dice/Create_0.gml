enum DICE_STATE
{
	HELD,
	SLOTTED,
	IDLE,
	LOCKED
}

scale_struct = scale_create();
state = DICE_STATE.IDLE;
slot = -1;
depth = -500;
start_depth = depth;

dice_pickup = function(){
	if (state == DICE_STATE.SLOTTED)
	{
		o_UpgradeManager.update_slot_filled(slot,false);
		slot = -1;	
	}
	squash_scale(scale_struct,1.25,1.25);
	state = DICE_STATE.HELD;
	depth = -1000;
}

dice_drop = function(){
	var _bl = bbox_left;
	var _bt = bbox_top;
	var _br = bbox_right;
	var _bb = bbox_bottom;
	var _bb = bbox_bottom;
	var _slot = o_UpgradeManager.collision_slot_array(_bl,_bt,_br,_bb);
	if (_slot != -1)
	{
		slot = _slot;
		x = o_UpgradeManager.get_slot_x(slot);
		y = o_UpgradeManager.get_slot_y(slot);
		o_UpgradeManager.fill_slot(_slot,id);
		state = DICE_STATE.SLOTTED;
		depth = start_depth;
	}
	else
	{
		state = DICE_STATE.IDLE;
		depth = start_depth;
	}
	squash_scale(scale_struct,0.75,0.75);
}

dice_lock = function(){
	state = DICE_STATE.LOCKED;
	squash_scale(scale_struct,1.25,1.25);	
	animate_unpause(anim_struct);
}

dice_emphasize = function(){
	animate_pause(anim_struct);
	squash_scale(scale_struct,1.5,1.5);	
}

anim_struct = animate_create(sprite_index);
animate_pause(anim_struct);

perform_step = function(){
	scale_step(scale_struct,SCALE_MED);
	animate_step(anim_struct);
	if(animate_frame_end_check(anim_struct))
	{
		anim_struct.anim_index = irandom(anim_struct.anim_image_num-1);
	}
	
	switch (state)
	{
		case DICE_STATE.IDLE:
			x = xstart;
			y = ystart;
		break;
		
		case DICE_STATE.HELD:
			x = o_UpgradeCursor.x;
			y = o_UpgradeCursor.y;
		break;
		
		case DICE_STATE.SLOTTED:
		break;
	}
}