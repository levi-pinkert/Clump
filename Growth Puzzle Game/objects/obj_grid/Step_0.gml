///Step

//Before the first frame...
if(firstFrame){
	joinBlocks();
	firstFrame = false;
}

//Fullscreen?
if(keyboard_check_pressed(ord("F"))){
	window_set_fullscreen(!window_get_fullscreen());
}

//Restart?
if(keyboard_check_pressed(vk_backspace)){
	room_restart();
}

//Manage the transitions
transitionInProgress = lerp(transitionInProgress, 1, transitionLerp);
if(transitioningOut){
	if(endPause > 0){
		endPause--;
	}else{
		transitionOutProgress = lerp(transitionOutProgress, 1, transitionLerp);
		if(1 - transitionOutProgress < .05)
			room_goto_next();
	}
}

//Get input
var xInput = 0;
var yInput = 0;
if(!transitioningOut && (keyboard_check(vk_left) || keyboard_check(vk_right) || keyboard_check(vk_up) || keyboard_check(vk_down))){
	if(inputCooldown <= 0){
		if(keyboard_check(vk_right)){
			xInput = 1;
		}else if(keyboard_check(vk_up)){
			yInput = -1;
		}else if(keyboard_check(vk_left)){
			xInput = -1;
		}else if(keyboard_check(vk_down)){
			yInput = 1;
		}
		if(firstInput)
			inputCooldown = 10;
		else
			inputCooldown = 5;
		firstInput = false;
	}else{
		inputCooldown--;
	}
}else{
	inputCooldown = 0;
	firstInput = true;
}

//If there was an input, try to move all the controllers (along with their colonies)
if(xInput != 0 || yInput != 0){
	//move each controller
	var controllerCount = instance_number(obj_controller);
	for(var i = 0; i < controllerCount; i++){
		var controller = instance_find(obj_controller, i);
		
		//Check if all the blocks are chill with moving
		var blockArr = controller.controlledBlocks;
		var blockCount = array_length(blockArr);
		var canMove = true;
		for(var j = 0; j < blockCount; j++){
			if(levelGrid[blockArr[j].gameX+xInput][blockArr[j].gameY+yInput] == Elements.wall){
				canMove = false;
				break;
			}
		}
		
		//Check if this is controlled by another controller which has already moved
		if(controller.controller != controller)
			canMove = false;
			
		//Move everything that needs to be moved
		if(canMove){
			var newBlockGrid = 0;
			for(var yy = 0; yy < height; yy++){
				for(var xx = 0; xx < width; xx++){
					newBlockGrid[xx][yy] = noone;
				}
			}
			
			for(var yy = 0; yy < height; yy++){
				for(var xx = 0; xx < width; xx++){
					if(controller.hasControl(blockGrid[xx][yy])){
						newBlockGrid[xx+xInput][yy+yInput] = blockGrid[xx][yy];
						blockGrid[xx][yy].gameX = xx+xInput;
						blockGrid[xx][yy].gameY = yy+yInput;
					}else{
						if(blockGrid[xx][yy] != noone)
							newBlockGrid[xx][yy] = blockGrid[xx][yy];
					}
				}
			}
			blockGrid = newBlockGrid;
			
			//Make a noise
			audio_play_sound(snd_move, 0, false);
		}
	}
	
	//Join everything together
	joinBlocks();
	
	//Check if we're winning, son
	var won = true;
	for(var yy = 0; yy < height; yy++){
		for(var xx = 0; xx < width; xx++){
			if(levelGrid[xx][yy] == Elements.goal){
				if(blockGrid[xx][yy] == noone){
					won = false;
				}
			}
		}
	}
	if(won && room != rm_endScreen){
		transitioningOut = true;
		audio_play_sound(snd_win, 0, false);
	}
}

//Do the goal effects
var goalEffectSize = 10;
for(var yy = 0; yy < height; yy++){
	for(var xx = 0; xx < width; xx++){
		if(levelGrid[xx][yy] == Elements.goal && blockGrid[xx][yy] != noone && surface_exists(blockSurface)){
			surface_set_target(blockSurface);
			draw_set_color(goalColor);
			draw_rectangle(xx*cellSize+cellSize/2-goalEffectSize, yy*cellSize+cellSize/2-goalEffectSize, xx*cellSize+cellSize/2+goalEffectSize, yy*cellSize+cellSize/2+goalEffectSize, false);
			surface_reset_target();
		}
	}
}