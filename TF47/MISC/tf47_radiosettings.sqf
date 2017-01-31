if(isclass (configfile >> "CfgPatches" >> "task_force_radio")	)then{
	params[["_mode",2,[0]]];
	// Call TFAR settings
	switch(_mode)do{
		//stand 23.12.2016
		case(0):{
			tf_radio_channel_name = "Radio Communication - Public I";
			tf_radio_channel_password = "India65";
		};
		case(1):{
			tf_radio_channel_name = "Radio Communication - Event";
			tf_radio_channel_password = "Alpha48";		
		};
		case(2):{
			tf_radio_channel_name = "Radio Communication - DEV";
			tf_radio_channel_password = "Zulu66";		
		};
	};
	//tf_freq_west_lr = 31;
	TFAR_defaultFrequencies_lr_west = 31;
	TFAR_defaultFrequencies_sr_west = 31;
	//tf_freq_west = 31;
	// TFAR-Basic settings (will override userconfig settings)
	tf_no_auto_long_range_radio = true;
	tf_give_personal_radio_to_regular_soldier = true;
	tf_same_sw_frequencies_for_side = true;
	tf_same_lr_frequencies_for_side = true;
	TF_defaultWestRiflemanRadio = "tf_anprc152";
};
//systemchat "[ INFO ] >> 'Radiosettings' >> Variables set ...";