///Draw

if(controlled)
	draw_surface_part(obj_grid.blockSurface, x, y, size, size, x, y);
else{
	draw_sprite_ext(spr_block, 0, x, y, 1, 1, 0, obj_grid.blockColor, 1);
}