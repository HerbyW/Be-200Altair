## Learjet 35-A, stall and overspeed warning
## PH-JBO 20120130p
# modified by Herbert Wagner for Be-200 Altair 12/2016-2019
# Slats are now also included

var aoaStall = 15;
setprop("/instrumentation/alerts/aoaStall",15);
setprop("/instrumentation/alerts/stall",0);

var warning = func {
  
  ## get variables
  var aoa = getprop("/orientation/alpha-deg");
  var flaps = getprop("/controls/flight/flaps") * -2;
  var gear = getprop("/controls/gear/gear-down") * -0.75;
  var stalling = 0;
  var gearalt = getprop("/position/altitude-agl-ft");
  var aoaStall = (13 + flaps + gear);
## compare and set warning
  if ((aoa!=nil) and (flaps!=nil))
    {
        if (aoa>aoaStall)
	{var stalling= 1;}
     }
	if ((gearalt!=nil) and ((getprop("/gear/gear[0]/wow")!=1) or (getprop("/gear/gear[1]/wow")!=1) or (getprop("/gear/gear[2]/wow")!=1)))
	{
	setprop("/instrumentation/alerts/stall",stalling);
	setprop("/instrumentation/alerts/aoaStall",aoaStall);
	}
	else setprop("/instrumentation/alerts/stall",0);
	setprop("/instrumentation/alerts/aoaStall",aoaStall);
	settimer (warning,0.5);
}

warning();
