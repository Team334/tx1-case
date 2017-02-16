// our font
use <Richardson_Brand_Accelerator.otf>;

module hc_column(length, cell_size, wall_thickness) { 
    no_of_cells = floor(length / (cell_size + wall_thickness)) ; 

    for (i = [0 : no_of_cells]) { 
        translate([0,(i * (cell_size + wall_thickness)),0]) 
        circle($fn = 6, r = cell_size * (sqrt(3)/3)); 
    } 
} 

module honeycomb(length, width, height, cell_size, wall_thickness) { 
    no_of_rows = floor(1.2 * length / (cell_size + 
wall_thickness)) ; 

    tr_mod = cell_size + wall_thickness; 
    tr_x = sqrt(3)/2 * tr_mod; 
    tr_y = tr_mod / 2; 
    off_x = -1 * wall_thickness / 2; 
    off_y = wall_thickness / 2; 
    linear_extrude(height = height, center = true, convexity = 10, twist = 0, slices = 1) 
        for (i = [0 : no_of_rows]) { 
            translate([i * tr_x + off_x, (i % 2) * tr_y + off_y,0]) 
                hc_column(width, cell_size, wall_thickness); 
        }
} 

w1 = 2; off=0.2;
difference() {
    // make a hollowed box
    linear_extrude(height=3.5)
        difference() {
            square([w1+off+.1,w1+off], center=true);
            square([w1+.1,w1], center=true);
        };
        
    union() {
        // team number text
        rotate(a=[90,-90,90]) {
            s = .7;

            font="Richardson Brand Accelerator";
            translate([.4,-s/2,1])
                linear_extrude(height=1.1)
                    text("334", size=s, font=font, center=true);
        };
        // honeycomb ventilation for fan
        translate([-1, -1.5/2+.05, 2.85])
            rotate([0, 90, 0]) honeycomb(2.3, 1.3, .5, .3, .08); 
        
        // cut out area for ports
        translate([(2+.1)/2-.7, -1.5, 3.5-3.3])
            cube([.7, .65, 3.3]);
    }
}

// bottom of box
translate([0, 0, -.1/2])
    cube([w1+off+.1,w1+off,.1],center=true);