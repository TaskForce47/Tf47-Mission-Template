#define CLICK "ReadoutClick"

FHQ_Ticker_getCursorPos = {
	private ["_cp", "_res"];
	_cp = FHQ_Ticker_Running getVariable "FHQ_Ticker_CursorPos";
	_res = [_cp select 0, _cp select 1];
	_res
};

FHQ_Ticker_setCursorHeight = {
	private ["_height", "_cp", "_scale"];
	_height = _this;
	//_cp = FHQ_Ticker_Running getVariable "FHQ_Ticker_CursorPos";
	_scale = _height / 0.0125; //(_cp select 3);
	
	FHQ_Ticker_Running setVariable ["FHQ_Ticker_CursorScale", _scale * 0.9];
	FHQ_Ticker_Running setVariable ["FHQ_move_Cursor", true];
};

FHQ_Ticker_setCursorPos = {
	private "_cp";
	_cp = call FHQ_Ticker_getCursorPos;
	_cp set [0, _this select 0];
	_cp set [1, _this select 1];
	FHQ_Ticker_Running setVariable ["FHQ_Ticker_CursorPos", _cp];
	FHQ_Ticker_Running setVariable ["FHQ_move_Cursor", true];
};

FHQ_Ticker_Start = {
	disableSerialization;
	_fade = "plain";
	if (_this) then {
		_fade = "Black";
	};
	
	100011 cutrsc ["RscIntroDialog", _fade];
	sleep 1;
	
	waitUntil {
		_xxx = uinamespace getvariable "FHQ_title";
		!isNil ("_xxx")
	};
	
	_display = uinamespace getvariable "FHQ_title";
	_display displayAddEventHandler ["unload", {uinamespace setVariable ["FHQ_title", objNull];}];
	FHQ_Ticker_Running = "Logic" createVehicleLocal [0,0,0];
	FHQ_Ticker_Running setVariable ["FHQ_Ticker_CursorPos", [
		0.00499997 * safezoneW + safezoneX,
		0.00500001 * safezoneH + safezoneY,
		0.01, 
		0.0125]
	];
	FHQ_Ticker_Running setVariable ["FHQ_move_Cursor", false];
	FHQ_Ticker_Running setVariable ["FHQ_Ticker_CursorScale", 1];
	
	{
		(_display displayCtrl _x) ctrlShow false;
		(_display displayCtrl _x) ctrlCommit 0;
	} forEach [1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015];
	
	// Spawn the cursor handler
	
	[_display] spawn {
		disableSerialization;
		_cursors = [
			"library\cursor_1.paa",
			"library\cursor_2.paa",
			"library\cursor_3.paa",
			"library\cursor_4.paa",
			"library\cursor_5.paa",
			"library\cursor_4.paa",
			"library\cursor_3.paa",
			"library\cursor_2.paa"
		];
		
		_display = _this select 0;
		_oldCursor = -1;
		_lastTime = time;
		while {!isnull FHQ_Ticker_Running} do {
			/*
			_deltaTime = time - _lastTime;
			_cursor = ((_deltaTime - floor(_deltaTime)) * 28) mod 7;
			if (_oldCursor != _cursor) then {
				_oldCursor = _cursor;
				(_display displayCtrl 1000) ctrlSetText (_cursors select _cursor);
				(_display displayCtrl 1000) ctrlCommit 0;
			};
			*/
			if (FHQ_Ticker_Running getVariable "FHQ_move_Cursor") then {
				_res = FHQ_Ticker_Running getVariable "FHQ_Ticker_CursorPos";
				FHQ_Ticker_Running setVariable ["FHQ_move_Cursor", false];
				(_display displayCtrl 1000) ctrlSetPosition _res;
				(_display displayCtrl 1000) ctrlSetScale (FHQ_Ticker_Running getVariable "FHQ_Ticker_CursorScale");
				(_display displayCtrl 1000) ctrlCommit 0;
				_lastTime = time;
			};
			_res = FHQ_Ticker_Running getVariable "FHQ_Updater";
			if (!isnil "_res") then {
				private ["_newSec", "_newText", "_dateString"];
				//player sideChat str _res;
				_newSec = floor time;
				
				if (_newSec != _res select 2) then {
					// Need to update
					_dateString = call FHQ_Ticker_formatTime;
					_newText = format [_res select 0, _dateString];
					(_display displayCtrl (1000 + (_res select 1)))
						ctrlSetText _newText;
					(_display displayCtrl (1000 + (_res select 1)))
						ctrlCommit 0;
					playSound CLICK;
					FHQ_Ticker_Running setVariable ["FHQ_Updater",
						[_res select 0, _res select 1, _newSec]];
				};
			};
		};
	};
	
	[0.00499997 * safezoneW + safezoneX, 0.00500001 * safezoneH + safezoneY] call FHQ_Ticker_setCursorPos;
	(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1) call FHQ_Ticker_setCursorHeight;
};

FHQ_Ticker_End = {
	disableSerialization;
	_display = uinamespace getvariable "FHQ_title";
	_tmp = FHQ_Ticker_Running;
	FHQ_Ticker_Running = objNull;
	deleteVehicle _tmp;
	{
		(_display displayCtrl _x) ctrlShow false;
		(_display displayCtrl _x) ctrlCommit 0;
	} forEach [1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015];
	
	100011 cutfadeout 0;
};

FHQ_Ticker_LeftCut = {
	private ["_text", "_cut", "_array", "_array2", "_i"];
	_text = _this select 0;
	_cut = _this select 1;
	_array = toarray _text;
	_array2 = [];
	for "_i" from 0 to _cut do {
		_array2 set [_i, _array select _i];
	};
	
	_text = tostring _array2;
	_text
};

/*
 * Get the length of a text in screen estate
 *
 * Parameters:
 * _this select 0: Text
 * _this select 1: (Optional) Font size
 * _this select 2: (Optional) Font
 */
FHQ_Ticker_PixelLength = {
	private ["_display", "_text", "_ctrl", "_size", "_font", "_targetHeight", "_realHeight", "_w", "_scale"];
	_text = [_this, 0, "tick", [""]] call BIS_fnc_param;
	_size = [_this, 1, (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1), [0]] call BIS_fnc_param;
	_font = [_this, 2, "PuristaMedium",  [""]] call BIS_fnc_param;

	_scale = _size / 0.02;
	
	disableSerialization;
	_display = uinamespace getvariable "FHQ_title";
	_ctrl =  (_display displayCtrl 999);
	_ctrl ctrlSetPosition [0,0, safeZoneW, safeZoneH];
	_ctrl ctrlShow false;
	_ctrl ctrlSetStructuredText (parseText format ["<t size=""%1"">%2</t>", _scale, _text]);
	_ctrl ctrlSetFont _font;
	_ctrl ctrlSetFontHeight _size;
	_ctrl ctrlCommit 0;
	
	_targetHeight = ctrlTextHeight _ctrl;
	_realHeight = 2;
	_ctrl ctrlSetPosition [0,0, _size, safeZoneH];
	_ctrl ctrlCommit 0;
	
	_w = _size;
	
	while {_realHeight != _targetHeight} do {
		_ctrl ctrlSetPosition [0,0,_w, 1];
		_ctrl ctrlCommit 0;
		_realHeight = ctrlTextHeight _ctrl;
		_w = _w + (_size / 2);
	};
	
	_w
};
/*
 * Single ticker
 *
 * Parmeters:
 * _this select 0: Text to ticker
 * _this select 1: X position
 * _this select 2: Y position
 * _this select 3: line # (1-15)
 * _this select 4: (Optional) Move cursor and wait before starting ticker
 * _this select 5: (Optional) Font size
 * _this select 6: (Optional) Font
 *
 */
FHQ_Ticker_SingleHandler = {
	private ["_text", "_xPos", "_yPos", "_line", "_move", "_size", "_font",
		"_time", "_cp", "_startPos", "_lerp", "_newPos",
		"_display", "_ctrl", "_width", "_step", "_i"];
	_text = [_this, 0, "tick", [""]] call BIS_fnc_param;
	_xPos = [_this, 1, 0, [0]] call BIS_fnc_param;
	_yPos = [_this, 2, 0, [0]] call BIS_fnc_param;
	_line = [_this, 3, 1, [0]] call BIS_fnc_param;
	_move = [_this, 4, false, [true]] call BIS_fnc_param;
	_size = [_this, 5, (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1), [0]] call BIS_fnc_param;
	_font = [_this, 6, "PuristaMedium",  [""]] call BIS_fnc_param;

	
	if (_move) then {
		// Phase 1 : move the cursor semi-quickly to the Y coordinate.
		_time = time;
		_cp = [] call FHQ_Ticker_getCursorPos;
		_startPos = _cp select 1;
		while {_time + 0.4 > time} do {
			_lerp = (time - _time) / 0.4;
			_newPos = _startPos + _lerp * (_yPos - _startPos);
			[_cp select 0, _newPos] call FHQ_Ticker_setCursorPos;
		};
		
		[_cp select 0, _yPos] call FHQ_Ticker_SetCursorPos;
		[_xPos, _yPos] call FHQ_Ticker_setCursorPos;
		sleep 1;
	};
	[_xPos, _yPos] call FHQ_Ticker_setCursorPos;
	_size call FHQ_Ticker_setCursorHeight;	
	disableSerialization;
	_display = uinamespace getvariable "FHQ_title";
	_ctrl =  (_display displayCtrl (1000 + _line));
	
	// Get the text dimensions
	_width = [_text, _size, _font] call FHQ_Ticker_PixelLength;
	
	
	_ctrl ctrlSetFont _font;
	_ctrl ctrlSetText  _text;
	_ctrl ctrlSetFontHeight _size; 
	_ctrl ctrlShow true;
	_ctrl ctrlSetPosition [_xPos, _yPos, 0, _size];
	[_xPos + _width, _yPos] call FHQ_Ticker_setCursorPos;
	_step = safeZoneW / 70;
	_ctrl ctrlCommit 0;
	
	_i = 0;
	_startTime = time;
	waitUntil {
		_ctrl ctrlSetPosition [_xPos, _yPos, _i, _size];
		_ctrl ctrlCommit 0;
		playSound CLICK;
		[_xPos + _i, _yPos] call FHQ_Ticker_setCursorPos;
		//_i = _i + _step;
		_deltaTime = time - _startTime;
		_i = _deltaTime * _width;
		_i >= _width
	};
	
	
	FHQ_Ticker_Running setVariable ["FHQ_ticking", false];
};

FHQ_Ticker_Single = {
	FHQ_Ticker_Running setVariable ["FHQ_ticking", true];
	_this spawn FHQ_Ticker_SingleHandler;
	waitUntil {!(FHQ_Ticker_Running getVariable "FHQ_ticking")};
};

/*
 * _this select 0 : Line #
 * _this select 1 : Colour
 */
FHQ_Ticker_SetColor = {
	_line  = [_this, 0, 1, [0]] call BIS_fnc_param;
	_color = [_this, 1, [1,1,1,1], [[]]] call BIS_fnc_param;
	disableSerialization;
	_display = uinamespace getvariable "FHQ_title";
	_ctrl =  (_display displayCtrl (1000 + _line));
	
	_ctrl ctrlSetTextColor _color;
};

// Format a number with a leading zero if needed
// call as [number] call _formatNumber
FHQ_Tick_formatNumber = {
	private ["_res"];
	if (_this select 0 < 10) then
	{
		_res = format ["0%1", _this select 0];
	}
	else
	{
		_res = format ["%1", _this select 0];
	};
	
	_res
};

FHQ_Ticker_formatTime = {
	private ["_dateStamp", "_text", "_num", "_time"];
	
	_text = "";
	_dateStamp = date;
	
	_text = [_dateStamp select 3] call FHQ_Tick_formatNumber;
	
	_num = [_dateStamp select 4] call FHQ_Tick_formatNumber;
	_text = _text + ":" + _num + ":";
	_time = (floor time) mod 60;
	_num =  [_time] call FHQ_Tick_formatNumber;
	_text =  _text + _num;
	_text
};

/*
 * Single ticker that will format in the time and update it, C-o-D style
 *
 * Parmeters:
 * _this select 0: Text to ticker
 * _this select 1: X position
 * _this select 2: Y position
 * _this select 3: line # (1-15)
 * _this select 4: (Optional) Move cursor and wait before starting ticker
 * _this select 5: (Optional) Font size
 * _this select 6: (Optional) Font
 *
 */
FHQ_Ticker_SingleWithDate = {
	private ["_text", "_dateString", "_newText"];
	_text = [_this, 0, "tick", [""]] call BIS_fnc_param;

	_dateString = call FHQ_Ticker_formatTime;
	_newText = format [_text, _dateString];
	_this set [0, _newText];
	_this call FHQ_Ticker_Single;
	
	FHQ_Ticker_Running setVariable [
		"FHQ_Updater",
		[_text, _this select 3, floor (time)]
	];
};

FHQ_Ticker_CLSTask = {
	disableserialization;
	private ["_display", "_ctrl"];
	
	_display = uinamespace getvariable "FHQ_title";
	
	{
		_ctrl = (_display displayCtrl _x); 
		if (ctrlShown _ctrl) then {
			_cp = ctrlPosition _ctrl;
			[_cp select 0, _cp select 1] call FHQ_Ticker_setCursorPos ;
			(_cp select 3) call FHQ_Ticker_SetCursorHeight;
			playsound CLICK;
			sleep 0.1;
			[(_cp select 0) + (_cp select 2), _cp select 1] call FHQ_Ticker_SetCursorPos;
			playSound CLICK;
			_ctrl ctrlShow false;
			_ctrl ctrlCommit 0;
			playSound CLICK;
		};
	} forEach [1001, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015];
	
	[0.00499997 * safezoneW + safezoneX, 0.00500001 * safezoneH + safezoneY] call FHQ_Ticker_setCursorPos;
	(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1) call FHQ_Ticker_setCursorHeight;

	FHQ_Ticker_Running setVariable ["FHQ_ticking", false];
};

FHQ_Ticker_CLS = {
	FHQ_Ticker_Running setVariable ["FHQ_ticking", true];
	
	_this spawn FHQ_Ticker_CLSTask;
	waitUntil {!(FHQ_Ticker_Running getVariable "FHQ_ticking")};
};
	