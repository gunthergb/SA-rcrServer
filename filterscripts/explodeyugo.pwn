#define FILTERSCRIPT

#include <a_samp>
#include <streamer>
#include <zcmd>

#define COLOR_RED 0xFF0000AA

new PlantingYugoBridge[MAX_PLAYERS];
new PlantYugoBomb[MAX_PLAYERS];
new ExplodeYugoTimer[MAX_PLAYERS];
new Explosions[MAX_PLAYERS];
new BlowYugoBridge;

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Terrorist Yugo Bridge Explosion");
	print("--------------------------------------\n");
	
	BlowYugoBridge = CreateDynamicCP(2115.1860, 2807.6877, 10.8203, 5, -1, -1, -1, 100.0);
	return 1;
}

public OnPlayerConnect(playerid)
{
	PlantingYugoBridge[playerid] = 0;
	Explosions[playerid] = 0;
	KillTimer(PlantYugoBomb[playerid]);
	KillTimer(ExplodeYugoTimer[playerid]);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlantingYugoBridge[playerid] = 0;
	Explosions[playerid] = 0;
	KillTimer(PlantYugoBomb[playerid]);
	KillTimer(ExplodeYugoTimer[playerid]);
	return 1;
}

CMD:cutchode(playerid, params[])
{
    if(!IsPlayerInDynamicCP(playerid, BlowYugoBridge)) return SendClientMessage(playerid, COLOR_RED, "You are not at the Yugoslavian Bridge");
    {
		SendClientMessage(playerid, COLOR_RED, "You have started to plant high-powered explosives around the base of the Yugoslavian Bridge.");
		PlantYugoBomb[playerid] = SetTimerEx("PlantYugoBridge", 2500, true, "d", playerid);
	}
	return 1;
}

forward PlantYugoBridge(playerid);
public PlantYugoBridge(playerid)
{
	switch(PlantingYugoBridge[playerid])
	{
	    case 0:
		{
		    SetPlayerPos(playerid,2115.1948,2813.8132,10.8203);
			SetPlayerFacingAngle(playerid,270.0542);
			SetCameraBehindPlayer(playerid);

			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
			PlantingYugoBridge[playerid] ++;
		}
	    case 1:
		{
		    SetPlayerPos(playerid,2139.3083,2816.8733,10.8203);
			SetPlayerFacingAngle(playerid,90.9567);
			SetCameraBehindPlayer(playerid);

			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
			PlantingYugoBridge[playerid] ++;
		}
	    case 3:
		{
		    SetPlayerPos(playerid,2127.6108,2837.9739,10.8517);
			SetPlayerFacingAngle(playerid,270);
			SetCameraBehindPlayer(playerid);

			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
			PlantingYugoBridge[playerid] ++;
		}
	    case 4:
		{
		    SetPlayerPos(playerid,2127.3152,2796.2083,10.6719);
	 		SetPlayerFacingAngle(playerid,0);
			SetCameraBehindPlayer(playerid);

			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
			PlantingYugoBridge[playerid] ++;
		}
	    default:
		{
		    SetPlayerPos(playerid,2115.1948,2813.8132,10.8203);
			SetPlayerFacingAngle(playerid,270.0542);
			SetCameraBehindPlayer(playerid);

			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
		    PlantingYugoBridge[playerid] = 0;
		    ExplodeYugoTimer[playerid] = SetTimerEx("ExplodeYugo", 5000, true, "d", playerid);
			KillTimer(PlantYugoBomb[playerid]);
		}
	}
	return 1;
}

forward ExplodeYugo(playerid);
public ExplodeYugo(playerid)
{
	switch(Explosions[playerid])
	{
	    case 0:
	    {
	        Explosions[playerid] ++;
			CreateExplosion(2115.0698,2813.4106,10.8203,6,10.0);
			CreateExplosion(2122.7292,2813.8962,12.9109,6,10.0);
			CreateExplosion(2128.6333,2816.7253,13.5952,6,10.0);
			CreateExplosion(2134.8408,2818.1902,14.1276,6,10.0);
		}
		default:
		{
		    Explosions[playerid] = 0;
			CreateExplosion(2115.0698,2813.4106,10.8203,6,10.0);
			CreateExplosion(2122.7292,2813.8962,12.9109,6,10.0);
			CreateExplosion(2128.6333,2816.7253,13.5952,6,10.0);
			CreateExplosion(2134.8408,2818.1902,14.1276,6,10.0);
			KillTimer(ExplodeYugoTimer[playerid]);
		}
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == BlowYugoBridge)
	{
	    GameTextForPlayer(playerid, "~r~/plantbomb ~w~to blow up the ~p~Yugoslavian Bridge", 1000, 3);
	}
	return 1;
}
