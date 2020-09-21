#include "colors.inc"
#include "textures.inc"

camera
{
	location <0.0, 20.0, -40.0>
	look_at <0.0, 0.0,  0.0>
	right x*image_width/image_height
}
    
//keep multiple light sources anyhow
    
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

#declare arrow_length = 10;
      

union {
	cylinder { <-arrow_length,0,0>,<0,0,0>,0.5 }
	cone { <0,0,0>,1,<3,0,0>,0 }
	pigment { rgb<1,0,0> transmit 0.5}    
   finish { reflection .2 }    
	//scale <1,2,1> // size change, longer
	translate <arrow_length,0,0>
    rotate <0,0,90> // point in another direction (left)   
    rotate<0,-360*(clock+0.00),0>
    
}    
union {
	cylinder { <-arrow_length,0,0>,<0,0,0>,0.5 }
	cone { <0,0,0>,1,<3,0,0>,0 }
	pigment { rgb<0,1,0> transmit 0.5}    
   finish { reflection .2 } 
	//scale <1,2,1> // size change, longer    
	translate <arrow_length,0,0>
    rotate <0,90,0> // point in another direction (left)   
    rotate<0,-360*(clock+0.00),0>
}
union {
	cylinder { <-arrow_length,0,0>,<0,0,0>,0.5 }
	cone { <0,0,0>,1,<3,0,0>,0 }
	pigment { rgb<0,0,1>transmit 0.5}    
   finish { reflection .2 }  
	//scale <1,2,1> // size change, longer 
	translate <arrow_length,0,0>
    rotate <90,0,0> // point in another direction (left)    
    rotate<0,-360*(clock+0.00),0>
} 
    


//satellite body
  
prism {
    linear_sweep
    linear_spline
    0, // sweep the following shape from here ...
    7, // ... up through here
    5, // the number of points making up the shape ...
    <0,0>, <1,3>, <5,3>,  <6,0>, <0,0>
    translate<-3,-3.5,-1.5>  
    pigment{
          image_map{ 
             png "gold_foil.png" 
             map_type 1
          }
       }  
       
	finish { reflection {1.0} ambient 0.3 diffuse 0.1 }
    rotate<-90, 0, 0> 
    rotate<0,-360*(clock+0.00),0>       
}    
    
//right solar wing
prism {
    linear_sweep
    linear_spline
    0, // sweep the following shape from here ...
    0.2, // ... up through here
    5, // the number of points making up the shape ...
    <0,0>, <6,0>, <6,6>,  <0,6>, <0,0>
    translate<2,1.3,-3.0>  
    pigment {image_map{
             png "solar_panel_texture.png"
             map_type 0 
             }
          }   
	  finish { reflection {1.0} ambient 0.2 diffuse 0.05 }
    rotate<-0, 0, 0> 
    rotate<0,-360*(clock+0.00),0>      
}
   
//left solar wing
prism {
    linear_sweep
    linear_spline
    0, // sweep the following shape from here ...
    0.2, // ... up through here
    5, // the number of points making up the shape ...
    <0,0>, <6,0>, <6,6>,  <0,6>, <0,0>
    translate<-8,1.3,-3.0>  
    pigment { image_map {
             png "solar_panel_texture.png" 
             map_type 0}
          }
	  finish { reflection {1.0} ambient 0.2 diffuse 0.05 }
    rotate<-0, 0, 0>  
    rotate<0,-360*(clock+0.00),0>      
}       
   

//earth

 sphere { <0,0,0> 6.378
    texture {
       pigment{
          image_map {
             png "earth.png" //gif "earthmap1k.gif"
             map_type 1  // Esfera
          }
       }
    }
    
    scale<1.03*45/7,1*45/7,1.03*45/7>
 rotate <0,0,0>
 translate <0,-30,+50>
 
 }

sky_sphere {
 pigment {
  crackle form <1,1,0>
  color_map {
   [.3 rgb 1]
   [.4 rgb 0]
  }
  scale .002
 }
}

