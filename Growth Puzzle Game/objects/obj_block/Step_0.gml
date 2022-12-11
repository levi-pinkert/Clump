///Step

if(!variable_instance_exists(id, "gameX")){
	show_debug_message(x);
	show_debug_message(y);
}

x = lerp(x, gameX*size, lerpSpd);
y = lerp(y, gameY*size, lerpSpd);

if(controlled = false && controller != noone){
	//Somebody's taken control of us!!!
	controlled = true;
	
	//Set the color in the surface
	surface_set_target(obj_grid.blockSurface);
	draw_set_color(obj_grid.blockColor);
	draw_rectangle(gameX*size, gameY*size, (gameX+1)*size, (gameY+1)*size, false);
	surface_reset_target();
	
	//do the same for adjacent squares if they're free
	//this gives some buffer so that color doesn't immediately flood from all sides
	if(obj_grid.blockGrid[gameX+1][gameY] == noone){
		surface_set_target(obj_grid.blockSurface);
		draw_set_color(obj_grid.blockColor);
		draw_rectangle((gameX+1)*size, (gameY)*size, (gameX+2)*size, (gameY+1)*size, false);
		surface_reset_target();
	}
	if(obj_grid.blockGrid[gameX-1][gameY] == noone){
		surface_set_target(obj_grid.blockSurface);
		draw_set_color(obj_grid.blockColor);
		draw_rectangle((gameX-1)*size, (gameY)*size, (gameX)*size, (gameY+1)*size, false);
		surface_reset_target();
	}
	if(obj_grid.blockGrid[gameY+1][gameY] == noone){
		surface_set_target(obj_grid.blockSurface);
		draw_set_color(obj_grid.blockColor);
		draw_rectangle((gameX)*size, (gameY+1)*size, (gameX+1)*size, (gameY+2)*size, false);
		surface_reset_target();
	}
	if(obj_grid.blockGrid[gameY-1][gameY] == noone){
		surface_set_target(obj_grid.blockSurface);
		draw_set_color(obj_grid.blockColor);
		draw_rectangle((gameX)*size, (gameY-1)*size, (gameX+1)*size, (gameY)*size, false);
		surface_reset_target();
	}
}