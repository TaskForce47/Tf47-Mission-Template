// Control types
#define CT_STATIC	0
#define CT_STRUCTURED_TEXT 13

// Static styles
#define ST_LEFT	0
#define ST_RIGHT	1
#define ST_CENTER	2
#define ST_UP		3
#define ST_DOWN	4
#define ST_VCENTER	5

#define ST_SINGLE	0
#define ST_MULTI	16
#define ST_PICTURE	48
#define ST_FRAME	64

#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE 144
#define ST_WITH_RECT 160
#define ST_LINE	176

#define ST_SHADOW	256
#define ST_NO_RECT	512

#define FontM "EtelkaNarrowMediumPro"
#define ST_LEFT      0
#define ST_RIGHT     1
#define ST_CENTER    2
#define CT_STATIC    0

class RscPicture
{
	idc = -1;
	type = CT_STATIC;
	style = ST_CENTER + ST_PICTURE;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	font = "EtelkaNarrowMediumPro";
	sizeEx = 0.02;
};
class FHQ_Logo {
	idd = -1;
	movingEnable = 0;
	duration = 30;
	name = "FHQ_Logo";
	controls[] = {"Picture"};
	class Picture: RscPicture
	{
		idc = 1200;
		text = "images\logo.paa";
		x = 0.788375 * safezoneW + safezoneX;
		y = 0.731306 * safezoneH + safezoneY;
		w = 0.199465 * safezoneW;
		h = 0.32161 * safezoneH;
	};
};

class FHQ_Logo2 {
	idd = -1;
	movingEnable = 0;
	duration = 30;
	name = "FHQ_Logo2";
	controls[] = {"Picture"};
	class Picture: RscPicture
	{
		idc = 1200;
		text = "images\logo2.paa";
		x = 0.788375 * safezoneW + safezoneX;
		y = 0.731306 * safezoneH + safezoneY;
		w = 0.199465 * safezoneW;
		h = 0.32161 * safezoneH;
	};
};
#define IDC_FHQ_3DEDIT_MOUSETARGET 1001

class RscText
{
	type = 0;
	idc = -1;
	style = 0;
	shadow = 2;
	colorBackground[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	font = "PuristaMedium";
	sizeEx = 0.02;
	text = "";
	x = 0;
	y = 0;
	w = 0;
	h = 0;
	fixedWidth = 0;
};

class RscStructuredText
{
	style = 0;

	x = 0;
	y = 0;
	h = 0.035;
	w = 0.1;
	text = "";
	size = 0.02; //"(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	sizeEx = 0.02;
	colorText[] = {1,1,1,1.0};
	shadow = 1;
	class Attributes
	{
		font = "PuristaMedium";
		color = "#ffffff";
		align = "left";
		shadow = 1;
		size = "1";
	};
};

class RscIntroDialog {
	onload = "uinamespace setvariable ['fhq_title',_this select 0];";
	idd = 888;
	movingEnable = false;
	moving = false;
	duration=10e10;
	enableSimulation = true;
	x = safeZoneX;
	y = safeZoneY;
	w = safeZoneW;
	h = safeZoneH;

	class Controls {
		class RscText_1000: RscText
		{
			idc = 1000;
			text = "";
			style = 48;
			x = 0.00499997 * safezoneW + safezoneX;
			y = 0.00500001 * safezoneH + safezoneY;
			w = 0.0125;
			h = 0.0125;
			fixedWidth = 0;
		};
		class RscLineMeasure : RscStructuredText
		{
			type = 13;
			idc = 999;
			text = "";
		};
		class RscLine_1 : RscText
		{
			idc = 1001;
			text = "";
		};
		class RscLine_2 : RscText
		{
			idc = 1002;
			text = "";
		};
		class RscLine_3 : RscText
		{
			idc = 1003;
			text = "";
		};
		class RscLine_4 : RscText
		{
			idc = 1004;
			text = "";
		};
		class RscLine_5 : RscText
		{
			idc = 1005;
			text = "";
		};
		class RscLine_6 : RscText
		{
			idc = 1006;
			text = "";
		};
		class RscLine_7 : RscText
		{
			idc = 1007;
			text = "";
		};		
		class RscLine_8 : RscText
		{
			idc = 1008;
			text = "";
		};
		class RscLine_9 : RscText
		{
			idc = 1009;
			text = "";
		};
		class RscLine_10 : RscText
		{
			idc = 1010;
			text = "";
		};
		class RscLine_11 : RscText
		{
			idc = 1011;
			text = "";
		};
		class RscLine_12 : RscText
		{
			idc = 1012;
			text = "";
		};
		class RscLine_13 : RscText
		{
			idc = 1013;
			text = "";
		};
		class RscLine_14 : RscText
		{
			idc = 1014;
			text = "";
		};
		class RscLine_15 : RscText
		{
			idc = 1015;
			text = "";
		};

	};

};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
/* #Werohy
$[
	1.062,
	["FHQ_3DEdit_GUI",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1000,"",[1,"FHQ 3D Editor",["0.00499997 * safezoneW + safezoneX","0.00500001 * safezoneH + safezoneY","0.0670312 * safezoneW","0.011 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
