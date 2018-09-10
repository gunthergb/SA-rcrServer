/*
--------------------LV, SF, LS teleports----------------
Island teleports ver 1.0
Thanks to Jasen for helping me throught this
By Benne


*/


#include <a_samp>

#define FILTERSCRIPT

#define DIALOGID 3300

public OnFilterScriptInit()
{
	print("\n  Go to LS, SF or LV.\n");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/teles", cmdtext, true, 10) == 0)
	{
	    if(IsPlayerAdmin(playerid))
		{
			ShowPlayerDialog(playerid, DIALOGID, DIALOG_STYLE_LIST, "Teleport Categories", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Cancel");
			return 1;
		}
		else
		{
	    	SendClientMessage(playerid,0x33AA33AA, "You have not logged in as reconned admin, do that before you can use the teleports");
	    	return 1;
	    }
	}
	return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOGID) // Teleport Dialog
	{
		if(response)
		{
   			if(listitem == 0) // Los Santos
			{
				ShowPlayerDialog(playerid, DIALOGID+1, DIALOG_STYLE_LIST, "Los Santos", "Los Santos Airport \nPershing Square \nVinewood \nGrove Street \nRichman \nSanta Maria Beach \nOcean Docks \nDillimore \nPalomino Creek \nBlueBerry \nMontGomery \nBack", "Select", "Cancel");
			}
			if(listitem == 1) // San Fierro
			{
				ShowPlayerDialog(playerid, DIALOGID+2, DIALOG_STYLE_LIST, "San Fierro", "San Fierro Airport \nGolden Gate Bridge \nMt. Chilliad \nCJ's garage \nSan Fierro Stadium \nOcean Flats \nMissionary Hill  \nBack", "Select", "Cancel");
			}
			if(listitem == 2) // Las Venturas
			{
				ShowPlayerDialog(playerid, DIALOGID+3, DIALOG_STYLE_LIST, "Las Venturas", "Las Venturas Airport \nArea51 \nFour Dragons Casino \nLas Venturas Police Department \nBayside \nBig Jump \nLas Barrancas \nFort Carson \nLas Venturas Stadium \nNorthern Las Venturas \nStarfish Casino \nBack", "Select", "Cancel");
   			}
		}
		return 1;
	}

	if(dialogid == DIALOGID+1) // Los Santos
	{
		if(response)
		{
			if(listitem == 0) // Airport
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1642.3022,-2333.6287,13.5469);
			}
			if(listitem == 1) //Pershing Square
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1511.8770,-1661.2853,13.5469);
			}
			if(listitem == 2) // Vinewood
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1382.6194,-888.5532,38.0863);
			}
			if(listitem == 3) // Grove Street
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 2485.2546,-1684.7223,13.5096);
			}
			if(listitem == 4) // Richman
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 597.6629,-1241.3900,18.1275);
			}
			if(listitem == 5) // Maria Beach
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 491.7868,-1823.2258,5.5028);
			}
			if(listitem == 6) // Ocean Docks
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 2771.1060,-2417.5828,13.6405);
			}
			if(listitem == 7) // Dillimore
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 661.0361,-573.5891,16.3359);
			}
			if(listitem == 8) // Palomino Creek
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 2269.6877,-75.0973,26.7724);
			}
			if(listitem == 9) // Blueberry
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 198.4328,-252.1696,1.5781);
			}
			if(listitem == 10) // MontGomery
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1242.2875,328.5506,19.7555);
			}
			if(listitem == 11) // Back
  			{
                ShowPlayerDialog(playerid, DIALOGID, DIALOG_STYLE_LIST, "Teleport Categories", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Cancel");
			}
		}
		return 1;
	}

	if(dialogid == DIALOGID+2) // San Fierro
	{
		if(response)
		{
			if(listitem == 0) // Airport
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -1422.8820,-287.4992,14.1484);
			}
			if(listitem == 1) // Golden Gate Bridge
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -2672.6116,1268.4943,55.9456);
			}
			if(listitem == 2) // Chilliad
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -2305.6143,-1626.0594,483.7662);
			}
			if(listitem == 3) // CJ's Garage
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -2026.2843,156.4974,29.0391);
			}
			if(listitem == 4) // SF Stadium
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -2159.3616,-407.8362,35.3359);
			}
			if(listitem == 5) // Ocean Flats
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -2648.7498,14.2868,6.1328);
			}
			if(listitem == 6) // Missionary Hill
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -2521.4055,-623.5245,132.7727);
			}
			if(listitem == 7) // Back
			{
                ShowPlayerDialog(playerid, DIALOGID, DIALOG_STYLE_LIST, "Teleport Categories", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Cancel");
			}
		}
		return 1;
	}

	if(dialogid == DIALOGID+3) // Las Venturas
	{
		if(response)
		{
			if(listitem == 0) // Airport
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1679.3361,1448.6248,10.7744);
			}
			if(listitem == 1) // Area51
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 95.7283,1920.3488,18.1163);
			}
			if(listitem == 2) // Four Dragons Casino
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 2027.5721,1008.2877,10.8203);
			}
			if(listitem == 3) // Police Department
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 2287.0313,2431.0276,10.8203);
			}
			if(listitem == 4) // Bayside
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -2241.4238,2327.4290,4.9844);
			}
			if(listitem == 5) // Big jump
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -670.6358,2306.0559,135.2990);
			}
			if(listitem == 6) // Las Barrancas
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -761.5192,1552.1647,26.9609);
			}
			if(listitem == 7) // Fort Carson
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, -143.5370,1217.8855,19.7352);
			}
			if(listitem == 8) // LV Stadium
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1099.1533,1384.3300,10.8203);
			}
			if(listitem == 9) // Northern LV
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 1614.2190,2334.9338,10.8203);
			}
			if(listitem == 10) // Starfish Casino
			{
				SetPlayerInterior(playerid, 0);
				SetPlayerPos(playerid, 2572.6560,1818.1030,10.8203);
			}
			if(listitem == 11) // Back
			{
                ShowPlayerDialog(playerid, DIALOGID, DIALOG_STYLE_LIST, "Teleport Categories", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Cancel");
			}
		}
		return 1;
	}
	return 0;
}
