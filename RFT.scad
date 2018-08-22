//底部交叉杆三角形
  module prism(l, w, h){
   
          
          
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
   
       }
 


 

//底部六边形多边形module
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


//底部支撑大梁
module cube_right_angle_base(width,height,length){
translate([-width/2,0,length/2+5]){
difference(){
    
    union(){
        
        //底座支撑三角 
       translate([-15,-87.5,-5]){
     
     rotate([0,-90,210]){
         color("Gainsboro",1.0){
   prism(10, 15, sqrt(675)); }
 }
     }    
 //底座支撑镜像三角 
 mirror([0,1,0])
 translate([-15,-87.5,-5]){
     
     
     rotate([0,-90,210]){
         color("Gainsboro",1.0){
   prism(10, 15, sqrt(675)); }
 }
     }    
        color("Gainsboro",1.0){  
cube([width,height,length],center=true);}

        }
translate([-2,-2,-2]){
cube([width,height+58,length],center=true);
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

//中间支撑杆A

module cube_truss_left(width,height,length){
 
    color("Gainsboro",1.0){
translate([-15-10,2,4.5]){
difference(){

cube([width,length,height]);
 
translate([1,1,0]){
cube([width-2 ,length-2,height+2]);}
} } }
}
//中间支撑杆B
module cube_truss_right(width,height,length){
 color("Gainsboro",1.0){
translate([-15-10,-12,4.5]){
difference(){

cube([width,length,height]);
 
translate([1,1,0]){
cube([width-2 ,length-2,height+2]);}
} } }}


 

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

translate([0,0,450]){
 rotate([180,0,90]){
     translate([-87.5+2,0,0]){
cube_right_angle_up(15,25,15);
 }}}

 



 

//顶部副镜支架

translate([0,0,450]){
 rotate([180,0,90]){

difference(){
cylinder(9,100,100,center,$fa=1,center=true);
cylinder(11,87.5,87.5,center,$fa=1,center=true);}
 
cylinder(20,25,25,center,$fa=1,center=true);

for(a=[0:1:2]){
rotate([0,0,a*120]){
translate([-87.5+2,0,0]){

 cube_right_angle_up(15,25,15);
    
    //副镜支架
translate([-13,0,2]){
    rotate([0,90,0]){
    cube([5,5,100]); 
    }
    }

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



 