/*
 * _this select 0: Delay/Time to show quote
 * _this select 1: Color for quote
 * _this select 2: Author of quote
 * _this select 3...n: Lines
 */

_delay = _this select 0;
_color = _this select 1;
_author = _this select 2;

_stdHeight = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);

_top = 0.2;

//player sideChat format ["%1 - %2", _stdHeight, _base];

true call FHQ_Ticker_Start;

for "_i" from 3 to (count _this)-1 do {
	private ["_num", "_flag"];
	_num = _i - 2;
	[_num, _color] call FHQ_Ticker_setColor;
	_flag = false;
	if (_i == 3) then {
		_flag = true;
	};
	sleep 0.3;
	[_this select _i, 0.2, _top, _num, _flag, _stdHeight] call FHQ_Ticker_Single;
	_top = _top + _stdHeight;
};

sleep 2;
_num = count _this - 2;
_top = _top + _stdHeight;
[_author, 0.3, _top, _num, false, _stdHeight, "PuristaBold"] call FHQ_Ticker_Single;


sleep _delay;
call FHQ_Ticker_CLS;
sleep 1;
call FHQ_Ticker_End;