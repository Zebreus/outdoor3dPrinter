module screwThreadAllSegments(
innerRadius = 8,
outerRadius = 10,
height = -30,
pitch = -5,
shape = [
    [0,0],
    [1,0.5],
    [0,1]
],
cutBottom = true,
cutTop = true
){

assert(height > 0 || height <= 0, "The height needs to be a number");

assert(pitch > 0 || pitch < 0, "The pitch has to be a nonzero number");

assert(len(shape) >= 3, "The shape needs to have more than three points");

for(point = shape)
assert(len(point) == 2, "The shape needs to consist of 2D points")
    
for(point = shape)
for(value = point)
assert(value >= 0 && value <= 1, "All values of the shape need to be between 0 and 1");


direction = sign(height) == 0 ? 1 : sign(height);

angle = 360*(abs(height)/pitch) + (cutBottom ? sign(pitch)*360 : 0);
segments = round(abs((angle/$fa))+1);
anglePerSegment = angle/segments;

pitchPerSegment = height/segments + (cutBottom?direction*abs(pitch)/segments:0);
    



allPoints = 
[ for(i = [0:1:segments])
  for(point = shape)
  [((outerRadius-innerRadius)*point[0]+innerRadius)*cos(anglePerSegment*i),
   ((outerRadius-innerRadius)*point[0]+innerRadius)*sin(anglePerSegment*i),
   (point[1]*(abs(pitch)))+i*pitchPerSegment]
];
echo(segments);
pointsPerShape = len(shape);

faces = [
  [ for(i= [pointsPerShape-1:-1:0]) i ],
  [ for(i= [len(allPoints)-pointsPerShape:1:len(allPoints)-1]) i ],
  for(i = [0:1:segments-1])
  for(a= [0:1:pointsPerShape-1])
  let (b = (a+1)%pointsPerShape)
  [
    a+(pointsPerShape*i),
    b+(pointsPerShape*i),
    b+(pointsPerShape*(i+1)),
    a+(pointsPerShape*(i+1)),
  ]
  
];

difference(){
translate([0,0,(cutBottom&&direction>0)?-abs(pitch):0])
 polyhedron(allPoints,faces,convexity = 100);
    
    if(cutBottom){
        
        rotate(height>=0?180:0,[1,0,0])
        translate([-outerRadius,-outerRadius,0])
        cube([outerRadius*2,outerRadius*2,abs(pitch)]);
    }
    if(cutTop){
        //translate([0,0,height])
        rotate(height<0?180:0,[1,0,0])
        translate([-outerRadius,-outerRadius,abs(height)])
        cube([outerRadius*2,outerRadius*2,abs(pitch)]);
    }
}
}

module screwThread(
innerRadius = 8,
outerRadius = 10,
height = -30,
pitch = -5,
shape = [
    [0,0],
    [1,0.5],
    [0,1]
],
cutBottom = true,
cutTop = true
){

assert(height > 0 || height <= 0, "The height needs to be a number");

assert(pitch > 0 || pitch < 0, "The pitch has to be a nonzero number");

assert(len(shape) >= 3, "The shape needs to have more than three points");

for(point = shape)
assert(len(point) == 2, "The shape needs to consist of 2D points")
    
for(point = shape)
for(value = point)
assert(value >= 0 && value <= 1, "All values of the shape need to be between 0 and 1");


direction = sign(height) == 0 ? 1 : sign(height);

angle = 360*(abs(height)/pitch) + (cutBottom ? sign(pitch)*360 : 0);
//segments = round(abs((angle/$fa))+1);
//anglePerSegment = angle/segments;
//pitchPerSegment = height/segments + (cutBottom?direction*abs(pitch)/segments:0);

anglePerSegment = $fa;
segments = round(abs(angle)/abs(anglePerSegment))+1;
pitchPerSegment = abs(pitch)/(360/anglePerSegment);
//+ (cutBottom?direction:1);


    



allPoints = 
[ for(i = [0:1:segments])
  for(point = shape)
  let (heightValue = point[1] == 1 ? 0.9999 : point[1])
  [((outerRadius-innerRadius)*point[0]+innerRadius)*cos(anglePerSegment*i),
   ((outerRadius-innerRadius)*point[0]+innerRadius)*sin(anglePerSegment*i),
   (heightValue*(abs(pitch)))+i*pitchPerSegment]
];
echo(segments);
pointsPerShape = len(shape);

faces = [
  [ for(i= [pointsPerShape-1:-1:0]) i ],
  [ for(i= [len(allPoints)-pointsPerShape:1:len(allPoints)-1]) i ],
  for(i = [0:1:segments-1])
  for(a= [0:1:pointsPerShape-1])
  let (b = (a+1)%pointsPerShape)
  each [ [
    a+(pointsPerShape*i),
    b+(pointsPerShape*(i+1)),
    a+(pointsPerShape*(i+1))
  ],
  [
    a+(pointsPerShape*i),
    b+(pointsPerShape*i),
    b+(pointsPerShape*(i+1))
  ] ]
  
];

difference(){
translate([0,0,(cutBottom&&direction>0)?-abs(pitch):0])
 polyhedron(allPoints,faces,convexity = 100);
    
    if(cutBottom){
        
        rotate(height>=0?180:0,[1,0,0])
        translate([-outerRadius,-outerRadius,0])
        cube([outerRadius*2,outerRadius*2,abs(pitch+5)]);
    }
    if(cutTop){
        //translate([0,0,height])
        rotate(height<0?180:0,[1,0,0])
        translate([-outerRadius,-outerRadius,abs(height)])
        cube([outerRadius*2,outerRadius*2,abs(pitch+5)]);
    }
}
}
/*
$fa = 45;
//screwThread(cutBottom = false, cutTop=false);
winchHeight = 35;
winchBorderHeight = 2;
winchBorderSize = 1;
winchOffset = 9;
winchRadius = 13.5;
winchScrewType = "M8";

    
wireRadius = 0.75;
wireTolerance = 0.5;
translate([winchRadius,0,0])
render(convexity=5)
difference(){
    cylinder(winchHeight, r=winchRadius);
    
    screwThread(innerRadius=winchRadius-wireRadius,
                outerRadius=winchRadius+0.0,
                height=31.08,
                pitch=2,
                shape= [[1,0],[0,0.5],[1,1]],
                cutBottom = true, cutTop=true);
}*/