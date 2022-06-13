module spindle(){
    $fn = 32;
    innerRadius = 3.5;
    outerRadius = 4.0;
    pitch = 1.5;
    steps = 32;
    length = 30;
    
    %cylinder(length, r=innerRadius);
    
// too round
/*    for(i = [0:steps]){
    translate([sin(i*360/steps)*(outerRadius-innerRadius),cos(i*360/steps)*(outerRadius-innerRadius),(pitch/steps)*i])
    cylinder((pitch/steps), r=innerRadius);
    }
    */

    for(i = [0:steps]){
        
        stepHeightIncrease = (pitch/steps);
        
        baseWidth = outerRadius-innerRadius;
        baseDepth = (PI*2*outerRadius)/steps;
        baseHeight = pitch/2;
        nextBaseHeight = baseHeight + stepHeightIncrease;
        
        
        
        CubePoints = [
            [  0,  0,  0 ],  //0
            [ baseWidth,  0,  0 ],  //1
            [ baseWidth,  baseDepth,  0 + stepHeightIncrease],  //2
            [  0,  baseDepth,  0 + stepHeightIncrease ],  //3
            [  0,  0,  baseHeight ],  //4
            [ baseWidth,  0,  baseHeight ],  //5
            [ baseWidth,  baseDepth,  baseHeight + stepHeightIncrease],  //6
            [  0,  baseDepth,  baseHeight + stepHeightIncrease]]; //7
            
        CubeFaces = [
            [0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]]; // left
  

        
        rotate(i*360/steps,[0,0,1])
        translate([0,0,stepHeightIncrease*i])
        translate([innerRadius,0,0])
        translate([0,-(PI*2*outerRadius)/steps/2,0])
        polyhedron( CubePoints, CubeFaces );
        //cube([outerRadius-innerRadius,(PI*2*outerRadius)/steps,pitch/2]);
    }

}