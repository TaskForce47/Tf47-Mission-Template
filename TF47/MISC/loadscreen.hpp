class RscText {
	type = 0;
	idc = -1;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0x100;
	font = EtelkaNarrowMediumPro;
	SizeEx = 0.03921;
	colorText[] = {1,1,1,1};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};

class RscPicture {
	access=0;
	type=0;
	idc=-1;
	style=48;
	colorBackground[]={0,0,0,0};
	colorText[]={1,1,1,1};
	font=EtelkaNarrowMediumPro;
	sizeEx=0;
	lineSpacing=0;
	text="";
};

class RscLoadingText : RscText {
	  x =  SafezoneX+0.025;
	  y = SafezoneY;
	  w = SafezoneW*0.95;
	  h = SafezoneH*0.075;
	  sizeEx = 0.05;
	  text = "";
	  colorText[] = {1,1,0.8,1};
	  shadow = 2;
};

class RscProgress {
    idc = 104;
    type = 8;
    style = 0;
    shadow = 2;
    texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
    colorFrame[] = {0,0,0,0};
    colorBar[] = {1,1,1,1};
    x =  (SafezoneX+(SafezoneW -SafezoneH*3/4)/2)+ (0.5/2/4)*3*SafezoneH;
    y = SafezoneY+SafezoneH*0.95;
    w =0.5* (((SafezoneW*3)/4)/SafezoneW)/(1/SafezoneH);
    h = 0.0261438;
};

class RscProgressNotFreeze {
	idc = -1;
	type = 45;
	style = 0;
	x = 0.022059;
	y = 0.911772;
	w = 0.029412;
	h = 0.039216;
	texture = "#(argb,8,8,3)color(0,0,0,0)";
};

class FHQ_loadingScreen {
	idd = -1;
	duration = 10e10;
	fadein = 0;
	fadeout = 0;
	name = "loading screen";
	class controlsBackground {
		class blackBG : RscText {
			x = safezoneXAbs;
			y = safezoneY;
			w = safezoneWAbs;
			h = safezoneH;
			text = "";
			colorText[] = {0,0,0,0};
			colorBackground[] = {0,0,0,1};
		};

		class nicePic : RscPicture {
			style = 48 + 0x800; // ST_PICTURE + ST_KEEP_ASPECT_RATIO
			  x =  SafezoneX;
			  y = SafezoneY+SafezoneH*0.075;
			  w = SafezoneW;
			  h = SafezoneH*0.85;
			text = "images\loadscreen.paa";
		};
	};

	class controls {
		class Title1 : RscLoadingText {
			text = "$STR_LOADING"; // "Loading" text in the middle of the screen
		};

		class CA_Progress : RscProgress {
			idc = 104; type = 8; // CT_PROGRESS
			style = 0; // ST_SINGLE
			//texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
			texture = "\A3\ui_f\data\GUI\RscCommon\RscProgress\progressbar_ca.paa";
		};

		class CA_Progress2 : RscProgressNotFreeze {
			idc = 103;
		};

		class Name2: RscText {
			idc = 101;
			x = 0.05;
			y = 0.029412;
			w = 0.9;
			h = 0.04902;
			text = "";
			sizeEx = 0.05;
			colorText[] = {0.543,0.5742,0.4102,1.0};
		};
	};
};
