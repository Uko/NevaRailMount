// customizable params
height = 10;
frameThickness = 20;

nevaRailMount(height, frameThickness);

// ---------
//  MODULES
// ---------

// open hollow cylinder that wraps around another cylindriacl shape
// used as an attachment of support
module cylinderGuide (height, diameter, thickness = 2, angle = 270) {
    
    $fn = 120;
    
    rotate_extrude(angle=angle)
    translate([diameter/2, 0])
    square([thickness, height]);
    
    translate([(diameter+thickness)/2,0,0])
    cylinder(height, d=thickness);
    
    rotate([0,0, angle])
    translate([(diameter+thickness)/2,0,0])
    cylinder(height, d=thickness);

}

module nevaRailMount(height, frameThickness = 10) {

    // non-customizable params
    $fn = 120;
    
    railHalfDist = 22.5; // half distance between the centers of 2 rails
    railGuideThickness = 2; // thichness of the raild attachments
    railDiameter = 7.9; // diameter of an attachment rail
    beltOffret = 6; //or 6.5. the distance from the center between rails to the attacment frame that ensures space around the belt
    
    ff  = 0.01; // fudge factor
    ff2 = 0.02;
    
    // computed values
    innerRailDist  = railHalfDist - railDiameter/2 - railGuideThickness;
    outerRailDist  = railHalfDist + railDiameter/2 + railGuideThickness;    
    outerFrameDist = beltOffret + frameThickness;
    
    // communicate values
    echo("---- Rail Mount Data ----");
    echo(str("x edge: ", outerRailDist));
    echo(str("y edge: ", outerFrameDist));
    echo(str("rail center: ", [railHalfDist, 0]));
    echo(str("rail radius: ", railDiameter/2));
    echo("-------------------------");
    
    // -------
    //  BUILD
    // -------
    
    union() {
        halfFrame();
        railGuide();
        
        mirror([1, 0, 0])
            halfFrame();
        mirror([1, 0, 0])
            railGuide();
    }
    
    // ---------
    //  MODULES
    // ---------
    
    // Quarter of a cyliner that lies in the first quadrant and has radius 1
    module unaryCylinderQuarter(height) {
        intersection() {
            cylinder(height, r=1);
            cube([1,1,height]);
        }
    }
    
    // half of the frame that connects the attachment cylinders
    module halfFrame() {
        
        difference() {
        
            scale([outerRailDist, outerFrameDist, 1])
                unaryCylinderQuarter(height);
        
            translate([-ff,-ff,-ff])
            scale([innerRailDist+ff, beltOffret+ff, 1])
                unaryCylinderQuarter(height+ff2);
            
            translate([railHalfDist, 0, -ff])
                cylinder(height+ff2, d=railDiameter+ff2);
        
        }
        
    }
    
    module railGuide() {
        translate([railHalfDist,0,0])
            rotate([0,0, -29])
                cylinderGuide(height, railDiameter, railGuideThickness, 234);
    }

}
