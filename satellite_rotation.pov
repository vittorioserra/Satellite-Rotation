#include "colors.inc"
#include "textures.inc"

#declare yaw_transmit = 0.9;
#declare roll_transmit = 0.9;
#declare pitch_transmit = 0.9;

// you are reading this in the future. Yeah good luck remembering and understading the following...
// seriously, we setup a few things depending on the stage we are in the animation clock
/*#switch (clock) // full turn on each axis
	#range(0,0.1)
		#declare aim = 0;
	#break
	#range(0.1,0.4)
		#declare aim = x*360*(clock-0.1)*10/3;
	#break
	#range(0.4,0.7)
		#declare aim = y*360*(clock-0.4)*10/3;
	#break
	#range(0.7,1)
		#declare aim = z*360*(clock-0.7)*10/3;
	#break
#end*/

#switch (clock) // wiggle wiggle
	#range(0,0.1)
		#declare aim = 0;
	#break
	#range(0.1,0.4)
		#local normalized_clock = (clock-0.1)*10/3;
		#declare aim = x*7.5*sin(pi*normalized_clock*8);
		#declare roll_transmit = 0.1;
	#break
	#range(0.4,0.7)
		#local normalized_clock = (clock-0.1)*10/3;
		#declare aim = y*7.5*sin(pi*normalized_clock*8);
		#declare yaw_transmit = 0.1;
	#break
	#range(0.7,1)
		#local normalized_clock = (clock-0.1)*10/3;
		#declare aim = z*7.5*sin(pi*normalized_clock*8);
		#declare pitch_transmit = 0.1;
	#break
#end

#ifndef (CamType) // if this variable is not set (here or in the .ini file), default to "outside" camera
	camera
	{
		location <10.0, 20.0, -40.0>
		look_at <0.0, 0.0,  0.0>
		right x*image_width/image_height
	}
	#declare sky_scale = 0.002;
#end
#ifdef (CamType) // startracker camera
camera
	{
		location y*20
		look_at y*100
		right x*image_width/image_height
		rotate aim
	}
	#declare sky_scale = 0.02;
#end
    
// Lights
#for(i, 0, 8)
	light_source
	{
		y*1000
		color White
		shadowless
		translate z*-250
		rotate y*(i*360/8)
	}
#end

// Earth
sphere
{
	<0,0,0> 6.378
	texture	{ pigment{ image_map { png "earth.png" map_type 1 } } }
	scale<1.03*45/7,1*45/7,1.03*45/7>
	rotate y*clock*5
	translate <0,-30,+50>
}

// Sky
sky_sphere
{
	pigment
	{
		crackle form <1,1,0> color_map { [.3 rgb 1] [.4 rgb 0] }
		scale sky_scale
	}
}

// Arrows and indicators
#declare arrow_length = 10;
      
#declare arrow =
union
{
	cylinder { -y * arrow_length, 0, 0.5 }
	cone { 0, 1, y * arrow_length/3, 0 }
	translate y * arrow_length
}

#declare indicator = 
union
{
	object {arrow}
	torus
	{
		arrow_length * (1 - 1/3), 1/3
	}
}

#declare yaw =
object
{
	indicator
	pigment { rgb<1,0,0> transmit yaw_transmit}
	finish { reflection .2 }
}

#declare roll =
object
{
	indicator
	rotate z*-90
	pigment { rgb<0,0,1> transmit roll_transmit}
	finish { reflection .2 }
}

#declare pitch =
object
{
	indicator
	rotate x*-90
	pigment { rgb<0,1,0> transmit pitch_transmit}
	finish { reflection .2 }
}

// Satellite model    
#declare solar_wing =
prism
{
	linear_sweep
	linear_spline
	0, // sweep the following shape from here ...
	0.2, // ... up through here
	5, // the number of points making up the shape ...
	<0,0>, <6,0>, <6,6>,  <0,6>, <0,0>
	pigment {image_map{ png "solar_panel_texture.png" map_type 0 } }   
	finish { reflection {1.0} ambient 0.2 diffuse 0.05 }
	rotate<-0, 0, 0> 
}

#declare satellite=
union
{  
	prism
	{
		linear_sweep
		linear_spline
		0, // sweep the following shape from here ...
		7, // ... up through here
		5, // the number of points making up the shape ...
		<0,0>, <1,3>, <5,3>,  <6,0>, <0,0>
		translate<-3,-3.5,-1.5>  
		pigment { image_map { png "gold_foil.png" map_type 1 } }  
		finish { reflection {1.0} ambient 0.3 diffuse 0.1 }
		rotate<-90, 0, 0> 
	}    
	object
	{
		solar_wing
		translate<2,1.3,-3.0>
	}
	object
	{
		solar_wing
		translate<-8,1.3,-3.0>
	}
}

union
{
	object { satellite }
	object { pitch }
	object { roll }
	object { yaw }
	rotate aim
}
