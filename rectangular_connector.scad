spacing = 25.4;

smidge = 0.01;

pin_width = 10;
housing_height = 140;

notch_inset = 40;
notch = [spacing*2, 4.3, 50];

wall = 3.9;

cutout_offset = 5;
inside_cutout = [spacing - wall*2, spacing - wall*2, housing_height - cutout_offset + smidge];


$fa=0.5;
$fs=0.5;

rectangular_housing();

% translate([0, 0, -50])
  led();

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

module led() {
  translate([0, 0, -50])
  cylinder(d=50, h=50);
  lead = 5.4;
  translate([25.4/2 - lead/2,0,0])
    cube([lead, lead, 155]);
  translate([-25.4/2 - lead/2,0,0])
    cube([lead, lead, 165]);
}
