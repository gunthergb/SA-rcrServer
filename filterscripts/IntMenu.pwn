//==============================================================================
//                     Interior Menu v1.4 by [03]Garsino!
//==============================================================================
// - Credits to DracoBlue for dcmd.
// - Credits to scandragon for helping me finding a few missing interiors.
//==============================================================================
//                             Changelog v1.4
//==============================================================================
// - [Added] Added Burglary House #17.
// - [Added] Added Market Stall #1.
// - [Added] Added Market Stall #2.
// - [Added] Added Market Stall #3.
// - [Added] Added Market Stall #4.
// - [Added] Added Market Stall #5.
// - [Script] Rewrote whole script, it now uses switch statements instead of a bunch of if statements.
// - [Added] Added information message when teleporting to an interior. It will tell you the interior name, position and interior.
// - [Added] Added a new category called "Worlds Locations".
// - [Script] Script now uses dcmd instead of strcmp.
// - [Added] Added /saveex. Works the same way as /save except that it saves interior and virtual world too. Position is saved in savedpositions.txt in /scriptfiles.
//==============================================================================
#include <a_samp> // Credits to SA:MP team
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define INTERIORMENU 1500
#define COLOUR_SAMP 0xA9C4E4FF
#define COLOUR_DEBUG 0x88AA62FF
//==============================================================================
public OnFilterScriptInit()
{
	print("\n\t\tInterior Menu v1.4 By Garsino Loaded!\n");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n\t\tInterior Menu v1.4 By Garsino Unloaded!\n");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(interiormenu, 12, cmdtext);
	dcmd(intmenu, 7, cmdtext);
	dcmd(saveex, 6, cmdtext);
	return 0;
}
dcmd_interiormenu(playerid, params[])
{
	#pragma unused params
	/*
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xF60000AA, "Only Admins Can Use This Command!");
	else // Uncomment for RCON admins to use only ...
	*/
	return ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
}
dcmd_intmenu(playerid, params[]) return dcmd_interiormenu(playerid, params);
dcmd_saveex(playerid, params[])
{
    /*
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, 0xF60000AA, "Only Admins Can Use This Command!");
	else // Uncomment for RCON admins to use only ...
	*/
	return SaveLocation(playerid, params);
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == INTERIORMENU && response)
	{
		switch(listitem)
		{
   			case 0: ShowPlayerDialog(playerid, INTERIORMENU+1, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - 24/7's", "24/7 Interior 1\n24/7 Interior 2\n24/7 Interior 3\n24/7 Interior 4\n24/7 Interior 5\n24/7 Interior 6\nBack", "Select", "Cancel");
			case 1: ShowPlayerDialog(playerid, INTERIORMENU+2, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Airport Interiors", "Francis Ticket Sales Airport\nFrancis Baggage Claim Airport\nAndromada Cargo Hold\nShamal Cabin\nLS Airport Baggage Claim\nInterernational Airport\nAbandoned AC Tower\nBack", "Select", "Cancel");
			case 2: ShowPlayerDialog(playerid, INTERIORMENU+3, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Ammunation Interiors", "Ammunation 1\nAmmunation 2\nAmmunation 3\nAmmunation 4\nAmmunation 5\nBooth Ammunation\nRange Ammunation\nBack", "Select", "Cancel");
			case 3: ShowPlayerDialog(playerid, INTERIORMENU+4, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Houses", "B Dup's Apartment\nB Dup's Crack Palace\nOG Loc's House\nRyder's house\nSweet's house\nMadd Dogg's Mansion\nBig Smoke's Crack Palace\nBack", "Select", "Cancel");
			case 4: ShowPlayerDialog(playerid, INTERIORMENU+5, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Houses 2", "Johnson House\nAngel Pine Trailer\nSafe House\nSafe House 2\nSafe House 3\nSafe House 4\nVerdant Bluffs Safehouse\nWillowfield Safehouse\nThe Camel's Toe Safehouse\nBack", "Select", "Cancel");
			case 5: ShowPlayerDialog(playerid, INTERIORMENU+6, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Missions", "Atrium\nBurning Desire Building\nColonel Furhberger\nWelcome Pump\nWu Zi Mu's Apartement\nJizzy's\nDillimore Gas Station\nJefferson Motel\nLiberty City\nSherman Dam\nBack", "Select", "Cancel");
			case 6: ShowPlayerDialog(playerid, INTERIORMENU+7, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Stadiums", "RC War Arena\nRacing Stadium\nRacing Stadium 2\nBloodbowl Stadium\nKickstart Stadium\nBack", "Select", "Cancel");
			case 7: ShowPlayerDialog(playerid, INTERIORMENU+8, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Casino Interiors", "Caligulas Casino\n4 Dragons Casino\nRedsands Casino\n4 Dragons Managerial Suite\nInside Track Betting\nCaligulas Roof\nRosenberg's Caligulas Office\n4 Dragons Janitors Office\nBack", "Select", "Cancel");
			case 8: ShowPlayerDialog(playerid, INTERIORMENU+9, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Shop Interiors", "Tattoo\nBurger Shot\nWell Stacked Pizza\nCluckin' Bell\nRusty Donut's\nZero's RC Shop\nSex Shop\nBack", "Select", "Cancel");
			case 9: ShowPlayerDialog(playerid, INTERIORMENU+10, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Mod Shops/Garages","Loco Low Co.\nWheel Arch Angels\nTransfender\nDoherty Garage\nBack", "Select", "Cancel");
			case 10: ShowPlayerDialog(playerid, INTERIORMENU+11, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - CJ's Girlfriends Interiors","Denises Bedroom\nHelena's Barn\nBarbara's Love Nest\nKatie's Lovenest\nMichelle's Love Nest\nMillie's Bedroom\nBack", "Select", "Cancel");
			case 11: ShowPlayerDialog(playerid, INTERIORMENU+12, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Clothing & Barber Store","Barber Shop\nPro-Laps\nVictim\nSubUrban\nReece's Barber Shop\nZip\nDidier Sachs\nBinco\nBarber Shop 2\nWardrobe\nBack", "Select", "Cancel");
   			case 12: ShowPlayerDialog(playerid, INTERIORMENU+13, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Resturants & Clubs","Brothel\nBrothel 2\nThe Big Spread Ranch\nDinner\nWorld Of Coq\nThe Pig Pen\nClub\nJay's Diner\nSecret Valley Diner\nFanny Batter's Whore House\nBack", "Select", "Cancel");
   			case 13: ShowPlayerDialog(playerid, INTERIORMENU+14, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - No Specific Category","Blastin' Fools Records\nWarehouse\nWarehouse 2\nBudget Inn Motel Room\nLil' Probe Inn\nCrack Den\nMeat Factory\nBike School\nDriving School\nBack", "Select", "Cancel");
   			case 14: ShowPlayerDialog(playerid, INTERIORMENU+15, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Burglary Houses","Burglary House 1\nBurglary House 2\nBurglary House 3\nBurglary House 4\nBurglary House 5\nBurglary House 6\nBurglary House 7\nBurglary House 8\nBurglary House 9\nBurglary House 10\nBack", "Select", "Cancel");
			case 15: ShowPlayerDialog(playerid, INTERIORMENU+16, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Burglary Houses 2","Burglary House 11\nBurglary House 12\nBurglary House 13\nBurglary House 14\nBurglary House 15\nBurglary House 16\nBurglary House 17\nBack", "Select", "Cancel");
   			case 16: ShowPlayerDialog(playerid, INTERIORMENU+17, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Gyms","Los Santos Gym\nSan Fierro Gym\nLas Venturas Gym\nBack", "Select", "Cancel");
   			case 17: ShowPlayerDialog(playerid, INTERIORMENU+18, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - Departments","SF Police Department\nLS Police Department\nLV Police Department\nPlanning Department\nBack", "Select", "Cancel");
   			case 18: ShowPlayerDialog(playerid, INTERIORMENU+19, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino - World Locations","Market Stall #1\nMarket Stall #2\nMarket Stall #3\nMarket Stall #4\nMarket Stall #5\nBack", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	24/7's
//==============================================================================
	if(dialogid == INTERIORMENU+1 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, -25.884499,-185.868988,1003.549988, 17, "24/7 #1");
			case 1: SetPlayerPosEx(playerid, -6.091180,-29.271898,1003.549988, 10, "24/7 #2");
			case 2: SetPlayerPosEx(playerid, -30.946699,-89.609596,1003.549988, 18, " 24/7 #3");
			case 3: SetPlayerPosEx(playerid, -25.132599,-139.066986,1003.549988, 16, " 24/7 #4");
			case 4: SetPlayerPosEx(playerid, -27.312300,-29.277599,1003.549988, 4, " 24/7 #5");
			case 5: SetPlayerPosEx(playerid, -26.691599,-55.714897,1003.549988, 6, "24/7 #6");
			case 6: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Airports
//==============================================================================
	if(dialogid == INTERIORMENU+2 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, -1827.147338,7.207418,1061.143554, 14, "Francis Ticket Sales Airport");
			case 1: SetPlayerPosEx(playerid, -1855.568725,41.263156,1061.143554, 14, "Francis Baggage Claim Airport");
			case 2: SetPlayerPosEx(playerid, 315.856170,1024.496459,1949.797363, 9, "Andromada Cargo Hold");
			case 3: SetPlayerPosEx(playerid, 2.384830,33.103397,1199.849976, 1, "Shamal Cabin");
			case 4: SetPlayerPosEx(playerid, -1870.80,59.81,1056.25, 14, "LS Airport Baggage Claim");
			case 5: SetPlayerPosEx(playerid, -1830.81,16.83,1061.14, 14, "Interernational Airport");
			case 6: SetPlayerPosEx(playerid, 419.8936, 2537.1155, 10, 10, "Abounded AC Tower");
			case 7: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Ammunation
//==============================================================================
	if(dialogid == INTERIORMENU+3 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 286.148987,-40.644398,1001.569946, 1, "Ammunation #1");
			case 1: SetPlayerPosEx(playerid, 286.800995,-82.547600,1001.539978, 4, "Ammunation #2");
			case 2: SetPlayerPosEx(playerid, 296.919983,-108.071999,1001.569946, 6, "Ammunation #3");
			case 3: SetPlayerPosEx(playerid, 314.820984,-141.431992,999.661987, 7, "Ammunation #4");
			case 4: SetPlayerPosEx(playerid, 316.524994,-167.706985,999.661987, 6, "Ammunation #5");
			case 5: SetPlayerPosEx(playerid, 302.292877,-143.139099,1004.062500, 7, "Booth Ammunation");
			case 6: SetPlayerPosEx(playerid, 280.795104,-135.203353,1004.062500, 7, "Range Ammunation");
			case 7: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");

		}
		return 1;
	}
//==============================================================================
//                          	Houses
//==============================================================================
	if(dialogid == INTERIORMENU+4 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 1527.0468, -12.0236, 1002.0971, 3, "B Dup's Apartment");
			case 1: SetPlayerPosEx(playerid, 1523.5098, -47.8211, 1002.2699, 2, "B Dup's Crack Palace");
			case 2: SetPlayerPosEx(playerid, 512.9291, -11.6929, 1001.565, 3, "OG Loc's House");
			case 3: SetPlayerPosEx(playerid, 2447.8704, -1704.4509, 1013.5078, 2, "Ryder's House");
			case 4: SetPlayerPosEx(playerid, 2527.0176, -1679.2076, 1015.4986, 1, "Sweet's House");
 			case 5: SetPlayerPosEx(playerid, 1267.8407, -776.9587, 1091.9063, 5, "Madd Dogg's Mansion");
			case 6: SetPlayerPosEx(playerid, 2536.5322, -1294.8425, 1044.125, 2, "Big Smoke's Crack Palace");
			case 7: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Safe Houses
//==============================================================================
	if(dialogid == INTERIORMENU+5 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 2496.0549, -1695.1749, 1014.7422, 3, "CJ's House");
			case 1: SetPlayerPosEx(playerid, 1.1853, -3.2387, 999.4284, 2, "Angel Pine trailer");
			case 2: SetPlayerPosEx(playerid, 2233.6919, -1112.8107, 1050.8828, 5, "Safe House #1");
			case 3: SetPlayerPosEx(playerid, 2194.7900, -1204.3500, 1049.0234, 6, "Safe House #2");
			case 4: SetPlayerPosEx(playerid, 2319.1272, -1023.9562, 1050.2109, 9, "Safe House #3");
			case 5: SetPlayerPosEx(playerid, 2262.4797,-1138.5591,1050.63285, 10, "Safe House #4");
			case 6: SetPlayerPosEx(playerid, 2365.1089, -1133.0795, 1050.875, 8, "Verdant Bluff safehouse");
			case 7: SetPlayerPosEx(playerid, 2282.9099, -1138.2900, 1050.8984, 11, "Willowfield Safehouse");
			case 8: SetPlayerPosEx(playerid, 2216.1282, -1076.3052, 1050.4844, 1, "The Camel's Toe Safehouse");
			case 9: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");

		}
		return 1;
	}
//==============================================================================
//                          	Missions 1
//==============================================================================
	if(dialogid == INTERIORMENU+6 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 1726.18,-1641.00,20.23, 18, "Atrium");
			case 1: SetPlayerPosEx(playerid, 2338.32,-1180.61,1027.98, 5, "Burning Desire");
			case 2: SetPlayerPosEx(playerid, 2807.63,-1170.15,1025.57, 8, "Colonel Furhberger");
			case 3: SetPlayerPosEx(playerid, 681.66,-453.32,-25.61, 1, "Welcome Pump(Dillimore)");
			case 4: SetPlayerPosEx(playerid, -2158.72,641.29,1052.38, 1, "Woozies Apartment");
			case 5: SetPlayerPosEx(playerid, -2637.69,1404.24,906.46, 3, "Jizzy's");
			case 6: SetPlayerPosEx(playerid, 664.19,-570.73,16.34, 0, "Dillimore Gas Station");
			case 7: SetPlayerPosEx(playerid, 2220.26,-1148.01,1025.80, 15, "Jefferson Motel");
			case 8: SetPlayerPosEx(playerid, -750.80,491.00,1371.70, 1, "Liberty City");
			case 9: SetPlayerPosEx(playerid, -944.2402, 1886.1536, 5.0051, 17, "Sherman Dam");
			case 10: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");

		}
		return 1;
	}
//==============================================================================
//                          	Missions 2
//==============================================================================
	if(dialogid == INTERIORMENU+7 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, -1079.99,1061.58,1343.04, 10, "RC War Arena");
			case 1: SetPlayerPosEx(playerid, -1395.958,-208.197,1051.170, 7, "Racing Stadium");
			case 2: SetPlayerPosEx(playerid, -1424.9319,-664.5869,1059.8585, 4, "Racing Stadium 2");
			case 3: SetPlayerPosEx(playerid, -1394.20,987.62,1023.96, 15, "Bloodbowl Stadium");
			case 4: SetPlayerPosEx(playerid, -1410.72,1591.16,1052.53, 14, "Kickstart Stadium");
			case 5: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Casino Interiors
//==============================================================================
	if(dialogid == INTERIORMENU+8 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 2233.8032,1712.2303,1011.7632, 1, "Caligulas Casino");
			case 1: SetPlayerPosEx(playerid, 2016.2699,1017.7790,996.8750, 10, "4 Dragons Casino");
			case 2: SetPlayerPosEx(playerid, 1132.9063,-9.7726,1000.6797, 12, "Redsands Casino");
			case 3: SetPlayerPosEx(playerid, 2003.1178, 1015.1948, 33.008, 11, "4 Dragons' Managerial Suite (Unsolid floor)");
			case 4: SetPlayerPosEx(playerid, 830.6016, 5.9404, 1004.1797, 3, "Inside Track betting");
			case 5: SetPlayerPosEx(playerid, 2268.5156, 1647.7682, 1084.2344, 1, "Caligulas Roof");
			case 6: SetPlayerPosEx(playerid, 2182.2017, 1628.5848, 1043.8723, 2, "Rosenberg's Caligulas Office (Unsolid floor)");
			case 7: SetPlayerPosEx(playerid, 1893.0731, 1017.8958, 31.8828, 10, "4 Dragons Janitor's Office");
			case 8: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Shop Interiors
//==============================================================================
	if(dialogid == INTERIORMENU+9 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, -203.0764,-24.1658,1002.2734, 16, "Tattoo");
			case 1: SetPlayerPosEx(playerid, 365.4099,-73.6167,1001.5078, 10, "Burger Shot");
			case 2: SetPlayerPosEx(playerid, 372.3520,-131.6510,1001.4922, 5, "Well Stacked Pizza");
			case 3: SetPlayerPosEx(playerid, 365.7158,-9.8873,1001.8516, 9, "Cluckin Bell");
			case 4: SetPlayerPosEx(playerid, 378.026,-190.5155,1000.6328, 17, "Rusty Donut's");
			case 5: SetPlayerPosEx(playerid, -2240.1028, 136.973, 1035.4141, 6, "Zero's");
			case 6: SetPlayerPosEx(playerid, -100.2674, -22.9376, 1000.7188, 3, "Sex Shop");
			case 7: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Mod Shops/Garages
//==============================================================================
	if(dialogid == INTERIORMENU+10 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 616.7820,-74.8151,997.6350, 2, "Loco Low Co.");
			case 1: SetPlayerPosEx(playerid, 615.2851,-124.2390,997.6350, 3, "Wheel Arch Angels");
			case 2: SetPlayerPosEx(playerid, 617.5380,-1.9900,1000.6829, 1, "Transfender");
			case 3: SetPlayerPosEx(playerid, -2041.2334, 178.3969, 28.8465, 1, "Doherty Garage");
			case 4: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Girlfriend Interiors
//==============================================================================
	if(dialogid == INTERIORMENU+11 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 245.2307, 304.7632, 999.1484, 1, "Denise's Bedroom");
			case 1: SetPlayerPosEx(playerid, 290.623, 309.0622, 999.1484, 3, "Helena's Barn");
			case 2: SetPlayerPosEx(playerid, 322.5014, 303.6906, 999.1484, 5, "Barbaras Lovenest");
			case 3: SetPlayerPosEx(playerid, 269.6405, 305.9512, 999.1484, 2, "Katie's Lovenest");
			case 4: SetPlayerPosEx(playerid, 306.1966, 307.819, 1003.3047, 4, "Michelle's Lovenest");
			case 5: SetPlayerPosEx(playerid, 344.9984, 307.1824, 999.1557, 6, "Millie's Bedroom");
			case 6: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                              Clothing/Barber Shops
//==============================================================================
	if(dialogid == INTERIORMENU+12 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 418.4666, -80.4595, 1001.8047, 3, "Barber Shop");
			case 1: SetPlayerPosEx(playerid, 206.4627, -137.7076, 1003.0938, 3, "Pro Laps");
			case 2: SetPlayerPosEx(playerid, 225.0306, -9.1838, 1002.218, 5, "Victim");
			case 3: SetPlayerPosEx(playerid, 204.1174, -46.8047, 1001.8047, 1, "Suburban");
			case 4: SetPlayerPosEx(playerid, 414.2987, -18.8044, 1001.8047, 2, "Reece's Barber Shop");
			case 5: SetPlayerPosEx(playerid, 161.4048, -94.2416, 1001.8047, 18, "Zip");
			case 6: SetPlayerPosEx(playerid, 204.1658, -165.7678, 1000.5234, 14, "Didier Sachs");
			case 7: SetPlayerPosEx(playerid, 207.5219, -109.7448, 1005.1328, 15, "Binco");
			case 8: SetPlayerPosEx(playerid, 411.9707, -51.9217, 1001.8984, 12, "Barber Shop 2");
			case 9: SetPlayerPosEx(playerid, 256.9047, -41.6537, 1002.0234, 14, "Wardrobe");
			case 10: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Resturants/Clubs
//==============================================================================
	if(dialogid == INTERIORMENU+13 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 974.0177, -9.5937, 1001.1484, 3, "Brotel");
			case 1: SetPlayerPosEx(playerid, 961.9308, -51.9071, 1001.1172, 3, "Brotel 2");
			case 2: SetPlayerPosEx(playerid, 1212.0762,-28.5799,1000.9531, 3, "Big Spread Ranch");
			case 3: SetPlayerPosEx(playerid, 454.9853, -107.2548, 999.4376, 5, "Dinner");
			case 4: SetPlayerPosEx(playerid, 445.6003, -6.9823, 1000.7344, 1, "World Of Coq");
			case 5: SetPlayerPosEx(playerid, 1204.9326,-8.1650,1000.9219, 2, "The Pig Pen");
			case 6: SetPlayerPosEx(playerid, 490.2701,-18.4260,1000.6797, 17, "Dance Club");
			case 7: SetPlayerPosEx(playerid, 449.0172, -88.9894, 999.5547, 4, "Jay's Dinner");
			case 8: SetPlayerPosEx(playerid, 442.1295, -52.4782, 999.7167, 6, "Secret Valley Dinner");
			case 9: SetPlayerPosEx(playerid, 748.4623, 1438.2378, 1102.9531, 6, "Fanny Batter's Whore House");
			case 10: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	No Specific Group
//==============================================================================
	if(dialogid == INTERIORMENU+14 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 1037.8276, 0.397, 1001.2845, 3, "Blastin' Fools Records");
			case 1: SetPlayerPosEx(playerid, 1290.4106, 1.9512, 1001.0201, 18, "Warehouse");
			case 2: SetPlayerPosEx(playerid, 1411.4434,-2.7966,1000.9238, 1, "Warehouse 2");
			case 3: SetPlayerPosEx(playerid, 446.3247, 509.9662, 1001.4195, 12, "Budget Inn Motel Room");
			case 4: SetPlayerPosEx(playerid, -227.5703, 1401.5544, 27.7656, 18, "Lil' Probe Inn");
			case 5: SetPlayerPosEx(playerid, 318.5645, 1118.2079, 1083.8828, 5, "Crack Den");
			case 6: SetPlayerPosEx(playerid, 963.0586, 2159.7563, 1011.0303, 1, "Meat Factory");
			case 7: SetPlayerPosEx(playerid, 1494.8589, 1306.48, 1093.2953, 3, "Bike School");
			case 8: SetPlayerPosEx(playerid, -2031.1196, -115.8287, 1035.1719, 3, "Driving School");
			case 9: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Burglary Houses 1
//==============================================================================
	if(dialogid == INTERIORMENU+15 && response) //
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 234.6087, 1187.8195, 1080.2578, 3, "Burglary House #1");
			case 1: SetPlayerPosEx(playerid, 225.5707, 1240.0643, 1082.1406, 2, "Burglary House #2");
			case 2: SetPlayerPosEx(playerid, 224.288, 1289.1907, 1082.1406, 1, "Burglary House #3");
			case 3: SetPlayerPosEx(playerid, 239.2819, 1114.1991, 1080.9922, 5, "Burglary House #4");
			case 4: SetPlayerPosEx(playerid, 295.1391, 1473.3719, 1080.2578, 15, "Burglary House #5");
			case 5: SetPlayerPosEx(playerid, 261.1165, 1287.2197, 1080.2578, 4, "Burglary House #6");
			case 6: SetPlayerPosEx(playerid, 24.3769, 1341.1829, 1084.375, 10, "Burglary House #7");
			case 7: SetPlayerPosEx(playerid, -262.1759, 1456.6158, 1084.36728, 4, "Burglary House #8");
			case 8: SetPlayerPosEx(playerid, 22.861, 1404.9165, 1084.4297, 5, "Burglary House #9");
			case 9: SetPlayerPosEx(playerid, 140.3679, 1367.8837, 1083.8621, 5, "Burglary House #10");
			case 10: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Burglary Houses 2
//==============================================================================
	if(dialogid == INTERIORMENU+16 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 234.2826, 1065.229, 1084.2101, 6, "Burglary House #11");
			case 1: SetPlayerPosEx(playerid, -68.5145, 1353.8485, 1080.2109, 6, "Burglary House #12");
			case 2: SetPlayerPosEx(playerid, -285.2511, 1471.197, 1084.375, 15, "Burglary House #13");
			case 3: SetPlayerPosEx(playerid, -42.5267, 1408.23, 1084.4297, 8, "Burglary House #14");
			case 4: SetPlayerPosEx(playerid, 84.9244, 1324.2983, 1083.8594, 9, "Burglary House #15");
			case 5: SetPlayerPosEx(playerid, 260.7421, 1238.2261, 1084.2578, 9, "Burglary House #16");
			case 6: SetPlayerPosEx(playerid, 447.0000, 1400.3000, 1084.3047, 2, "Burglary House #17");
			case 7: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          	Gyms
//==============================================================================
	if(dialogid == INTERIORMENU+17 && response)
	{
		switch(listitem)
		{
			case 0: SetPlayerPosEx(playerid, 234.2826, 1065.229, 1084.2101, 6, "Los Santos Gym");
			case 1: SetPlayerPosEx(playerid, 771.8632,-40.5659,1000.6865, 6, "San Fierro Gym");
			case 2: SetPlayerPosEx(playerid, 774.0681,-71.8559,1000.6484, 7, "Las Venturas Gym");
			case 3: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          Deparments
//==============================================================================
	if(dialogid == INTERIORMENU+18 && response)
	{
	    switch(listitem)
	    {
			case 0: SetPlayerPosEx(playerid, 246.40,110.84,1003.22, 10, "San Fierro Police Department");
			case 1: SetPlayerPosEx(playerid, 246.6695, 65.8039, 1003.6406, 6, "Los Santos Police Department");
			case 2: SetPlayerPosEx(playerid, 288.4723, 170.0647, 1007.1794, 3, "Las Venturas Police Department");
			case 3: SetPlayerPosEx(playerid, 386.5259, 173.6381, 1008.382, 3, "Planning Department (City Hall)");
			case 4: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
//==============================================================================
//                          World Locations
//==============================================================================
	if(dialogid == INTERIORMENU+19 && response)
	{
	    switch(listitem)
	    {
			case 0: SetPlayerPosEx(playerid, 390.6189, -1754.6224, 8.2057, 0, "Market Stall #1");
			case 1: SetPlayerPosEx(playerid, 398.1151, -1754.8677, 8.2150, 0, "Market Stall #2");
			case 2: SetPlayerPosEx(playerid, 380.1665, -1886.9348, 7.8359, 0, "Market Stall #3");
			case 3: SetPlayerPosEx(playerid, 383.4514, -1912.3203, 7.8359, 0, "Market Stall #4");
			case 4: SetPlayerPosEx(playerid, 380.8439, -1922.2300, 7.8359, 0, "Market Stall #4");
			case 5: ShowPlayerDialog(playerid, INTERIORMENU, DIALOG_STYLE_LIST, "Interior Menu v1.4 by [03]Garsino","24/7's\nAirports\nAmmunations\nHouses\nHouses 2\nMissions\nStadiums\nCasinos\nShops\nGarages\nGirlfriends\nClothing/Barber Store\nResturants/Clubs\nNo Category\nBurglary\nBurglary 2\nGym\nDepartment\nWorld Locations", "Select", "Cancel");
		}
		return 1;
	}
	return 0;
}
//==============================================================================
stock SetPlayerPosEx(playerid, Float:X, Float:Y, Float:Z, interior, location[])
{
    new string[128];
	SetPlayerPos(playerid, X, Y, Z);
	SetPlayerInterior(playerid,interior);
	SetPlayerVirtualWorld(playerid, 0);
	format(string, 128, "You've teleported to %s. [X: %0.2f | Y: %0.2f | Z: %0.2f | Interior: %d]. Use /saveex to save your position.", location, X, Y, Z, interior);
	SendClientMessage(playerid, COLOUR_DEBUG, string);
	return 1;
}
stock SaveLocation(playerid, comment[])
{
	new File:gFile, Float:Pos[4], string[256];
	switch(IsPlayerInAnyVehicle(playerid))
	{
		case 0:
		{
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);
			SendClientMessage(playerid, COLOUR_DEBUG, "-> OnFoot position saved");
		}
		case 1:
		{
			GetVehiclePos(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), Pos[3]);
			SendClientMessage(playerid, COLOUR_DEBUG, "-> Vehicle position saved");
		}
	}
	if(!fexist("savedpositions.txt"))
	{
		gFile = fopen("savedpositions.txt", io_write);
		fclose(gFile);
	}
	gFile = fopen("savedpositions.txt", io_append);
	format(string, 256, "SetPlayerPos(playerid, %0.4f, %0.4f, %0.4f); // %s [Angle: %0.4f | Int: %d | VW: %d]\r\n", Pos[0], Pos[1], Pos[2], Pos[3], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), comment);
	fwrite(gFile, string);
	fclose(gFile);
	return 1;
}
