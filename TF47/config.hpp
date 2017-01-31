/*
	set settings for radiocommunication if mod taskforce radio arrowhead radio is used
	RADIOCHANNEL 0: "Radio Communication - Public I"
	RADIOCHANNEL 1: "Radio Communication - Event"
	RADIOCHANNEL 2: "Radio Communication - DEV"
*/

#define RADIOCHANNEL 1

/*
	set option to display custom intro on missionstart
	intro will not be shown on jip clients
	INTRO	false	-	do NOT show intro
	INTRO	true	-	do show intro
*/

#define INTRO	true

/*
	set option to activate tracker for specific side and unittypes on map
	TRACKING true	-	will show markers on map
	TRACKING false	-	will not track units
*/

#define TRACKING false

/*
	set option to display tracking marker for specific side
	possible options: WEST, EAST, INDEPENDENT, CIVILIAN
*/

#define SIDES	[WEST,EAST,INDEPENDENT,CIVILIAN]

/*
	set option to display tracking marker for specific unittypes
	possible options: "man", "car", "ship", "air", "static", "tank"
*/

#define TYPES	["car","ship","air","static","tank"]