///// Things to improve
////////////////////////
/* There is no need for all the array_length code to be in the draw step.
Plan a better and more universal list update function (see how passing arrays in works)
and set those variables during the update function.

*/


if (!debug_mode) {instance_destroy();exit;}

enum DB_MENU{
	NONE,
	MENU,
	ROOM,
	PARTICLE,
	PARTICLE_VARIABLE,
	PARTICLE_VALUE,
	TARGET,
	VARIABLE,
	VALUE
}

menu_list = ["Room Change", "Modify Particles", "Modify Object", "Exit"];
menu_input_prev = noone;

debug_key = false;
debug_enter_key = false;
debug_prev_key = false;

debug_input = false; // indicates debug is taking input
menu_state = DB_MENU.MENU; // state machine
//
particle_string_prefix = "part_"; // change according to how particles are named
particle_list = [];
particle_list_sort = [];
particle = noone;
particle_input_prev = noone;
//
particle_variable_list = ["Size","Speed","Direction","Gravity","Orientation","Life"];
//
object_list = [];
object_list_sort = [];
//
target = noone;
target_input_prev = noone;
//
var_list = [];
var_list_sort = [];
variable = noone;
variable_input_prev = noone;
variable_type = noone;
variable_current_value = noone;
//
value = noone;
list_selection = 0; // moves selection in array
update_list = true;

#region Drawing
	window_x = 0;
	window_width = view_get_wport(view_current); 
	window_height = GAME_HEIGHT/2;
	window_y = GAME_HEIGHT - window_height;
	window_color = make_color_rgb(38,36,58);//col_grey5;
	window_alpha = 0.75;
	edge_height = 16;
	edge_color = c_white;
	edge_alpha = 1;

	// Text
		text_xoffset = 32;
		text_yoffset = 32;
		// List
		text_list_x = window_x + window_width - text_xoffset;
		text_list_y = window_y + text_yoffset;
		list_limit = 3;
		// Target
		text_msg_x = window_x + text_xoffset;
		text_msg_y = window_y + text_yoffset;
		// Variable
		text_variable_x = window_x + text_xoffset;
		text_variable_y = window_y + (text_yoffset*2);
		// Value
		text_value_x = window_x + text_xoffset;
		text_value_y = window_y + (text_yoffset*3);
		// Input
		text_input_xoffset = 32;
		text_input_y = window_y + window_height - text_yoffset;
		current_input = "";
		target_input = "";
		variable_input = "";
		value_input = "";
	
	text_color = c_white;
	text_color_base = c_white;
	text_color_error = make_color_rgb(196,44,54);//col_red3;
	text_alpha = 1;
	text_font = f_Pixel;
	text_no_value_msg = "Enter a value for the variable.";

	// Selection
	draw_set_font(text_font);
	selection_height = string_height(text_no_value_msg);
	selection_width = 160;
	selection_alpha = 0.25;
	selection_color = make_color_rgb(163,172,190);//col_grey1;
#endregion Drawing

// Timers
error_time = 0;
error_time_max = 15;


list_sort_update = function(_array,_array_sort){
	#region
	_array_sort = [];
	var _length = array_length(_array);
	var _inputlength = string_length(current_input);
	if (_inputlength > 0)
	{
		for (var _i = 0; _i < _length; _i += 1)
		{
			// MUST BE <= since string_char starts at 1
			for (var _ic = 0; _ic <= _inputlength; _ic += 1)
			{
				var _ichar = string_char_at(current_input,_ic);
				var _vchar = string_char_at(_array[_i],_ic);
				// If string matches (not case sensitive)
				if (string_lower(_ichar) == string_lower(_vchar))
				{
					if (_ic == _inputlength) array_push(_array_sort,_array[_i]);
				}
				else break;
			}
		}
		array_sort(_array_sort,true);
	}
	else _array_sort = _array;
	
	return _array_sort;
	#endregion
}

get_room_list = function(){
#region
	room_list = [];
	room_list_sort = [];
	var _roomid = room_first;
	while (true)
	{
		if (room_exists(_roomid))
		{
			// Do not include first room (treated as initialization room)
			if (_roomid != room_first)
			{
				var _roomname = room_get_name(_roomid);
				array_push(room_list,_roomname);
			}
		}
		else dbm("Room does not exist");
		if (_roomid == room_last) break;
		else _roomid = room_next(_roomid);
	}
	array_sort(room_list,true);
#endregion
}
// Run function
get_room_list();

get_particle_list = function(){
#region
	// Get list of all globals
	var _globalvar_array = variable_instance_get_names(global);
	// Add entries with matching prefix to particle_list
	var _length = array_length(_globalvar_array);
	for (var _i = 0; _i < _length; _i += 1)
	{
		var _varname = _globalvar_array[_i];
		var _prefix_length = string_length(particle_string_prefix);
		var _stringcheck = string_copy(_varname,1,_prefix_length);
		if (_stringcheck == particle_string_prefix) array_push(particle_list,_varname);
	}
	// Sort list
	particle_list_sort = array_sort(particle_list,true);	
#endregion	
}
// Run function
get_particle_list();

draw_list_options = function(_array){
#region
	// Draw object list
	var _alength = array_length(_array);
	var _selection = (list_selection div list_limit) * list_limit;
	if (_alength > 0)
	{
		// Draw selection bar
		var _yoff = (list_selection mod list_limit) * text_yoffset;
		draw_set_color(selection_color);
		draw_set_alpha(selection_alpha);
		draw_rectangle(text_list_x,text_list_y+_yoff,text_list_x-selection_width,text_list_y+_yoff+selection_height,false);
		// Draw text
		draw_set_alpha(text_alpha*0.9);
		draw_set_halign(fa_right);
		var _limit = min(_alength-_selection,list_limit);
		for (var _i = 0; _i < _limit; _i += 1)
		{
			var _pos = (list_selection div list_limit) * list_limit + _i;
			_pos = clamp(_pos,0,max(0,_alength - 1));
			draw_text(text_list_x,text_list_y + (_i * text_yoffset),_array[_pos]);
		}	
	}
#endregion
}

draw_selection_list = function(){
#region
	switch (menu_state)
	{
		case DB_MENU.MENU:
			draw_list_options(menu_list);
		break;
		
			case DB_MENU.ROOM:
				draw_list_options(room_list_sort);
			break;
			
			case DB_MENU.PARTICLE:
				draw_list_options(particle_list_sort);
			break;
			
			case DB_MENU.PARTICLE_VARIABLE:
				draw_list_options(particle_variable_list);
			break;
			
			case DB_MENU.PARTICLE_VALUE:
			break;
		
			case DB_MENU.TARGET:
					draw_list_options(object_list_sort);
				break;
				case DB_MENU.VARIABLE:
					draw_list_options(var_list_sort);
				break;
	}
#endregion
}

draw_display_text = function(){
#region
	draw_set_alpha(text_alpha);
	draw_set_color(text_color);
	draw_set_font(text_font);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var _text = "";
	// Determine text to draw based on menu state
	switch (menu_state)
	{
		// Main Menu
		case DB_MENU.MENU:
			_text = "Select a command and press ENTER.";
		break;
		
			// Room Menu
			case DB_MENU.ROOM:
				_text = "Select a destination room.";
			break;
			
			// Particle Modify Menu
			case DB_MENU.PARTICLE:
				_text = "Select a particle.";
			break;
		
			// Object Modify Menu
			case DB_MENU.TARGET:
				_text = "Select an object.";
			break;
				// Variable Selection Menu
				case DB_MENU.VARIABLE:
					_text = "TARGET: " + string(target_input);
					draw_text(text_variable_x,text_variable_y,"Select a variable.");
				break;
					// Value Entry
					case DB_MENU.VALUE:
						_text = "TARGET: " + string(target_input);
						// Draw variable
							draw_text(text_variable_x,text_variable_y,"VARIABLE: " + string(variable_input) +
							" | VALUE: " + string(variable_current_value) + " | TYPE: " + string(variable_type));
						// Draw value
							if (value != noone) draw_text(text_value_x,text_value_y,"VALUE UPDATED: " + string(value_input));
							else draw_text(text_value_x,text_value_y,text_no_value_msg);
					break;
	}
	// Draw text
	draw_text(text_msg_x,text_msg_y,_text);
#endregion
}

get_input = function(){
#region
	var _lastkey = keyboard_lastchar;
	if (ord(_lastkey) == ord("`")) 
	{
		debug_key = true;
		keyboard_lastchar = "";
	}
	else debug_key = false;
	debug_enter_key = keyboard_check_pressed(vk_enter);
	debug_key_up = keyboard_check_pressed(vk_up);
	debug_key_down = keyboard_check_pressed(vk_down);
	debug_prev_key = keyboard_check_pressed(vk_left);
#endregion
}

get_prev_input = function(){
#region
	clear_keyboard_input();
	switch (menu_state)
	{
		case DB_MENU.MENU:
			list_selection = menu_input_prev;
		break;
		case DB_MENU.PARTICLE:
			keyboard_string = particle_input_prev;
		break;
		case DB_MENU.TARGET:
			keyboard_string = target_input_prev;
		break;
		case DB_MENU.VARIABLE:
			keyboard_string = variable_input_prev;
		break;
	}
#endregion
}

get_active_objects = function(){
#region Retrieve list of active objects in the room
	object_list = [];
	var _length = instance_count;
	for (var _i = 0; _i < _length; _i += 1)
	{
		var _inst = instance_id[_i];
		var _obj = object_get_name(_inst.object_index);
		// Check that object is not already listed
		var _listlength = array_length(object_list);
		var _duplicate = false;
		for (var _il = 0; _il < _listlength; _il += 1)
		{
			if (_obj == object_list[_il]) 
			{
				_duplicate = true;
				break;
			}
		}
		// Add if not listed yet
		if (!_duplicate) array_push(object_list,_obj);
	}
	array_sort(object_list,true);
#endregion
}

debug_start = function(){
#region Open Debug window
	o_PauseManager.pause_start();
	debug_input = true;
	debug_reset();
	get_active_objects();
#endregion
}

debug_end = function(){
#region Close Debug window
	// unpausing first ensures input can be reenabled.
	o_PauseManager.pause_end();
	debug_input = false;
	debug_reset();
#endregion
}

debug_reset = function(){
#region Reset window--menu state, input, etc.
	clear_keyboard_input();
	menu_state = DB_MENU.MENU;
	particle = noone;
	object_list = [];
	target = noone;
	var_list = [];
	var_list_sort = [];
	variable = noone;
	variable_current_value = noone;
	variable_type = noone;
	value = noone;
	list_selection = 0;
	update_list = true;
#endregion
}

selection_update = function(){
#region Move selector based on menu length and input
	switch (menu_state)
	{
		case DB_MENU.MENU:
			var _limit = array_length(menu_list)-1;
		break;
		case DB_MENU.ROOM:
			var _limit = array_length(room_list_sort)-1;
		break;
		case DB_MENU.PARTICLE:
			var _limit = array_length(particle_list_sort)-1;
		break;
		case DB_MENU.PARTICLE_VARIABLE:
			var _limit = array_length(particle_variable_list)-1;
		break;
		case DB_MENU.TARGET:
			var _limit = array_length(object_list_sort)-1;
		break;
		case DB_MENU.VARIABLE:
			var _limit = array_length(var_list_sort)-1;
		break;
		default:
			var _limit = 0;
		break;
	}
	if (debug_key_down) list_selection += 1;
	else if (debug_key_up) list_selection -= 1;
	if (list_selection > _limit) list_selection = 0;
	else if (list_selection < 0) list_selection = _limit;
#endregion
}

add_default_variables = function(){
#region Add built-in variables to variable list
	array_push(var_list,"x");
	array_push(var_list,"y");
	array_push(var_list,"image_alpha");
	array_push(var_list,"image_angle");
#endregion
}

get_variable_data = function(){
#region Get value and data type of selected variable
	variable = variable_input;
	variable_input_prev = variable_input;
	variable_current_value = variable_instance_get(target,variable);
	variable_type = typeof(variable_instance_get(target,variable));
#endregion
}

get_text_input = function(){
#region
	if (debug_prev_key) get_prev_input();
	if (string_length(keyboard_string) != string_length(current_input)) 
	{
		update_list = true;
		list_selection = 0;
	}
	current_input = keyboard_string;
	
	#region Sort list
	if (update_list)
	{
		switch (menu_state)
		{	
			case DB_MENU.ROOM:
				room_list_sort = list_sort_update(room_list,room_list_sort);
			break;
			
			case DB_MENU.PARTICLE:
				particle_list_sort = list_sort_update(particle_list,particle_list_sort);
			break;
			
			case DB_MENU.TARGET:
				object_list_sort = list_sort_update(object_list,object_list_sort);
			break;
			
			case DB_MENU.VARIABLE:
				var_list_sort = list_sort_update(var_list,var_list_sort);
			break;
		}
		update_list = false;
	}
	#endregion
	
	selection_update();
	
	#region Make selection
	if (debug_enter_key)
	{
		var _valid = false;
		switch (menu_state)
		{
			case DB_MENU.MENU:
			#region
				var _select = menu_list[list_selection];
				menu_input_prev = list_selection;
				switch (_select)
				{
				case "Room Change":
					menu_state = DB_MENU.ROOM;
					_valid = true;
				break;
				
				case "Modify Particles":
					menu_state = DB_MENU.PARTICLE;
					_valid = true;
				break;
		
				case "Modify Object":
					menu_state = DB_MENU.TARGET;
					_valid = true;
				break;
		
				case "Exit":
					debug_end();
					_valid = true;
				break;
				}
			#endregion
			break;
			
			case DB_MENU.ROOM:
			#region
			if (array_length(room_list_sort) > 0)
			{
				var _room = room_list_sort[list_selection];
				var _roomid = asset_get_index(_room);
				// Ensure room exists
				if (room_exists(_roomid))
				{
					room_change(_roomid);
					_valid = true;
					debug_end();
				}
			}
			#endregion
			break;
			
			case DB_MENU.PARTICLE:
			#region
				if (array_length(particle_list_sort) > 0)
				{
					particle_input = particle_list_sort[list_selection];
					// Check that particle exists
					var _partid = variable_global_exists(particle_input);
					_valid = part_type_exists(_partid);
					if (_valid)
					{
						particle = _partid;
						particle_input_prev = particle_input;
						menu_state = DB_MENU.PARTICLE_VARIABLE;
					}
				}
			#endregion
			break;
			
			case DB_MENU.TARGET:
			#region
				if (array_length(object_list_sort) > 0)
				{
					target_input = object_list_sort[list_selection];
					var _index = asset_get_index(target_input);
					// Check that asset exists
					if (_index > -1)
					{
						// Check that asset is an object
						var _type = asset_get_type(target_input);
						if (_type == asset_object) _valid = true;
						if (_valid) 
						{
							target = _index;
							target_input_prev = target_input;
							var _inst = instance_find(target,0);
							var_list = variable_instance_get_names(_inst);
							add_default_variables();
							array_sort(var_list,true);
							menu_state = DB_MENU.VARIABLE;
						}
					}
				}
			#endregion
			break;
		
			case DB_MENU.VARIABLE:
			#region
				if (array_length(var_list_sort) > 0)
				{
					variable_input = var_list_sort[list_selection];
					// Check that variable exists in target
					_valid = variable_instance_exists(target,variable_input);
					if (_valid) 
					{
						// Get variable type
						get_variable_data();
						menu_state = DB_MENU.VALUE;
					}
				}
			#endregion
			break;
		
			case DB_MENU.VALUE:
			#region
				if (string_length(current_input) > 0)
				{
					value_input = current_input;
					// Input variable as type to match previous type
					switch (variable_type)
					{
						case "number":
							// If any non digit, "-", or "." character exists, invalid entry
							var _charcheckstring = value_input;
							var _charvalid = true;
							var _length = string_length(_charcheckstring);
							for (var _i = 1; _i <= _length; _i += 1)
							{
								var _char = string_char_at(_charcheckstring,_i);
								// If not a digit, check if "-" or "."
								if (string_digits(_char) == "")
								{
									// If character other than "-" or ".", return false and end loop
									if (_char != "-") && (_char != ".") {_charvalid = false; break;}
								}
							}
							if (_charvalid)
							{
								// Remove letters and symbols
								var _string = value_input;
								if (string_length(_string) > 0) {value = real(_string); _valid = true;}	
							}
							
						break;
						
						case "string":
							value = string(value_input);
							_valid = true;
						break;
						
						case "bool":
							if (value_input == "false") {value = false; _valid = true;}
							else if (value_input == "true") {value = true; _valid = true;}
						break;
						
						default :
							_valid = false;
						break;
					}
					if (_valid) 
					{
						var _instnum = instance_number(target);
						for (var _i = 0; _i < _instnum; _i += 1)
						{
							var _inst = instance_find(target,_i);
							variable_instance_set(_inst,variable,value);
						}
						// update displayed data
						get_variable_data();
					}
				}
			#endregion
			break;
		}
		if (!_valid)
		{
			invalid_input();
		}
		clear_keyboard_input();
	}
	#endregion
#endregion
}

invalid_input = function(){
#region Display invalid input visual feedback
	text_color = text_color_error;
	error_time = error_time_max;
	switch (menu_state)
	{
		case DB_MENU.TARGET:
			target = noone;
		break;
		case DB_MENU.VARIABLE:
			variable = noone;
		break;
		case DB_MENU.VALUE:
			value = noone;
		break;
	}
#endregion
}

clear_keyboard_input = function(){
#region Clear current input and keyboard string. Set list_seleciton to 0
	current_input = "";
	keyboard_string = "";
	list_selection = 0;
	update_list = true;
#endregion
}



perform_timers = function(){
	if (error_time > 0) error_time -= 1;
	else
	{
		text_color = text_color_base;
	}
}

perform_step = function(){
#region
	perform_timers();
	get_input();
	
	// Open manager window
	if (debug_key)
	{
		// TURN OFF
		if (debug_input) 
		{
			debug_end();
		}
		// TURN ON
		else
		{
			debug_start();
		}
	}
	// If window is open, allow for inut and selections
	if (debug_input)
	{
		get_text_input();
	}
#endregion
}
