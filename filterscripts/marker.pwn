//MADE BY SNIPE AND DRAGSTA DONT EDIT THIS!!!!!!DONT CHANGE CREDIT!!!!
//IMPORTANT: ALL KEYS ARE ON NUMPAD SO IF YOU HAVE A PORTABLE COMPUTER YOU MUST CHANGE KEYS!CHECK SA-MP FORUM!
#include <a_samp>

#define FILTERSCRIPT

forward SaveMarker();
forward DeleteMarker();
forward GotoMarker();

new Float:Position[MAX_PLAYERS][3];
new Float:Pos[MAX_PLAYERS][6];
new Marked[MAX_PLAYERS];


public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Marker by Snipe and Dragsta");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
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

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_ANALOG_UP) //Save marker (8 KEY)
 	{
    	GetPlayerPos(playerid, Position[playerid][0],Position[playerid][1],Position[playerid][2]);
    	SetPlayerCheckpoint(playerid,Position[playerid][0],Position[playerid][1],Position[playerid][2],3.0);
     	GameTextForPlayer(playerid,"Marker Saved.",2000,5);
     	Marked[playerid] = 1;
    }
    else if(newkeys == KEY_ANALOG_LEFT) //Delete Marker (4 KEY)
    {
    	DisablePlayerCheckpoint(playerid);
     	GameTextForPlayer(playerid,"Marker Deleted.",2000,5);
     	Marked[playerid] = 0;
	}
	else if(newkeys == KEY_ANALOG_RIGHT) //Goto Marker (6 KEY)
 	{
  		if(Marked[playerid] == 0)
        {
        	GameTextForPlayer(playerid, "Set Marker First.",2000,5);
        	return 1;
		}
 		if (GetPlayerState(playerid) == 2)
   		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, Position[playerid][0],Position[playerid][1],Position[playerid][2]);
			Pos[playerid][0] = 0.0;
			Pos[playerid][1] = 0.0;
   		}
   		else
	    {
			SetPlayerPos(playerid, Position[playerid][0],Position[playerid][1],Position[playerid][2]);
   		}
		GameTextForPlayer(playerid,"You are Now on the Marker.",2000,5);
	}
 	return 1;
}


