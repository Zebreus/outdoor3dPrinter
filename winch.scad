include <components/stepperPlate.scad>
include <components/screwThread.scad>
include <components/screwHole.scad>
include <sizes.scad>

profileWidth = 20;
profileScrewType = "M4";
profileScrewHeadSize = 2;
wallStrength = 3;
height = 50;
stepperType = "NEMA 17";
width = stepperWidth(stepperType);


stepperScrewLength = 10;
stepperShaftLength = 24;
stepperShaftDentRadius = 2.2;
stepperPlateHeight = stepperPlateHeight(stepperType,stepperScrewLength);


winchHeight = 35;
winchBorderHeight = 2;
winchBorderSize = 1;
winchOffset = 9;
winchRadius = 13.5;
winchScrewType = "M8";

winchThreadExtraDepth = 1;
    
wireRadius = 0.75;
//0.4 To small
wireTolerance = 0.5;

pulleyInnerRadius = 2.05;
pulleyOuterRadius = 5;
pulleySpacerSize = 1.5;
pulleyWidth = 7;

bearingOuterRadius = 11;
bearingMountExtraWidth = 0.1;
bearingWidth = 7;
bearingSpacerWidth = 0.8;
bearingSpacerSize = 1.75;
bearingHolderScrewType = "M4";
bearingHolderScrewLength = 10;
bearingHolderScrewHeadSize = 2;
bearingHolderScrewHeadHeight = 2.5;
bearingHolderHeight = max(bearingWidth+wallStrength+bearingSpacerWidth+bearingMountExtraWidth,(threadRadius(bearingHolderScrewType)+bearingHolderScrewHeadSize+wallStrength)*2);
bearingHolderWidth = max(profileWidth,(bearingOuterRadius+wallStrength)*2);
bearingHolderMountWidth = bearingHolderScrewHeadHeight+nutThickness(bearingHolderScrewType);

grooveDepth = wireRadius*2+wireTolerance+winchThreadExtraDepth;
grooveOffset = (2*sin(45)-1)*wireRadius+wireTolerance;
pitch = 2*grooveDepth;

// 0.3 too small
winchHolderDistance = 0.7;


//TODO Stabilität
module winchbase(){
    firstScrewOffset = 10;
    supportAngle = 45;

    assert(threadRadius(winchScrewType) != undef, str("The radius is not defined for the winch screw type ",winchScrewType));
    assert(threadRadius(profileScrewType) != undef, str("The radius is not defined for the profile screw type ",winchScrewType));
    assert(stepperWidth(stepperType) != undef, str("The stepper width is not defined for ",stepperType));
    


    armWidth = profileWidth;

    pulleySpacerWidth = width/2-winchRadius-wireRadius-pulleyWidth/2;
    pulleyWinchDistance = winchHeight*4/3;
    pulleyPositionHeight = winchOffset+winchHeight/2+pulleyOuterRadius-stepperPlateHeight;

    stepperPlate(stepperType, height=stepperPlateHeight, center = false);
    
    translate([width,0,0])
    cube([wallStrength,width,stepperPlateHeight]);
    
    translate([width,0,stepperPlateHeight])
    difference(){
        union(){
            translate([0,(width-armWidth)/2,0])
            cube([wallStrength,armWidth,height+wallStrength]);
            
            translate([wallStrength,0,0])
            rotate(-90,[0,1,0]){
            difference(){
                cube([width,width,wallStrength]);
                for(i = [0,180])
                translate([0,width/2,wallStrength/2])
                rotate(i,[1,0,0])
                translate(-[0,width/2,wallStrength/2])
                rotate(-60,[0,0,1])
                translate([0,0,-1])
                cube([width*2,width*2,wallStrength+2]);
            }
            
                translate([pulleyPositionHeight,width/2,0]){
                    translate([-armWidth/2,0,0])
                    cube([armWidth,pulleyWinchDistance,wallStrength]);
                    translate([0,pulleyWinchDistance,0])
                    cylinder(wallStrength, d=armWidth);
                }
                
                translate([pulleyPositionHeight,width/2+pulleyWinchDistance, wallStrength]){
                    cylinder(pulleySpacerWidth,r=pulleyInnerRadius+pulleySpacerSize);
                    translate([0,0,pulleySpacerWidth])
                    cylinder(pulleyWidth,r=pulleyInnerRadius);
                }
                
                translate([pulleyPositionHeight-pulleyInnerRadius-pulleySpacerSize,width/2, wallStrength]){
                    cube([(pulleyInnerRadius+pulleySpacerSize)*2,pulleyWinchDistance,pulleySpacerWidth-bearingSpacerWidth]);
                }
                
                /*
                //Top support
                for(i = [0, armWidth-wallStrength])
                translate([height-armWidth,(width-armWidth)/2+wallStrength+i,wallStrength])
                rotate(90,[1,0,0])
                linear_extrude(wallStrength)
                polygon([
                    [0,0],
                    [armWidth,0],
                    [armWidth,armWidth]
                ]);
                */
                //Bottom support
                /*
                translate([0,width/2+width/(3*2),wallStrength])
                rotate(90,[1,0,0])
                linear_extrude(width/3)
                polygon([
                    [0,0],
                    [0,width/2-winchBorderSize-winchRadius],
                    [profileWidth-stepperPlateHeight-threadRadius(profileScrewType)-1,0]
                ]);
                */
                
                
            }
            
            borderDistance = (stepperWidth(stepperType)-armWidth)/2;
            extraHeight = 5;
            winchHolderRadius = winchRadius+grooveDepth-grooveOffset+winchHolderDistance;
            winchHolderOuterRadius = winchHolderRadius+wallStrength;
            // Winch holder
            difference(){
            union(){
                translate([-stepperWidth(stepperType)/2,borderDistance,0])
                cube([stepperWidth(stepperType)/2+wallStrength,stepperWidth(stepperType)-borderDistance*2,height]);
                translate([-stepperWidth(stepperType)/2,stepperWidth(stepperType)/2,0])
                cylinder(winchHeight+winchOffset-stepperPlateHeight+wallStrength,r=winchHolderRadius+wallStrength);
                
                difference(){
                translate([-stepperWidth(stepperType)/2,stepperWidth(stepperType)/2,0])
                rotate(-45,[0,0,1])
                cube([winchHolderOuterRadius,winchHolderOuterRadius,height]);
                
                translate([wallStrength,0,0])
                cube([stepperWidth(stepperType),stepperWidth(stepperType),height]);
                }
                
            }
            
            //Core cutout
            translate([-stepperWidth(stepperType)/2,stepperWidth(stepperType)/2,0])
            cylinder(height,r=winchRadius+grooveDepth-grooveOffset+winchHolderDistance);
            
            //Print support cutout
            difference(){
            union(){
            translate([-stepperWidth(stepperType)/2+winchRadius+winchHeight/2,stepperWidth(stepperType)/2,(winchHeight/2+winchOffset-stepperPlateHeight)])
            rotate(135,[0,-1,0])
            cube([sqrt(2*pow(winchHeight/2,2)),winchHolderRadius+wallStrength,sqrt(2*pow(winchHeight/2,2))]);
             
            translate([-stepperWidth(stepperType)/2+winchRadius,stepperWidth(stepperType)/2,(winchOffset-stepperPlateHeight)])
            cube([sqrt(2*pow(winchHeight/2,2)),winchHolderRadius+wallStrength,winchHeight]);
                
            }
            
            translate([-stepperWidth(stepperType)/2+winchRadius+wireRadius*2,0,0])
            cube([stepperWidth(stepperType)/2,stepperWidth(stepperType),height]);
            }
            
            //Top cutout
            translate([-stepperWidth(stepperType)/2,stepperWidth(stepperType)/2,0])
            rotate(135,[0,0,1])
            cube([winchHolderRadius,winchHolderRadius,height]);
            }
        }
        
        // Profile screw holes
        for(i = [0:profileWidth:height-threadRadius(profileScrewType)-profileWidth+stepperPlateHeight])
        translate([0,width/2,i+profileWidth-stepperPlateHeight]){
        translate([-1,0,0])
        rotate(90,[0,1,0])
        cylinder(wallStrength+2,r=threadRadius(profileScrewType));
        translate([-profileWidth,0,0])
        rotate(90,[0,1,0])
        cylinder(profileWidth,r=threadRadius(profileScrewType)+profileScrewHeadSize);
        }
    }
    translate([stepperWidth(stepperType)+wallStrength,(stepperWidth(stepperType)-bearingHolderWidth)/2,height+stepperPlateHeight])
    mirror([1,0,0])
    difference(){
        
    cube([bearingHolderMountWidth,bearingHolderWidth,bearingHolderHeight]);
    
    for(i = [1,2])
    translate([0,bearingHolderWidth*i/3,bearingHolderHeight/2])
    rotate(90,[0,1,0]){
    cylinder(bearingHolderScrewHeadHeight, r=threadRadius(bearingHolderScrewType)+bearingHolderScrewHeadSize);
    cylinder(bearingHolderScrewHeadHeight+nutThickness(bearingHolderScrewType)+1, r=threadRadius(bearingHolderScrewType));
    }
    }

    
}

module bearingHolder(){
   
    // Bearing holder
    translate([width/2,width/2,height+stepperPlateHeight])
    difference(){
        union(){
            cylinder(bearingHolderHeight, r=bearingHolderWidth/2);
            translate([0,-bearingHolderWidth/2,0])
            cube([width/2+wallStrength-bearingHolderMountWidth,bearingHolderWidth,bearingHolderHeight]);
        }
    
    for(i = [-1,1])
    translate([width/2+wallStrength-bearingHolderMountWidth-bearingHolderScrewLength+nutThickness(bearingHolderScrewType)*4/5,bearingHolderWidth*i/6,bearingHolderHeight/2])
        rotate(90,[-1,0,0])
    rotate(90,[0,1,0])

    screwHole(bearingHolderScrewType, bearingHolderScrewLength-nutThickness(bearingHolderScrewType)*4/5, true,true);
        
        
        translate([0,0,bearingHolderHeight-bearingSpacerWidth-bearingWidth]){
            cylinder(bearingSpacerWidth+1,r=bearingOuterRadius- bearingSpacerSize);
            translate([0,0,bearingSpacerWidth]){
                cylinder(bearingWidth+1,r=bearingOuterRadius);
                intersection(){
                    rotate(225,[0,0,-1])
                    cube([bearingOuterRadius,bearingOuterRadius,bearingWidth+1]);
                    cylinder(bearingWidth+1,r=bearingOuterRadius+wallStrength*0.5);
                }  
            } 
        }
        translate([0,0,-1])
        cylinder(bearingHolderHeight+2,r=((bearingOuterRadius-bearingSpacerSize)+threadRadius(winchScrewType))/2);
    }  
}



//TODO besten winkel für borders finden
//TODO Loch verbessern
//DONE borders abflachen
//DONE Loch l förmig machen
//DONE Motorloch passt
//DONE Montierbar
//TODO wire tolerance integrieren
module winch(){
    
    shaftDepth = stepperShaftLength-winchOffset;
    
    counterScrewDepth = winchHeight-shaftDepth-wallStrength;
    
    //For the bendy thing
    heightChange = winchBorderHeight+wireRadius;
    bendRadius = winchRadius*3/5;
    tubeRadius = wireRadius+wireTolerance;
    
    assert(threadRadius(winchScrewType) != undef, str("The thread radius is not defined for the winch screw type ",winchScrewType));
    counterScrewRadius = threadRadius(winchScrewType);
    
    assert(stepperShaftRadius(stepperType) != undef, str("The stepper shaft radius is not defined for ",stepperType));
    shaftRadius = stepperShaftRadius(stepperType);

    difference(){
    union(){
        
            //translate([0,0,winchHeight-winchBorderHeight])
            //cylinder(winchBorderHeight,winchRadius,winchRadius+winchBorderSize);
            //cylinder(winchBorderHeight,r=winchRadius+winchBorderSize);
        
        rotate(90,[0,0,1])
        render(convexity=6)
        difference(){
        
        cylinder(winchHeight,r=winchRadius+grooveDepth-grooveOffset);
                translate([0,0,winchBorderHeight-pitch/2+wireRadius])
    screwThread(innerRadius=winchRadius-grooveOffset,
                outerRadius=winchRadius-grooveOffset+grooveDepth,
                height=winchHeight+winchBorderHeight,
                pitch=pitch,
                shape= [
                    [1,0],
                    [0,0.5],
                    [1,1]
                ],

                /*shape= [
                    [1,0],
                    [(0.5-(2*sin(45)-1)/2)/(1+winchThreadExtraDepth),0],
                    [0,(1-(2*sin(45)-1))/(2.71+winchThreadSpacingHeight)],
                    [0,(1+(2*sin(45)-1))/(2.71+winchThreadSpacingHeight)],
                    [1,(2.71+winchThreadExtraDepth)/(2.71+winchThreadSpacingHeight)]
                ],*/
                cutBottom = false, cutTop=true);
        }
        
        /*
        difference(){
        translate([0,winchRadius+wireRadius,winchBorderHeight+wireRadius])
        bendyThing(bendRadius-winchBorderHeight-wireRadius*2-wireTolerance,bendRadius,pitch/2, onlyFirstHalf = true);
        translate([-winchRadius*2,-winchRadius*2,-winchRadius*4])
        cube([winchRadius*4,winchRadius*4,winchRadius*4]);
        }*/
    }
    
    
    translate([0,winchRadius+wireRadius,winchBorderHeight+wireRadius]){

            //rotate(90,[0,-1,0])
            //cylinder(winchRadius,r=tubeRadius);
            bendyThing(bendRadius-winchBorderHeight-wireRadius*2-wireTolerance,bendRadius,tubeRadius,winchHeight,winchHeight);
    }

    translate([0,0,-1])
    intersection(){
        cylinder(shaftDepth+1, r=shaftRadius);
        translate([-shaftRadius*2,-stepperShaftDentRadius])
        cube([shaftRadius*4,shaftRadius*4,shaftDepth+1]);
    }
    
    translate([0,0,winchHeight-counterScrewDepth])
    cylinder(counterScrewDepth+1, r=counterScrewRadius);
    
    }
    
}

module bendyThing(
heightChange,
bendRadius,
tubeRadius,
extraLength,
extraBottomLength,
onlyFirstHalf = false
){

    
    
    specialAngle = acos((heightChange/(bendRadius/sqrt(2))/2)*sqrt(2)/sqrt(2))-45;
   
    rotate(specialAngle,[1,0,0])
    translate([0,-bendRadius,0]){
    mirror([1,-1,0])
    rotate_extrude(angle=90)
    //rotate(45,[1,0,0])
    translate([bendRadius,0,0])
    circle(r=tubeRadius);
    
    if(onlyFirstHalf != true){
    //rotate()
    translate([bendRadius*sin(90),0,0])
    rotate(90,[0,1,0])
    rotate(90,[0,0,-1])
    translate([0,-bendRadius,0])
    mirror([1,-1,0]){
        rotate_extrude(angle=90+specialAngle)
        translate([bendRadius,0,0])
        circle(r=tubeRadius);
        
        rotate(90+specialAngle,[0,0,1])
        translate([bendRadius,0,0])
        rotate(90,[-1,0,0]){
        if(extraLength != undef){
            cylinder(extraLength, r=tubeRadius);
        }
        if(extraBottomLength != undef){
            rotate(180,[1,0,0])
            cylinder(extraBottomLength, r=tubeRadius);
        }
        }
        
    }
    }
    }
    
    
    
}

module assembly(){
width = stepperWidth(stepperType);
winchbase();
translate([width/2,width/2, winchOffset])
winch();
}

module evaluateWinch(){
    circumference = 2*PI*winchRadius;
    realCircumference = norm([circumference,pitch]);
    echo(str("Circumference: ", realCircumference, "mm"));
    
    stepsPerRevolution = 180;
    microStepping = 16;
    
    stepsPerMM = (stepsPerRevolution*microStepping)/realCircumference;
    
    //TODO bottom homing backoff
    //TODO Distance to pulley
    //TODO height
    //TODO Think of something to calibrate and fix exact winch height
}

evaluateWinch();

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 0.5 : 0.1 ;

winchbase();

//winch();
//color("Red")
//bearingHolder();
//assembly();