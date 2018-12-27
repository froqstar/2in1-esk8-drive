$fa=2;
$fs=0.4;

PI = 3.14159;

//all values are in mm


//truck parameters
useableTruckSize = 154; //the distance between the wheels (measured from rubber to rubber, NOT bearing to bearing!)
truckWidth = 18;
truckAdapterDiameter = 42;
truckAdapterPlay = 1.3;
truckAdapterAdjustmentAngle = 7.5; //stepsize of mount-to-truck angle adjustment. has to be a clean divisor of 90°. smaller steps are harder to print!
truckAdapterTensioningSlotWidth = 3; 
truckAdapterTensioningSlotLength = 30;
truckAdapterTensioningScrewDiameter = 3.1;
truckAdapterTensioningScrewLength = 30;
truckAdapterTensioningScrewCount = 2;
truckAdapterTensioningScrewHeadDiameter = 6.1;
truckAdapterTensioningScrewNutDiameter = 5.7;

distanceScrewDiameter = 8;

//belt mechanics parameters
beltWidth = 15;
beltLength = 280;
motorPulleyTeeth = 15;
wheelPulleyTeeth = 40;
wheelPulleyWidth = 19;
beltPitch = 5;

motorPulleyCircumference = motorPulleyTeeth * beltPitch;
wheelPulleyCircumference = wheelPulleyTeeth * beltPitch;

//motor parameters
//SK3 6374 values: http://www.electric-skateboard.builders/uploads/db1493/original/3X/c/4/c40213f09c3a9efb59e033c84dde2ed19bf27e4f.png
motorHousingDiameter = 59;
motorHousingDepth = 84.5;
motorClearing = 2;
motorAxisDiameter = 8;
motorAxisClearing = 0.7;
motorClipDiameter = 15;
motorClipDepth = 2;
motorScrewHoleCount = 4;
motorScrewHoleDiameter = 4.4;
motorScrewHoleSpacing = 44;
motorScrewHoleTensioningSpan = 15;
motorScrewHeadDiameter = 8;

//bearing parameters
bearingDiameter = 22.1;
bearingDepth = 7;
bearingWallWidth = 2;
bearingScrewDiameter = 3;
bearingScrewNutDiameter = 5.7;
bearingScrewNutHeight = 4.4;
bearingScrewHeadDiameter = 6;

//general structural parameters
truckMountWidth = 30;
motorMountWidth = (useableTruckSize - 2 - wheelPulleyWidth*2 - motorHousingDepth) / 2;
wallWidth = 6; //the minimum wall width of parts


//yes, this is incorrect, but that is what the tensioning holes are for ;)
axesDistance = (beltLength - motorPulleyCircumference/2 - wheelPulleyCircumference/2) / 2;


module motorMount() {
	difference() {
		//create outer hull
		mountHullWithAxisHole();
		
		//motor clip clearing
		hull() {
			translate([axesDistance - motorScrewHoleTensioningSpan/2, 0, motorMountWidth - motorClipDepth]) {
				cylinder(h=motorClipDepth, d = motorClipDiameter);
			}
			translate([axesDistance + motorScrewHoleTensioningSpan/2, 0, motorMountWidth - motorClipDepth]) {
				cylinder(h=motorClipDepth, d = motorClipDiameter);
			}
		}
		
		//motor mount holes
		for (i = [0:motorScrewHoleCount]) {
			hull() {
				translate([axesDistance - motorScrewHoleTensioningSpan/2, 0, 0]) {
					motorMountingHole(i);
				}
				translate([axesDistance + motorScrewHoleTensioningSpan/2, 0, 0]) {
					motorMountingHole(i);
				}
			}
			hull() {
				translate([axesDistance - motorScrewHoleTensioningSpan/2, 0, -0.5]) { //do a slight slope for the screw head to keep it from sliding inwards
					motorMountingScrewHead(i);
				}
				translate([axesDistance + motorScrewHoleTensioningSpan/2, 0, 0]) {
					motorMountingScrewHead(i);
				}
			}
		}
	}
}


module bearingMount() {
	difference() {
		//create outer hull
		mountHullWithAxisHole();
		
		//pocket for bearing sleigh
		translate([axesDistance, 0, motorMountWidth - bearingDepth - bearingWallWidth]) {
			hull() {
				translate([-motorScrewHoleTensioningSpan/2, 0, 0]) {
					bearingSleigh();
				}
				translate([+motorScrewHoleTensioningSpan/2, 0, 0]) {
					bearingSleigh();
				}
			}
			//setscrew
			translate([bearingDiameter/2, 0, bearingDepth/2]) {
				rotate([0,90,0]) {
					cylinder(h=bearingWallWidth + wallWidth + 30, d=bearingScrewDiameter);
				}
			}
			//setscrew head hole
			translate([motorScrewHoleTensioningSpan/2 + bearingDiameter + wallWidth/2, 0, bearingDepth/2]) {
				rotate([0,90,0]) {
					cylinder(h=wallWidth + 30, d=bearingScrewHeadDiameter);
				}
			}
		}
	}
}


module mountHullWithAxisHole() {
	difference() {
		//outer shape
		hull() {
			cylinder(h=truckMountWidth, r=truckAdapterDiameter/2 + wallWidth);
			
			translate([axesDistance - motorScrewHoleTensioningSpan/2, 0, 0]) {
				cylinder(h=motorMountWidth, r1=motorPulleyCircumference/(2*PI) + 2, r2=motorHousingDiameter/2 + motorClearing);
			}
			translate([axesDistance + motorScrewHoleTensioningSpan/2, 0, 0]) {
				cylinder(h=motorMountWidth, r1=motorPulleyCircumference/(2*PI) + 2, r2=motorHousingDiameter/2 + motorClearing);
			}
			//distance screw hole
			translate([-(truckAdapterDiameter/2+wallWidth*2+distanceScrewDiameter/2), 0, 0]) {
				cylinder(h=truckMountWidth, d=distanceScrewDiameter+wallWidth);
			}
		}
		//distance screw hole
		translate([-(truckAdapterDiameter/2+wallWidth*2+distanceScrewDiameter/2), 0, 0]) {
			cylinder(h=truckMountWidth, d=distanceScrewDiameter);
		}
		translate([-(truckAdapterDiameter/2+wallWidth*2+distanceScrewDiameter/2), 0, 0]) {
			cylinder(d=21, h=6);
		}
		
		//axis hole
		hull() {
			translate([axesDistance - motorScrewHoleTensioningSpan/2, 0, 0]) {
				cylinder(h=motorMountWidth, r = motorAxisDiameter/2 + motorAxisClearing);
			}
			translate([axesDistance + motorScrewHoleTensioningSpan/2, 0, 0]) {
				cylinder(h=motorMountWidth, r = motorAxisDiameter/2 + motorAxisClearing);
			}
		}
		//plain mount surfaces
		translate([0,0,truckMountWidth]) {
			cylinder(h=motorMountWidth, d=truckAdapterDiameter + 2*wallWidth);
		}
		hull() {
			translate([axesDistance - motorScrewHoleTensioningSpan/2, 0, motorMountWidth]) {
				cylinder(h=motorMountWidth, r = motorHousingDiameter/2);
			}
			translate([axesDistance + motorScrewHoleTensioningSpan/2, 0, motorMountWidth]) {
				cylinder(h=motorMountWidth, r = motorHousingDiameter/2);
			}
		}
		
		truckAdapterBase(truckAdapterDiameter + truckAdapterPlay);
		
		//truck adapter tensioning slot
		hull() {
			cylinder(h=truckMountWidth, d=truckAdapterTensioningSlotWidth);
			translate([truckAdapterDiameter/2 + truckAdapterTensioningSlotLength,0,0]) {
				cylinder(h=truckMountWidth, d=truckAdapterTensioningSlotWidth);
			}
		}
		//truck adapter tensioner screwholes
		for (i = [0:truckAdapterTensioningScrewCount-1]) {
			truckSlotTensioningScrewHole(i);
		}
	}
}


module motorMountingHole(number) {
	rotate([0,0,360/motorScrewHoleCount*number + (360/motorScrewHoleCount)/2]) {
		translate([motorScrewHoleSpacing/2,0,0]) {
			cylinder(h=motorMountWidth, d=motorScrewHoleDiameter);
		}
	}
}

module motorMountingScrewHead(number) {
	rotate([0,0,360/motorScrewHoleCount*number + (360/motorScrewHoleCount)/2]) {
		translate([motorScrewHoleSpacing/2,0,0]) {
			cylinder(h=motorMountWidth-wallWidth, d=motorScrewHeadDiameter);
		}
	}
}


module truckSlotTensioningScrewHole(number) {
	
	translate([	truckAdapterDiameter/2 + wallWidth, 0, (truckMountWidth/(truckAdapterTensioningScrewCount+1)) * (number + 1)]) {
		rotate([90,0,0]) {
			cylinder(h=motorHousingDiameter + 2*wallWidth,d=truckAdapterTensioningScrewDiameter, center=true);
			//head hole
			translate([0,0,truckAdapterTensioningScrewLength]) {
				cylinder(h=truckAdapterDiameter, d=truckAdapterTensioningScrewHeadDiameter, center=true);
			}
			//nut hole
			translate([0,0,-truckAdapterTensioningScrewLength+4]) {
				nutM3(h=30);
				//cube([truckAdapterTensioningScrewNutDiameter, truckAdapterTensioningScrewNutDiameter *1.4, 30], center=true);
			}
		}
	}
}


module truckAdapterBase(diameter) {
	for (i = [0:90/truckAdapterAdjustmentAngle]) {
		rotate([0, 0, truckAdapterAdjustmentAngle * i]) {
			translate([0, 0, truckMountWidth/2]) {
				cube([	2*sqrt(pow(diameter/2, 2)/2), 
						2*sqrt(pow(diameter/2, 2)/2), 
						truckMountWidth]
				,center=true); 
			}	
		}
	}
	translate([0,0,truckMountWidth/3]) {
		cylinder(h=truckMountWidth/3, d=diameter);
	}
}


module bearingSleigh() {
	difference() {
		hull() {
			translate([-(bearingWallWidth + wallWidth - 1), 0, 0]) {
				cylinder(h=bearingDepth + bearingWallWidth, d=bearingDiameter + bearingWallWidth*2);
			}
			translate([+(bearingWallWidth + wallWidth - 1), 0, 0]) {
				cylinder(h=bearingDepth + bearingWallWidth, d=bearingDiameter + bearingWallWidth*2);
			}
		}
		//holes for bearing and axis
		cylinder(h=bearingDepth, d=bearingDiameter);
		cylinder(h=bearingDepth + bearingWallWidth, d=motorAxisDiameter + motorAxisClearing*2);
		
		//setscrew
		translate([0,0,bearingDepth/2]) {
			rotate([0,90,0]) {
				cylinder(h=bearingDiameter + bearingWallWidth + wallWidth, d=bearingScrewDiameter);
			}
		}
		//setnut
		translate([bearingDiameter/2 + wallWidth/2 - 1,-bearingScrewNutDiameter/2,0]) {
			cube([bearingScrewNutHeight, bearingScrewNutDiameter, bearingDepth]);
		}
	}
}


module truckAdapter() {
	difference() {
		truckAdapterBase(truckAdapterDiameter-0.5);
		translate([2,0,0]) {
			truckShape();
		}
	}
	
	//hooks to hold it in place
	//15/4
	translate([-(17 - truckWidth/2), truckWidth/2, 4.5/2]) {
		rotate([90,0,0]) {
			cylinder(h=3.5, d=4.5);
		}
	}
	translate([-(17 - truckWidth/2), -truckWidth/2 + 3.5, 4.5/2]) {
		rotate([90,0,0]) {
			cylinder(h=3.5, d=4.5);
		}
	}
}

truckDepthOuter = 16;
truckDepthInner = 28;

module truckShape() {
	difference() {
		group() {
			translate([-truckDepthInner, -truckWidth/2, 0]) {
				cube([truckDepthInner, truckWidth, truckMountWidth], center=false);
			}
			translate([0,0,0]) {
				cylinder(h=truckMountWidth, d=truckWidth);
			}
		}
		//16/28
		cutAwaySize = 83;
		
		translate([-(cutAwaySize/2+(truckWidth/2-(truckWidth-truckDepthOuter))),0,truckMountWidth]) {
			rotate([90,0,0]) {
				cylinder(h=truckWidth, d=cutAwaySize, center=true);
			}
		}
	}
}

module nutM3(
	ri =  5.5/2,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------
	ra = ri*2/sqrt(3) + 0.2;
	cylinder(r = ra, h=h, $fn=6, center=true);
}


translate([0, 0, (motorMountWidth+10)*2]) {
	rotate([180,0,0]) {
		color("white") {
			bearingMount();
		}
	}
}

translate([axesDistance, 0, (motorMountWidth+10)*1]) {
	rotate([180,0,0]) {
		color("grey") {
			bearingSleigh();
		}
	}
}

translate([0,0,-(motorMountWidth+10)*1]) {
	color("white") {
		motorMount();
	}
}

translate([0,0,-(motorMountWidth+10)*3]) {
	color("green") {
		truckAdapter();
	}
}