global.input_enabled = true;
if (debug_mode) global.level_start = 2;
else global.level_start = 2;
global.level = global.level_start;
global.level_limit = 7;
global.dice_num = global.level_start;
global.pause = false;
global.grid = 0;
global.db_draw = false;
global.db_path = false;
global.draw_ui = false;

display_set_gui_size(GAME_WIDTH,GAME_HEIGHT);
window_set_size(GAME_WIDTH*2,GAME_HEIGHT*2);

randomize();

window_set_fullscreen(true);

#macro START_ROOM r_Title