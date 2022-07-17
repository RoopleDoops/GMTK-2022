event_inherited();

movement_create();
scale_struct = scale_create();
squash_scale(scale_struct,0.5,1.5);

sprite_setup = function(_change,_friendly){
	change_sprite = _change;
	friendly_sprite = _friendly;
	anim_struct = animate_create(change_sprite);
}


perform_step = function(){
	if (anim_struct.anim_sprite == change_sprite) && (animate_end_check(anim_struct))
	{
		animate_set_sprite(anim_struct,friendly_sprite);
	}
	// Drawing
	animate_step(anim_struct);
	scale_step(scale_struct,SCALE_SLOW);
	depth = -y;
}

