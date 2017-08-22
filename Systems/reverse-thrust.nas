#      
#    HerbyW 2015
#
################################ Reverser ####################################


var togglereverser = func {
	r1 = "/fdm/jsbsim/propulsion/engine";
	r2 = "/fdm/jsbsim/propulsion/engine[1]";
	

	rc1 = "/controls/engines/engine";
	rc2 = "/controls/engines/engine[1]";
	

	r5 = "/sim/input/selected";

	rv1 = "/engines/engine/reverser-pos-norm"; 
	rv2 = "/engines/engine[1]/reverser-pos-norm";
	

	val1 = getprop(rv1) or 0;
	
	t1 = getprop("/controls/engines/engine[0]/throttle") or 0;

	if ((val1 == 0 or val1 == nil) and t1 < 0.25) {
		interpolate(rv1, 1.0, 1.4); 
		interpolate(rv2, 1.0, 1.4);
		 
		setprop(r1,"reverser-angle-rad",2);
		setprop(r2,"reverser-angle-rad",2);   
		
		setprop(rc1,"reverser", "true");
		setprop(rc2,"reverser", "true");
		
		setprop(r5,"engine", "true");
		setprop(r5,"engine[1]", "true");
		
		setprop("controls/reverser", "true");
		
	} else {
		if (val1 == 1.0 and t1 < 0.25){
		interpolate(rv1, 0.0, 1.4);
		interpolate(rv2, 0.0, 1.4); 
		
		setprop(r1,"reverser-angle-rad",0);
		setprop(r2,"reverser-angle-rad",0); 
		
		setprop(rc1,"reverser",0);
		setprop(rc2,"reverser",0);
		
		setprop(r5,"engine", "true");
		setprop(r5,"engine[1]", "true");
		
		setprop("controls/reverser", "false");
		
		}
	}
}


#############################################################################################################
# Start-up-screen message

setprop("sim/messages/copilot", "Hello");
setprop("sim/messages/copilot", getprop("sim/multiplay/generic/string[0]"));
setprop("sim/messages/copilot", "Have fun with the Berijew-200 Altair");
setprop("sim/messages/copilot", "Press s for autostart");
setprop("sim/messages/copilot", "Features: Wildfire-Waterbombing, Landing/Takeoff on water");


########################################################################################################
