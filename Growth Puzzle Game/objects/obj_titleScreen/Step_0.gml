/// @description Insert description here
// You can write your code in this editor

if(keyboard_check_pressed(vk_anykey))
	transitioningOut = true;
	
if(transitioningOut){
	transitionOutProgress = lerp(transitionOutProgress, 1, transitionLerp);
	if(1 - transitionOutProgress < .05)
		room_goto_next();
}

if(!audio_is_playing(snd_music))
	audio_play_sound(snd_music, 0, true);