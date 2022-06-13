//TODO Maybe 5° bigger shaft or support
module spindleEnd(
  spindleRadius = 4.0,
  wallStrength = 3.0,
  ballRadius = 12.0,
  holeDepth = 20,
  maxAngle = 45
  ){
    cylinderRadius = spindleRadius+wallStrength;
    
    assert(cylinderRadius < sin(maxAngle)*ballRadius, "The cylinder needs to be smaller");
    
    difference(){
        union(){
            sphere(ballRadius, $fn=$preview?0:80);
            cylinder(holeDepth, r=cylinderRadius);
        }
        cylinder(holeDepth+10, r=spindleRadius);
    }
}

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 1 : 0.1 ;

spindleEnd();