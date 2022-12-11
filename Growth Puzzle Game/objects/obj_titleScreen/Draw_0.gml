/// @description Insert description here
// You can write your code in this editor

draw_self();
draw_set_color(make_color_rgb(10, 2, 20));
draw_rectangle(0, lerp(room_height, -32, transitionOutProgress), room_width, room_height, false);
draw_set_color(c_white);