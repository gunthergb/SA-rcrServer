#include <a_samp>
#include <zcmd>

#define COLOR_LIGHTBLUE "{33CCFF}"
#define DIALOG_COMMANDS 1550

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_SPRINT))
    {
	   	ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W",4.1,0,0,0,1,0);
 		return 1;
	}
	return 1;
}
CMD:commands( playerid, params[] )
{
    new Str8[1970],
	Str1[] = "{FFFFFF}________________________________________________________________________________\n\
	         |\t\t\t\t\t\t\t\t\t\t\t\t|\n\
			 |       My commands\t     Best Commands\t   Vehicle Commands\t       Other Commands{FFFFFF}\t|\n\
			 |\t/register\t|\t/radio\t\t|\t/holycow\t|\t/commands\t|\n\
			 |\t/login\t\t|\t/style\t\t|\t\t\t|\t/updates\t|\n\
			 |\t/changepass\t|\t/trashf\t\t|\t/v\t\t|\t"COLOR_LIGHTBLUE"/rules{FFFFFF}\t\t|\n",
	Str2[] = "|\t/stats\t\t|\t/incred\t\t|\t/car\t\t|\t"COLOR_LIGHTBLUE"/credits{FFFFFF}\t|\n\
			 |\t/kill\t\t|\t/police\t\t|\t/vhelp\t\t|\t/help\t\t|\n\
			 |\t/god\t\t|\t/iron\t\t|\t/antifall\t\t|\t/creators\t|\n\
			 |\t/mywheels\t|\t/dick\t\t|\t/vspeed\t|\t/cookies\t|\n",
	Str3[] = "|\t/mypimp\t|\t/alien/surfing\t|\t/aspeed\t|\t/server\t|\n\
			 |\t/buyweapons\t|\t/shake\t\t|\t/speed\t\t|\t/teleports\t|\n\
			 |\t/myweapons\t|\t/shakestop\t|\t/boost\t\t|\t/t\t\t|\n\
			 |\t/cpanel(/cp)\t|\t/weaponizer\t|\t/ss\t\t|\t\t\t|\n\
			 |\t/goto\t\t|\t\t\t|\t/bp\t\t|\t/hold\t\t|\n",
	Str4[] = "|\t/pgoto\t\t|\t\t\t|\t/boostpower\t|\t/light\t\t|\n\
			 |\t/mytime\t|___________________\t|\t/spin\t\t|\t/csd\t\t|\n\
			 |\t/myweather\t|     Cookies Center{FFFFFF}\t|\t/binds\t\t|\t/chainsawdick\t|\n\
			 |\t/myskin\t|\t/buycookies\t|\t/boostoff\t|\t/katana\t\t|\n\
		   	 |\t/time\t\t|\t/buycookiejar\t|\t/up\t\t|\t/phone\t\t|\n\
	 		 |\t/report\t\t|\t/givecookies\t|\t/vup\t\t|\t/dildo\t\t|\n\
			 |\t/bug\t\t|\t/eatcookie\t|\t/cdive\t\t|\t/bone\t\t|\n",
	Str5[] = "|\t/stuntmode\t|\t/cookies\t|\t/nrg\t\t|\t"COLOR_LIGHTBLUE"/accounts{FFFFFF}\t|\n\
			 |\t/tag\t\t|___________________\t|\t/inf\t\t|\t"COLOR_LIGHTBLUE"/c{FFFFFF}\t\t|\n\
			 |\t/s\t\t|  Server Mini-Games{FFFFFF}\t|\t/flip\t\t|\t/eme\t\t|\n\
			 |\t/l\t\t|\t/trucking\t|\t/nos\t\t|\t"COLOR_LIGHTBLUE"/admins{FFFFFF}\t|\n\
			 |\t/sl\t\t|\t\t\t|\t/fix\t\t|\t"COLOR_LIGHTBLUE"/vips{FFFFFF}\t\t|\n",
	Str6[] =  "|\t/vhelp\t\t|\t/nc\t\t|\t/tc1\t\t|\t/pm\t\t|\n\
			 |\t/antifall\t\t|\t/wtfrace\t|\t/tc2\t\t|\t/teles\t\t|\n\
			 |\t/duel\t\t|\t\t\t|\t/tc3\t\t|\t/me\t\t|\n\
			 |\t/cduel\t\t|\t\t\t|\t/kp\t\t|\t"COLOR_LIGHTBLUE"/sex{FFFFFF}\t\t|\n\
			 |\t/duelaccept\t|\t\t\t|\t\t\t|\t/rz\t\t|\n\
			 |\t/td\t\t|\t\t\t|\t\t\t|\t/rorz\t\t|\n\
			 |\t/cj\t\t|\t\t\t|\t\t\t|\t/rzcmds\t|\n\
			 |\t/holdoff\t|\t\t\t|\t\t\t|\t/suggest\t|\n",
	Str7[] = "|{FFFFFF}_______________________________________________________________________________\t|\n\
			 |    /t /sps /races /dms /cities /tbs /stunts /ammu /rcs /drifts /drags /fun /pks /bjs /bsjs\t|\n\
			 |{FFFFFF}_______________________________________________________________________________\t|";
	format( Str8, sizeof( Str8 ), "%s%s%s%s%s%s%s",Str1, Str2, Str3, Str4, Str5, Str6, Str7);
	ShowPlayerDialog( playerid, DIALOG_COMMANDS, DIALOG_STYLE_MSGBOX, "Server Commands", Str8, "Ok", "");
	return 1;
}

CMD:copcmds(playerid, params[])
{
	new commands[1024];
	strins(commands, "{FFFFFF}______________________________________________________________________________________________\n",strlen(commands));
    strins(commands, "|\t"COLOR_LIGHTBLUE"/vc [PlayerID]\t\t\t{FFFFFF}|\tReport Visual Contact with a suspect.\t\t\t|\n",strlen(commands));
    strins(commands, "|\t"COLOR_LIGHTBLUE"/rp [PlayerID][Reason]\t\t{FFFFFF}|\tReport Criminal Activity\t\t\t\t\t|\n",strlen(commands));
    strins(commands, "|\t"COLOR_LIGHTBLUE"/fine [PlayerID]\t\t\t{FFFFFF}|\tIssue a fine to a suspect. Suspect must be {FFFF00}Yellow{FFFFFF}.\t\t|\n",strlen(commands));
    strins(commands, "|\t"COLOR_LIGHTBLUE"/pu [PlayerID]\t\t\t{FFFFFF}|\tAsk a player to pull over if in vehicle. Or freeze if on foot.\t|\n",strlen(commands));
    strins(commands, "|\t"COLOR_LIGHTBLUE"/taze [PlayerID]\t\t{FFFFFF}|\tTaze a suspect. Suspect must have a warrant issued.\t|\n",strlen(commands));
    strins(commands, "|\t"COLOR_LIGHTBLUE"/cuff [PlayerID]\t\t\t{FFFFFF}|\tPlace a suspect in handcuffs.\t\t\t\t|\n",strlen(commands));
    strins(commands, "|\t"COLOR_LIGHTBLUE"/search [PlayerID]\t\t{FFFFFF}|\tSearch a suspect for drugs or other illegal items\t\t|\n",strlen(commands));
	strins(commands, "|\t"COLOR_LIGHTBLUE"/ar [PlayerID]\t\t\t{FFFFFF}|\tArrest a suspect with a warrant.\t\t\t\t|\n",strlen(commands));
	strins(commands, "|\t"COLOR_LIGHTBLUE"/parole [PlayerID][Reason]\t{FFFFFF}|\tRelease a player from jail\t\t\t\t\t|\n",strlen(commands));
	strins(commands, "|\t"COLOR_LIGHTBLUE"/cm [PlayerID][Message]\t{FFFFFF}|\tSends a message through the Police Radio\t\t\t|\n",strlen(commands));
	strins(commands, "|\t"COLOR_LIGHTBLUE"/radon\t\t\t\t{FFFFFF}|\tTurn your Police Radio on.\t\t\t\t\t|\n",strlen(commands));
	strins(commands, "|\t"COLOR_LIGHTBLUE"/radoff\t\t\t\t{FFFFFF}|\tTurn your Police Radio off.\t\t\t\t\t|\n",strlen(commands));
	strins(commands, "|_____________________________________________________________________________________________|",strlen(commands));
	ShowPlayerDialog(playerid, DIALOG_COMMANDS, DIALOG_STYLE_MSGBOX, "{10F141}Police Officer Commands", commands, "Continue", "");
	return 1;
}
