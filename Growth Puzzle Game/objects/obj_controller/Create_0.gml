///Create

lerpSpd = obj_grid.cellLerpSpeed;
size = obj_grid.cellSize;

//This controls itself
controlledBlocks[0] = id;
controller = id;


//Define functions
function hasControl(block){
	if(block == noone)
		return false;
	controlledBlockCount = array_length(controlledBlocks);
	for(var i = 0; i < controlledBlockCount; i++){
		if(controlledBlocks[i] == block)
			return true;
	}
	return false;
}