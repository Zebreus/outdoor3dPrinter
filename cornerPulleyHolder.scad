include <components/screwHole.scad>
include <sizes.scad>

module copy_mirror(vec)
{
    children();
    mirror(vec)
    children();
}

module cornerPulleyHolder(){
    profileWidth = 20;
    connectorWidth = 18;
    connectorHeight = 38;
    baseDepth = 3.7;
    wallDepth = 1;
    slotWidth = 6;
    screwType = "M4";
    screwHeadRadius = 4;
    screwLength = 16;
    
    holderLength = 20;
    
    holderHeight = 35;

    axisScrewType = "M4";
    pulleyOuterRadius = 5;
    pulleyWidth = 7;
    pulleySpacerWidth = 0.5;
    pulleySpacerRadius = 3;
    wireRadius = 1;
    
    screwLengthInNut = nutThickness(screwType)*2/3;
    cutoutWidth = pulleyWidth+2*pulleySpacerWidth;
    holderScrewDepth = (screwLength-pulleyWidth-pulleySpacerWidth/2-screwLengthInNut)/2;
    holderWidth = nutThickness(screwType)+holderScrewDepth;
    
    translate([0,0,(profileWidth-connectorWidth)/2]){
    difference(){
        cube([connectorHeight,connectorHeight,connectorWidth]);
        
        translate([baseDepth,baseDepth,wallDepth])
        cube([connectorHeight,connectorHeight,connectorWidth]);
        
        translate([connectorHeight+baseDepth,0,-1])
        rotate(45,[0,0,1])
        cube([connectorHeight*2,connectorHeight*2,connectorWidth+2]);
        
        for(i = [0,90])
        translate([baseDepth/2,baseDepth/2,0])
        rotate(i, [0,0,1])
        translate(-[baseDepth/2,baseDepth/2,0])
        translate([connectorHeight-connectorWidth/2,baseDepth/2,connectorWidth/2])
        rotate(90,[1,0,0])
        translate([0,0,-(baseDepth+2)/2])
        screwHole(screwType, baseDepth+2);
    }
    
    completeHolderWidth = holderWidth*2+pulleySpacerWidth*2+pulleyWidth;
    
    center = [completeHolderWidth/2, holderLength/2, 0];
    
    difference(){
    translate([0,sin(45)*(pulleySpacerWidth*2+pulleyWidth),0])
    rotate(45,[0,0,-1])
    translate([-holderWidth,0,0])
    difference(){
    union(){
        translate(center)
        copy_mirror([1,0,0])
        translate(-center)
        {
            cube([holderWidth, holderLength, holderHeight]);
            translate([holderWidth, holderLength*3/4, holderHeight-pulleySpacerRadius])
            rotate(90,[0,1,0])
            cylinder(pulleySpacerWidth,r=pulleySpacerRadius);
        }
    }
    
    translate([0,holderLength*3/4,holderHeight-pulleySpacerRadius])
    rotate(90,[0,1,0])
    rotate(90,[0,0,-1])
    screwHole($screwHoleTolerance = 0.2, $nutSlotExtraHeight = 0,axisScrewType, completeHolderWidth*2,true,false, nutSlotLength=0);
    
    translate([holderWidth+pulleySpacerWidth*2+pulleyWidth+holderScrewDepth,holderLength*3/4,holderHeight-pulleySpacerRadius])
    rotate(90,[0,1,0])
    cylinder(holderLength-holderScrewDepth,r=screwHeadRadius);
    
    }
    
    copy_mirror([1,-1,0])
    translate([0,-holderWidth,-1])
    cube([completeHolderWidth,holderWidth,holderHeight+2]);
    
    copy_mirror([1,-1,0])
    translate([connectorHeight,-1,connectorWidth/2])
    rotate(135,[0,1,0])
    rotate(90,[-1,0,0])
    cube([sqrt(2*pow(connectorWidth/2,2)),sqrt(2*pow(connectorWidth/2,2)),connectorHeight+baseDepth+1]);
    }
}
    
    
    
}

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 1 : 0.1 ;

union(){
cornerPulleyHolder();
}