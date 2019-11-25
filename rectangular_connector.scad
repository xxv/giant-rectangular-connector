include <shapes.scad>;

spacing = 25.4;

smidge = 0.01;

pin_width = 10;
housing_height = 140;

notch_inset = 40;
notch = [spacing*2, 4.3, 50];

wall = 3.9;

cutout_offset = 5;
inside_cutout = [spacing - wall*2, spacing - wall*2, housing_height - cutout_offset + smidge];

led_lead = 5.3;

$fa=0.5;
$fs=0.5;


module mockup() {
  color("#333")
    rectangular_housing();

  % translate([0, 0, -50])
    led();

  color("gold") {
      translate([-spacing/2, 0, 5])
        pin_clamp();
      translate([spacing/2, 0, 5])
        pin_clamp();
        }
}

module rectangular_housing() {
  difference() {
    translate([-spacing, -spacing/2, 0])
    cube([spacing * 2, spacing, housing_height]);

    for (mir = [0, 1])
      mirror([ mir, 0, 0]) {
        translate([spacing/2, 0, -smidge])
          rotate([0, 0, 45])
            cylinder(d1=(spacing + 6), d2=pin_width + 4, h=3, $fn=4);

        translate([spacing/2 - pin_width/2, -pin_width/2, 0])
          cube([pin_width, pin_width, housing_height + smidge * 2]);

        translate([wall, -inside_cutout.y/2, cutout_offset])
          cube(inside_cutout);
      }
    translate([-notch.x/2 - smidge, spacing/2 - notch.y, notch_inset])
      cube(notch + [smidge * 2, smidge * 2, smidge * 2]);
  }

  // aarow
  translate([-spacing/2, spacing/2, notch_inset - 6])
    rotate([-90, 90, 0])
      cylinder(d=spacing - 10, h=0.5, $fn=3);


    tab = [16, notch.y - 0.5, 32];

    for (mir = [0, 1])
      mirror([ mir, 0, 0]) {
        translate([spacing/2, spacing/2 -0.5, notch_inset + notch.z + smidge*2])
        rotate([180, 0, 0])
        difference() {
          translate([-tab.x/2, 0, 0])
            cube(tab);
         translate([0, -2, 0])
          rotate([-92.5, 0, 0])
          linear_extrude(height=2)
          hull() {
            translate([0, -tab.z + 8])
              circle(d=10);
            circle(d=10);
          }
        }
      }
}

module pin_clamp() {
  clamp_height = 60;
  clamp_wall = 2;

  clamp_size = [inside_cutout.x - 0.5, inside_cutout.y - 2, clamp_height];
  clamp_cutout = [clamp_size.x, clamp_size.y, clamp_height]- [clamp_wall * 2, clamp_wall * 2, -smidge * 2];

  difference() {
    translate([-clamp_size.x/2, -clamp_size.y/2, 0])
      rounded_cube(clamp_size, 2);
    translate([-led_lead/2, -led_lead/2,-smidge])
      cube([led_lead, led_lead, clamp_height + smidge * 2]);

    translate([0, 0, 40])
      union() {
        translate([-clamp_size.x/2 - smidge, clamp_size.y/2 - clamp_wall * 4, 0])
          difference() {
            rotate([0, 90, 0])
              rounded_cube([25, clamp_size.y + smidge * 2, clamp_size.x + smidge * 2], 2);
            translate([clamp_size.x/2-led_lead/2,clamp_wall * 1 -led_lead/2,-33-smidge])
              cube([led_lead, led_lead +1.2, clamp_height + smidge * 2]);
          }
        translate([0, clamp_size.y/2, 33])
          translate([-10, -clamp_wall*2, -33-smidge])
            cube([20, 8+smidge, 14+smidge]);
        *translate([0, clamp_size.y/2, 33])
          translate([-14, -clamp_wall*2, -36-smidge])
            cube([20, 8+smidge, 8+smidge]);
      }

    difference() {
      translate([-clamp_cutout.x/2, -clamp_cutout.y/2, -smidge])
        rounded_cube(clamp_cutout, 1);
      translate([-led_lead/2 + smidge, -inside_cutout.y/2, 0])
        cube([led_lead - smidge*2, inside_cutout.y, clamp_height]);
    }
  }

  translate([0, clamp_size.y/2, 48]) {
    union() {
      translate([clamp_size.x/2, 0, 0])
        rotate([0, 0, 180])
        tab(clamp_size, clamp_wall);
      translate([-clamp_size.x/2, -clamp_wall, -8])
        rotate([180, 0, 0])
        tab(clamp_size, clamp_wall);
      }
  }
}

module tab(clamp_size, wall) {
  intersection() {
    translate([-6, 0, 0])
    rotate([-90, 0, 0])
      rounded_cube([20, 8, wall*2 + smidge], 1);

    difference() {
      translate([0, 0, -clamp_size.z/2])
        rounded_cube(clamp_size, 2);
      translate([wall, wall, -clamp_size.z/2 - smidge])
        rounded_cube(clamp_size - [wall*2, wall*2, 0], 2);
    }
  }
}

module led() {
  lead = 5.4;
  translate([0, 0, -50])
  cylinder(d=50, h=50);
  translate([25.4/2 - lead/2,-lead/2,0])
    cube([lead, lead, 155]);
  translate([-25.4/2 - lead/2,-lead/2,0])
    cube([lead, lead, 165]);
}
