#include <a_samp>
#include <zcmd>
#include <foreach>

#define COLOR_DEADCONNECT 0x808080AA
#define COLOR_LIGHTBLUE 0x00C7FFAA

#define VEHICLE_PARAMS_ON 1
#define VEHICLE_PARAMS_OFF 0

new engine, lights, alarm, doors, bonnet, boot, objective, Locked[MAX_PLAYERS];

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(Locked[playerid] == 1)
	{
	    foreach(Player, i)
		{
			if(i != playerid)
			{
				SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 0);
			}
			SendClientMessage(playerid, 0xFFFF00AA, "Vehicle unlocked!");
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1058,pX,pY,pZ);
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_WALK)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only start the engine as the driver.");
			    return 1;
			}
		    GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
		    if(engine == 0)
		    {
				
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), 1, lights, alarm, doors, bonnet, boot, objective);
				new Float:pX, Float:pY, Float:pZ;
				GetPlayerPos(playerid,pX,pY,pZ);
				PlayerPlaySound(playerid,1056,pX,pY,pZ);
				SendClientMessage(playerid, 0xFFFF00AA, "Engine Started!");
				return 1;
			}
			else if(engine == 1)
			{
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, lights, alarm, doors, bonnet, boot, objective);
			    new Float:pX, Float:pY, Float:pZ;
				GetPlayerPos(playerid,pX,pY,pZ);
				PlayerPlaySound(playerid,1058,pX,pY,pZ);
				SendClientMessage(playerid, 0xFFFF00AA, "Engine Stopped!");
				return 1;
			}
		}
		return 1;
	}
	return 1;
}

CMD:vehhelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_DEADCONNECT, "|_Vehicle Help_|");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/engineon - start engine");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/engineoff - stop engine");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/lightson - activate lights");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/lightsoff - deactivate lights");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/openbonnet - open the bonnet");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/closebonnet - close the bonnet");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/openboot - open the boot");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/closeboot - close the boot");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/lock - lock your car");
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "/unlock - unlock your car");
	return 1;
}

CMD:engineon(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(engine != 1)
	    {
			if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only start the engine as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), 1, lights, alarm, doors, bonnet, boot, objective);
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1056,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Engine Started!");
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFF00AA, "Your engine is already on.");
		}
    }
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}

CMD:engineoff(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(engine != 1)
	    {
            SendClientMessage(playerid, 0xFFFF00AA, "Your engine isn't on.");
            return 1;
		}
		else
		{
		    if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only stop the engine as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), 0, lights, alarm, doors, bonnet, boot, objective);
		    new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1058,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Engine Stopped!");
		}
    }
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
		return 1;
	}
	return 1;
}

CMD:lightson(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(lights != 1)
	    {
			if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only turn on the lights as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 1, alarm, doors, bonnet, boot, objective);
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1056,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Lights Activated!");
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFF00AA, "Your lights are already on.");
		    return 1;
		}
    }
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
		return 1;
	}
	return 1;
}

CMD:lightsoff(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(lights != 1)
	    {
			SendClientMessage(playerid, 0xFFFF00AA, "Your lights aren't on.");
		    return 1;
	    }
	    else
		{
		    if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only turn off the lights as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 0, alarm, doors, bonnet, boot, objective);
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1058,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Lights Deactivated!");
		}
	}
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}

CMD:openbonnet(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(bonnet != 1)
	    {
			if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only open the bonnet as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 1, boot, objective);
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1056,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Bonnet Opened!");
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFF00AA, "Your bonnet isn't open.");
		    return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}

CMD:closebonnet(playerid, params[])
{
    if(bonnet != 1)
    {
	    if(IsPlayerInAnyVehicle(playerid))
		{
			SendClientMessage(playerid, 0xFFFF00AA, "Your bonnet isn't open.");
		    return 1;
		}
		else
		{
		    if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only close the bonnet as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, 0, boot, objective);
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1058,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Bonnet Closeed!");
		}
	}
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}

CMD:openboot(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
 		if(boot != 1)
   		{
			if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only open the boot as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 1, objective);
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1056,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Boot Opened!");
		}
		else
		{
		    SendClientMessage(playerid, 0xFFFF00AA, "Your boot is already open.");
		    return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}

CMD:closeboot(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(boot != 1)
   		{
            SendClientMessage(playerid, 0xFFFF00AA, "Your boot isn't open.");
		    return 1;
		}
		else
		{
		    if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only close the boot as the driver.");
			    return 1;
			}
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, 0, objective);
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1058,pX,pY,pZ);
			SendClientMessage(playerid, 0xFFFF00AA, "Boot Closed!");
		}
	}
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}

CMD:lock(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(Locked[playerid] != 1)
	    {
			if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only lock the doors as the driver.");
			    return 1;
			}
	  		foreach(Player, i)
			{
				if(i != playerid)
				{
					SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 1);
				}
			}
			SendClientMessage(playerid, 0xFFFF00AA, "Vehicle locked!");
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1056,pX,pY,pZ);
		}
		else
		{
		    SendClientMessage(playerid,0xFFFF00AA,"Your car is already locked");
		    return 1;
		}
	}
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}

CMD:unlock(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
	{
	    if(Locked[playerid] != 1)
		{
            SendClientMessage(playerid,0xFFFF00AA,"Your car isn't locked");
            return 1;
		}
		else
		{
		    if(GetPlayerState(playerid) !=PLAYER_STATE_DRIVER)
			{
			    SendClientMessage(playerid,0xFFFF00AA,"You can only lock the doors as the driver.");
			    return 1;
			}
	  		foreach(Player, i)
			{
				if(i != playerid)
				{
					SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i, 0, 0);
				}
			}
			SendClientMessage(playerid, 0xFFFF00AA, "Vehicle unlocked!");
			new Float:pX, Float:pY, Float:pZ;
			GetPlayerPos(playerid,pX,pY,pZ);
			PlayerPlaySound(playerid,1058,pX,pY,pZ);
		}
	}
	else
	{
		SendClientMessage(playerid, 0xFFFF00AA, "You're not in a vehicle!");
	}
	return 1;
}
