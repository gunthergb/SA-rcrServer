// This is a comment
// uncomment the line below if you want to write a filterscript
#define FILTERSCRIPT

#include <a_samp>
#include <streamer>

#if defined FILTERSCRIPT

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xFF0000AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUEVIOLET 0x8A2BE2AA
#define COLOR_DEADCONNECT 0x808080AA
#define COLOR_BLUE 0x0000FFAA
#define COLOR_FORESTGREEN 0x228B22AA
#define COLOR_DODGERBLUE 0x1E90FFAA
#define COLOR_DARKOLIVEGREEN 0x556B2FAA
#define COLOR_ORANGE 0xFFA500AA
#define COLOR_PURPLE 0x800080AA
#define COLOR_ROYALBLUE 0x4169FFAA
#define COLOR_ERROR 0xD2691EAA

#define TEAM_TERRORIST 16

new IsPlantingYugoBridge[MAX_PLAYERS];
new YugoBlown =0;
new IsSpawned[MAX_PLAYERS];
new isKidnapped[MAX_PLAYERS];
new Frozen[MAX_PLAYERS];
new gTeam[MAX_PLAYERS];
new HasC4[MAX_PLAYERS];
new terroristrank[MAX_PLAYERS];
new oscore;
//Yugo Bridge
new YugoBridge;

forward PlantingOneYugoBridge();
forward PlantingTwoYugoBridge();
forward PlantingThreeYugoBridge();
forward FinalPlantYugoBridge();
forward YugoBridgeExplosionOne();
forward YugoBridgeExplosionTwo();
forward YugoBridgeExplosionThree();
forward YugoBridgeExplosionFour();
forward YugoBridgeExplosionFive();
forward RestoreYugoBridge();

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    IsPlantingYugoBridge[playerid] =0;

	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp(cmdtext, "/plantbomb", true) == 0)
    {
    if(IsSpawned[playerid] != 1)
    {
        SendClientMessage(playerid,COLOR_ERROR,"You must be alive and spawned in order to be able to use this command.");
        return 1;
	}
	if(isKidnapped[playerid] == 1)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You are kidnapped. You cannot use this command.");
	    return 1;
	}
	if(Frozen[playerid] == 1)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You have been frozen by a Server Administrator. You cannot use this command.");
	    return 1;
	}
	if(gTeam[playerid] != TEAM_TERRORIST)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You must be a terrorist in order to blow up buildings/structures.");
	    return 1;
	}
	if(!IsPlayerInCheckpoint(playerid))
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You must be in the checkpoint of a building/structure that you can blow up.");
	    return 1;
	}
	if(getCheckpointType(playerid) != CP_CIAEnt && getCheckpointType(playerid) != CP_CIASatBlow && getCheckpointType(playerid) != CP_CIABridge)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You must be in the checkpoint of a building/structure that you can blow up.");
	    return 1;
	}
	if(HasC4[playerid] == 0)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You need C4 in order to blow things up .. Try going to the bomb shop. (Behind Wang Cars)");
	    return 1;
	}
	if(getCheckpointType(playerid) == CP_CIABridge)
	{
	    if(terroristrank[playerid] < 30)
	    {
	        SendClientMessage(playerid,COLOR_ERROR,"You must have a Terrorism Level of 20 before you can blow up the CIA Bridge.");
	        return 1;
		}
		if(YugoBlown >= 1)
		{
		    SendClientMessage(playerid,COLOR_ERROR,"The CIA Bridge has already been blown up. You must wait for it to be re-built before you can blow it up.");
		    return 1;
		}
	    SendClientMessage(playerid,COLOR_DEADCONNECT,"[[_Planting Explosives_]]");
	    SendClientMessage(playerid,COLOR_RED,"You have begun to plant explosives on the bridge.");

	    IsPlantingYugoBridge[playerid] =1;
	    TogglePlayerControllable(playerid,0);
	    HasC4[playerid] --;
	    SetTimer("PlantingOneYugoBridge",2000,0);
	    return 1;
	}
	return 1;
}

public PlantingOneYugoBridge()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlantingYugoBridge[i] == 1)
	        {
	            SetPlayerPos(i,2115.1948,2813.8132,10.8203);
	            SetPlayerFacingAngle(i,270.0542);
	            SetCameraBehindPlayer(i);

	            ApplyAnimation(i, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0); // Place Bomb
	            SetTimer("PlantingTwoYugoBridge",5000,0);
			}
		}
	}
}

public PlantingTwoYugoBridge()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlantingYugoBridge[i] == 1)
	        {
	            SetPlayerPos(i,2139.3083,2816.8733,10.8203);
	            SetPlayerFacingAngle(i,90.9567);
	            SetCameraBehindPlayer(i);

	            ApplyAnimation(i, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0); // Place Bomb
	            SetTimer("PlantingThreeYugoBridge",5000,0);
			}
		}
	}
}

public PlantingThreeYugoBridge()
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlantingYugoBridge[i] == 1)
	        {
	            SetPlayerPos(i,2127.6108,2837.9739,10.8517);
	            SetPlayerFacingAngle(i,270);
	            SetCameraBehindPlayer(i);

	            ApplyAnimation(i, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0); // Place Bomb
	            SetTimer("FinalPlantYugoBridge",5000,0);
			}
		}
	}
}

public FinalPlantYugoBridge()
{
    for(new i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlantingYugoBridge[i] == 1)
	        {
	            SetTimer("YugoBridgeExplosionOne",5000,0);

	            SetPlayerPos(i,2127.3152,2796.2083,10.6719);
	            SetPlayerFacingAngle(i,0);
	            SetCameraBehindPlayer(i);
	            TogglePlayerControllable(i,1);

	            SendClientMessage(i,COLOR_ERROR,"You have planted the bombs on the bridge and they are rigged to explode in 5 seconds, move back!");
			}
		}
	}
}

public YugoBridgeExplosionOne()
{
	CreateExplosion(2115.0698,2813.4106,10.8203,6,10.0);
	SetTimer("YugoBridgeExplosionTwo",500,0);
}

public YugoBridgeExplosionTwo()
{
	CreateExplosion(2122.7292,2813.8962,12.9109,6,10.0);
	SetTimer("YugoBridgeExplosionThree",500,0);
}

public YugoBridgeExplosionThree()
{
	CreateExplosion(2128.6333,2816.7253,13.5952,6,10.0);
	SetTimer("YugoBridgeExplosionFour",500,0);
}

public YugoBridgeExplosionFour()
{
	CreateExplosion(2134.8408,2818.1902,14.1276,6,10.0);
	SetTimer("YugoBridgeExplosionFive",500,0);
}

public YugoBridgeExplosionFive(playerid)
{
	new string[128];
    for(new i=0; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(IsPlantingYugoBridge[i] == 1)
	        {
				CreateExplosion(2134.6951,2830.5581,17.7997,6,10.0);

				new plwl = GetPlayerWantedLevel(playerid);
	    		SetPlayerWantedLevel(playerid, plwl +20);
				oscore = GetPlayerScore(i);
  				SetPlayerScore(i, oscore +1);

				if(terroristrank[i] < 40)
				{
				    terroristrank[i] ++;
				    SendClientMessage(i,COLOR_DODGERBLUE,"Your terrorist level has increased. Check out /tlevel to see your level and what you can blow up next.");
				}

				YugoBlown =480;

				format(string,sizeof(string),"[TERRORIST ACTION] %s(%d) has blown the CIA Bridge with high powered explosives!",PlayerName(i),i);
				SendClientMessageToAll(COLOR_RED,string);
			}
		}
	}
}

public OnPlayerEnterDynamicCP(playerid,checkpointid)
{
 if(IsPlayerInDynamicCP(playerid, RaceAreaEnter))
    {
        if(IsPlayerInAnyVehicle(playerid)) //if player is in any vehicle
        {
            SendClientMessage(playerid,COLOR_WHITE,"CHECKPOINT HELP: Leave your vehicle and re-enter the checkpoint.");
     }
  else
  {
      SetPlayerPos(playerid, -408.1791,1546.1188,146.2871 ); //set player pos
      SetCameraBehindPlayer(playerid); //puts cam behind players
      SendClientMessage(playerid,0x00C2ECFF,"You have reached the Spectator's Area! Enjoy the race.");
  }
    }

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}
dont s
public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
