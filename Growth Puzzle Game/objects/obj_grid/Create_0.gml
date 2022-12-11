///Create



//Define functions
function claimBlock(xx, yy, controller){
	//Base Cases
	if(xx < 0 || xx >= width || yy < 0 || yy >= height)
		return;
	
	var block = blockGrid[xx][yy];
	if(block == noone || block.controller == controller)
		return;
	
	//Claim this block to the given controller
	block.controller = controller;
	array_push(controller.controlledBlocks, block);
	
	//Recur in all 4 directions
	claimBlock(xx, yy-1, controller);
	claimBlock(xx-1, yy, controller);
	claimBlock(xx, yy+1, controller);
	claimBlock(xx+1, yy, controller);
	
}

function joinBlocks(){
	for(var yy = 0; yy < height; yy++){
		for(var xx = 0; xx < width; xx++){
			var block = blockGrid[xx][yy];
			if(block != noone && block.object_index == obj_block){
				//Check all four directions around this block
				for(var i = 0; i < 4; i++){
					//Figure out where we're checking
					var dx = 0;
					var dy = 0;
					if(i == 0){ dy = -1; }
					if(i == 1){ dx = -1; }
					if(i == 2){ dy = 1; }
					if(i == 3){ dx = 1; }
					
					//Check what's there
					var otherBlock = blockGrid[xx+dx][yy+dy];
					if(otherBlock == noone){
						//nothing to see here
					}else if(otherBlock.object_index == obj_controller){
						//it's a controller, so we should try to join it
						claimBlock(xx, yy, otherBlock);
					}else if(otherBlock.object_index == obj_block){
						//it's another block, so we should try to make it join
						//but we'll also use recurion so neighboring blocks also join
						if(block.controller != noone){
							claimBlock(xx+dx, yy+dy, block.controller);
						}
					}
				}
			}
		}
	}
}

//Misc variables
firstFrame = true;

//Input Stuff
inputCooldown = 0;
firstInput = true;
keyboard_set_map(ord("W"), vk_up);
keyboard_set_map(ord("A"), vk_left);
keyboard_set_map(ord("S"), vk_down);
keyboard_set_map(ord("D"), vk_right);

//Transition Stuff
transitionInProgress = 0;
transitionOutProgress = 0;
transitionLerp = .05;
endPause = 20;

transitioningOut = false;

//Find the dimensions of the grid
cellSize = 32;
cellLerpSpeed = .2;
width = ceil(room_width / cellSize);
height = ceil(room_height / cellSize);

//Build the grid from the objects in the room
enum Elements{
	empty = 0,
	wall = 1,
	block = 2,
	contoller = 3,
	goal = 4
};

levelGrid = array_create(width, pointer_null);
for(var i = 0; i < width; i++){
	levelGrid[i] = array_create(height, Elements.empty);	
}

blockGrid = array_create(width, pointer_null);
for(var i = 0; i < width; i++){
	blockGrid[i] = array_create(height, noone);	
}

for(var yy = 0; yy < height; yy++){
	for(var xx = 0; xx < width; xx++){
		var obj = instance_place(xx*cellSize, yy*cellSize, all);
		if(obj == noone){
			//do nothing
		}else if(obj.object_index == obj_wall){
			levelGrid[xx][yy] = Elements.wall;
		}else if(obj.object_index == obj_block){
			blockGrid[xx][yy] = obj;
			obj.gameX = xx;
			obj.gameY = yy;
		}else if(obj.object_index == obj_controller){
			blockGrid[xx][yy] = obj;
			obj.gameX = xx;
			obj.gameY = yy;
		}else if(obj.object_index == obj_goal){
			levelGrid[xx][yy] = Elements.goal;
		}
	}
}

//Automatically cover the walls in walls
for(var i = 0; i < width; i++){
	levelGrid[i][0] = Elements.wall;
	levelGrid[i][height-1] = Elements.wall;
}
for(var i = 0; i < height; i++){
	levelGrid[0][i] = Elements.wall;
	levelGrid[width-1][i] = Elements.wall;
}

//Setup rendering thigns
blockSurface = surface_create(room_width, room_height);
tempSurface = surface_create(room_width, room_height);
wallSurface = surface_create(room_width, room_height);
setBlockSurface = false;
setWallSurface = false;

//controlColor = make_color_rgb(255,119,119);
//blockColor = make_color_rgb(255,206,149);

//controlColor = make_color_rgb(0,228,55);
//blockColor = make_color_rgb(41,173,255);

controlColor = make_color_rgb(255,129,66);
blockColor = make_color_rgb(171,30,101);
goalColor = make_color_rgb(74,231,236);
wallColor1 = make_color_rgb(15, 5, 30);
wallColor2 = make_color_rgb(55, 12, 71);
transitionColor = make_color_rgb(10, 2, 20);