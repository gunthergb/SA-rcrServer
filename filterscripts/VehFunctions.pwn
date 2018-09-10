#include <a_samp>
#define COLOR_YELLOW 0xFFFF00AA
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
												//Config
#define JumpKey 			KEY_ANALOG_UP
#define SBKey 				KEY_CROUCH
#define NosKey 				0
#define FlipKey 			0
#define ColorChangeKey 		0
#define FixKey				KEY_FIRE


#define SpeedBoost 2
#define Jump 1
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
new CarColors[][1] =
{
	{1},
	{2},
	{3},
	{4},
	{5},
	{6},
	{7},
	{8},
	{9},
	{10},
	{11},
	{12},
	{13},
	{14},
	{15},
	{16},
	{17},
	{18},
	{19},
	{20},
	{21},
	{22},
	{23},
	{24},
	{25},
	{26},
	{27},
	{28},
	{29},
	{30},
	{31},
	{32},
	{33},
	{34},
	{35},
	{36},
	{37},
	{38},
	{39},
	{40},
	{41},
	{42},
	{43},
	{44},
	{45},
	{46},
	{47},
	{48},
	{49},
	{50},
	{51},
	{52},
	{53},
	{54},
	{55},
	{56},
	{57},
	{58},
	{59},
	{60},
	{61},
	{62},
	{63},
	{64},
	{65},
	{66},
	{67},
	{68},
	{69},
	{70},
	{71},
	{72},
	{73},
	{74},
	{75},
	{76},
	{77},
	{78},
	{79},
	{80},
	{81},
	{82},
	{83},
	{84},
	{85},
	{86},
	{87},
	{88},
	{89},
	{90},
	{91},
	{92},
	{93},
	{94},
	{95},
	{96},
	{97},
	{98},
	{99},
	{100},
	{101},
	{102},
	{103},
	{104},
	{105},
	{106},
	{107},
	{108},
	{109},
	{110},
	{111},
	{112},
	{113},
	{114},
	{115},
	{116},
	{117},
	{118},
	{119},
	{120},
	{121},
	{122},
	{123},
	{124},
	{125},
	{126}

};
new CarColors2[][1] =
{
	{126},
	{125},
	{124},
	{123},
	{122},
	{121},
	{120},
	{119},
	{118},
	{117},
	{116},
	{115},
	{114},
	{113},
	{112},
	{111},
	{110},
	{109},
	{108},
	{107},
	{106},
	{105},
	{104},
	{103},
	{102},
	{101},
	{100},
	{99},
	{98},
	{97},
	{96},
	{95},
	{94},
	{93},
	{92},
	{91},
	{90},
	{89},
	{88},
	{87},
	{86},
	{85},
	{84},
	{83},
	{82},
	{81},
	{80},
	{79},
	{78},
	{77},
	{76},
	{75},
	{74},
	{73},
	{72},
	{71},
	{70},
	{69},
	{68},
	{67},
	{66},
	{65},
	{64},
	{63},
	{62},
	{61},
	{60},
	{59},
	{58},
	{57},
	{56},
	{55},
	{54},
	{53},
	{52},
	{51},
	{50},
	{49},
	{48},
	{47},
	{46},
	{45},
	{44},
	{43},
	{42},
	{41},
	{40},
	{39},
	{38},
	{37},
	{36},
	{35},
	{34},
	{33},
	{32},
	{31},
	{30},
	{29},
	{28},
	{27},
	{26},
	{25},
	{24},
	{23},
	{22},
	{21},
	{20},
	{19},
	{18},
	{17},
	{16},
	{15},
	{14},
	{13},
	{12},
	{11},
	{10},
	{9},
	{8},
	{7},
	{6},
	{5},
	{4},
	{3},
	{2},
	{1}

};
public OnFilterScriptInit()
















{
    print("\n--------------------------------------");
	print("Vehicles Functions By Etch");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}


main(){}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/vfhelp", cmdtext, true, 7) == 0)
	{
		SendClientMessage(playerid,COLOR_YELLOW,"NumPad 8 ==> Jump");
		//SendClientMessage(playerid,COLOR_YELLOW,"NumPad 4 ==> Color Change");
		//SendClientMessage(playerid,COLOR_YELLOW,"NumPad 6 ==> Flip");
		//SendClientMessage(playerid,COLOR_YELLOW,"NumPad 2 ==> Nos");
		SendClientMessage(playerid,COLOR_YELLOW,"Horn ==> SpeedBoost");
		SendClientMessage(playerid,COLOR_YELLOW,"LMB ==> Fix");
		return 1;
	}
	return 0;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new vehicleid = GetPlayerVehicleID(playerid);
 	if(newkeys & ColorChangeKey) // Color Change
	{
	new colors = random(sizeof(CarColors));
	new colors2 = random(sizeof(CarColors2));
	ChangeVehicleColor(vehicleid,CarColors[colors][0],CarColors2[colors2][0]);
	}
	if(newkeys & JumpKey) // Jump
	{
	new Float:vehx; new Float:vehy; new Float:vehz;
	GetVehicleVelocity(vehicleid,vehx,vehy,vehz);
	SetVehicleVelocity(vehicleid,vehx,vehy,vehz+Jump);
	}
	if(newkeys & NosKey) // Nos
	{
	AddVehicleComponent(vehicleid,1010);
	GameTextForPlayer(playerid,"Nos Added",1000,3);
	}
	if(newkeys & FlipKey) // Flip
	{
	new Float:X, Float:Y, Float:Z, Float:Angle; GetPlayerPos(playerid, X, Y, Z);
	GetVehicleZAngle(vehicleid, Angle);	SetVehiclePos(vehicleid, X, Y, Z); SetVehicleZAngle(vehicleid, Angle);
	}
	if(newkeys & SBKey) // SpeedBoost
	{
 	new Float:vehx; new Float:vehy; new Float:vehz;
	GetVehicleVelocity(vehicleid,vehx,vehy,vehz);
	SetVehicleVelocity(vehicleid,vehx*SpeedBoost,vehy*SpeedBoost,vehz*SpeedBoost);
	}
	if(newkeys & FixKey) // Fix
	{
 	RepairVehicle(GetPlayerVehicleID(playerid));
	}
	if(newkeys & FixKey) // Fix
	{
	RepairVehicle(GetPlayerVehicleID(playerid));
	}
	return 1;
}


