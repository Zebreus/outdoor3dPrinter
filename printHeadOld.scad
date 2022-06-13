use <spindleEnd.scad>
include <components/screwHole.scad>

ballRadius = 12;
ballTolerance = 0.4;
wallStrength = 3;
screwCenterDistance = 20;
screwType = "M4";
screwHeadRadius = 4;
screwLength = 10;
wireRadius = 1;
wireTolerance = 1;

module bendTube(lengthA, lengthB, radius, angle, axis){
    union(){
        cylinder(lengthA, r=radius);
        
        translate([0,0,lengthA])
        rotate(-angle,axis)
        cylinder(lengthB, r=radius);
        
        translate([0,0,lengthA])
        sphere(r=radius);
    }
}

module printHeadTop(){
    maxAngle = 20;
    
    screwHeight = wallStrength;

    
    innerRadius = ballRadius+ballTolerance;
    outerRadius = screwCenterDistance+wallStrength;
    height = sin(maxAngle)*innerRadius;
    
    assert(screwCenterDistance >= ballRadius+ballTolerance+wallStrength+threadRadius(screwType), "The printhead top screws are too close to the center.");
    
    assert(screwHeight <= height, "The printhead top screws are too close to the center.");
    
    difference(){
        union(){
            sphere(innerRadius+wallStrength);
            
            for(i = [45:90:315])
            rotate(i,[0,0,1])
            translate([screwCenterDistance, 0,0]){
            cylinder(screwHeight, r=threadRadius(screwType)+wallStrength);
            rotate(90,[0,0,1])
            translate([-(threadRadius(screwType)+wallStrength),0,0])
            cube([(threadRadius(screwType)+wallStrength)*2, screwCenterDistance, screwHeight]);
            }
        }
        
        sphere($fn=$preview?0:80,innerRadius);
        
        //TODO better round edge
        //translate([0,0,height+cos(maxAngle)*innerRadius-1])
        //sphere(innerRadius);
        
        translate([0,0,-outerRadius*2])
        cube([outerRadius*4,outerRadius*4,outerRadius*4],center=true);
        translate([0,0,height+outerRadius*2])
        cube([outerRadius*4,outerRadius*4,outerRadius*4],center=true);
        
        for(i = [45:90:315])
        rotate(i,[0,0,1])
        translate([screwCenterDistance, 0,0])
        {
            translate([0,0,-1])
            screwHole(screwType, screwHeight+2);
            translate([0,0,screwHeight])
            cylinder(height-screwHeight+1, r=threadRadius(screwType)+wallStrength*2/3);
        }
    }
}

//TODO Maybe add nut inserts
module printHeadBottom(){
    height = 15;
    holeCenterDistance = 30;
    holeHeightDifference = 0;
    holeAngle = 45;
    holeAngledLength = 13;
    
    screwHoleDepth = screwLength-wallStrength+1;
    
    difference(){
        union(){
            // Main body
            difference(){
            sphere(r=holeCenterDistance);
            cylinder(holeCenterDistance,r=holeCenterDistance);
            translate([0,0,-holeCenterDistance-height])
            cylinder(holeCenterDistance,r=holeCenterDistance);
            }
            // Channel bases for wires
            difference(){
                for(i = [0:90:270])
                rotate(i,[0,0,1])
                translate([holeCenterDistance,0,holeHeightDifference])
                rotate(-90-holeAngle, [0,1,0])
                bendTube(holeAngledLength, height, wireRadius+wireTolerance+wallStrength, holeAngle, [0,1,0]);
                
                translate([0,0,-2*height])
                cylinder(height, r=holeCenterDistance);
            }
        }
        
        // Hole for joint;
        sphere($fn=$preview?0:80, ballRadius+ballTolerance);
        
        // Holes for wires
        for(i = [0:90:270])
        rotate(i,[0,0,1])
        translate([holeCenterDistance,0,holeHeightDifference])
        rotate(-90-holeAngle, [0,1,0])
        translate([0,0,-1])
        bendTube(holeAngledLength+1, height, wireRadius+wireTolerance, holeAngle, [0,1,0]);
        
        // Holes for screws

        union(){
        for(i = [45:90:315])
        rotate(i,[0,0,1])
        translate([screwCenterDistance, 0,0])
        translate([0,0,-screwHoleDepth])
        rotate(90,[0,0,1])
        render(convexity = 2)
        screwHole(screwType,screwHoleDepth+1,true,nutSlotPushSlot=false);
        }
    }
}

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 1 : 0.01 ;

printHeadTop();
//printHeadBottom();