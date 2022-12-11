/// @description Insert description here
// You can write your code in this editor

function scaleCanvas(baseWidth,baseHeight,centerWidth,centerHeight,centered){
	if(os_browser == browser_not_a_browser){ return; }
	var _aspect = (baseWidth / baseHeight);

	if ((centerWidth / _aspect) > centerHeight)
	    {
	    window_set_size((centerHeight *_aspect), centerHeight);
	    }
	else
	    {
	    window_set_size(centerWidth, (centerWidth / _aspect));
	    }
	if (centered)
	    {
	    window_center();
	    }

	surface_resize(application_surface, min(window_get_width(), baseWidth), min(window_get_height(), baseHeight));
}


width = browser_width;
height = browser_height;
base_width = room_width;
base_height = room_height;
