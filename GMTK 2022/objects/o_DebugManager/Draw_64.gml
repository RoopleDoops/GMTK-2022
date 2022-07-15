if (debug_input)
{
	// Draw window
		draw_set_color(window_color);
		draw_set_alpha(window_alpha);
		draw_rectangle(window_x,window_y,window_x+window_width,window_y+window_height,false);
	// Window Edge
		draw_set_color(edge_color);
		draw_set_alpha(edge_alpha);
		draw_rectangle(window_x,window_y,window_x+window_width,window_y+edge_height,false);
	
	// Draw Display Text
		draw_display_text();
	
	// Draw input
		draw_text(window_x + text_input_xoffset,text_input_y,current_input);
	
	// Draw selection list
		draw_selection_list();
	
	// Reset draw alpha
	draw_set_alpha(1);
}