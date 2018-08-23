

Secondary_Mirror();

module Secondary_Mirror(){
    
    $s2 = sqrt(2);
$HPart = 89.44;
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