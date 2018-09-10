#include <a_samp>
#include <sscanf2>

#define COLOR_GREEN 0x33AA33AA
#define COLOR_ERROR 0xD2691EAA
#define COLOR_DEADCONNECT 0x808080AA
#define COLOR_YELLOW 0xFFFF00AA

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

forward Float:GetDistanceBetweenPlayers(p1,p2);
public Float:GetDistanceBetweenPlayers(p1,p2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	if (!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
	{
		return -1.00;
	}
	GetPlayerPos(p1,x1,y1,z1);
	GetPlayerPos(p2,x2,y2,z2);
	return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
}

stock PlayerName(playerid)
{
	new name[255];
	GetPlayerName(playerid, name, 255);
	return name;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    dcmd(gg,2,cmdtext);
    dcmd(apm,3,cmdtext);
    dcmd(sethealth,9,cmdtext);
    dcmd(setwanted,9,cmdtext);
    return 1;
}

dcmd_gg(playerid, params[])
{
	new string[128];
	new giveplayerid;
    if(sscanf(params, "u", giveplayerid))
	{
	    SendClientMessage(playerid,COLOR_ERROR,"USAGE: /gg (Player Name/ID)");
	    return 1;
	}
	/*if(IsSpawned[playerid] != 1)
    {
        SendClientMessage(playerid,COLOR_ERROR,"You must be alive and spawned in order to be able to use this command.");
        return 1;
	}
	if(IsKidnapped[playerid] == 1)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You are kidnapped. You cannot use this command.");
	    return 1;
	}
	if(IsFrozen[playerid] == 1)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You have been frozen by a Server Administrator. You cannot use this command.");
	    return 1;
	}*/
	if(!IsPlayerConnected(giveplayerid))
	{
		format(string,sizeof(string),"The Player ID (%d) is not connected to the server. You cannot give a gun to them.",giveplayerid);
        SendClientMessage(playerid,COLOR_ERROR,string);
		return 1;
	}
	if(giveplayerid == playerid)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"You cannot give a gun to yourself. Why would you waste your time?");
	    return 1;
	}
	if(GetDistanceBetweenPlayers(playerid,giveplayerid) > 6)
	{
	    SendClientMessage(playerid,COLOR_ERROR,"That player is not close enough in order to give them a gun.");
	    return 1;
	}
	new wname[24];
	GetWeaponName(GetPlayerWeapon(playerid),wname,sizeof(wname));

	SendClientMessage(playerid,COLOR_DEADCONNECT,"[[_Gun Given_]]");
	format(string,sizeof(string),"You have given your %s to %s(%d).",wname,PlayerName(giveplayerid),giveplayerid);
	SendClientMessage(playerid,COLOR_YELLOW,string);
	GivePlayerWeapon(playerid,GetPlayerWeapon(playerid),-GetPlayerAmmo(playerid));

	SendClientMessage(giveplayerid,COLOR_DEADCONNECT,"[[_Gun Received_]]");
	format(string,sizeof(string),"You have been given an %s by %s(%d). Make sure you thank them.",wname,PlayerName(playerid),playerid);
	SendClientMessage(giveplayerid,COLOR_YELLOW,string);
	GivePlayerWeapon(giveplayerid,GetPlayerWeapon(playerid),GetPlayerAmmo(playerid));
	return 1;
}

dcmd_sethealth(playerid, params[])
{
	//if(PlayerAdminLevel[playerid] == 1337)
	//{
		new giveplayerid, Float:amount, string[70];
		if(sscanf(params, "uf", giveplayerid, amount)) return SendClientMessage(playerid, 0xFF0000AA, "Usage: /sethealth (id) (amount)");
        /*if(IsSpawned[giveplayerid] != 1)
		{
			format(string, sizeof(string), "%s(%d) is dead.",PlayerName(giveplayerid),giveplayerid);
		    SendClientMessage(playerid, COLOR_ERROR, string);
		    return 1;
    	}*/
		if(!IsPlayerConnected(giveplayerid))
	  	{
	  	    format(string, sizeof(string), "ID (%d) is not an active player", giveplayerid);
	    	SendClientMessage(playerid, COLOR_ERROR, string);
	    	return 1;
		}
        else
		{
			SetPlayerHealth(giveplayerid, amount);
			format(string, sizeof(string), "You've Set %s's (%d) Health To %d.", PlayerName(playerid), giveplayerid, amount);
			SendClientMessage(playerid, 0x00FF00AA, string);
			return 1;
		}
	//}
	//else return SendClientMessage(playerid,0xFF0000AA,"Bad Command. Type /commands for available commands depending on your chosen job/skill");
}

dcmd_setwanted(playerid, params[])
{
	//if(PlayerAdminLevel[playerid] == 1337)
	//{
		new giveplayerid, amount, string[70];
		if(sscanf(params, "ui", giveplayerid, amount)) return SendClientMessage(playerid, 0xFF0000AA, "Usage: /setwanted (id) (amount)");
		if(!IsPlayerConnected(giveplayerid))
	  	{
	  	    format(string, sizeof(string), "ID (%d) is not an active player", giveplayerid);
	    	SendClientMessage(playerid, COLOR_ERROR, string);
	    	return 1;
		}
        else
		{
			SetPlayerWantedLevel(giveplayerid, amount);
			format(string, sizeof(string), "You've Set %s's (%d) Wanted Level To %d.", PlayerName(playerid), giveplayerid, amount);
			SendClientMessage(playerid, 0x00FF00AA, string);
			return 1;
		}
	//}
	//else return SendClientMessage(playerid,0xFF0000AA,"Bad Command. Type /commands for available commands depending on your chosen job/skill");
}

dcmd_apm(playerid, params[])
{
    //if(PlayerAdminLevel[playerid] == 1337)
	//{
	    new giveplayerid, msg[128], string[128];
	    if(sscanf(params, "us[128]", giveplayerid, msg)) return SendClientMessage(playerid, 0xFF0000AA, "Usage: /apm (id) (msg)");
	    if(!IsPlayerConnected(giveplayerid))
	    {
	        format(string, sizeof(string), "ID (%d) is not an active player", giveplayerid);
	        SendClientMessage(playerid, COLOR_ERROR, string);
	        return 1;
		}
		else
		{
		    SendClientMessage(playerid,COLOR_DEADCONNECT, "|_Admin Message Sent_|");
			format(msg,sizeof(msg),"MESSAGE TO %s(%d): %s",PlayerName(giveplayerid),giveplayerid, msg);
			SendClientMessage(playerid,COLOR_GREEN,msg);
			SendClientMessage(playerid,COLOR_DEADCONNECT, "|_Admin Message Received_|");
			format(msg,sizeof(msg),"PM from Admin: %s", msg);
			SendClientMessage(giveplayerid,COLOR_GREEN,msg);
			PlayerPlaySound(giveplayerid,1085,0.0,0.0,0.0);
			printf("ADMIN PM: %s",msg);
			return 1;
		}
	//}
	//else return SendClientMessage(playerid,0xFF0000AA,"Bad Command. Type /commands for available commands depending on your chosen job/skill");
}
