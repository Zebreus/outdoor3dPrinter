// A B6 profile

module cutoutB6(){
// Main cutout
maxSlotWidth = 12;
minSlotWidth = 7;
slotDepth = 5.5;
slotStartDepth = 1.5;
slotOpening = 6;
profileWidth = 20;

frontCutWidth = 6.5;
frontCutDepth = 0.5;

innerCoreRadius = 2.75;
outerCoreRadius = 3.55;

roundEdgeRadius = 1.5;

center = [profileWidth/2,profileWidth/2];
depthStartAngle = slotDepth-(maxSlotWidth-minSlotWidth)/2;
    
cutout = [
    [(profileWidth-frontCutWidth)/2,-1],
    [(profileWidth-frontCutWidth)/2,frontCutDepth],
    [(profileWidth-slotOpening)/2,frontCutDepth],
    [(profileWidth-slotOpening)/2,slotStartDepth],
    [(profileWidth-maxSlotWidth)/2,slotStartDepth],
    [(profileWidth-maxSlotWidth)/2, depthStartAngle],
    [(profileWidth-minSlotWidth)/2,slotDepth],
    [profileWidth/2-1,slotDepth],
    [profileWidth/2,slotDepth+0.5],
    [profileWidth/2+1,slotDepth],
    [profileWidth-(profileWidth-minSlotWidth)/2,slotDepth],
    [profileWidth-(profileWidth-maxSlotWidth)/2,depthStartAngle],
    [profileWidth-(profileWidth-maxSlotWidth)/2,slotStartDepth],
    [profileWidth-(profileWidth-slotOpening)/2,slotStartDepth],
    [profileWidth-(profileWidth-slotOpening)/2,frontCutDepth],
    [profileWidth-(profileWidth-frontCutWidth)/2,frontCutDepth],
    [profileWidth-(profileWidth-frontCutWidth)/2,-1]
    ];
    
simpleCutout = [
    [(profileWidth-frontCutWidth)/2,-1],
    [(profileWidth-frontCutWidth)/2,frontCutDepth],
    [(profileWidth-slotOpening)/2,frontCutDepth],
    [(profileWidth-slotOpening)/2,slotStartDepth],
    [(profileWidth-maxSlotWidth)/2,slotStartDepth],
    [(profileWidth-maxSlotWidth)/2, depthStartAngle],
    [(profileWidth-minSlotWidth)/2,slotDepth],
//    [profileWidth/2-1,slotDepth],
//    [profileWidth/2,slotDepth+0.5],
//    [profileWidth/2+1,slotDepth],
    [profileWidth-(profileWidth-minSlotWidth)/2,slotDepth],
    [profileWidth-(profileWidth-maxSlotWidth)/2,depthStartAngle],
    [profileWidth-(profileWidth-maxSlotWidth)/2,slotStartDepth],
    [profileWidth-(profileWidth-slotOpening)/2,slotStartDepth],
    [profileWidth-(profileWidth-slotOpening)/2,frontCutDepth],
//    [profileWidth-(profileWidth-frontCutWidth)/2,frontCutDepth],
//    [profileWidth-(profileWidth-frontCutWidth)/2,-1]
    ];

for(i = [0:90:270])
translate(center)
rotate(i)
translate(-center)
//polygon(cutout);
polygon(simpleCutout);

// Core
/*translate(center)
circle($fn=16, innerCoreRadius);

translate(center)
difference(){
    circle($fn=16, outerCoreRadius);
    for(i = [0:90:270])
    rotate(i+45)
    translate([0.7,0.7])
    square(outerCoreRadius);
}*/

// Round edges
for(i = [0:90:270])
translate(center)
rotate(i)
translate(-center)
difference(){
    translate([-1,-1])
    square(roundEdgeRadius+1);
    translate([roundEdgeRadius,roundEdgeRadius])
    circle($fn=8, roundEdgeRadius);
}

}

module profileB6(length, center=false){
width = 20;
position = center? -[length/2,width/2,width/2] : [0,0,0];

translate(position)
translate([width/2,width/2,width/2])
rotate(90,[0,1,0])
translate(-[width/2,width/2,width/2])
linear_extrude(length)
difference(){
    square(width);
    cutoutB6();
}

}

module connectorB6(){
    profileWidth = 20;
    connectorWidth = 18;
    connectorHeight = 18;
    baseDepth = 3.7;
    wallDepth = 1;
    slotWidth = 6;
    holeWidth = 4.5;
    holeHeight = 7.2;
    
    center = [profileWidth/2,profileWidth/2,connectorHeight/2];
    
    translate([0,0,(profileWidth-connectorWidth)/2])
    difference(){
        cube([connectorHeight,connectorHeight,connectorWidth]);
        
        translate([baseDepth,baseDepth,wallDepth])
        cube([connectorHeight,connectorHeight,connectorWidth-(2*wallDepth)]);
        
        translate([connectorHeight+baseDepth,0,-1])
        rotate(45,[0,0,1])
        cube([connectorHeight*2,connectorHeight*2,connectorWidth+2]);
        
        for(i = [0,-90])
        translate(center)
        rotate(i)
        translate(-center)
        translate([profileWidth/2,baseDepth/2,connectorWidth/2])
        cube([holeHeight,baseDepth+2,holeWidth], center = true);
    }
    
}

rotate(90,[0,-1,0])
profileB6(200);

//connectorB6();