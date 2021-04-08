use <sizes.scad>
include <components/nutSlot.scad>
include <components/screwHole.scad>
include <components/stepperPlate.scad>

profileScrewType = "M4";
profileWidth = 20;
stepperType = "NEMA 17";
motorWidth = stepperWidth(stepperType);
motorHeight = 48;    
wallStrength = 3;
axisRadius = 5;

fixedThreadScrewType = "M3";
fixedThreadScrewLength = 8;
fixedThreadRadius = 11;
fixedThreadHeight = 3.5;
fixedThreadScrewCenterDistance = 8;
motorMountHeight = max(
    stepperPlateHeight(stepperType,10),
    stepperCenterDepth("NEMA 17")+fixedThreadScrewLength-fixedThreadHeight+nutThickness(fixedThreadScrewType)*1/3);

bearingInnerRadius = 4;
bearingOuterRadius = 11;
// The bearing wont sit flush against the spacer, because 3d printing
bearingMountExtraWidth = 0.1;
bearingWidth = 7;
bearingSpacerWidth = 0.8;
bearingSpacerSize = 1.75;

extraSideClearance = 3;

module innerMotorMount(){
    bearingHolderTopGap = 10;
    wallHeight = 10;
    
    translate([0,0,-motorHeight/2 - motorMountHeight]){
    translate([0,0,motorMountHeight])
    mirror([0,0,1])
    difference(){
        union(){
            stepperPlate(stepperType,height=motorMountHeight);    
            cylinder(motorMountHeight, r=fixedThreadRadius+1);
        }
        
        translate([0,0,-1])
        cylinder(motorMountHeight+2, r=axisRadius);
        
        translate([0,0,-1])
        cylinder(stepperCenterDepth(stepperType)+1.0001, r=stepperCenterRadius(stepperType)+0.1);
        
        for(i = [0:90:270])
        rotate(i, [0,0,1])
        translate([fixedThreadScrewCenterDistance,0,stepperCenterDepth(stepperType)])
        screwHole($nutSlotExtraHeight = 0.4,fixedThreadScrewType, fixedThreadScrewLength, nutSlot = true, nutSlotPushSlot = false,nutSlotLength = 0);
    }
    
    for(i = [0,180])
    rotate(i,[0,0,1])
    translate([motorWidth/2,bearingOuterRadius+wallStrength,0])
    rotate(180,[1,0,1])
    difference(){
        // Bearing holder base
        union(){
            cube([motorHeight/2+motorMountHeight,bearingOuterRadius*2+wallStrength*2, bearingWidth+wallStrength+bearingSpacerWidth+bearingMountExtraWidth]);
            translate([motorHeight/2+motorMountHeight,bearingOuterRadius+wallStrength,0])
            cylinder(bearingWidth+wallStrength+bearingSpacerWidth+bearingMountExtraWidth,r=bearingOuterRadius+wallStrength);
        }
        // Holes for bearing
        translate([motorHeight/2+motorMountHeight,bearingOuterRadius+wallStrength,wallStrength]){
            cylinder(bearingWidth+1,r=bearingOuterRadius-bearingSpacerSize);
            translate([0,0,bearingSpacerWidth])
            cylinder(bearingWidth+1,r=bearingOuterRadius);
            
            translate([0,0,bearingSpacerWidth])
            intersection(){
            
            rotate(45,[0,0,-1])
            cube([bearingOuterRadius,bearingOuterRadius,bearingWidth+1]);
            cylinder(bearingWidth+1,r=bearingOuterRadius+wallStrength*0.5);
            }
        }
    }
    
    for(i = [0:90:270])
    rotate(i,[0,0,1])
    translate([motorWidth/2,-motorWidth/2-wallStrength,0])
    cube([wallStrength, motorWidth+2*wallStrength, motorMountHeight+wallHeight]);
    
  }
}

module middleMotorMount(){
    extraSideClearance = 3;
    
    screwHoleDepth = 14;
    screwType = "M4";
    nutHeight = 3.2 + 0.6;
    nutRadius = 4.05;
    
    
    innerWidth = (motorWidth/2 + wallStrength + bearingSpacerWidth*2 + bearingWidth + bearingMountExtraWidth*2)*2;
    echo(innerWidth);
    innerLength = (sqrt(pow(motorHeight/2+wallStrength,2) + pow(motorWidth/2+wallStrength,2))+ extraSideClearance) *2;
    
    height = (bearingOuterRadius+wallStrength)*2;
    bearingHolderWidth = bearingWidth+wallStrength+bearingSpacerWidth+bearingMountExtraWidth;
    
    rotate(90,[0,-1,0])
    translate([0,0,-innerWidth/2]){
    
    // Bearing mount
    cylinder(bearingSpacerWidth, r=bearingSpacerSize+bearingInnerRadius);
    translate([0,0,bearingSpacerWidth])
    cylinder(bearingWidth+bearingMountExtraWidth, r=bearingInnerRadius);
    
    // Backplate
    translate([-bearingOuterRadius-wallStrength, -innerLength/2,-wallStrength])
    cube([height, innerLength, wallStrength]);
    
    // Screw hole side
    translate([-height/2,innerLength/2, -wallStrength])
    difference(){
        cube([height, bearingHolderWidth, wallStrength]);
        
        for(i=[1,3])
        translate([(height/4)*i, bearingHolderWidth/2, -1])
        screwHole(screwType,wallStrength+2);
    }
    
    // Bearing side
    translate([-height/2,-innerLength/2-bearingHolderWidth,0])
    difference(){
        translate([0,0, -wallStrength])
        cube([height, bearingHolderWidth, innerWidth+wallStrength]);
        
        for(i=[1,3])
        translate([(height/4)*i, bearingHolderWidth/2, innerWidth-screwHoleDepth])
        screwHole(screwType,screwHoleDepth+1,true);
        
        translate([height/2, 0, innerWidth/2])
        rotate(90,[-1,0,0]){
            translate([0,0,-1])
            cylinder(bearingWidth+1,r=bearingOuterRadius);
            translate([0,0,bearingWidth-1])
            cylinder(bearingSpacerWidth+1,r=bearingOuterRadius- bearingSpacerSize);
            translate([0,0,-1])
            rotate(135,[0,0,-1])
            cube([bearingOuterRadius,bearingOuterRadius,bearingWidth+1]);
        }
    }
    }
}

module outerMotorMount(){
    cornerRounding = 3;
    
    spacerHeight = 5;
    spacerRadius = 10;
    
    
    middleLength = (sqrt(pow(motorHeight/2+wallStrength,2) + pow(motorWidth/2+wallStrength,2))+ extraSideClearance + bearingWidth+wallStrength+bearingSpacerWidth+bearingSpacerWidth+bearingMountExtraWidth*2) *2 ;
    
    height = (bearingOuterRadius+wallStrength)*2;
    width = (spacerRadius+threadDiameter(profileScrewType)+wallStrength*2)*2;
    
    translate([0,-middleLength/2-wallStrength-spacerHeight,0])
    rotate(180,[0,1,1]){
    
    // Base plate
    difference(){
    translate([-width/2,-profileWidth/2,0])
    minkowski(){
        cube([width-2*cornerRounding,profileWidth-2*cornerRounding,wallStrength/2]);
        translate([cornerRounding,cornerRounding,0])
        cylinder(wallStrength/2, r=cornerRounding);
    }
    for(i = [0,180])
    rotate(i,[0,0,1])
    translate([(width/2+spacerRadius)/2,0,-1])
    screwHole(profileScrewType, wallStrength+2);
    }
        
    // Bearing mount
    translate([0,0,wallStrength]){
    cylinder(spacerHeight, r=spacerRadius);
    translate([0,0,spacerHeight]){
        cylinder(bearingSpacerWidth, r=bearingSpacerSize+bearingInnerRadius);
        translate([0,0,bearingSpacerWidth])
        cylinder(bearingWidth+bearingMountExtraWidth, r=bearingInnerRadius);
    }
    }
    }
    
}

module assembly(){
    for(i = [0,180])
    rotate(i,[0,0,1])
    outerMotorMount();
    
    rotate($t*360, [0,1,0]){
        for(i = [0,180])
        rotate(i,[0,0,1])
        middleMotorMount();
        
        rotate($t*360, [1,0,0])
        innerMotorMount();
    }
}

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 1 : 0.1 ;

//outerMotorMount();
//middleMotorMount();
innerMotorMount();