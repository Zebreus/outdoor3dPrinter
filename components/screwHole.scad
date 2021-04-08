use <../sizes.scad>
include <nutSlot.scad>

$screwHoleTolerance = 0;

module screwHole(
  type,
  depth,
  nutSlot = false,
  nutSlotPushSlot = true,
  nutSlotLength
  ){
    
    assert((type != undef), "You need to specify a valid screw type");
     
    assert(threadRadius(type) != undef, str("The thread radius is not defined for ", type));
    
    radius = threadRadius(type)+$screwHoleTolerance/2;
      
    cylinder(depth, r=radius);
    
    if(nutSlot == true){
        if(nutSlotLength == undef){
            nutSlot(type=type, pushSlot=nutSlotPushSlot);
        }else{
            nutSlot(type=type, pushSlot=nutSlotPushSlot, length=nutSlotLength);
        }
    }
}

//screwHole("M4",10,true,nutSlotLength=0);