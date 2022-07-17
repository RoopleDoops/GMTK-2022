global.input_enabled = true;
global.level = 2;
global.pause = false;
global.grid = 0;
global.db_draw = false;
global.db_path = false;
global.draw_ui = false;

display_set_gui_size(GAME_WIDTH,GAME_HEIGHT);
window_set_size(GAME_WIDTH*2,GAME_HEIGHT*2);

randomize();

#macro START_ROOM r_L5