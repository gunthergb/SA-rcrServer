/*
    Name: VBan
	Description: Bans system
	Author: ViniBorn
	Contact : vini-elite@hotmail.com
	Country : Brazil


        ***        ***   ***   *****     ***   ***   *** ***       *****      ********    ******    ***
         ***      ***    ***   *** ***   ***   ***   ***   **    ***   ***    ***  ***    *** ***   ***
          ***    ***     ***   ***  ***  ***   ***   *** **      ***   ***    *** ***     ***  ***  ***
           ***  ***      ***   ***   *** ***   ***   ***   **    ***   ***    ***  ***    ***   *** ***
            ******       ***   ***    ******   ***   *** ****      *****      ***   ***   ***    ******





        Do not remove the credits.
        Your name is valuable, do not mess it.


        Comments:

        - The default directory for saving bans is: scriptfiles/bans. Create bans folder.


*/

#include <Double-O-Files_2>
#include <a_samp>

#define BanDir     "/SArcr/Users/Bans/%s.ini"     // Directory of bans
#define ErrorColor      0xAFAFAFAA
#define BanColor        0xE11D36AA

new VIP[32],Vnewban[32],Vstring[128],NICKBAN[20];

stock VBanID(playerid,giveid,reason[])
{
    format(NICKBAN,20,VBPlayer(giveid));
	if(playerid > -1)
	{
	    format(Vstring,128,"'- VBan -' Player '%s' was banned by Administrator '%s' for '%s'.",VBPlayer(giveid),VBPlayer(playerid),reason);
	    SendClientMessageToAll(BanColor,Vstring);
	    GetPlayerIp(giveid, VIP, sizeof(VIP));
	    format(Vnewban,32,BanDir,VIP);
		DOF2_CreateFile(Vnewban);
		VBanSaveInfo(playerid,Vnewban,reason);
	    format(Vnewban,32,BanDir,VBPlayer(giveid));
		DOF2_CreateFile(Vnewban);
		VBanSaveInfo(playerid,Vnewban,reason);
	}
	else
	{
	    format(Vstring,128,"Player '%s' was banned by VBot Admin for '%s'.",VBPlayer(giveid),reason);
	    SendClientMessageToAll(BanColor,Vstring);
	    format(Vnewban,32,BanDir,VBPlayer(giveid));
		DOF2_CreateFile(Vnewban);
		VBanSaveInfo(-1,Vnewban,reason);
	}
	if(IsPlayerConnected(giveid))
		VBanLoadInfo(giveid,Vnewban);

	Kick(giveid);

    return 1;
}

stock VBanNick(playerid,nick[],reason[])
{
    format(Vnewban,32,BanDir,nick);

    if(DOF2_FileExists(Vnewban))
		return SendClientMessage(playerid, ErrorColor,"This nickname is already banned.");

	new giveid;
	giveid = VBReturnUser(nick);
	if(!IsPlayerConnected(giveid))
	{
        format(NICKBAN,20,nick);
		format(Vstring,128,"Nickname '%s' was banned by Administrator '%s' for '%s'.",nick,VBPlayer(playerid),reason);
		SendClientMessageToAll(BanColor,Vstring);
		DOF2_CreateFile(Vnewban);
	    return VBanSaveInfo(playerid,Vnewban,reason);
    }
	else
	    return VBanID(playerid,giveid,reason);
}

stock VBanIP(playerid,IP2[],reason[])
{
    format(Vnewban,32,BanDir,IP2);

    if(DOF2_FileExists(Vnewban))
		return SendClientMessage(playerid, ErrorColor,"This IP Address has already been banned.");

	if(playerid > -1)
	{
	    new ban;

		for(new i=0, j = GetMaxPlayers(); i < j; i++)
		    if(IsPlayerConnected(i))
		    {
			    GetPlayerIp(i, VIP, sizeof(VIP));
			    if(!strcmp(VIP, IP2))
			    {
			        ban++;
		            VBanID(playerid,i,reason);
	            }
            }

		if(ban == 0)
		{
	        DOF2_CreateFile(Vnewban);
		    format(Vstring,128,"IP Address '%s' was banned by Administrator '%s' for '%s'.",IP2,VBPlayer(playerid),reason);
		    SendClientMessageToAll(BanColor,Vstring);
		    VBanSaveInfo(playerid,Vnewban,reason);
	    }
    }
    else
    {
        format(Vnewban,32,BanDir,IP2);
        DOF2_CreateFile(Vnewban);
	    format(Vstring,128,"IP Address '%s' was banned by VBot Admin for attempting to evade a previous ban.",IP2);
	    SendClientMessageToAll(BanColor,Vstring);
	    VBanSaveInfo(-1,Vnewban,"Ban Evade");
    }
    return 1;
}

stock VUnBan(playerid,Arq[])
{
    format(Vnewban,32,BanDir,Arq);
    if(!DOF2_FileExists(Vnewban))
		return SendClientMessage(playerid, ErrorColor,"Ban not found.");

	new BANNEDIP[32];
	format(BANNEDIP,32,BanDir,DOF2_GetString(Vnewban,"IP"));
    if(DOF2_FileExists(BANNEDIP))
    {
        new BANNEDACC[32];
        if(VBIsIP(Arq))
            format(Vstring,128,"The IP Address '%s(%s)' has been unbanned by Administrator '%s'.",Arq,DOF2_GetString(Vnewban,"Nick"),VBPlayer(playerid));
        else
	    	format(Vstring,128,"Player '%s(%s)' has been unbanned by Admininstrator '%s'.",Arq,DOF2_GetString(Vnewban,"IP"),VBPlayer(playerid));

    	format(BANNEDACC,32,BanDir,DOF2_GetString(Vnewban,"Nick"));
		DOF2_RemoveFile(BANNEDACC);
    	DOF2_RemoveFile(BANNEDIP);
   	}
    else
		format(Vstring,128,"Player '%s' has been unbanned by Administrator '%s'.",Arq,VBPlayer(playerid));

	SendClientMessageToAll(0x10B4EEAA,Vstring);
	DOF2_RemoveFile(Vnewban);
	return 1;
}

stock VBanCheck(playerid)
{
    format(Vnewban,32,BanDir,VBPlayer(playerid));
    if(DOF2_FileExists(Vnewban))
    {
		VBanLoadInfo(playerid,Vnewban);
		GetPlayerIp(playerid, VIP, sizeof(VIP));
		VBanIP(-1,VIP,DOF2_GetString(Vnewban,"Reason"));
		return Kick(playerid);
	}
	GetPlayerIp(playerid, VIP, sizeof(VIP));
	format(Vnewban,32,BanDir,VIP);
	if(DOF2_FileExists(Vnewban))
    {
        VBanLoadInfo(playerid,Vnewban);
        format(NICKBAN,20,VBPlayer(playerid));
        DOF2_SetString(Vnewban,"Nick",NICKBAN);
        DOF2_SaveFile();
        VBanID(-1,playerid,DOF2_GetString(Vnewban,"Reason"));
		return Kick(playerid);
	}
    return 1;
}
stock VBanLoadInfo(playerid,Varq[])
{
    if(!DOF2_FileExists(Varq))
		return SendClientMessage(playerid, ErrorColor,"Ban not found.");

	new InfoString[300];
	format(InfoString,300,"\n\t{FFFFFF}Nickname : {E11D36}%s\n\t{FFFFFF}IP : {E11D36}%s\n\t{FFFFFF}Admin : {E11D36}%s\n\t{FFFFFF}Reason : {E11D36}%s\n\t{FFFFFF}Date : {E11D36}%s\n\t{FFFFFF}Hour : {E11D36}%s",DOF2_GetString(Varq,"Nick"),DOF2_GetString(Varq,"IP"),DOF2_GetString(Varq,"Admin"),DOF2_GetString(Varq,"Reason"),DOF2_GetString(Varq,"Date"),DOF2_GetString(Varq,"Hour"));
	ShowPlayerDialog(playerid, 231, DIALOG_STYLE_MSGBOX, "        {FFFFFF}VBan - BanInfo -       By: ViniBorn", InfoString,"Close", "");
    return 1;
}

stock VBanSaveInfo(playerid,Varq[],reason[])
{
    new Vyear, Vmonth, Vday, Vhour, Vminute, Vsecond;
	getdate(Vyear, Vmonth, Vday); gettime(Vhour, Vminute, Vsecond);
    DOF2_SetString(Varq,"IP",VIP);
    DOF2_SetString(Varq,"Nick",NICKBAN);
    if(playerid > -1)
	    DOF2_SetString(Varq,"Admin",VBPlayer(playerid));
	else
	    DOF2_SetString(Varq,"Admin","VBot Admin");
    format(Vstring,32,"%02d:%02d:%02d", Vhour, Vminute, Vsecond);
    DOF2_SetString(Varq,"Hour",Vstring);
    format(Vstring,32,"%02d/%02d/%d", Vday, Vmonth, Vyear);
    DOF2_SetString(Varq,"Date",Vstring);
    DOF2_SetString(Varq,"Reason",reason);
    DOF2_SaveFile();
    return 1;
}

stock VBPlayer(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	return pname;
}

stock VBReturnUser(PlayerName[])
{
    if(VBIsNumeric(PlayerName))
        return strval(PlayerName);
    else
    {
        new found=0, id;
        for(new i=0; i < GetMaxPlayers(); i++)
        {
            if(IsPlayerConnected(i))
            {
                new foundname[MAX_PLAYER_NAME];
                GetPlayerName(i, foundname, MAX_PLAYER_NAME);
                new namelen = strlen(foundname);
                new bool:searched=false;
                for(new pos=0; pos <= namelen; pos++)
                {
                    if(searched != true)
                    {
                        if(strfind(foundname,PlayerName,true) == pos)
                        {
                            found++;
                            id = i;
                        }
                    }
                }
            }
        }
        if(found == 1)
            return id;
        else
            return INVALID_PLAYER_ID;
    }
}

stock VBIsIP(const string[])
{
	new count;
    for (new i = 0, j = strlen(string); i < j; i++)
        if(string[i] > 47 && string[i] < 58)
			count++;

	if(count > 5)
	    return 1;

    return 0;
}

stock VBIsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
        if(string[i] > '9' || string[i] < '0') return 0;

    return 1;
}
