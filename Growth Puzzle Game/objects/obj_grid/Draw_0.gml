/// @description Insert description here
// You can write your code in this editor

//Set up the surfaces
if(!setBlockSurface || !surface_exists(blockSurface)){
	//Make the blocks' surface
	blockSurface = surface_create(room_width, room_height);
	surface_set_target(blockSurface);
	draw_set_color(controlColor);
	draw_rectangle(0, 0, room_width, room_height, false);
	surface_reset_target();
	draw_set_color(c_white);
	setBlockSurface = true;
}

if(!surface_exists(tempSurface)){
	tempSurface = surface_create(room_width, room_height);
}

if(!setWallSurface || !surface_exists(wallSurface)){
	//Make the walls' surface
	wallSurface = surface_create(room_width, room_height);
	surface_set_target(wallSurface);
	var midColor = make_color_rgb((color_get_red(wallColor1)+color_get_red(wallColor2))/2,(color_get_green(wallColor1)+color_get_green(wallColor2))/2,(color_get_blue(wallColor1)+color_get_blue(wallColor2))/2);
	draw_rectangle_color(0, 0, room_width, room_height, wallColor1, midColor, wallColor2, midColor, false);
	surface_reset_target();
	setWallSurface = true;
}

//Add more stuff
if(mouse_check_button(mb_left)){
	surface_set_target(blockSurface);
	draw_set_color(blockColor);
	draw_rectangle(mouse_x, mouse_y, mouse_x+50, mouse_y+50, false);
	surface_reset_target();
}

//Turn on the shader
shader_set(shader_blur);
var uniform_tex_size = shader_get_uniform(shader_blur, "texture_size");
shader_set_uniform_f(uniform_tex_size, room_width, room_height);

//Draw to a temp surface while the blur is on
surface_set_target(tempSurface);
draw_surface(blockSurface, 0, 0);
surface_reset_target();

//Copy it back
shader_reset();
surface_set_target(blockSurface);
draw_surface(tempSurface, 0, 0);
surface_reset_target();

//Draw it onto the screen
//draw_surface(blockSurface, 0, 0);


