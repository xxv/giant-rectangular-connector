module rounded_cube(size, round_radius) {
  linear_extrude(height=size.z)
    translate([round_radius, round_radius])
      minkowski() {
        circle(r=round_radius);
        square(size - [round_radius*2, round_radius*2]);
      };
}
