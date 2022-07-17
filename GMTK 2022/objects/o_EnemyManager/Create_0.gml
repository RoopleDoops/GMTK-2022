enum EMGR_STATE
{
	COUNT,
	WIN,
	TRANS,
	DONE
}
state = EMGR_STATE.COUNT;
enemy_num = instance_number(o_Enemy);


enemy_count_update = function(){
	enemy_num -=1;
	if (enemy_num <= 0) 
	{
		audio_play_sound(sfx_dice06,50,false);
		o_ParticleManager.make_confetti();
		state = EMGR_STATE.WIN;
	}
}

win_time_max = 120;
win_time = win_time_max;

perform_step = function(){
	switch(state)
	{
		case EMGR_STATE.COUNT:
		break;
		case EMGR_STATE.WIN:
			if (win_time > 0) win_time -=1;
			else state = EMGR_STATE.TRANS;
		break;
		case EMGR_STATE.TRANS:
			global.level += 1;
			if (global.dice_num != 6) global.dice_num = min(global.level,6);
			state = EMGR_STATE.DONE;
			if (instance_exists(o_Player)) 
			{
				with (o_Player) player_win();
			}
			if (global.level <= global.level_limit) room_change(r_Upgrade);
			else 
			{
				global.level = global.level_start;
				room_change(r_Title);
			}
		break;
		case EMGR_STATE.DONE:
		break;
	}
}