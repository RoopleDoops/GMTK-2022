// Draw hand
if (hand_behind) draw_sprite_ext(hand_sprite,0,hand_x,hand_y,1,image_xscale,hand_angle,image_blend,image_alpha);
scale_draw(scale_struct,x,y);
// Draw hand
if (!hand_behind) draw_sprite_ext(hand_sprite,0,hand_x,hand_y,1,image_xscale,hand_angle,image_blend,image_alpha);
debug_draw();

// Stat Draw
