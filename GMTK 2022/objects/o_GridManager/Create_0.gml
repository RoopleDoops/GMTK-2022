grid_size = UNIT;
grid_width = 0;
grid_height = 0;
new_grid = false;

grid_create = function(){
	mp_grid_destroy(global.grid);
	grid_width = room_width/grid_size;
	grid_height = room_height/grid_size;
	global.grid = mp_grid_create(0,0,grid_width,grid_height,grid_size,grid_size);
}

grid_update = function(){
	for (var _ix = 0; _ix < grid_width; _ix += 1)
	{
		for (var _iy = 0; _iy < grid_height; _iy += 1)
		{
			var _tmap = layer_tilemap_get_id(LAYER_WALL_TILES);
			if (!tile_passable(_tmap,_ix,_iy)) mp_grid_add_cell(global.grid,_ix,_iy);
		}
	}
}

perform_step = function(){

	if (new_grid)
	{
		grid_create();
		grid_update();
		new_grid = false;
	}
}