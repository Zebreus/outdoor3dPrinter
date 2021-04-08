use <../sizes.scad>

$stepperPlateHoleTolerance = 0;
$stepperPlateHoleLengthMultiplier = 1;

function stepperPlateHeight(type, boltLength, height) = 
    assert(height != undef || (boltLength != undef && stepperBoltDepth(type) != undef), str("You either have to define height, or boltLength and a stepper bolt depth for ",type))
    assert(!(height != undef && boltLength != undef), "You cannot define height and boltLength")
    height != undef ? height : boltLength-stepperBoltDepth(type);

module stepperPlate(
  type,
  boltLength,
  width,
  height,
  boltType,
  center = true
  ){
    boltType = boltType != undef ? boltType : stepperBoltType(type);
    assert(boltType != undef, "You need to define a boltType.");

    size = width != undef ? width : stepperWidth(type);
    height = stepperPlateHeight(type,boltLength,height);
    
    boltCenterDistance = stepperBoltDistance(type);
    assert(boltCenterDistance != undef, str("The stepper bolt center distance is not defined for ", type));
    
    motorHoleRadius = stepperCenterRadius(type);
    assert(motorHoleRadius != undef, str("The stepper center radius is not defined for ", type));
      
    boltRadius = threadRadius(boltType);
    assert(boltRadius != undef, str("The thread diameter is not defined for ", boltType));
    
    
    centerVector = center == true ? [0,0,0] : [size/2,size/2,0];
    translate(centerVector)
    difference(){
    translate([-size/2,-size/2,0])
    cube([size,size,height]);
    translate([0,0,-1])
    linear_extrude(height+2){
        //Motor hole
        circle(r=motorHoleRadius);
            
        //Mounting holes
        for(r = [0:90:270])
        rotate(r,[0,0,1])
        translate(-[sin(45)*boltCenterDistance,sin(45)*boltCenterDistance,0])
        hull(){
            offset = boltRadius*0.5*$stepperPlateHoleLengthMultiplier;
            for(offset = [-offset,offset])
            translate([sin(45)*offset,sin(45)*offset,0])
            circle($fn=12,boltRadius+$stepperPlateHoleTolerance);
        }
    }
    }
}

//stepperPlate("NEMA 17", boltLength=10, center = false);