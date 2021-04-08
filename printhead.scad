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

rodRadius = 4;
rodHolderScrewType = "M3";
rodHolderScrewLength = 8;
rodHolderScrewHeadSize = 2;
rodHolderNutPosition = (rodHolderScrewLength+nutThickness(rodHolderScrewType))/2;
rodHolderExtraSideClearance =  1.5;

bearingInnerRadius = 4;
bearingOuterRadius = 11;
// The bearing wont sit flush against the spacer, because 3d printing
bearingMountExtraWidth = 0.1;
bearingWidth = 7;
bearingSpacerWidth = 0.8;
bearingSpacerSize = 1.75;
bearingHolderHeight = max(bearingWidth+wallStrength+bearingSpacerWidth+bearingMountExtraWidth);
bearingHolderWidth = (bearingOuterRadius+wallStrength)*2;


innerRodHolderWidth = (rodRadius + wallStrength + bearingSpacerWidth*2 + bearingWidth + bearingMountExtraWidth*2)*2;
innerRodHolderLength = bearingHolderWidth+rodHolderExtraSideClearance*2;

middleRodHolderWidth = max(
    norm([innerRodHolderWidth/2+(wallStrength),bearingInnerRadius+bearingSpacerSize])*2,
    norm([(innerRodHolderWidth)/2-bearingSpacerWidth,bearingHolderWidth/2])*2
) + rodHolderExtraSideClearance*2;

middleRodHolderLength = innerRodHolderLength+(bearingHolderHeight+bearingMountExtraWidth+bearingSpacerWidth)*2;

middleRodHolderHeight = bearingHolderWidth;

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

module axisConnector(){
    difference(){
        for(i = [0,180])
        rotate(i,[0,0,1])
        translate([rodRadius, 0, bearingHolderWidth/2])
        rotate(90,[0,1,0])
        //TODO move this to a component (modify first two lines for general)
        difference(){
            translate([0,0,-rodRadius]){

            cylinder(bearingHolderHeight+rodRadius, r=bearingHolderWidth/2);
            intersection(){
            rotate(45,[0,0,-1])
            cube([bearingHolderWidth/2,bearingHolderWidth/2,bearingHolderHeight+rodRadius]);
            translate([0,-bearingHolderWidth/2,0])
            cube([bearingHolderWidth/2,bearingHolderWidth,bearingHolderHeight+rodRadius]);
            }
            }
            translate([0,0,bearingHolderHeight-bearingSpacerWidth-bearingWidth]){
                cylinder(bearingSpacerWidth+1,r=bearingOuterRadius- bearingSpacerSize);
                translate([0,0,bearingSpacerWidth]){
                    cylinder(bearingWidth+1,r=bearingOuterRadius);
                    intersection(){
                        rotate(225,[0,0,-1])
                        cube([bearingOuterRadius,bearingOuterRadius,bearingWidth+1]);
                        //cylinder(bearingWidth+1, r=bearingOuterRadius+wallStrength*0.5);
                    }  
                } 
            }
        }
        

        translate([0,0,wallStrength])
        cylinder(bearingHolderWidth,r=rodRadius);
        
        for(i = [0,180])
        rotate(i,[0,0,1])
        translate([0,-rodRadius, bearingHolderWidth/2]){
            translate([0, -rodHolderNutPosition, 0])
            rotate(90,[-1,0,0])
            screwHole(rodHolderScrewType,rodHolderNutPosition+1,true,false);
            translate([0, -rodHolderNutPosition, 0])
            rotate(-90,[-1,0,0])
            screwHole(rodHolderScrewType,rodHolderNutPosition+1,false);
            translate([0, -rodHolderScrewLength, 0])
            rotate(-90,[-1,0,0])
            cylinder(bearingHolderHeight,r=threadRadius(rodHolderScrewType)+rodHolderScrewHeadSize);
        }
        
    }
}

module middleBit(){
    translate([rodRadius+wallStrength+bearingSpacerWidth+bearingMountExtraWidth,0,0])
    rotate(90,[0,1,0]){
        translate([0,0,bearingWidth+bearingMountExtraWidth])
        cylinder(bearingSpacerWidth, r=bearingSpacerSize+bearingInnerRadius);
        cylinder(bearingWidth+bearingMountExtraWidth, r=bearingInnerRadius);
        //Should not be seen
        color("Red")
        translate([0,0,bearingWidth+bearingMountExtraWidth+bearingSpacerWidth])
        cylinder(bearingSpacerWidth, r=bearingSpacerSize+bearingInnerRadius);
    }
}

module middleMotorMount(){
    screwHoleDepth = 4.5;
    screwType = "M3";

    
    //height = (bearingOuterRadius+wallStrength)*2;
    height = (bearingSpacerSize+bearingInnerRadius)*2;
    
    
    rotate(90,[0,-1,0])
    translate([0,0,-innerRodHolderWidth/2]){
    
    // Bearing mount
    cylinder(bearingSpacerWidth, r=bearingSpacerSize+bearingInnerRadius);
    translate([0,0,bearingSpacerWidth])
    cylinder(bearingWidth+bearingMountExtraWidth, r=bearingInnerRadius);
    
    // Backplate
    translate([-height/2, -innerRodHolderLength/2,-wallStrength])
    cube([height, innerRodHolderLength, wallStrength]);
    
    // Screw hole side
    translate([-height/2,innerRodHolderLength/2, -wallStrength])
    difference(){
        cube([height, bearingHolderHeight, wallStrength]);
        
        for(i=[2])
        translate([(height/4)*i, bearingHolderHeight/2, -1])
        screwHole(screwType,wallStrength+2);
    }
    
    // Bearing side
    translate([-height/2,-innerRodHolderLength/2-bearingHolderHeight,0])
    difference(){
        union(){
        translate([0,0, -wallStrength])
        cube([height, bearingHolderHeight, innerRodHolderWidth+wallStrength]);
        translate([height/2,bearingHolderHeight,innerRodHolderWidth/2]){
        rotate(90,[1,0,0])
        cylinder(bearingHolderHeight, r=bearingOuterRadius+wallStrength);
            translate([0,-bearingHolderHeight,0])
            difference(){
            rotate(135,[0,1,0])
            cube([bearingOuterRadius+wallStrength,bearingHolderHeight,bearingOuterRadius+wallStrength]);
            translate([-bearingOuterRadius+wallStrength,-1,-innerRodHolderWidth/2-(bearingOuterRadius+wallStrength)-wallStrength])
            cube([(bearingOuterRadius+wallStrength)*2,bearingHolderHeight+2,bearingOuterRadius+wallStrength]);
            }
        }
        }
        
        for(i=[2])
        translate([(height*i/4), bearingHolderHeight/2, innerRodHolderWidth-screwHoleDepth])
        screwHole(screwType,screwHoleDepth+1,true);
        
        translate([height/2, 0, innerRodHolderWidth/2])
        rotate(90,[-1,0,0]){
            translate([0,0,-1])
            cylinder(bearingWidth+1,r=bearingOuterRadius);
            translate([0,0,bearingWidth-1])
            cylinder(bearingSpacerWidth+1,r=bearingOuterRadius- bearingSpacerSize);
            translate([0,0,-1])
            intersection(){
                rotate(135,[0,0,-1])
                cube([bearingOuterRadius,bearingOuterRadius,bearingWidth+1]);
                cylinder(bearingWidth+1,r=bearingOuterRadius+wallStrength*0.5);
           } 
        }
    }
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
    holeCenterDistance = 40;
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
        
        // Cutout middle
        translate(-[middleRodHolderWidth,middleRodHolderLength,middleRodHolderHeight]/2)
        %cube([middleRodHolderWidth,middleRodHolderLength,middleRodHolderHeight]);

        // Holes for wires
        for(i = [0:90:270])
        rotate(i,[0,0,1])
        translate([holeCenterDistance,0,holeHeightDifference])
        rotate(-90-holeAngle, [0,1,0])
        translate([0,0,-1])
        bendTube(holeAngledLength+1, height, wireRadius+wireTolerance, holeAngle, [0,1,0]);
        
    }
}

//middleMotorMount();
module outerPrintHead(){
    screwLength = 20;
    screwType = "M3";
    
    holeHeightDifference = 0;
    holeAngle = 45;
    holeAngledLength = 10;
    
    holeRadius = wireRadius+wireTolerance;
    holeCenterDistance = middleRodHolderLength/2 + sin(holeAngle)*holeAngledLength + holeRadius + wallStrength;
    echo(holeCenterDistance);

    
    //height = (bearingOuterRadius+wallStrength)*2;
    height = (bearingSpacerSize+bearingInnerRadius)*2;
    
    
    // Bearing holder
    translate([0,-middleRodHolderLength/2,0])
    rotate(90,[-1,0,0]){
    cylinder(bearingSpacerWidth, r=bearingSpacerSize+bearingInnerRadius);
    translate([0,0,bearingSpacerWidth])
    cylinder(bearingWidth+bearingMountExtraWidth, r=bearingInnerRadius);
    }
    
    difference(){
    union(){
   
    //Base
    difference(){
        union(){
        translate([0,0,bearingSpacerSize+bearingInnerRadius-height])
        intersection(){
        translate([-holeCenterDistance,-holeCenterDistance,0])
        cube([holeCenterDistance*2,holeCenterDistance+middleRodHolderLength/2,height]);
        //cylinder(10, r=holeCenterDistance/0.93);
        }
        
        translate([0,-holeCenterDistance,0])
        rotate(90,[-1,0,0])
        cylinder(holeCenterDistance*2,r=middleRodHolderWidth/2+wallStrength);
        
            for(i = [0:90:270])
    rotate(i,[0,0,1])
    translate([middleRodHolderLength/2+ wallStrength+holeRadius,0,bearingSpacerSize+bearingInnerRadius-height])
    rotate(180,[1,0,0])
    scale([1,2,1])
    difference(){
    cylinder((holeCenterDistance-middleRodHolderLength/2),(holeCenterDistance-middleRodHolderLength/2)/2,0);
    translate([0,0,(holeCenterDistance-middleRodHolderLength/2)/2])
        cylinder((holeCenterDistance-middleRodHolderLength/2),r=(holeCenterDistance-middleRodHolderLength/2)/2);
        }
        }
        
        
        
        translate([-holeCenterDistance-1,-holeCenterDistance-1,bearingSpacerSize+bearingInnerRadius])
        cube([holeCenterDistance*2+2,holeCenterDistance*2+2,holeCenterDistance]);
        
        translate([-holeCenterDistance-1,middleRodHolderLength/2,-holeCenterDistance])
        cube([holeCenterDistance*2+2,holeCenterDistance*2+2,holeCenterDistance*2]);
        
        translate(-[0,middleRodHolderLength/2,0]){
        translate([-holeCenterDistance-1,0,-holeCenterDistance])
        cube([holeCenterDistance+1,middleRodHolderLength+1,holeCenterDistance*2]);
        rotate(90,[-1,0,0])
        cylinder(middleRodHolderLength+1,r=middleRodHolderWidth/2);
        }
        
        
    }
    }
    

    
    // Holes for wires
    for(i = [0:90:270])
    rotate(i,[0,0,1])
    translate([holeCenterDistance,0,holeHeightDifference])
    rotate(-90-holeAngle, [0,1,0]){
        
        bendTube(holeAngledLength, height+50, holeRadius, holeAngle, [0,1,0]);
        rotate(180,[0,1,0])
        cylinder(holeRadius*5,holeRadius,holeRadius*5+holeRadius);
    }
    
    //Screw Holes
    for(i = [0,180])
    rotate(i,[0,0,1])
    for(j=[1,3])
    translate([middleRodHolderWidth/2+(holeCenterDistance-middleRodHolderWidth/2)*j/4,middleRodHolderLength/2+(holeCenterDistance-middleRodHolderLength/2)-screwLength,0])
    rotate(90,[-1,0,0])
    rotate(0,[0,0,1])
    screwHole(screwType,screwLength,true);

    }
    
    
}

module assembly(){
    translate([0,0,-bearingHolderWidth/2])
    axisConnector();
    middleBit();
    
    for(i = [0,180])
    rotate(i,[0,0,1])
    middleMotorMount();
   
}

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 1 : 0.1 ;

//assembly();
//middleMotorMount();
//middleBit();
//axisConnector();
//printHeadTop();
outerPrintHead();
//printHeadBottom();