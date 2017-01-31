/*
	
	author: TF47  mindbl4ster
	
	description:
		tracking units by markers on map.
	parameter:
		0: BOOL	(optional)		-	false:stop tracking
		1: ARRAY (optional)		-	side to track 
		2: ARRAY (optional)		-	types to track 
	return
		nothing
	example
		[] call tf47_debug_fnc_trackUnits;
		
*/
params [
	["_tracking",false],
	["_sides",[]],
	["_types",[]]
];
if (isNil "TF47_DEBUG_UNITTRACKING_PROCESS_STOP" )then{ TF47_DEBUG_UNITTRACKING_PROCESS_STOP = false; };
if (isNil "TF47_DEBUG_UNITTRACKING_PROCESS_ACTIVE" )then{ TF47_DEBUG_UNITTRACKING_PROCESS_ACTIVE = false; };
if (isNil "TF47_DEBUG_UNITTRACKING_SIDES" )then{ TF47_DEBUG_UNITTRACKING_SIDES = []; };
if (isNil "TF47_DEBUG_UNITTRACKING_TYPES" )then{ TF47_DEBUG_UNITTRACKING_TYPES = []; };

/*
	stop old tracking process
*/
if !_tracking exitWith { TF47_DEBUG_UNITTRACKING_PROCESS_STOP = !_tracking; };

/*
	terminate tracking process if already running. changes in unitarrays can lead to errors and leave markers on map
*/
if TF47_DEBUG_UNITTRACKING_PROCESS_ACTIVE then{
	TF47_DEBUG_UNITTRACKING_PROCESS_STOP = true;
	waitUntil{ !TF47_DEBUG_UNITTRACKING_PROCESS_ACTIVE };
	TF47_DEBUG_UNITTRACKING_PROCESS_STOP = false;
}else{
	TF47_DEBUG_UNITTRACKING_PROCESS_STOP = false;
};

/*
	change arrays for side and types to be tracked
*/
private _sideToTrack = [];
{ if (_x in [WEST,EAST,INDEPENDENT,CIVILIAN]) then{_sideToTrack pushBackUnique _x} } forEach _sides;
private _typesToTrack = [];
{ if ( (toLower _x) in ["man","car","ship","air","static","tank"]) then{_typesToTrack pushBackUnique _x} } forEach _types;
TF47_DEBUG_UNITTRACKING_SIDES = _sideToTrack;
TF47_DEBUG_UNITTRACKING_TYPES = _typesToTrack;

/*
	start loop
*/
[
{
	if !TF47_DEBUG_UNITTRACKING_PROCESS_STOP then{
		TF47_DEBUG_UNITTRACKING_PROCESS_ACTIVE	=	true;
		if("man" in TF47_DEBUG_UNITTRACKING_TYPES)then{
			{
				private _pos 	=	getPos _x;
				private _side	=	side _x;
				
				if( _side in TF47_DEBUG_UNITTRACKING_SIDES)then{
					
					if( _x isEqualTo vehicle _x )then{
					
						if (_x getVariable ["tf47_debug_unitTracking",""] isEqualTo "") then{

							private _str	=	format ["tf47_debug_trackUnit_%1_%2",_pos,_side];
							private _mkr	=	createMarkerLocal [_str, _pos];
							_mkr	setMarkerShapelocal "ICON";
							private _pre	=	switch(_side)do{
								case(WEST):{"b_inf"};
								case(EAST):{"o_inf"};
								case(INDEPENDENT):{"n_inf"};
								default{"c_unknown"};
							};
						
							_mkr 	setMarkerTypeLocal (_pre);
							_mkr 	setMarkerSizeLocal	[0.5,0.5];
							_mkr 	setMarkerAlphaLocal 1;	
							
							_x setVariable ["tf47_debug_unitTracking",_mkr];
							
						}else{
						
							private _mkr = _x getVariable ["tf47_debug_unitTracking",""];
							
							if( alive _x)then{
								_mkr setMarkerPosLocal _pos;
								private _pre	=	switch(_side)do{
									case(WEST):{"b_inf"};
									case(EAST):{"o_inf"};
									case(INDEPENDENT):{"n_inf"};
									default{"c_unknown"};
								};
								_mkr 	setMarkerTypeLocal _pre;				
							}else{
								_x setVariable ["tf47_debug_unitTracking",nil];
								deleteMarkerLocal _mkr;
							};
							
						};
					};
				};
			}forEach allUnits;
		};
		
		{
			private _pos 	=	getPos _x;
			private _side	=	if( count crew _x != 0 )then{ 
				side (	(crew _x) select 0	) 
			}else{ 
				//read config entry for empty vehicles
				private _number	=	getNumber (configFile >> "CfgVehicles" >> (typeOf _x) >> "side");
				private _return = switch(_number)do{
					case(0):{EAST};
					case(1):{WEST};
					case(2):{INDEPENDENT};
					case(3):{CIVILIAN};
					default {NEUTRAL};
				};
				_return
			};
			if( _side in TF47_DEBUG_UNITTRACKING_SIDES)then{
				if(_x getVariable ["tf47_debug_unitTracking",""] isEqualTo "")then{
					private _parents = ( [(configFile >> "CfgVehicles" >> (typeOf _x)), true] call BIS_fnc_returnParents ) apply {tolower _x};
					if( ({_x in TF47_DEBUG_UNITTRACKING_TYPES} count _parents) > 0)then{
						private _pre	=	switch(_side)do{
								case(WEST):{"b_"};
								case(EAST):{"o_"};
								case(INDEPENDENT):{"n_"};
								default{"c_"};
							};
						private _main = "unknown";
						if(_side != CIVILIAN)then{
							if(_side != CIVILIAN)then{
								if ( "car" in _parents ) then { _main	=	"motor_inf" };
								if ( "tank" in _parents ) then { _main	=	"armor" };
								if ( "static" in _parents ) then { _main	=	"installation" };
								if ( "ship" in _parents ) then { _main	=	"naval" };
								if ( "air" in _parents ) then { _main	=	"air" };
							};
						};	
						private _str	=	format ["tf47_debug_trackUnit_%1_%2",_pos,_side];
						private _mkr	=	createMarkerLocal [_str, _pos];
								_mkr	setMarkerShapelocal "ICON";
						if(count crew _x == 0)then{	_mkr setMarkerColorLocal "ColorBlack"};
						_mkr 	setMarkerTypeLocal (_pre + _main);
						_mkr 	setMarkerSizeLocal	[0.5,0.5];
						_x setVariable ["tf47_debug_unitTracking",_mkr];
					};
				}else{
					if(alive _x)then{
						private _mkr = _x getVariable ["tf47_debug_unitTracking",""];
						_mkr setMarkerPosLocal _pos;
						private _pre	=	switch(_side)do{
							case(WEST):{"b_"};
							case(EAST):{"o_"};
							case(INDEPENDENT):{"n_"};
							default{"c_"};
						};
						private _main = "unknown";
						if(_side != CIVILIAN)then{
							private _parents = ( [(configFile >> "CfgVehicles" >> (typeOf _x)), true] call BIS_fnc_returnParents ) apply {tolower _x};
							if ( "car" in _parents ) then { _main	=	"motor_inf" };
							if ( "tank" in _parents ) then { _main	=	"armor" };
							if ( "static" in _parents ) then { _main	=	"installation" };
							if ( "ship" in _parents ) then { _main	=	"naval" };
							if ( "air" in _parents ) then { _main	=	"air" };
						};
						_mkr 	setMarkerTypeLocal (_pre + _main);
					}else{
						deleteMarkerLocal _mkr;
						_x setVariable ["tf47_debug_unitTracking",nil];
					};
				};
			};
		}forEach vehicles;	
		
	}else{
		{
			private _mkr = toArray _x; _mkr resize 20;
			if ( toString _mkr isEqualTo "tf47_debug_trackUnit" ) then {
				deleteMarkerLocal _x;
			};
		}forEach allMapMarkers;
		{
			_x setVariable ["tf47_debug_unitTracking",nil];
		}forEach (allUnits select {!isNil (_x getVariable "tf47_debug_unitTracking")});
		{
			_x setVariable ["tf47_debug_unitTracking",nil];
		}forEach (vehicles select {!isNil (_x getVariable "tf47_debug_unitTracking")});
		TF47_DEBUG_UNITTRACKING_PROCESS_ACTIVE = false;
		[_this select 1] call CBA_fnc_removePerFrameHandler;
	};
},
0.1,
[]
] call CBA_fnc_addPerFrameHandler;
