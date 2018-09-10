#include <a_samp>
#include <zcmd>

#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_ERROR 0xD2691EAA

#define DIALOG_RULES 1330
#define DIALOG_SHOWRULES 1331

CMD:rules(playerid, params[])
{
    new string[128];
   	new pName[24];
	GetPlayerName(playerid, pName, sizeof(pName));
	format(string, sizeof(string), "Info: %s has typed /rules.", pName);
	SendClientMessageToAll(COLOR_ORANGE, string);
	SendClientMessage(playerid, COLOR_ORANGE, "For the complete list of rules, check www.sa-rcr.com");
	ShowPlayerDialog(playerid,DIALOG_RULES,DIALOG_STYLE_LIST,"{33CCFF}Rules Menu","{10F441}1: {FFFFFF}Don't DM\n{10F441}2: {FFFFFF}Don't Hack\n{10F441}3: {FFFFFF}Don't Spam\n{10F441}4: {FFFFFF}Don't Disrespect\n{10F441}5: {FFFFFF}Don't Abuse Bugs\n{10F441}6: {FFFFFF}Police Rules\n{10F441}7: {FFFFFF}SWAT Rules\n{10F441}8: {FFFFFF}FBI Rules\n{10F441}9: {FFFFFF}Army Rules\n{10F441}10: {FFFFFF}Frequently Used Terms","Select","Done");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_RULES)
	{
  		if(!response)
	    {
	        SendClientMessage(playerid, COLOR_ORANGE, "Thank you for reading the /rules.");
	        return 1;
		}
		switch(listitem)
   		{
			case 0:
			{
			    new rules[1024];
			    strins(rules,"{33CCFF}DM'ing or Deathmatching, is when one player approaches another and just kills him for no apparent reason.\n",strlen(rules));
			    strins(rules,"{33CCFF}A few VALID reasons for killing someone are...\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player /rapes or /robs you.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player attempts to kidnap you and either fails or you /cutrope.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a mechanic /breaks your car.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player starts shooting at you, but only fire after you warn him.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a police officer is chasing you. If you are orange, you can only shoot after he /pu's you or starts chasing.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If you are a hitman and the person either has a hit on them or fails to pay for the hit that they placed.\n",strlen(rules));
			    strins(rules,"{33CCFF}Some INVALID reasons for killing someone are...\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player talks bad about you or your friend.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player kills your friend. This may be different if you are in a Gang.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player rams you. However, if he rams you on purpose or tries to carpark you, then you may shoot at him.\n",strlen(rules));
				ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Deathmatching", rules, "Continue","Back");
				return 1;
			}
			case 1:
			{
			    new rules[1024];
			    strins(rules,"{33CCFF}Hacking is when you use a third party addon for GTA San Andreas (mod s0beit / CLEO Mods / Key Binds) to gain advantages over other players.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Not all CLEO Mods are prohibited, only the ones that give you UNFAIR advantages. Mods like ELM (Emergency Light Mod) are perfectly okay.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do not hack cash or weapons, you will get caught and Perma-Banned.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Using hacks can and will most likely get you banned.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If you see a player hacking, don't shout HACKING in main chat. Use /report [id][reason] instead.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Don't start hacking when there aren't any admins on. Most of the time Admins will get on with secret accounts.\n",strlen(rules));
			    strins(rules,"{33CCFF}Please note that if you are caught hacking on [SArcr] that your ban will be permanent unless there is a valid reason behind it.\n",strlen(rules));
				ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Hacking", rules, "Continue","Back");
			}
			case 2:
			{
			    new rules[1024];
			    strins(rules,"{33CCFF}Spamming is when you flood the main chat or posting links in the main chat that you know you're not supposed to.\n",strlen(rules));
			    strins(rules,"{FFFFFF}No posting links to: Malware, Pornography, Warez, etc.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT Advertise. Advertising is defined as posting the IPs/Names/Forums of other servers.\n",strlen(rules));
			    strins(rules,"{33CCFF}Using hacks can and will most likely get you banned.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT Command Spam - spamming commands like /report or /me\n",strlen(rules));
			    strins(rules,"{33CCFF}If you are caught breaking these rules you will get three warnings.\n",strlen(rules));
			    strins(rules,"{10F141}1. {FFFFFF}An Admin will speak to you regarding it.\n",strlen(rules));
			    strins(rules,"{10F141}2. {FFFFFF}You will be muted temporarily.\n",strlen(rules));
			    strins(rules,"{10F141}3. {FFFFFF}You will be kicked.\n",strlen(rules));
			    strins(rules,"{33CCFF}If you come back and continue, you will be banned and will have to appeal.\n",strlen(rules));
				ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Spamming", rules, "Continue","Back");
			}
			case 3:
			{
			    new rules[1024];
			    strins(rules,"{33CCFF}Disrespecting is when you purposely insult others over main chat or /pm.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT purposely insult a player. For example, [DR]Sc0pe is a fat homo(sexual).\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT insult admins. You will get warned, muted and possibly kicked if you continue.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT try to argue with an admin because you feel that you were punished wrongly.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT flame the main chat because a player killed you.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Making insults about a player's family member(s) is forbidden. Doing so will get you muted without warning.\n",strlen(rules));
			    strins(rules,"{FFFFFF}No Racism in main chat. Doing so will get you muted without warning.\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Disrespecting", rules, "Continue","Back");
			}
			case 4:
			{
			    new rules[1024];
			    strins(rules,"{33CCFF}Bug Abuse or Abusing Bugs, is when you use SA-MP or Server bugs to your advantage.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If you are caught bug abusing you will be punished accordingly based on what you did.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If you find a bug make a post of what you saw, with screenshots and/or videos, in the Bug Reports section of the forum.\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Bug Abusing", rules, "Continue","Back");
   			}
			case 5:
			{
			    new rules[1024];
			    strins(rules,"{FFFFFF}Police Officers can only shoot at orange players if they either resist arrest or shoot first.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Police Officers can shoot at red players without warning.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Police Officers cannot cuff a player and leave them there unless the player is a DM'er.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player surrenders or puts his hands up, just arrest him instead of killing him.\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Detailed Police Rules", rules, "Continue","Back");
				return 1;
			}
			case 6:
			{
			    new rules[1024];
			    strins(rules,"{FFFFFF}SWAT Officers can shoot at red players without warning.\n",strlen(rules));
			    strins(rules,"{FFFFFF}SWAT Officers cannot cuff a player and leave them there unless the player is a DM'er.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player surrenders or puts his hands up, just arrest him instead of killing him.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player is trespassing on the SWAT Base you are authorized to fire at them after 1 minute.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT place spikes and leave them there. You will be suspended and possibly demoted if you get caught.\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Detailed SWAT Rules", rules, "Continue","Back");
   			}
			case 7:
			{
			    new rules[1024];
			    strins(rules,"{FFFFFF}FBI Agents can shoot at red players.\n",strlen(rules));
			    strins(rules,"{FFFFFF}FBI Agents cannot cuff a player and leave them there unless the player is a DM'er.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player surrenders or puts his hands up, just arrest him instead of killing him.\n",strlen(rules));
			    strins(rules,"{FFFFFF}FBI Agents cannot cuff a player and leave them there unless the player is a DM'er.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player is trespassing on the SWAT Base you are authorized to fire at him.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT place spikes and leave them there. You will be suspended and possibly demoted if you get caught.\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Detailed FBI Rules", rules, "Continue","Back");
   			}
			case 8:
			{
			    new rules[1024];
			    strins(rules,"{FFFFFF}Army Officers cannot cuff a player and leave them there unless the player is a DM'er.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player surrenders or puts his hands up, just arrest him instead of killing him.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player is trespassing on the Army base, you are authorized to fire at him ONLY after you give him a 1 minute warning.\n",strlen(rules));
			    strins(rules,"{33CCFF}Army Rules of Engagement\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player is trespassing on the Army Base you are authorized to fire at them after 1 minute.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player is red, you are authorized to use Army Vehicles on them.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player is red and a white or yellow player is with them, you are not authorized to use Army Vehicles.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If a player is red and an orange player is with them you are authorized to use Army Vehicles.\n",strlen(rules));
			    strins(rules,"{FFFFFF}If there are two orange players in a car, you are authorized to use Army Vehicles.\n",strlen(rules));
			    strins(rules,"{FFFFFF}For more information regarding colors, please check /pc.\n",strlen(rules));
			    strins(rules,"{33CCFF}Please note that the Rules of Engagement applies to players in vehicles.\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}Detailed Army Rules", rules, "Continue","Back");
				return 1;
			}
			case 9:
			{
			    new rules[1024];
			    strins(rules,"{FFFFFF}Do NOT score abuse. If you are caught your score may be reset to either your previous score or 0.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT ram other players - intentionally crashing your car into the other player's car.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Jail Fighting is allowed, however it will increase the length of the jail sentence of the player who killed.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT Cop Hunt - Hunting down EVERY cop in the server and killing them.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT trespass in Army, SWAT or FBI base, doing so will get you shot at and possibly killed.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT driveby players who are on foot.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Do NOT hide in houses or other special areas while wanted.\n",strlen(rules));
			    strins(rules,"{FFFFFF}The Regular Players Lounge is a place of peace. No /robbing or /raping inside.\n",strlen(rules));
			    strins(rules,"{33CCFF}English in Main Chat - This server is located in the United States. If you wish to speak in another language, please use /pm [id][message].\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}General Rules", rules, "Continue","Back");
			}
			case 10:
			{
			    new rules[1024];
			    strins(rules,"{FFFFFF}DM - Deathmatching\n",strlen(rules));
			    strins(rules,"{FFFFFF}DM'er - A player who runs around killing people without a valid reason.\n",strlen(rules));
			    strins(rules,"{FFFFFF}Hacker - A person who uses third party addons to San Andreas to gain advantages over other players.\n",strlen(rules));
			    strins(rules,"{FFFFFF}LEO - Law Enforcement Officer (Police, SWAT, FBI, Army, etc.).\n",strlen(rules));
			    strins(rules,"{FFFFFF}tag - The [SArcr] tag.\n",strlen(rules));
			    strins(rules,"{FFFFFF}reg(ular)s - Regular Players.\n",strlen(rules));
			    strins(rules,"{FFFFFF}screen(s) - Screenshots (Press F8 to take Screenshots.\n",strlen(rules));
			    strins(rules,"{FFFFFF}vid(s) - Videos.\n",strlen(rules));
			    strins(rules,"{FFFFFF}n00b/nawb/narb/etc. - An annoying player who doesn't know how to play.\n",strlen(rules));
			    strins(rules,"{FFFFFF}hit - a Hit Contract (/hit [id][amount] while in a vehicle to place hits on other players.\n",strlen(rules));
			    strins(rules,"{FFFFFF}kick(ed) - getting Kicked from the server by an Admin.\n",strlen(rules));
			    strins(rules,"{FFFFFF}ban(ned) - getting Banned from the server by an Admin.\n",strlen(rules));
			    strins(rules,"{FFFFFF}mute(d) - getting Muted by an Admin.\n",strlen(rules));
			    strins(rules,"{FFFFFF}weps - Weapons\n",strlen(rules));
			    ShowPlayerDialog(playerid,DIALOG_SHOWRULES, DIALOG_STYLE_MSGBOX, "{10F441}[SArcr] Frequently Used Terms", rules, "Continue","Back");
			}
		}
	}
	if(dialogid == DIALOG_SHOWRULES)
	{
	    if(!response)
        {
            ShowPlayerDialog(playerid,DIALOG_RULES,DIALOG_STYLE_LIST,"{33CCFF}Rules Menu","{10F441}1: {FFFFFF}Don't DM\n{10F441}2: {FFFFFF}Don't Hack\n{10F441}3: {FFFFFF}Don't Spam\n{10F441}4: {FFFFFF}Don't Disrespect\n{10F441}5: {FFFFFF}Don't Abuse Bugs\n{10F441}6: {FFFFFF}Police Rules\n{10F441}7: {FFFFFF}SWAT Rules\n{10F441}8: {FFFFFF}FBI Rules\n{10F441}9: {FFFFFF}Army Rules\n{10F441}10: {FFFFFF}Frequently Used Terms","Select","Exit");
			return 1;
        }
		else
		{
 			ShowPlayerDialog(playerid,DIALOG_RULES,DIALOG_STYLE_LIST,"{33CCFF}Rules Menu","{10F441}1: {FFFFFF}Don't DM\n{10F441}2: {FFFFFF}Don't Hack\n{10F441}3: {FFFFFF}Don't Spam\n{10F441}4: {FFFFFF}Don't Disrespect\n{10F441}5: {FFFFFF}Don't Abuse Bugs\n{10F441}6: {FFFFFF}Police Rules\n{10F441}7: {FFFFFF}SWAT Rules\n{10F441}8: {FFFFFF}FBI Rules\n{10F441}9: {FFFFFF}Army Rules\n{10F441}10: {FFFFFF}Frequently Used Terms","Select","Exit");
			return 1;
		}
	}
	return 0;
}

/*public OnGameModeExit()
{
	DestroyMenu(RulesMenu);
}
public OnPlayerSelectedMenuRow(playerid, row)
{
    new Menu:Current = GetPlayerMenu(playerid);
    if(Current == RulesMenu)
	{
		TogglePlayerControllable(playerid, 1);
		switch(row)
		{
			case 0:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "DM'ing or Deathmatching, is when one player approaches another and just kills him for no apparent reason.");
			    SendClientMessage(playerid,COLOR_ORANGE, "A few VALID reasons for killing someone are...");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player /rapes or /robs you.");
       			SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player attempts to kidnap you and either fails or you /cutrope.");
       			SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a mechanic /breaks your car.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player starts shooting at you, but only fire after you warn him.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a police officer is chasing you. If you are orange, you can only shoot after he /pu's you or starts chasing.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If you are a hitman and the person either has a hit on them or fails to pay for the hit that they placed.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player infects you with a disease.");
			    SendClientMessage(playerid,COLOR_ORANGE, "Some INVALID reasons for killing someone are...");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player talks bad about you or your friend.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player kills your friend. This may be different if you are in a Gang.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player rams you. However, if he rams you on purpose or tries to carpark you, then you may shoot at him.");
			    ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 1:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Hacking is when you use a third party addon for GTA San Andreas (mod s0beit / CLEO Mods / Key Binds) to gain advantages over other players.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Not all CLEO Mods are prohibited, only the ones that give you advantages, mods like ELM (Emergency Light Mod) are perfectly okay.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do not hack cash or weapons, you will get caught and Perma-Banned.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Using hacks can and will most likely get you banned.");
			    SendClientMessage(playerid,COLOR_ORANGE, "If you see a player hacking, don't shout HACKING in main chat. Use /report [id][reason] instead.");
			    SendClientMessage(playerid,COLOR_ORANGE, "Don't start hacking when there aren't any /admins on. Most of the time Admins will get on with secret accounts.");
			    ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 2:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Spamming is when you flood the main chat or posting links in the main chat that you know you're not supposed to.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "No posting links to...Malware, Pornography, Warez, etc.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT Advertise. Advertising is defined as posting the IPs / Names / Forums of other servers.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT Command Spam - spamming commands like /report or /me");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Please note that this also applies to the forums, meaning don't start a pointless thread.");
			    SendClientMessage(playerid,COLOR_ORANGE, "You will get three warnings.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "1. An Admin will speak to you regarding it.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "2. You will be muted temporarily.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "3. You will be kicked.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If you still come back and continue, you will be banned.");
			    ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 3:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Disrespecting is when you purposely insult others over main chat or /pm.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT purposely insult a player. For example, [SArcr]Sc0pe is a fat homo.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT insult admins. You will get warned, muted and possibly kicked if you continue.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT flame the main chat because a player killed you.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Making insults about a player's family members is forbidden. Doing so will get you muted without warning.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "No Racism in main chat. Doing so will get you muted without warning.");
			    ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 4:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Bug Abuse or Abusing Bugs, is when you use SA-MP or Server bugs to your advantage.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If you are caught bug abusing you will be punished accordingly based on what you did.");
			    SendClientMessage(playerid,COLOR_ORANGE, "If you find a bug make a post of what you saw, with screenshots and/or videos, in the Bug Reports section of the forum.");
			    ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 5:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Detailed Police Rules");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Police Officers can only shoot at orange players if they either resist arrest or shoot first.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Police Officers can shoot at red players without warning.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Police Officers cannot cuff a player and leave them there unless the player is a DM'er.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player surrenders or puts his hands up, just arrest him instead of killing him.");
			    ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 6:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Detailed SWAT Rules");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "SWAT Officers can shoot at red players.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "SWAT Officers cannot cuff a player and leave them there unless the player is a DM'er.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player surrenders or puts his hands up, just arrest him instead of killing him.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "SWAT Officers cannot cuff and leave a player cuffed unless the player is a DM'er.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player is trespassing on the SWAT Base you are authorized to fire at him.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT place spikes and leave them there. You will be suspended and possibly demoted if you get caught.");
                ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 7:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Detailed FBI Rules");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "FBI Agents can shoot at red players.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "FBI Agents cannot cuff a player and leave them there unless the player is a DM'er.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player surrenders or puts his hands up, just arrest him instead of killing him.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "FBI Agents cannot cuff and leave a player cuffed unless the player is a DM'er.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player is trespassing on the SWAT Base you are authorized to fire at him.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT place spikes and leave them there. You will be suspended and possibly demoted if you get caught.");
                ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 8:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "Detailed Army Rules");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Army Officers cannot cuff a player and leave them there unless the player is a DM'er.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player surrenders or puts his hands up, just arrest him instead of killing him.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Army Officers cannot cuff and leave a player cuffed unless the player is a DM'er.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player is trespassing on the Army base, you are authorized to fire at him ONLY after you give him a 1 minute warning.");
			    SendClientMessage(playerid,COLOR_ORANGE, "Army Rules of Engagement");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player is red, you are authorized to use Army Vehicles on them.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player is red and a white or yellow player is with them, you are not authorized use Army Vehicles.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If a player is red and an orange player is with them you are authorized to use Army Vehicles.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "If there are two orange players in a car, you are authorized to use Army Vehicles.");
			    SendClientMessage(playerid,COLOR_ORANGE, "For more information regarding colors, please check /pc.");
			    SendClientMessage(playerid,COLOR_ORANGE, "Please note that the Rules of Engagement applies to players in vehicles.");
			    ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 8:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "General Rules");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT score abuse. If you are caught your score may be reset to your previous score or 0.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT ram other players - intentionally crashing your car into the other player's car.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Jail Fighting is allowed.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT Cop Hunt - Hunting down EVERY cop in the server and killing them.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT trespass in Army, SWAT or FBI base, doing so will get you shot at and possibly killed.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT driveby players who are on foot.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Do NOT hide in houses while wanted.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "RPL is a place of peace. No /robbing or /raping inside.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "English in Main Chat - This server is English and we plan to keep it that way.");
                ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 9:
			{
			    SendClientMessage(playerid,COLOR_ORANGE, "[SArcr] Frequently Used Terms");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "DM - Deathmatching");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "DM'er - A player who runs around killing people for no reason.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "Hacker - A person who uses third party addons to San Andreas to gain advantages over other players.");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "NSV - North Side Vagos (Gang)");
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "LVPB - Las Venturas Play Boys (Gang)");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "LEO - Law Enforcement Officer (Police, SWAT, FBI, Army, etc.)");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "tag - The [SArcr] tag.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "reg(ular) - Regular Players");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "screen - Screenshots (F8 to take Screenshots)");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "vid - Videos");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "n00b/nawb/narb/etc. - An annoying player who doesn't know how to play.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "hit - a Hit Contract (/hit [id] while in a vehicle to put hits)");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "kick - getting Kicked from the server by an Admin.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "ban - getting Banned from the server by an Admin.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "mute - getting Muted by an Admin.");
                SendClientMessage(playerid,COLOR_LIGHTBLUE, "weps - Weapons");
                ShowMenuForPlayer(RulesMenu,playerid);
			}
			case 10:
			{
				HideMenuForPlayer(RulesMenu,playerid);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Thank you for reading the /rules. You may also want to check out /pc and /commands.");
			}
		}
	}
	return 1;
}
public OnPlayerExitedMenu(playerid)
{
	TogglePlayerControllable(playerid, 1);
	return 1;
}
CMD:rules(playerid, params[])
{
    new string[128];
   	new pName[24];
	GetPlayerName(playerid, pName, sizeof(pName));
	format(string, sizeof(string), "Info: %s has typed /rules.", pName);
	SendClientMessageToAll(COLOR_ORANGE, string);
	SendClientMessage(playerid, COLOR_ORANGE, "For the complete list of rules, check www.sa-rcr.com");
	ShowMenuForPlayer(RulesMenu,playerid);
	return 1;
}*/
