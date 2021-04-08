use <profileB6.scad>
use <winch.scad>
use <quat/maths.scad>

module debugX(level=0){
    rodColor = level == 0 ? "green" : level == 1 ? "yellow" : level == 2 ? "red" : "blue";
    
    length = 4-(level*0.5);
    width = level*0.25+1;
    
    color(rodColor){
    translate([5,0,0])
    cube([10,1,1],center=true);
    translate([0,length/2,0])
    cube([width,length,width],center=true);
    }
    children();
}


module connector(dir1,dir2, profileWidth = 20){
    assert(dir1*dir2 == 0, "The vectors need to be perpendicular");
    
    model1 = [-1,0,0];
    
    model1n = model1/norm(model1);
    dir1n = dir1/norm(dir1);
    
    
    
    axis1 = 
      let (mcross = cross(model1n,dir1n))
      mcross == [0,0,0] ? [0,0,-1] : mcross;

    
    angle1 = acos(model1n*dir1n);
    
    
    matrix1 = quat_to_mat4(quat(axis1, angle1));
    

    
    
    model2gen = matrix1*[0,-1,0,0];
    model2 = [model2gen[0],model2gen[1],model2gen[2]];
    model2n = model2/norm(model2);
    //dir2gen = [dir2[0],dir2[1],dir2[2],0]*matrix1;
     //dir2n = [dir2gen[0],dir2gen[1],dir2gen[2]];
    dir2n = dir2/norm(dir2);
    
    
    yaxisgen = [0,0,1,0] * matrix1;
    //yaxis = [
    
    axis2 = 
      let (mcross = cross(model2,dir2))
      mcross == [0,0,0] ? [-1,0,0,0]*matrix1 : mcross;
      
   axis2gen = [axis2[0],axis2[1],axis2[2],0];
   axis2f = [axis2gen[0],axis2gen[1],axis2gen[2]];
     
    angle2 = acos(dir2*model2);
    matrix2 = quat_to_mat4(quat(axis2f, angle2));
    
    
    angle22 = acos(cross(dir2n,dir1n)*cross(model2,model1));

    matrix3 = matrix2*matrix1;
    
    axis = axis1;
    angle = angle1;
    

    echo(axis1);
    echo(axis2f);
    
    echo(angle1);
    echo(angle2);
    
    echo(model2);
    echo(dir2);
    echo(matrix2);
    
    center = [profileWidth/2,profileWidth/2,profileWidth/2];
    
    translate(center)
    multmatrix(matrix3)
//    debugX(0) // green
//    multmatrix(matrix2)
//    debugX(1) // yellow
    translate(-center)
    connectorB6();
}

module testConnector(){
connector([0,0,-1],[1,0,0]);
translate([0,-25,0])
connector([0,0,-1],[0,1,0]);
translate([0,-50,0])
connector([0,0,-1],[-1,0,0]);
translate([0,-75,0])
connector([0,0,-1],[0,-1,0]);

translate([25,0,0]){
connector([1,0,0],[0,0,-1]);
translate([0,-25,0])
connector([0,1,0],[0,0,-1]);
translate([0,-50,0])
connector([-1,0,0],[0,0,-1]);
translate([0,-75,0])
connector([0,-1,0],[0,0,-1]);
}


translate([75,0,0])
for(z = [-1,1])
translate([0,max(0,z)*-50,0])
{
a = [0,0,z];
b = [z,0,0];
connector(a,b);
translate([0,-25,0])
connector(b,a);
}

translate([50,0,0])
for(z = [-1,1])
translate([0,max(0,z)*-50,0])
{
a = [0,z,0];
b = [0,0,z];
connector(a,b);
translate([0,-25,0])
connector(b,a);
}

translate([100,0,0])
for(z = [-1,1])
translate([0,max(0,z)*-50,0])
{
a = [z,0,0];
b = [0,z,0];
connector(a,b);
translate([0,-25,0])
connector(b,a);
}
}

/*
function create_beam(id, length, otherlist=[]) = concat(otherlist, [id, length]);
function create_connector(id, direction1, direction2, otherlist=[]) = concat(otherlist, [id, direction1, direction2]);
function attach_connector(beamid, connectorid, position, otherlist=[]) = concat(otherlist, [beamid, connectorid, position]);

module drawBeams(beams, connectors, connections){
    for()
}

beams1 = create_beam(1,200);
beams2 = create_beam(2,200, beams1);
connectors = create_connector(100, [0,-1,0],[1,0,0]);
connections = attach_connector(1, 100, 100);
connections = attach_connector(2, 100, 100);
drawBeams(beams2, connectors, connections);
*/

baseHeight = 200;
baseWidth = 300;
module profileDirection(direction){
    translate([10,10,10])
    rotate(acos(direction*[1,0,0]),cross(direction,[-1,0,0]))
    translate(-[10,10,10])
    children();
}

for(x = [0,baseWidth-20])
for(y = [0,baseWidth-20])
translate([x,y,0])
profileDirection([0,0,1])
profileB6(baseHeight-20);

for(x = [0,baseWidth-20])
translate([0,x,baseHeight-20])
profileDirection([1,0,0])
profileB6(baseWidth);

for(y = [0,baseWidth-20])
translate([y,20,baseHeight-20])
profileDirection([0,1,0])
profileB6(baseWidth-40);

for(y = [0:90:270])
translate([baseWidth/2,baseWidth/2,0])
rotate(y,[0,0,1])
translate(-[baseWidth/2,baseWidth/2,0]){
    translate([20,0,baseHeight-40])
    connector([-1,0,0],[0,0,1]);
    translate([0,20,baseHeight-40])
    connector([0,-1,0],[0,0,1]);
}


shaftLength = 22;
shaftHoleDepth = 14;
width = 39.5;

translate([-width-3,-width/2+10,0]){
    winchbase();
    translate([width/2,width/2, shaftLength-shaftHoleDepth])
    winch();
}