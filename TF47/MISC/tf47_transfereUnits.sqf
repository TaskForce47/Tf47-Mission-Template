/*
	
	author: TF47  mindbl4ster
	
	credits: blaubär [W]
	
	last edited: 2017.01.14
	
	description:
		automated system for balancing groups between server and headlessclients. the system requieres the arma 3 modification @cba_a3.
		if one or more curators are used in the mission the system will automaticly apply eventhandlers to transfere placed groups and make them editable for all curator entities.
		on the serverside of things there will be a loop to detect created groups and automaticly transfere them.
		if headlessclients need to be reserved for special purposses initialise them with:
			this setVariable ["tf47_core_hc_isReserved",true];
			
	localtity of file execution:
		global
			
	parameter:
		nothing
		
	return
		nothing
		
	example
		n.a.
		
*/


{
    _x addEventHandler ["CuratorGroupPlaced", {
        params ["", "_group"];
        ["TF47_core_hc_transferObject", [_group]] call CBA_fnc_serverEvent;
    }];

    _x addEventHandler ["CuratorObjectPlaced", {
        params ["", "_object"];
        if (_object isKindOf "CAManBase") then {
            if (count units _object == 1) then {
                ["TF47_core_hc_transferObject", [group _object]] call CBA_fnc_serverEvent;
            };
        } else {
            if (count crew _object > 1) then {
                ["TF47_core_hc_transferObject", [group (crew _object select 0)]] call CBA_fnc_serverEvent;
            };
        };
    }];

    false
} count (entities "moduleCurator_F");

if !isServer exitWith {};

[
{
	//need loop to see if units were created without calling directly the cba_fnc_serverEvent
	//only transfere one unit in one cycle to get the necessary time to make an effectiv group owner change over the network
	private _groups = allGroups select { _x getVariable ["tf47_core_hc_groupToTransfere",true] };
	if(count _groups > 0)then{
		private _grp = selectRandom _groups;
		["TF47_core_hc_transferObject", [_grp]] call CBA_fnc_serverEvent;
	};
},
0.2,
[]
] call cba_fnc_addperframehandler;

["TF47_core_hc_transferObject", {
    params ["_group"];
	//mark as processed unit
	_group setVariable ["tf47_core_hc_groupToTransfere",false];
	//make the unit editable for curator entities
	if(	[_group] isEqualTypeParams [grpNull]	)then{
		{
			_x addCuratorEditableObjects [units _input,	true];
		}forEach (entities "moduleCurator_F");
	};
	//see if headlessclients are available
	//and if hc entitiy is not reserved for special purposes
    private _activeHCs = (entities "HeadlessClient_F") select {!local _x && !(_x getVariable ["tf47_core_hc_isReserved",false]) };
    if (_activeHCs isEqualTo []) exitWith {
		//transfere unit from client (curator) to server
		_group setGroupOwner 0;
	};
	
	//create feedback arrays
    private _hcClientIDs = _activeHCs apply {owner _x};		
    private _hcsWithLoad = _hcClientIDs apply {[0, _x]};	

	//quick search through all groups
    {
        private _hcIndex = _hcClientIDs find groupOwner _x;
        if (_hcIndex != -1) then {
            private _loadArray = _hcsWithLoad select _hcIndex;
            _loadArray params ["_load", "_hcID"];
            _loadArray set [0,_load + count units _x];
            _hcsWithLoad set [_hcIndex, _loadArray];
        };

        false
    } count allGroups;

    _hcsWithLoad sort true;
	//transfere unit from zeus to server or hc with lowest load
    _group setGroupOwner ((_hcsWithLoad select 0) select 1);
	
}] call CBA_fnc_addEventHandler;