
        
#    modified by HerbyW 2015




var min_carrier_alt = 2;

# Do terrain modelling ourselves.
setprop("sim/fdm/surface/override-level", 1);

terrain_survol = func {

var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");
var info = geodinfo(lat, lon);




 if (info != nil) {
    if (info[0] != nil){
       setprop("fdm/jsbsim/environment/terrain-hight",info[0]);

#var terrain_hight = info[0];
#print("TERRAIN ",terrain_hight);

      
    }
    if (info[1] != nil){
      if (info[1].solid !=nil){
        setprop("fdm/jsbsim/environment/terrain-undefined",0);
        setprop("fdm/jsbsim/environment/terrain-solid",info[1].solid);

#var solid = info[1].solid;
#print("SOLID ",solid);

    }
      if (info[1].light_coverage !=nil)
       setprop("fdm/jsbsim/environment/terrain-light-coverage",info[1].light_coverage);
      if (info[1].load_resistance !=nil)
       setprop("fdm/jsbsim/environment/terrain-load-resistance",info[1].load_resistance);
      if (info[1].friction_factor !=nil)
       setprop("fdm/jsbsim/environment/terrain-friction-factor",info[1].friction_factor);
      if (info[1].bumpiness !=nil)
       setprop("fdm/jsbsim/environment/terrain-bumpiness",info[1].bumpiness);
      if (info[1].rolling_friction !=nil)
       setprop("fdm/jsbsim/environment/terrain-rolling-friction",info[1].rolling_friction);
      if (info[1].names !=nil)
       setprop("fdm/jsbsim/environment/terrain-names",info[1].names[0]);

#unfortunately when on carrier the info[1]  is nil,  only info[0] is valid
#var terrain_name = info[1].names[0];
#print("NAME ",terrain_name);
      #if (terrain_name == "Ocean" and terrain_hight >  min_carrier_alt)
        #setprop("fdm/jsbsim/environment/terrain-oncarrier",1);
    }else{
setprop("fdm/jsbsim/environment/terrain-undefined",1);
}
	      #debug.dump(geodinfo(lat, lon));


  }else {
    setprop("fdm/jsbsim/environment/terrain-hight",0);
    setprop("fdm/jsbsim/environment/terrain-solid",1);
    setprop("fdm/jsbsim/environment/terrain-oncarrier",0);
    setprop("fdm/jsbsim/environment/terrain-light-coverage",1);
    setprop("fdm/jsbsim/environment/terrain-load-resistance",1e+30);
    setprop("fdm/jsbsim/environment/terrain-friction-factor",1);
    setprop("fdm/jsbsim/environment/terrain-bumpiness",0);
    setprop("fdm/jsbsim/environment/terrain-rolling-friction",0.02);
    setprop("fdm/jsbsim/environment/terrain-names","unknown");
    }

settimer (terrain_survol, 0.5);
}


terrain_survol();

###########################################################################
# Killer grass and other surfaces get now killed themselfs :)
# by HerbyW 07-2015
#

setlistener("fdm/jsbsim/environment/terrain-friction-factor", func { 
  
  if (getprop("fdm/jsbsim/environment/terrain-friction-factor") > 0.7)
  {
          setprop("fdm/jsbsim/environment/terrain-friction-factor", 0.8)
  }  
}
);

setlistener("fdm/jsbsim/environment/terrain-rolling-friction", func { 
  
  if (getprop("fdm/jsbsim/environment/terrain-rolling-friction") > 0.5)
  {
          
	  setprop("fdm/jsbsim/environment/terrain-rolling-friction", 0.25)
  }  
}
);



###########################################################################
# wildfire implementation by HerbyW 07-2015  have Fun!!!!
#

setprop("environment/wildfire/enabled",1);
setprop("environment/wildfire/share-events",1);
setprop("environment/wildfire/save-on-exit",1);
setprop("environment/wildfire/restore-on-startup",1);
setprop("environment/wildfire/fire-on-crash",1);
setprop("environment/wildfire/fire-on-impact",1);
setprop("environment/wildfire/report-score",1);
setprop("environment/wildfire/models/enabled",1);
setprop("environment/wildfire/models/fire-lod",5);
setprop("environment/wildfire/models/smoke-lod",5);

setlistener("/sim/signals/click", func {
  if (__kbd.shift.getBoolValue()) {
    if (__kbd.ctrl.getBoolValue()) {
      var click_pos = geo.click_position();
      wildfire.ignite(click_pos);
      setprop("sim/messages/copilot", "Wildfire made!");
    }
  }
});


setlistener("/sim/model/bomb-signal", func { 
  
  if (getprop("/fdm/jsbsim/fcs/water-qty-liters") > 1)
  {
          var drop_pos = geo.aircraft_position();
          wildfire.resolve_water_drop(drop_pos, 450, 1);
  }  
}
);

############## Liveboat Control on water ################################################

setlistener("/controls/switches/liveboat", func { 
  
  if (getprop("/fdm/jsbsim/environment/terrain-solid") != 0)
  {
          setprop("/controls/switches/liveboat", 0);
	  setprop("sim/messages/copilot", "The liveboat is working only on water!");
  }  
}
);
