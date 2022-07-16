event_inherited();


movement_create();
scale_struct = scale_create();
squash_scale(scale_struct,0.5,1.5);


perform_step = function(){
	
	// Drawing
	scale_step(scale_struct,SCALE_SLOW);
	depth = -y;
}

