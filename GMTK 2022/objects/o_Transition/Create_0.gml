// Use the macros to control default fade properteries of duration, color, and wait.
#macro FADE_TO_DUR 90
#macro FADE_FROM_DUR 60
#macro FADE_COLOR c_black
#macro FADE_WAIT 5
#macro FADE_WAIT_SKIP -1

#region fade_from
	/// @method		fade_from()
	/// @desc		Fades in from a _color over _duration steps.
	///				The fade is drawn at a depth of -16000, above all other layers, except the GUI.
	///				_color can be a predefined color or a custom color using make_color().
	///				_duration can be any number of steps.
	///				_wait_time can be any number of steps.
	/// @param {integer}	[duration]
	/// @param				[color]
	/// @param {integer}	[wait_time]
	fade_from = function(_dur = FADE_FROM_DUR, _color = FADE_COLOR, _wait = FADE_WAIT){
		if (complete)
		{
			wait_time_max = _wait;
			wait_time_from = _wait;
			from_duration_max = _dur;
			duration = from_duration_max;
			color = _color;
			fade_state = FADE.FROM;
			complete = false; // Let fade object know it has started a process.
		}
	}
#endregion

#region fade_to
	/// @method		fade_to()
	/// @desc		Fades out to a _color over _duration steps.
	///				The fade is drawn at a depth above all other layers, except the GUI.
	///				_color can be a predefined color or a custom color using make_color().
	///				_dur can be any number of steps.
	///				_wait can be any number of steps. A _wait > 0 triggers an automatic complete_transition() after it expires.
	///					used for player dying.
	/// @param {integer}	[duration]
	/// @param				[color]
	/// @param {integer}	[wait_time]
	fade_to = function(_dur = FADE_TO_DUR, _color = FADE_COLOR, _wait = FADE_WAIT_SKIP){
		if (complete)
		{
			// -1 _wait signals wait to be off.
			// Greater than -1 wait signals wait to occur and fade to auto transition after wait_time_to, not waiting on external signals.
			wait_time_max = _wait;
			wait_time_to = _wait;
			to_duration_max = _dur;
			duration = to_duration_max;
			color = _color;
			fade_state = FADE.TO;
			complete = false; // Let fade object know it has started a process.
		}
	}
#endregion

#region Create

depth = -16000;
complete = true;

enum FADE
{
	TO,
	FROM,
	WAIT_TO, // waiting time in same room after fade to ends
	WAIT_FROM, // waiting time in new room before fade from starts
	IDLE // Switch to this to make inactive
}

fade_state = FADE.FROM;
room_to = undefined; // Target room after fading.

from_duration_max = FADE_FROM_DUR;
to_duration_max = FADE_TO_DUR;
duration = from_duration_max;

color = FADE_COLOR;
alpha = 100;

wait_time_to = 0;
wait_time_from = 0;
wait_time_max = 0; // used for detecting progress of wait_timer

// Fade in on creation
fade_from();
#endregion

#region complete_transition()
// Call this method from Exit objects when their animation is done.
complete_transition = function(){
	room_goto(room_to);
	fade_state = FADE.WAIT_FROM;
}
#endregion

perform_step = function(){
#region Step

// Check if complete based on duration remaining
if (duration > 0) duration -= 1;
else complete = true;

// Update Alpha
switch (fade_state)
{
	// Fading TO a color
	case FADE.TO:
		alpha = 1 - duration/to_duration_max;
		// Once fully faded to a color, move to wait_to
		if (complete) fade_state = FADE.WAIT_TO;
	break;
	
	// Wait at black for wait time, transition to new room and send signal to ctrl
	case FADE.WAIT_TO:
		if (wait_time_to == -1)
		{
			// Default when fading. Do nothing and wait for external signal to complete transition.
		}
		else
		{
			if (wait_time_to > 0) wait_time_to -= 1;
			else complete_transition();
			if (instance_exists(o_Player))
			{
				o_Player.image_alpha = wait_time_to/wait_time_max;
			}
		}
	break;
	
	// Wait at black for wait time > initiate fade from the color.
	case FADE.WAIT_FROM:
		if (wait_time_from > 0) wait_time_from -= 1;
		else
		{	
			o_PauseManager.pause_end();
			o_Controller.enable_input();
			fade_from(from_duration_max,color); // Matches FADE.TO values
		}
	break;
	
	// Fading FROM a color
	case FADE.FROM:
		alpha = duration/from_duration_max;
		// Once fully faded from, renable input and clear the room_to target and change state
		if (complete)
		{
			room_to = undefined;
			fade_state = FADE.IDLE;
		}
	break;
	
	case FADE.IDLE:
		// Do nothing
	break;
}

#endregion
}