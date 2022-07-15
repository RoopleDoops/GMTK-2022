#macro UNIT 32
#macro GAME_WIDTH 480
#macro GAME_HEIGHT 270
#macro TERM_VELOC UNIT

enum AXIS
{
	X,
	Y
}

#macro LAYER_WALL_TILES "L_TileWall"


// Depth
#macro DEPTH_CURSOR -15000


// BBOX
#macro BBOX_CENTER floor((bbox_left+bbox_right)/2)
#macro BBOX_MIDDLE floor((bbox_top+bbox_bottom)/2)