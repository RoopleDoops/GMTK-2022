if (shader_time > 0) shader_draw_color_flash();
// Draw hand
if (hand_behind) draw_sprite_ext(hand_sprite,0,hand_x,hand_y,1,image_xscale,hand_angle,image_blend,alpha);
scale_draw_ext(scale_struct,sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,alpha);
// Draw hand
if (!hand_behind) draw_sprite_ext(hand_sprite,0,hand_x,hand_y,1,image_xscale,hand_angle,image_blend,alpha);
if (shader_time > 0) shader_reset();
debug_draw();

// Stat Draw
