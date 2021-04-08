height = 100;
width = 200;
depth = 200;

drawDebug = true;

pullAnchors = [[0,0,height],[width,0,height],[width,depth,height],[0,depth,height]];

pushAnchors = [[width/2,depth/2,height]];

coreXYDistance = 20;
coreZDistance = 0;
corePullAnchorsRel = [
[-sin(45)*coreXYDistance, -sin(45)*coreXYDistance, coreZDistance],
[ sin(45)*coreXYDistance, -sin(45)*coreXYDistance, coreZDistance],
[ sin(45)*coreXYDistance,  sin(45)*coreXYDistance, coreZDistance],
[-sin(45)*coreXYDistance,  sin(45)*coreXYDistance, coreZDistance]
];

corePushAnchorsRel = [
[0,0,5]
];

x = width/2 + width/4*sin($t*360);
y = depth/2 + depth/4*cos($t*360);
z = 0;
core = [x,y,z];

rawPullLengths = [for(i = [0:1:len(pullAnchors)-1]) 
    norm(pullAnchors[i]-(core+corePullAnchorsRel[i])) ];

rawPushLengths = [for(i = [0:1:len(pushAnchors)-1]) 
    norm(pushAnchors[i]-(core+corePushAnchorsRel[i])) ];

pullLengths = rawPullLengths;
pushLengths = rawPushLengths;



pushStretch = 1;
pullStretch = 4;
colors = ["LimeGreen","MediumVioletRed","Crimson","DodgerBlue","Silver"];

corePullAnchors = [ for(i = [0:1:len(pullAnchors)-1]) corePullAnchorsRel[i]+core ];
corePushAnchors = [ for(i = [0:1:len(pushAnchors)-1]) corePushAnchorsRel[i]+core ];



transparency = 0.1;


intersection(){
union(){
color("Red")
intersection_for(i  = [0:1:len(pullAnchors)-1]){
        translate(pullAnchors[i]-corePullAnchorsRel[i])
        sphere(r=pullLengths[i]-0.01);
};

difference(){
    color("White")
    intersection_for(i  = [0:1:len(pullAnchors)-1]){
        translate(pullAnchors[i]-corePullAnchorsRel[i])
        sphere(r=pullLengths[i]+pullStretch);
    }
    
    for(i  = [0:1:len(pushAnchors)-1])
    translate(pushAnchors[i]-corePushAnchorsRel[i])
    sphere(r=pushLengths[i]-pushStretch);
}
}

cube([width,depth,height]);
}


if($preview && drawDebug)
for(i  = [0:1:len(pushAnchors)-1])
color(colors[i+len(pullAnchors)], transparency*2)
translate(pushAnchors[i])
sphere(5);

if($preview && drawDebug)
for(i  = [0:1:len(pushAnchors)-1])
color(colors[i+len(pullAnchors)], transparency*2)
translate(corePushAnchors[i])
sphere(5);

if($preview && drawDebug)
for(i  = [0:1:len(pullAnchors)-1])
color(colors[i], transparency*2)
translate(pullAnchors[i])
sphere(5);

if($preview && drawDebug)
for(i  = [0:1:len(pullAnchors)-1])
color(colors[i], transparency*2)
translate(corePullAnchors[i])
sphere(5);

if($preview && drawDebug)
for(i  = [0:1:len(pushAnchors)-1])
color(colors[i+len(pullAnchors)], transparency)
translate(pushAnchors[i])
sphere(r=pushLengths[i]);

if($preview && drawDebug)
for(i  = [0:1:len(pullAnchors)-1])
color(colors[i], transparency)
translate(pullAnchors[i])
render()
sphere(r=pullLengths[i]);


$fa = $preview ? 8 : 12 ;
$fs = $preview ? 0.5 : 1 ;