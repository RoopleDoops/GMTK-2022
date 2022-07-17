scale_draw_ext(scale_struct,astruct_body.anim_sprite,astruct_body.anim_index,x,y,draw_scalex,draw_scaley,image_angle,image_blend,image_alpha);
// Draw hat
scale_draw_ext(scale_struct,hat_sprite,astruct_body.anim_index,x,y,draw_scalex,draw_scaley,image_angle,image_blend,image_alpha);
// Draw boots
scale_draw_ext(scale_struct,boot_sprite,astruct_body.anim_index,x,y,draw_scalex,draw_scaley,image_angle,image_blend,image_alpha);
// Draw hand
draw_sprite_ext(hand_sprite,0,hand_x,hand_y,draw_scalex,draw_scaley,0,image_blend,image_alpha);