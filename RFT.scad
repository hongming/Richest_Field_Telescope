//多边形module
module cylinder_outer(height,radius,fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}

module cube_right_angle(width,height,length){
translate([-width/2,0,length/2+5]){
difference(){
cube([width,height,length],center=true);
translate([-2,-2,2]){
cube([width,height+8,length],center=true);
}
}
}
}


module cube_right_angle_base(width,height,length){
translate([-width/2,0,length/2+5]){
difference(){
cube([width,height,length],center=true);
translate([-2,-2,-2]){
cube([width,height+8,length],center=true);
}
}
}
}


module cube_right_angle_up(width,height,length){
translate([-width/2,0,length/2+4.5]){
difference(){
cube([width,height,length],center=true);
translate([2,-2,2]){
cube([width,height+8,length],center=true);
}
}
}
}


module cube_truss_left(width,height,length){
 
translate([-15-10,2,4.5]){
difference(){

cube([width,length,height]);
 
translate([1,1,0]){
cube([width-2 ,length-2,height+2]);}
} } }

module cube_truss_right(width,height,length){
 
translate([-15-10,-12,4.5]){
difference(){

cube([width,length,height]);
 
translate([1,1,0]){
cube([width-2 ,length-2,height+2]);}
} } }


 

//最低托盘
 
difference(){
cylinder_outer(5,100,6);
cylinder(12,50,50,center=true);
}


for(a=[0:1:2])
{
	rotate([0,0,a*120]){
translate([100*cos(30),100*sin(30),0]){
rotate([0,0,30]){
 cube_right_angle(15,115,15);}}
}

}


for(a=[0:1:2])
{
	rotate([0,0,a*120]){
translate([70*cos(30),70*sin(30),0]){
rotate([0,0,30]){
 cube_right_angle_base(30,175,10);}}
}
}



//顶部副镜支架

translate([0,0,450]){
 rotate([180,0,90]){

difference(){
cylinder(9,100,100,center,$fa=1,center=true);
cylinder(11,87.5,90,center,$fa=1,center=true);}
 
for(a=[0:1:2]){
rotate([0,0,a*120]){
translate([-87.5+2,0,0]){

 cube_right_angle_up(15,25,15);
rotate([-4.499,0,0]){
cube_truss_left(10,450,10);
}
//4.499为预估
rotate([4.499,0,0]){
cube_truss_right(10,450,10);
 }

}
}}
}}