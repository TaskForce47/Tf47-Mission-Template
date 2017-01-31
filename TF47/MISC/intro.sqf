FHQ_PlayerIsJIP = false;
if (isNull player && !isServer) then {
    FHQ_PlayerIsJIP = true;
};

/* Fade out only if intro not played, and only for non-JIP players */
if (isNil "FHQ_IntroDone" && !FHQ_PlayerIsJIP) then
{  
	0 fadesound 0;
	cutText ["", "BLACK FADED", 999];
};
waitUntil {!isNil "BIS_fnc_init"};
if (!isDedicated) then
{
	waitUntil {!(isNull player)};
    waitUntil {alive player};
};

call compile preprocessFileLineNumbers "tf47\misc\tickerCode.sqf";

if (isDedicated) exitWith {};

//#define SOUND_FADE_IN	"PMC_ElectricBlast1"
//#define SOUND_FADE_OUT	"PMC_ElectricBlast2"

#define SOUND_FADE_IN	"skirmishEntering"
#define SOUND_FADE_OUT	"skirmishEntering"

FHQ_fnc_date2String = {
	/* Create a string for the given date.
	 * Date is standard 'date' output, i.e. [year, month, day, hour, minute]
	 */

	private ["_year", "_day", "_month", "_endString"];
	_year = _this select 0;

	_day = _this select 2;

	_month = ["Unknowinus", "January", "February", "March", "April", "May", "June", "July",
			  "August", "September", "October", "November", "December"] 
			select (_this select 1);

	_endString = "th";
	if (_day == 1 || _day == 21 || _day == 31) then
	{
		_endString = "st";
	};

	if (_day == 2 || _day == 22) then
	{
		_endString = "nd";
	};


	_dateString = format["%1 %2%3, %4", _month, _day, _endString, _year];

	_dateString;
};

FHQ_fnc_time2FuzzyString = {
	/* Convert time into a fuzzy string
	 * _this select 0   time
	 * _this select 1   prefix
	 * _this select 2   suffix
	 */ 

	private ["_curTime", "_timeString", "_prefix", "_suffix", "_res"];

	_curTime = _this select 0;
	_prefix = _this select 1;
	_suffix = _this select 2;
	 
	if (_curTime < 4) then
	{
		_timeString = "Night";
	};
	if (_curTime >= 4 && _curTime < 8) then
	{
		_timeString = "Early Morning";  
	};
	if (_curTime >= 8 && _curTime < 11) then
	{
		_timeString = "Morning";
	};
	if (_curTime >= 11 && _curTime < 14) then
	{
		_timeString = "Noon";  
	};
	if (_curTime >= 14 && _curTime < 17) then
	{
		_timeString = "Afternoon";
	};
	if (_curTime >= 17 && _curTime < 20) then
	{
		_timeString = "Early Evening";
	};
	if (_curTime >= 20 && _curTime < 23) then
	{
		_timeString = "Evening";
	};
	if (_curTime >= 23) then
	{
		_timeString = "Night";
	};

	_res = format["%1%2%3", _prefix, _timeString, _suffix];

	_res;
};
FHQ_preload_complete = true; 

[] spawn 
{
    waitUntil {!(isNil "FHQ_preload_complete")};
    
    if (FHQ_PlayerIsJIP) then {
     	cutText ["", "BLACK IN", 1];
		1 fadeSound 1;
        FHQ_IntroDone = true;
    }
    else
    {
    	FHQ_IntroDone = true;
		cutText ["", "BLACK FADED", 999];
		_handle = [
			8, 
			[1,1,1,1], 
			"Douglas MacArthur",	//author
			"“Whoever said the pen is mightier than the sword", //line 1
			"obviously never encountered automatic weapons.”" //line2
		] execVM "tf47\misc\newQuote.sqf";
		waitUntil {scriptDone _handle};

		"dynamicBlur" ppEffectEnable true;   
		"dynamicBlur" ppEffectAdjust [6];   
		"dynamicBlur" ppEffectCommit 0;     
		"dynamicBlur" ppEffectAdjust [0.0];  
		"dynamicBlur" ppEffectCommit 3;  
		cutText ["", "BLACK IN", 5];
		2 fadeSound 1;
		sleep 2;

	 	_dateString = date call FHQ_fnc_date2String;
		 _timeString = [daytime, "", ""] call FHQ_fnc_time2FuzzyString;
		
		/*
		[5, true, [0.4,1,1,1], """Moutain King""",
 		"Near Mt. Tafos, Altis",
		"NATO Recon Unit Hawkeye 2",
		"July 6th, 2045 - %1"]	execVM "tf47\misc\ticker.sqf";
		*/
		sleep 5;
		//playSound [SOUND_FADE_OUT, true];
		100012 cutfadeout 0;
		sleep 3;
	};        
};
