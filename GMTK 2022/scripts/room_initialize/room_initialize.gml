function room_initialize(){
	with (o_GridManager)
	{
		grid_create();
		grid_update();
	}
	var _name = room_get_name(room);
	var _prefix = string_char_at(_name,3);
	if (_prefix == "L")
	{
			instance_create_depth(0,0,0,o_EnemyManager);
			var _tmap = layer_tilemap_get_id(LAYER_WALL_TILES);
			var _w = tilemap_get_width(_tmap);
			var _h = tilemap_get_height(_tmap);
			for (var _ix = 0; _ix < _w; _ix += 1)
			{
				for (var _iy = 0; _iy < _h; _iy += 1)
				{
					var _tile = tilemap_get(_tmap,_ix,_iy);
					var _tindex = tile_get_index(_tile);
					// If tile is bush, randomly assign new index of other bushes
					if (_tindex == 1)
					{
						var _rand = irandom(5) + 1;
						var _newtile = tile_set_index(_tile,_rand);
						tilemap_set(_tmap, _newtile,_ix,_iy);
					}
				}
			}
	}
}