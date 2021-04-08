use <../sizes.scad>

$nutSlotMinPushSlotRadius = 1;
$nutSlotMaxPushSlotRadius = 5;
$nutSlotExtraHeight = 1.0;
$nutSlotExtraAngle = 35;


module copy_mirror(vec)
{
    children();
    mirror(vec)
    children();
}

module nutSlot(
  type,
  pushSlot = true,
  length,
  pushSlotRadius,
  height,
  radius
  ){
    
    assert((type != undef) || (height != undef && radius != undef), "You need to specify either type or height and radius");
     
    if(type != undef){
        assert(nutRadius(type) != undef, str("The nut diameter is not defined for ", type));
        assert(nutThickness(type) != undef, str("The nut thickness is not defined for ", type));
    }
    
    height = ((type != undef) ? nutThickness(type) : height);
    radius = (type != undef) ? nutRadius(type) : radius;
    
    pushSlotRadius = (pushSlotRadius != undef) ? pushSlotRadius : max($nutSlotMinPushSlotRadius, height*2/5);
    length = (length != undef) ? length : radius*10;
    
    // Nut insert
    difference(){
    linear_extrude(height+$nutSlotExtraHeight)
    polygon([
      [cos(30)*radius,sin(30)*radius],
      [0,radius],
      [cos(150)*radius,sin(150)*radius],
      [cos(210)*radius,-length/2+sin(210)*radius],
      [0,-length/2-radius],
      [cos(330)*radius,-length/2+sin(330)*radius]
    ]);
        
    copy_mirror([1,0,0])
    translate([-cos(30)*radius,-length/2-radius,height])
    rotate($nutSlotExtraAngle,[0,-1,0])
    cube([radius*2,length+radius*2,radius]);
        
    copy_mirror([1,0,0])
    translate([-cos(30)*radius,sin(30)*radius,height])
    rotate(60,[0,0,-1])
    rotate($nutSlotExtraAngle,[0,-1,0])
    cube([radius*2,radius*2,radius]);
    }

    
    if(pushSlot == true){
    // push slot 
    translate([0,0,height*0.5])
    rotate(90,[-1,0,0])
    rotate(30,[0,0,1])
    cylinder($fn=6,length/2+1, r=pushSlotRadius);
    }
}

module nutSlotTestCube(){
    type = "M4";
    height = nutThickness(type)+4;
    depth = nutDiameter(type)+8;
    width = sin(30)*nutDiameter(type)+6;
difference(){
    translate([-width/2,-depth/2,-1])
    cube([width,depth,height]);
    nutSlot(type="M4");
    cylinder(nutThickness(type)*3,r=threadRadius(type));
}
}
//$fn=100;

//nutSlot(type="M4",length=0);
//nutSlotTestCube();