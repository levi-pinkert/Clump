/// @description Insert description here
// You can write your code in this editor

//Draw the in transition
draw_set_color(transitionColor);
draw_rectangle(0, 0, browser_width+100, lerp(browser_height, 0, transitionInProgress), false);

//Draw the transition out
draw_rectangle(0, lerp(browser_height, -32, transitionOutProgress), browser_width+100, browser_height, false);