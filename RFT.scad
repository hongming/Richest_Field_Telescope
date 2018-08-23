//环形切口，来自https://www.youmagine.com/designs/openscad-arc
include <ARC.scad>;


//底部六边形多边形module
module Mirror_Box_Base(height, radius, fn) {
    fudge = 1 / cos(180 / fn);
    cylinder(h = height, r = radius * fudge, $fn = fn);
}

module Mirror_Box_Right_Angle(width, height, length) {
    translate([-width / 2, 0, length / 2 + 5]) {
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
    translate([-width / 2, 0, length / 2 + 5]) {
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
        translate([-15 - 10, 2, 4.5]) {
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
        translate([-15 - 10, -12, 4.5]) {
            difference() {

                cube([width, length, height]);

                translate([1, 1, 0]) {
                    cube([width - 2, length - 2, height + 2]);
                }
            }
        }
    }
}



//副镜架Secondary Cage
Secondary_Cage_Outer_Radius=100;//副镜架外半径
Secondary_Cage_Inner_Radius=Secondary_Cage_Outer_Radius-12.5;//副镜架内半径
Secondary_Cage_Thickness=9;//副镜架厚度
Secondary_Mirror_Base_Radius=25; //副镜底座半径
Secondary_Mirror_Base_Thickness=20; //副镜底座厚度
//镜筒主题
Main_Tube_Height=450;	//镜筒主体高度
//主镜底座
Mirror_Box_Base_Thickness=5; //主镜箱底座厚度

//Module-副镜架固定角铁
module Secondary_Cage_Right_Angle(width, height, length) {
    translate([-width / 2, 0, length / 2 + 4.5]) {
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
        difference() {
            cylinder(Secondary_Cage_Thickness, Secondary_Cage_Outer_Radius, Secondary_Cage_Outer_Radius, center, $fa = 1, center = true);
            cylinder(Secondary_Cage_Thickness+2, Secondary_Cage_Inner_Radius,Secondary_Cage_Inner_Radius, center, $fa = 1, center = true);
        }


//生成副镜基座
        cylinder(Secondary_Mirror_Base_Thickness, Secondary_Mirror_Base_Radius, Secondary_Mirror_Base_Radius, center, $fa = 1, center = true);



        for (a = [0: 1: 2]) {
            rotate([0, 0, a * 120]) {
		rotate([0, 0, 90]) {cube([1,Secondary_Cage_Outer_Radius,4]);}//生成副镜连接支架
                translate([-Secondary_Cage_Inner_Radius + 2, 0, 0]) {
                  Secondary_Cage_Right_Angle(15, 25, 15); //生成副镜架固定角铁
                    rotate([-4.499, 0, 0]) {            //4.499为预估
                        Cube_Truss_Left(10, 450, 10); //连接杆组-左半部分
                    }
                    rotate([4.499, 0, 0]) {
                        Cube_Truss_Right(10, 450, 10); //连接杆组-右半部分
                    }

                }
            }
        }
    }
}

//调焦座部分支架

translate([0,0,Main_Tube_Height*0.8]){

difference() {
    Mirror_Box_Base(2, Secondary_Cage_Outer_Radius, 6);
    cylinder(12, Secondary_Cage_Inner_Radius, Secondary_Cage_Inner_Radius, center = true);

    //调焦座部分支架的切割部件
        rotate([0,0,60]){
            translate([0,0,-2]){
        3D_arc(w=32,r=Secondary_Cage_Outer_Radius,deg=218,fn=6,h=5);
        }

        }
}
}

//调焦座部分支架的固定角铁
translate([0,0,Main_Tube_Height*0.8-5+2]){
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




//最低托盘

difference() {
    Mirror_Box_Base(Mirror_Box_Base_Thickness, Secondary_Cage_Outer_Radius, 6);
    cylinder(12, 70, 70, center = true);
}

//最底托盘的边缘角铁连接件
for (a = [0: 1: 2]) {
    rotate([0, 0, a * 120]) {
        translate([Secondary_Cage_Outer_Radius * cos(30), Secondary_Cage_Outer_Radius * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Box_Right_Angle(15, 115, 15);
            }
        }
    }

}


 
 
//主镜片
translate([0,0,23.5]){
    cylinder(15, 75, 75, center, $fa = 1, center = true);

    }

//最低托盘上的主镜架
for (a = [0: 1: 2]) {
    rotate([0, 0, a * 120]) {
        translate([70 * cos(30),70 * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Cell_Right_Angle(30, 150, 10);
            }
        }
    }
}


//最低托盘上的主镜架的固定角铁，用于连接鸠尾板A点
translate([0,0,Main_Tube_Height*0.4-5+2]){
//for (a = [0: 1: 1]) {
    rotate([0, 0,   120]) {
        translate([Secondary_Cage_Outer_Radius * cos(30), Secondary_Cage_Outer_Radius * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Box_Right_Angle(15, 70, 15);
//            }
        }
    }

}
}

//最低托盘上的主镜架的固定角铁，用于连接鸠尾板B点
translate([0,0,Main_Tube_Height*0.2-5+2]){

    rotate([0, 0,    120]) {
        translate([Secondary_Cage_Outer_Radius * cos(30), Secondary_Cage_Outer_Radius * sin(30), 0]) {
            rotate([0, 0, 30]) {
                Mirror_Box_Right_Angle(15, 80, 15);

        }
    }

}
}