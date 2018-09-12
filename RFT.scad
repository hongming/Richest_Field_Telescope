/*
2018年9月4日
    底板采用环氧板，Mirror_Box_Base_Thickness厚度减少至3毫米；
    底板角铁移动到底部，改为拖底式。
*/

/*
    口径168，焦距534，厚度32，精密退火派勒克斯材料
*/

//环形切口，来自https://www.youmagine.com/designs/openscad-arc
include <ARC.scad>;
//旋转调焦器，来自https://www.thingiverse.com/thing:1936225/files,其中引用了https://github.com/JohK/nutsnbolts和https://github.com/openscad/MCAD
use <Helical_Crayford_Focuser.scad>;



//主镜Primary Mirror
Primary_Mirror_Thickness=32;
Primary_Mirror_Radius=84;
Primary_Mirror_Focal_Length=534;

//副镜架Secondary Cage
Secondary_Cage_Outer_Radius=112.5;//副镜架外半径
Secondary_Cage_Inner_Radius=Secondary_Cage_Outer_Radius-12.5;//副镜架内半径
Secondary_Cage_Thickness=10;//副镜架厚度
Secondary_Mirror_Base_Radius=25; //副镜底座半径
Secondary_Mirror_Base_Thickness=20; //副镜底座厚度
//镜筒主体？
Main_Tube_Height=Primary_Mirror_Focal_Length-Primary_Mirror_Thickness-15-Secondary_Cage_Outer_Radius;	//镜筒主体高度
//主镜底座
Mirror_Box_Base_Thickness=3; //主镜箱底座厚度
//镜筒支架-旋转角度
Cube_Truss_Angle=atan((Secondary_Cage_Outer_Radius*tan(30)-15)/Main_Tube_Height);
//镜筒支架-支架长度
Cube_Truss_Length= sqrt(Main_Tube_Height*Main_Tube_Height+Secondary_Cage_Outer_Radius*tan(30)*Secondary_Cage_Outer_Radius*tan(30));


//底部六边形多边形module
module Mirror_Box_Base(height, radius, fn) {
    fudge = 1 / cos(180 / fn);
    cylinder(h = height, r = radius * fudge, $fn = fn);
}

module Mirror_Box_Right_Angle(width, height, length) {
    translate([-width / 2, 0, length / 2 + Mirror_Box_Base_Thickness]) {
        difference() {
            cube([width, height, length], center = true);
            translate([-2, -2, 2]) {
                cube([width, height + 8, length], center = true);
            }
        }
    }
}



//底部交叉杆三角形
module prism(l, w, h) {
    polyhedron(
        points = [
            [0, 0, 0],
            [l, 0, 0],
            [l, w, 0],
            [0, w, 0],
            [0, w, h],
            [l, w, h]
        ],
        faces = [
            [0, 1, 2, 3],
            [5, 4, 3, 2],
            [0, 4, 5, 1],
            [0, 3, 4],
            [5, 2, 1]
        ]
    );
}


//底部支撑大梁
module Mirror_Cell_Right_Angle(width, height, length) {
    translate([-width / 2, 0, length / 2 + Mirror_Box_Base_Thickness]) {
        difference() {

            union() {

                //底座支撑三角 
                translate([-15, -height/2, -5]) {

                    rotate([0, -90, 210]) {
                        color("Gainsboro", 1.0) {
                            prism(10, 15, sqrt(675));
                        }
                    }
                }
                //底座支撑镜像三角 
                mirror([0, 1, 0])
                translate([-15, -height/2, -5]) {


                    rotate([0, -90, 210]) {
                        color("Gainsboro", 1.0) {
                            prism(10, 15, sqrt(675));
                        }
                    }
                }
                color("Gainsboro", 1.0) {
                    cube([width, height, length], center = true);
                }

            }
            translate([-2, -2, -2]) {
                cube([width, height + 58, length], center = true);
            }
        }
    }
}


//中间支撑杆A

module Cube_Truss_Left(width, height, length) {

    color("Gainsboro", 1.0) {
        translate([-15 - 10, 0, 0.5*Secondary_Cage_Thickness]) {
            difference() {

                cube([width, length, height]);

                translate([1, 1, 0]) {
                    cube([width - 2, length - 2, height + 2]);
                }
            }
        }
    }
}
//中间支撑杆B
module Cube_Truss_Right(width, height, length) {
    color("Gainsboro", 1.0) {
        translate([-15 - 10, -10, 0.5*Secondary_Cage_Thickness]) {
          difference() {

                cube([width, length, height]);

                translate([1, 1, 0]) {
                    cube([width - 2, length - 2, height + 2]);
                }
            }
        }
    }
}







//Module-副镜架固定角铁
module Secondary_Cage_Right_Angle(width, height, length) {
    translate([-width / 2, 0, length / 2 + 0.5*Secondary_Cage_Thickness]) {
        difference() {
            cube([width, height, length], center = true);
            translate([2, -2, 2]) {
                cube([width, height + 8, length], center = true);
            }
        }
    }
}


//顶部副镜支架

translate([0, 0, Main_Tube_Height]) {
    rotate([180, 0, 90]) {

//生成副镜架框体
                color("Silver", 1.0){
        difference() {
            cylinder(Secondary_Cage_Thickness, Secondary_Cage_Outer_Radius, Secondary_Cage_Outer_Radius, center, $fa = 1, center = true);
            cylinder(Secondary_Cage_Thickness+2, Secondary_Cage_Inner_Radius,Secondary_Cage_Inner_Radius, center, $fa = 1, center = true);
        }
    }

//生成副镜调节座
        cylinder(Secondary_Mirror_Base_Thickness, Secondary_Mirror_Base_Radius, Secondary_Mirror_Base_Radius, center, $fa = 1, center = true);

//副镜座

rotate([0,0,210]){
    
    Secondary_Mirror_Holder();
    }

//生成副镜连接支架
for (a = [0: 1: 3]) {
            rotate([0, 0, a * 90]) {
		rotate([0, 0, 90]) {cube([1,Secondary_Cage_Outer_Radius,4]);}
    }}
    
    
for (a = [0: 1: 2]) {
            rotate([0, 0, a * 120]) { 


                translate([-Secondary_Cage_Inner_Radius , 0, 0]) {
                  Secondary_Cage_Right_Angle(15, 25, 15); //生成副镜架固定角铁
                    rotate([-Cube_Truss_Angle, 0, 0]) {            //4.499为预估
                        Cube_Truss_Left(10, Cube_Truss_Length-0.5*Secondary_Cage_Thickness, 10); //连接杆组-左半部分
                    }
                    rotate([Cube_Truss_Angle, 0, 0]) {
                        Cube_Truss_Right(10, Cube_Truss_Length-0.5*Secondary_Cage_Thickness, 10); //连接杆组-右半部分
                    }

                }
            }
        }
    }
}
 

//调焦器
 
translate([Secondary_Cage_Outer_Radius-10,-55,Main_Tube_Height-Secondary_Cage_Thickness*0.5-40]){
 rotate([0,90,150]){
Focuser();
    TubeAdapter();}
    
    }
 

//调焦座部分支架

translate([0,0,Main_Tube_Height-Secondary_Cage_Thickness*0.5-80]){

difference() {
    Mirror_Box_Base(2, Secondary_Cage_Outer_Radius, 6);
    cylinder(12, Secondary_Cage_Inner_Radius, Secondary_Cage_Inner_Radius, center = true);

    //调焦座部分支架的切割部件
        rotate([0,0,60]){
            translate([0,0,-2]){
        3D_arc(w=40,r=Secondary_Cage_Outer_Radius,deg=218,fn=6,h=5);
        }

        }
}
}

//调焦座部分支架的固定角铁
translate([0,0,Main_Tube_Height-Secondary_Cage_Thickness*0.5-80]){
for (a = [0: 1: 1]) {
    rotate([0, 0, a * 240]) {
        translate([Secondary_Cage_Outer_Radius * cos(30), Secondary_Cage_Outer_Radius * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Box_Right_Angle(15, 40, 15);
            }
        }
    }

}
}



//求解左右支架分叉角度


//最低托盘

difference() {
    Mirror_Box_Base(Mirror_Box_Base_Thickness, Secondary_Cage_Outer_Radius, 6);
    cylinder(12, 70, 70, center = true);
}

//最底托盘的边缘角铁连接件
for (a = [0: 1: 2]) {
    rotate([0, 0, a * 120]) {
        translate([(Secondary_Cage_Outer_Radius+2) * cos(30), (Secondary_Cage_Outer_Radius+2) * sin(30), -Mirror_Box_Base_Thickness-2]) {
            rotate([0, 0, 30]) {
                Mirror_Box_Right_Angle(15, 2*Secondary_Cage_Outer_Radius*tan(30), 15);
            }
        }
    }

}


 
 
//主镜片

color("red", 1.0){
translate([0,0,
    Mirror_Box_Base_Thickness+10+0.5*Primary_Mirror_Thickness]){
    cylinder(Primary_Mirror_Thickness, Primary_Mirror_Radius, Primary_Mirror_Radius, center, $fa = 1, center = true);

    }}

//最低托盘上的主镜架
for (a = [0: 1: 2]) {
    rotate([0, 0, a * 120]) {
        translate([70 * cos(30),70 * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Cell_Right_Angle(30, 180, 10);
            }
        }
    }
}


//最低托盘上的主镜架的固定角铁，用于连接鸠尾板A点
translate([0,0,Main_Tube_Height*0.4-5+2]){
//for (a = [0: 1: 1]) {
    rotate([0, 0,   120]) {
        translate([(Secondary_Cage_Outer_Radius+2) * cos(30), (Secondary_Cage_Outer_Radius+2) * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Box_Right_Angle(15, 80, 15);
//            }
        }
    }

}
}

//最低托盘上的主镜架的固定角铁，用于连接鸠尾板B点
translate([0,0,Main_Tube_Height*0.2-5+2]){

    rotate([0, 0,    120]) {
        translate([(Secondary_Cage_Outer_Radius+2) * cos(30), (Secondary_Cage_Outer_Radius+2) * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Box_Right_Angle(15, 80, 15);

        }
    }

}
}

//鸠尾板
translate([0,0,Main_Tube_Height*0.3-5+2]){

    rotate([0, 0,    120]) {
        translate([(Secondary_Cage_Outer_Radius+2) * cos(30), (Secondary_Cage_Outer_Radius+2) * sin(30), 0]) {
            rotate([0, 0, 30]) {
       
			translate([5,0,-30]){
difference(){
cube([10,30,200],center=true);
cube([12,10,160],center=true);
}
}

        }
    }

}
}


module Secondary_Mirror_Holder(){
    //引用自https://www.thingiverse.com/thing:3059131/files
    $s2 = sqrt(2);
$HPart = 69.44;
$diam = 38.14;
$Tslice = $diam*$s2/2;
$fn=100;

$Hnut = 5;
$Wnut = 8.1;
$Wnutfloor = 3;
difference()
{
difference() //cut off a 45 degree chunk at the right height
{
translate([0,0,$HPart/2])
  cylinder(h=$HPart,d=$diam,center=true); //create main body

translate([0,0,$HPart-$diam/2])
  translate([0,-$s2/2*($Tslice/2),-$s2/2*($Tslice/2)+$s2*$Tslice/2])
    rotate([45,0,0])  
      cylinder(h=$Tslice,d=$s2*$diam,center=true); //create cutter
}

union()
{
translate([0,0,$Wnutfloor+$Hnut])
  cylinder(d=15,h=$HPart); //wide well to seat nut
translate([0,0,-1])
  cylinder(d=5,h=$HPart); //hole for screw
translate([0,0,$Wnutfloor])
  cylinder(r = $Wnut / 2 / cos(180 / 6) + 0.05, h=$Hnut, $fn=6); //M5 nut

}    
}}