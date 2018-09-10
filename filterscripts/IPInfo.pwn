                                                        ///////////////////////
                                                        //Improved PlayerInfo//
                                                        ///////Created by://///
                                                        ///////°Fallout°///////
                                                        ///////////////////////

#include <a_samp>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

new PlayerVehicle[213][] = {
"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana",
"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat",
"Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife",
"Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo",
"Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito",
"Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring",
"Sandking", "Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B",
"Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster","Stunt",  "Tanker",
"Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Streak",
"Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck LA", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit",
"Utility", "Nevada", "Yosemite", "Windsor", "Monster A", "Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance",
"RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito", "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway",
"Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer 3", "Emperor", "Wayfarer", "Euros", "Hotdog",
"Club", "Freight Carriage", "Trailer 4", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)",
"Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage Trailer A",
"Luggage Trailer B", "Stairs", "Boxville", "Tiller", "Utility Trailer","-None-" };

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnFilterScriptInit()
{
    print("   Loaded successful.");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public OnRconCommand(cmd[])
{
	if(!strcmp(cmd,"playerinfo",true))
	{
	    new n;
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
			    if(n == 0)
				{
					print("ID: Name:            IP:             Ping: RCON: Vehicle:          State:");
					print("--- -----            ---             ----- ----- --------          ------");
					n++;
				}

				//--------------ID---------------//

				new Tab_PlayerID_Length[3];
				if(i >= 0 && i <= 9) { Tab_PlayerID_Length = "  "; }
				if(i >= 10 && i <= 99) { Tab_PlayerID_Length = " "; }
				if(i >= 100) { Tab_PlayerID_Length = ""; }

				//-------------Name--------------//

			    new PlayerName[MAX_PLAYER_NAME];
				GetPlayerName(i, PlayerName, sizeof(PlayerName));

				//--------------IP---------------//

				new PlayerIp[256];
				GetPlayerIp(i, PlayerIp, sizeof(PlayerIp));

				//-------------Ping--------------//

				new PlayerPing = GetPlayerPing(i);
				new Tab_PlayerPing_Length[4];
				if(PlayerPing >= 0 && PlayerPing <= 9) { Tab_PlayerPing_Length = "   "; }
				if(PlayerPing >= 10 && PlayerPing <= 99) { Tab_PlayerPing_Length = "  "; }
				if(PlayerPing >= 100 && PlayerPing <= 999) { Tab_PlayerPing_Length = " "; }
				if(PlayerPing >= 1000) { Tab_PlayerPing_Length = ""; }

				//-------------RCON--------------//

				new PlayerAdmin[7];
				if(IsPlayerAdmin(i) == 1) { PlayerAdmin = "yes"; }
				if(IsPlayerAdmin(i) == 0) { PlayerAdmin = "no"; }

				//------------Vehicle------------//

				new PlayerVehicleModelID;
				if(IsPlayerInAnyVehicle(i) == 1)
				{
				 	PlayerVehicleModelID = GetVehicleModel(GetPlayerVehicleID(i));
					PlayerVehicleModelID -= 400;
				}
				else { PlayerVehicleModelID = 212; }

				//-------------State-------------//

				new PlayerState[10];
				if(GetPlayerState(i) == 1) { PlayerState = "On foot"; }
				if(GetPlayerState(i) == 2) { PlayerState = "Driver"; }
				if(GetPlayerState(i) == 3) { PlayerState = "Passenger"; }
				if(GetPlayerState(i) == 7) { PlayerState = "Dead"; }
				if(GetPlayerState(i) == 0 || GetPlayerState(i) == 4 ||
				GetPlayerState(i) == 5 || GetPlayerState(i) == 6 ||
				GetPlayerState(i) == 8) { PlayerState = "/"; }

				//------------Message------------//

			    printf("%i%s %16s %15s %i %s %5s %17s %s", i, Tab_PlayerID_Length, PlayerName, PlayerIp, PlayerPing, Tab_PlayerPing_Length, PlayerAdmin, PlayerVehicle[PlayerVehicleModelID], PlayerState);
			}
		}
		if(n == 0) { print("There are no players on the server."); }
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
