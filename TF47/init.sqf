// do not edit unless you know what you are doing!
#include "config.hpp"

[] call compileFinal preprocessFileLineNumbers "tf47\misc\tf47_transfereUnits.sqf";
[ RADIOCHANNEL ] call compileFinal preprocessFileLineNumbers "tf47\misc\tf47_radiosettings.sqf";
if INTRO then { [] call compile preprocessFileLineNUmbers "tf47\misc\intro.sqf"; };
[ TRACKING, SIDES, TYPES ] call compile preprocessFileLineNUmbers "tf47\misc\tf47_trackUnits.sqf"; 
