// Physical Keygen - by Nirav Patel <http://eclecti.cc>
// Modified to accomodate Schlage Everest D145 by DPY
// I tried to keep all the original comments where needed.
// Mostly a cluster fuck of code - I tried to clean it up as much as possible.
// Required file - d145v4.8.stl for the main key object
//
// Generate a duplicate of a Schlage D145 key by editing lines 24-39
// and entering in the key code of the lock.  If you don't know the key code,
// you can measure the key and compare the numbers at:
// http://web.archive.org/web/20050217020917fw_/http://dlaco.com/spacing/tips.htm
//
// This work is licensed under a Creative Commons Attribution 3.0 Unported License.

// Since the keys and locks I have were all designed in imperial units, the
// constants in this file will be defined in inches.  The mm function
// allows us to retain the proper size for exporting a metric STL.

// Thanks to Roidzo - Easy Key Copier for help with the Customizer comments http://www.thingiverse.com/thing:52363

// preview[view:south, tilt:side]

//(this is just a reference table to help pick cuts below)
distance_from_cut_to_bottom_of_key = 0; // [0:0 = .335",1:1 = .320",2:2 = .305",3:3 = .290",4:4 = .275",5:5 = .260",6:6 = .245",7:7 = .230",8:8 = .215",9:9 = .200"]

        
//(cut closest to tip of key)
cut_6 = 0; //[0:9]

//
cut_5 = 5; //[0:9]

//
cut_4 = 1; //[0:9]

//
cut_3 = 2; //[0:9]

//
cut_2 = 6; //[0:9]

//(cut closest to grip/bow of key)
cut_1 = 4; //[0:9]

//(Rotate key flat for printing)
rotate_flat=0; //[0:No,1:Yes]

function mm(i) = i*25.4;

module bit() {
    w = mm(1/4);
    difference() {
        translate([-w/2, 0, 0]) cube([w, mm(1), w]);
        translate([-mm(7/256), 0, 0]) rotate([0, 0, 135]) cube([w, w, w]);
         translate([mm(7/256), 0, 0]) rotate([0, 0, -45]) cube([w, w, w]);
    }
}

// Schlage SC1 5 pin key.  The measurements are mostly guesses based on reverse
// engineering some keys I have and some publicly available information.
module sc1(bits) {
    // You may need to adjust these to fit your specific printer settings
    width = mm(.335);
    
    shoulder = mm(.231);
    pin_spacing = mm(.1562);
    depth_inc = mm(.015);
    
    // A fudge factor.  Printing with your average RepRap, the bottom layer is
    // going to be squeezed larger than you want. You can make the pins
    // go slighly deeper by a fudge amount to make up for it if you aren't
    // adjusting for it elsewhere like Skeinforge or in your firmware.
    // 0.5mm works well for me.
    fudge = 0.5;
    
    // Handle size
    h_l = mm(1);
    h_w = mm(1);
    h_d = mm(1/16);
    difference() {
        // blade and key handle
        union() {
           // translate([-h_l, -h_w/2 + width/2, 0]) rounded([h_l, h_w, thickness], mm(1/4));
                rotate ([0,0,88])
                translate ([4.1,-6,-3])
                import("d145v4.8.stl");

        }

        
   //     translate([-h_d, width - mm(9/64), 0]) cube([length + h_d, width - (width - mm(10/64)), thickness/2]);
  //      translate([-h_d, width - mm(9/64), thickness/2]) rotate([-110, 0, 0]) cube([length + h_d, width, thickness/2]);
        
  //      intersection() {
 //           translate([-h_d, mm(1/32), thickness/2]) rotate([-118, 0, 0]) cube([length + h_d, width, width]);
 //           translate([-h_d, mm(1/32), thickness/2]) rotate([-110, 0, 0]) cube([length + h_d, width, width]);
  //      }
        
        // Do the actual bitting
        for (b = [0:5]) {
            translate([shoulder + b*pin_spacing, width - bits[b]*depth_inc - fudge, 0]) bit();
        }
    }
}

// This sample key goes to a lock that is sitting disassembled on my desk
// Flip the key over for easy printing
if (rotate_flat==1){
	rotate([180,0,0]) sc1([cut_1,cut_2,cut_3,cut_4,cut_5,cut_6]);
} else {
	rotate([90,0,0]) sc1([cut_1,cut_2,cut_3,cut_4,cut_5,cut_6]);
}
