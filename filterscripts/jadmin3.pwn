

//============================================================================//

//Includes

#include <a_samp>
//#include <a_whirlpool>
native WP_Hash(buffer[], len, const str[]);
#include <zcmd>
#include <sscanf2>
#include <foreach>
#include <YSI\y_scripting>

#pragma  dynamic    39470

//============================================================================//

//Variables, Defnes and other stuffs starts here.

stock
	 st[100]
;

//Public Macro
#define function:%0(%1)\
			forward %0(%1);\
				 public %0(%1)

//Level Check Macro
#define LevelCheck(%0,%1); \
		if(User[(%0)][accountAdmin] < %1 && !IsPlayerAdmin((%0)))\
			return format(st, 100, ""red"[ERROR] "grey"You are not authorized to use this command.", (%1)),\
				SendClientMessage((%0), -1, st);

//Login Check Macro
#define LoginCheck(%1) if(User[%1][accountLogged] == false) return SendClientMessage(%1, COLOR_RED, "Syntax Error: You must be logged in to use this command.")

//Do not change the file type to .ini, We uses SQLite.
#define 					 _DB_		        			"JakAdmin3/juser.db"
//The location and folder has been changed on 3.3.

#define                     _LOG_                           "JakAdmin3/Logs/"
//The location and folder for the log has been also changed on 3.3.

new _God[MAX_PLAYERS];
new reportmsg[4][136];

new SpecInt[MAX_PLAYERS][2];
new Float:SpecPos[MAX_PLAYERS][4];

new GameTimer[MAX_PLAYERS];

new VehicleNames[212][] = {
{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
{"Utility Trailer"}
};

//Configuration
#define                 VERSION                             "3.3 Patch I"

#define 				ADMIN_SPEC_TYPE_NONE 				0
#define 				ADMIN_SPEC_TYPE_PLAYER 				1
#define 				ADMIN_SPEC_TYPE_VEHICLE 			2

#define                 STARTING_SCORE                      0
//Starting score for registered player.
#define                 STARTING_CASH                       50000
//Starting cash for registered player.
#define                 MAX_RCON_WARNINGS                   3
//Max warnings for attempting to logged in RCON.
//Change the starting score and starting cash.
#define                 LOG                                 true
//Change to false if you want to disable making logs on the server (Such as saving kicks etc, ban messages).
#define                 AUTO_LOGIN                          true
//Change to false if you want to disable the auto-login system.
#define                 REGISTER_DIALOG                     true
//Change to false if you want to disable the register/login dialog.
#define                 READ_COMMANDS                       false
//Change to false if you want to disable reading all player commands.
#define                 MAX_PING                            false
//Change to false if you want to disable this system.
#define                 ANTI_SWEAR                          true
//Change to false if you want to disable the AntiSwear.
#define                 ANTI_NAME                           true
//Change to false if you want to disable the AntiName.
#define                 ANTI_SPAWN                          true
//Change to false if you want to disable.
//Anti Spawn disables player from spawning if they aren't registered or logged in.
#define                 ANTI_AD                             true
//Change to false if you want to disable the anti ad.
#define                 RconProtect                         false
//Change to false if you want to disable the 2nd Rcon.
#define                 AntiSpam                            true
//Change to false if you want to disable the AntiSpam.
#define                 ReportTD                            true
//Change to false if you want to disable the textdraw.

#if ReportTD == true
	new Text:Textdraw0;
#endif

enum PlayerInfo
{
    accountID,
    accountName[24],
    accountIP[20],
    accountQuestion[129],
    accountAnswer[129],
    accountPassword[129],
    accountAdmin,
    accountKills,
    accountDeaths,
    accountScore,
    accountCash,
    bool: accountLogged,
	WarnLog,
	accountDate[150],
	accountWarn,
	accountMuted,
	accountMuteSec,
	accountCMuted,
	accountCMuteSec,
	accountJail,
	accountJailSec,
	SpecID,
	SpecType,
	pCar,
	accountGame[3],
	pDuty,
	#if AntiSpam == true
	SpamCount,
	SpamTime
	#endif
};

new User[MAX_PLAYERS][PlayerInfo],
    DB:Database,
    static_Warn[MAX_PLAYERS]
;

#if AntiSpam == true
	#define 			SPAM_MAX_MSGS 						3  	// Max Spam Messages
	#define 			SPAM_TIMELIMIT						2  	// In seconds
#endif

#if RconProtect == true
	#include <OPRL>
	//Includes the OPRL by Lordzy if 2nd_Rcon is set to true.
	#define 			RconPass        					"ngc4ever"
	//Password for the 2nd Rcon, changeme to anything you want.
	new bool:_RCON[MAX_PLAYERS];
	new _RCONwarn[MAX_PLAYERS];
#endif

#if ANTI_NAME == true
	new ForbidNames[][] =
	{
		{"Admin"},
		{"AssLicker"},
		{"Vip"},
		{"Hacker"},
		{"Justin_Bieber"},
		{"Administrator"},
		{"Motherfucker"},
		{"Iwillfucktheserver"},
		{"noober"}
		//Names here, Remember, the last stanza don't have ","
	};
#endif

#if ANTI_SWEAR == true
	new Swears[][] =
	{
		{"dick"},
		{"pussy"},
		{"dildo"},
		{"adventure time gay"}
		//Bad Words here, Remember, the last stanza don't have ","
	};
#endif

#if MAX_PING == true
	#define             PING_EXCEED                         1500
	//Maximum ping if the MAX_PING is set to true, if player exceeds it, He or SHE gets kicked.
	#define             MAX_PING_WARN                       3
	//Max ping warning from Ping Kick, once exceed, player gets kicked.
#endif

//JakAdmin3 now makes everything easy.
#define                     SD                              ShowPlayerDialog
#define                     DP                              DIALOG_STYLE_PASSWORD
#define                     DI                              DIALOG_STYLE_INPUT
#define                     DM                              DIALOG_STYLE_MSGBOX
#define                     DL                              DIALOG_STYLE_LIST

//Dialog Begin is null, You can use it as a message displayer since it is not used.
#define             	DIALOG_BEGIN                            905
//Change the dialog id of the DIALOG_BEGIN if it conflicts.
#define                 DIALOG_REGISTER                 	DIALOG_BEGIN+1
#define                 DIALOG_LOGIN	                 	DIALOG_BEGIN+2
#define                 DIALOG_COLORS                       DIALOG_BEGIN+3
#define                 DIALOG_RCON                         DIALOG_BEGIN+4
#define                 DIALOG_QUESTION                     DIALOG_BEGIN+5
#define                 DIALOG_ANSWER                       DIALOG_BEGIN+6
#define                 DIALOG_FORGET                       DIALOG_BEGIN+7

//Colors

#define 				white 								"{FFFFFF}"
#define 				lightblue 							"{33CCFF}"
#define                 grey                                "{AFAFAF}"
#define                 orange                              "{FF8000}"
#define                 black                               "{2C2727}"
#define                 red                                 "{FF0000}"
#define                 yellow                              "{FFFF00}"
#define                 green                               "{33CC33}"
#define                 blue                                "{0080FF}"
#define                 purple                              "{D526D9}"
#define                 pink                                "{FF80FF}"
#define                 brown                               "{A52A2A}"

#define 				COLOR_RED  							0xFF0000C8
#define 				COLOR_YELLOW 						0xFFFF00AA
#define 				COLOR_GREEN         				0x33CC33C8
#define 				COLOR_ORANGE        				0xFF8000C8
#define 				COLOR_WHITE         				0xFFFFFFFF
#define 				COLOR_PURPLE        				0xD526D9FF
#define 				COLOR_LIGHTGREEN    				0x00FF00FF
#define 				COLOR_PINK          				0xFF80FFFF
#define 				COLOR_LIGHTBLUE     				0x33CCFFAA
#define 				COLOR_GREY          				0xAFAFAFAA
#define 				COLOR_BLUE          				0x0080FFC8
#define 				COLOR_BROWN	 						0xA52A2AAA
#define 				COLOR_BLACK		    				0x2C2727AA

//============================================================================//

//Script line starts here

public OnFilterScriptInit()
{
	new
		day,
		month,
		year,
		hour,
		sec,
		mins,
		result = GetTickCount()
	;

	getdate(year, month, day);
	gettime(hour, mins, sec);
	
	/*
		Checks the JakAdmin3 and logs folder if exist, otherwise sends a print message.
	*/
	
	checkfolder();
	
	/*
	    Just so you know, even if the folders of JakAdmin3 is missing, nothing will happen except
		accounts won't save. We have also blocked the SaveLog function from overwriting files
		when the Logs folder is missing.
	*/
	
	if(checkfolderEx() == 1)
	{
	    /*
			If CheckFolderEX returns 1 instead of 0 (Doesn't exist), proceed the daily route.
	    */
		printf("\nJakAdmin %s (c), Copyright - 2015", VERSION);
		print("Security Updates for SQL Injection, Patch I\n");

		//Load the .DB file.
		loadb();
		printf("[AS] Duration: %i ms", (GetTickCount() - result));
		printf("[AS] Total Commands: %i", j_CountCmds());
		printf("[AS] Date: %02i/%02i/%02i | Time: %02d:%02d:%02d", day, month, year, hour, mins, sec);
		Config();
		print("\n");

		//Syncing Timers
		SetTimer("SyncStats", 1000, true);
		//Ping Timer (if set to true)
		#if MAX_PING == true
		    SetTimer("PingCheck", 1000, true);
		#endif
		//Punishment Timer Handler
		SetTimer("PunishmentHandle", 1000, true);

		for(new i=0; i<4; i++)
		{
		    format(reportmsg[i], 136, "None");
		}

		#if ReportTD == true
			Textdraw0 = TextDrawCreate(400.000000, 386.000000, "~r~New Report! ~w~Check your ~g~chat ~w~or ~y~/reports~w~!");
			TextDrawBackgroundColor(Textdraw0, 255);
			TextDrawFont(Textdraw0, 1);
			TextDrawLetterSize(Textdraw0, 0.320000, 1.100000);
			TextDrawColor(Textdraw0, -1);
			TextDrawSetOutline(Textdraw0, 1);
			TextDrawSetProportional(Textdraw0, 1);
		#endif

		foreach(new i : Player)
		{
		    OnPlayerConnect(i);
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	//Closing the .DB file.
	closedb();
	
	#if ReportTD == true
		TextDrawDestroy(Textdraw0);
	#endif
	
	foreach(new i : Player)
	{
	    if(User[i][pCar] != -1)
	    {
	        DestroyVehicle(User[i][pCar]);
	    }
	    OnPlayerDisconnect(i, 1);
		User[i][accountLogged] = false;
	}
	return 1;
}

function:PunishmentHandle()
{
	new string[128+50];

	foreach(new i : Player)
	{
		if(User[i][accountJail] == 1)
		{
		    if(User[i][accountJailSec] >= 1)
		    {
		        User[i][accountJailSec] --;
		    }
	        else if(User[i][accountJailSec] == 0)
	        {
	            User[i][accountJail] = 0;
	            format(string, sizeof(string), "** %s(ID:%d) has been unjailed from Admin's Jail.", pName(i), i);
				SendClientMessageToAll(COLOR_GREY, string);
				SpawnPlayer(i);
	        }
		}
		if(User[i][accountMuted] == 1)
		{
		    if(User[i][accountMuteSec] >= 1)
		    {
		        User[i][accountMuteSec] --;
		    }
	        else if(User[i][accountMuteSec] == 0)
	        {
	            User[i][accountMuted] = 0;
	            format(string, sizeof(string), "** %s(ID:%d) has been unmuted from Admin's Mute.", pName(i), i);
				SendClientMessageToAll(COLOR_GREY, string);
	        }
		}
		if(User[i][accountCMuted] == 1)
		{
		    if(User[i][accountCMuteSec] >= 1)
		    {
		        User[i][accountCMuteSec] --;
		    }
	        else if(User[i][accountCMuteSec] == 0)
	        {
	            User[i][accountCMuted] = 0;
	            format(string, sizeof(string), "** %s(ID:%d) has been unmuted from Admin's Command Mute.", pName(i), i);
				SendClientMessageToAll(COLOR_GREY, string);
	        }
		}
	}
	return 1;
}

#if MAX_PING == true
	function:PingCheck()
	{
		new
			string[130]
		;
	    foreach(new i : Player)
		{
		    if(GetPlayerPing(i) > PING_EXCEED)
			{
				if(static_Warn[i] == MAX_PING_WARN)
				{
					format(string, sizeof(string), "** %s(ID:%d) has been automatically kicked by the reason [Reason: Exceeding Maximum Ping Limit] (Ping: %d | Maximum Ping: %d)", pName(i), i, GetPlayerPing(i), PING_EXCEED);
					SendClientMessageToAll(COLOR_GREY, string);
					KickDelay(i);
					return 1;
				}
				static_Warn[i] ++;
				format(string, sizeof(string), "** %s(ID:%d) has received a Ping Kick Warning (Ping: %d | Maximum Ping: %d) (Warnings: %d/%d)", pName(i), i, GetPlayerPing(i), PING_EXCEED, static_Warn[i], MAX_PING_WARN);
				SendClientMessageToAll(COLOR_YELLOW, string);
			}
		}
		return 1;
	}
#endif

function:SyncStats()
{
	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
			User[i][accountCash] = GetPlayerMoney(i);
			User[i][accountScore] = GetPlayerScore(i);
		}
		
		//Will be using for god too. (Improving it on the next version)
		if(_God[i] == 1)
		{
            SetPlayerHealth(i, 100000);
		}
	}
	return 1;
}

function:GamePlay(playerid)
{
	if(User[playerid][accountLogged] == true)
	{
		User[playerid][accountGame][0] += 1;
		if(User[playerid][accountGame][0] == 60)
		{
	        User[playerid][accountGame][0] = 0;
	        User[playerid][accountGame][1] += 1;
	        if(User[playerid][accountGame][1] >= 59 && User[playerid][accountGame][0] == 0)
	        {
	            User[playerid][accountGame][1] = 0;
	            User[playerid][accountGame][2] += 1;
	        }
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	#if ANTI_NAME == true
	    new string[128+40];
     	for(new x = 0; x < sizeof(ForbidNames); x++)
	    {
            if(!strcmp(pName(playerid), ForbidNames[x], true))
			{
			    format(string, sizeof string, "** Player %s(ID:%d) has been kicked by the Server (Forbidden Name)", pName(playerid), playerid);
			    SendClientMessageToAll(COLOR_GREY, string);
			    printf(string);
			    #if LOG == true
			    	SaveLog("kicklog.txt", string);
				#endif
			    KickDelay(playerid);
			    return 1;
			}
	    }
	#endif

	for(new x; x < _: PlayerInfo; ++x ) User[playerid][PlayerInfo: x] = 0;
	User[playerid][SpecID] = INVALID_PLAYER_ID;

	#if RconProtect == true
		_RCON[playerid] = false;
		_RCONwarn[playerid] = 0;
	#endif

	User[playerid][pDuty] = 0;
	User[playerid][pCar] = -1;
	#if AntiSpam == true
		User[playerid][SpamCount] = 0;
		User[playerid][SpamTime] = 0;
	#endif
	
	_God[playerid] = 0;
	
    GetPlayerName(playerid, User[playerid][accountName], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, User[playerid][accountIP], 20);

	static_Warn[playerid] = 0;

	new
		bQuery[128+90],
		reason[128],
		admin[128],
		when[128],
	    DBResult:jResult
	;
	format(bQuery, 600, "SELECT * FROM `bans` WHERE `username` = '%s'", pName(playerid));
	jResult = db_query(Database, bQuery);

	if(db_num_rows(jResult))
	{
	    db_get_field_assoc(jResult, "banby", admin, 128);
	    db_get_field_assoc(jResult, "banreason", reason, 128);
	    db_get_field_assoc(jResult, "banwhen", when, 128);

		ShowBan(playerid, admin, reason, when);

		KickDelay(playerid);
	    return 1;
	}
	db_free_result(jResult);

    new
        Query[128+71],
        DBResult: Result
    ;

	#if AUTO_LOGIN == true
		new fIP[20];
	#endif

	#if ReportTD == true
	    TextDrawHideForPlayer(playerid, Textdraw0);
	#endif

	GameTimer[playerid] = SetTimerEx("GamePlay", 1000, true, "d", playerid);

    #if AUTO_LOGIN == true
	    format(Query, sizeof(Query), "SELECT `password`, `question`, `answer`, `IP` FROM `users` WHERE `username` = '%s'", DB_Escape(User[playerid][accountName]));
	    Result = db_query(Database, Query);
	#else
	    format(Query, sizeof(Query), "SELECT `password`, `question`, `answer` FROM `users` WHERE `username` = '%s'", DB_Escape(User[playerid][accountName]));
	    Result = db_query(Database, Query);
	#endif
    if(db_num_rows(Result))
    {
        SendClientMessage(playerid, -1, "Your account is already existed in our database");
    
        db_get_field_assoc(Result, "password", User[playerid][accountPassword], 129);
    	db_get_field_assoc(Result, "question", User[playerid][accountQuestion], 129);
    	db_get_field_assoc(Result, "answer", User[playerid][accountAnswer], 129);
        #if AUTO_LOGIN == true
        	db_get_field_assoc(Result, "IP", fIP, 20);
			if(strcmp(fIP, User[playerid][accountIP], true) == 0)
	        {
	            SendClientMessage(playerid, -1, "You have been auto logged in.");
    			format(string, sizeof string, ""white"["red"NGC"white"] Admin "orange"%s "white" has been Auto Logged-in to his/her account.", pName(playerid));
    			SendClientMessageToAll(-1, string);
				LoginPlayer(playerid);
	        }
			else
			{
			    #if REGISTER_DIALOG == true
        			SD(playerid, DIALOG_LOGIN, DP, ""lightblue"NGC "white"- "red"Login", ""grey"Welcome back to the NGC!\nYou are already registered, Please insert your account's password below.\n\nTIPS: If you do not own the account, Please /q and find another username.", "Login", "Forget");
				#else
				    SendClientMessage(playerid, COLOR_ORANGE, "LOGIN: /login [password] to login to your account.");
				#endif
			}
        #else
            #if REGISTER_DIALOG == true
        		SD(playerid, DIALOG_LOGIN, DP, ""lightblue"NGC - Login", ""grey"Welcome back to the NGC!\nYou are already registered, Please insert your account's password below.\n\nTIPS: If you do not own the account, Please /q and find another username.", "Login", "Forget");
			#else
				SendClientMessage(playerid, COLOR_ORANGE, "LOGIN: /login [password] to login to your account.");
			#endif
		#endif
	}
    else
    {
        SendClientMessage(playerid, -1, "Your account is not existed in our database");
        #if REGISTER_DIALOG == true
        	SD(playerid, DIALOG_REGISTER, DP, ""lightblue"NGC - Register", ""grey"Welcome to the NGC!\nYour account is not registered, Please insert your password below.\n\nTIPS: Make the password long so no one can hack it.", "Register", "Quit");
		#else
			SendClientMessage(playerid, COLOR_ORANGE, "REGISTER: /register [password] to register your account.");
		#endif
	}
	db_free_result(Result);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	#if ReportTD == true
	    TextDrawHideForPlayer(playerid, Textdraw0);
	#endif

	for(new x=0; x<MAX_PLAYERS; x++)
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] == playerid)
   		   	AdvanceSpectate(x);

    if(User[playerid][pCar] != -1) EraseVeh(User[playerid][pCar]);

	KillTimer(GameTimer[playerid]);

    if(User[playerid][accountLogged] == true)
    {
        //Saves the statistics to the .db.
		SaveData(playerid);
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
    if(User[playerid][accountJail] == 1)
    {
		SetTimerEx("JailPlayer", 3000, 0, "d", playerid);
		SendClientMessage(playerid, COLOR_RED, "PUNISHMENT: You cannot escape your punishment. You are still jailed, Hah!");

		return 1;
	}
	return 1;
}

function:JailPlayer(playerid)
{
	new string[128];

	SetPlayerPos(playerid, 197.6661, 173.8179, 1003.0234);
	SetPlayerInterior(playerid, 3);
	SetCameraBehindPlayer(playerid);

    format(string, 200, "You have been placed in the jail for %d seconds.", User[playerid][accountJailSec]);
    SendClientMessage(playerid, COLOR_RED, string);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	for(new x=0; x<MAX_PLAYERS; x++)
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] == playerid)
   		   	AdvanceSpectate(x);

	User[playerid][accountDeaths] ++;
	if(killerid != INVALID_PLAYER_ID)
	{
		User[killerid][accountKills] ++;
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	foreach(new i : Player)
	{
        if(vehicleid == User[i][pCar])
		{
		    EraseVeh(vehicleid);
	        User[i][pCar] = -1;
        }
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new string[128+50];

	#if ANTI_AD == true
		if(strfind(text, ":", true) != -1)
		{
			new
				i_numcount,
				i_period,
				i_pos;

			while(text[i_pos]) {
				if('0' <= text[i_pos] <= '9') i_numcount++;
				else if(text[i_pos] == '.') i_period++;
				i_pos++;
			}
			if(i_numcount >= 8 && i_period >= 3)
			{
				format(string, sizeof(string), "ALERT: Player %s(ID: %d) may be server advertising: '%s'.", pName(playerid), playerid, text);
				foreach(new i : Player)
				{
				    if(User[i][accountLogged] == true)
				    {
				        if(User[i][accountAdmin] >= 1)
				        {
				            SendClientMessage(i, COLOR_RED, string);
				        }
				    }
				}
				SendClientMessage(playerid, -1, "Your chat has been sent.");
				return 0;
			}
		}
	#endif

	if(User[playerid][accountMuted] == 1)
	{
	    format(string, sizeof(string), "You are still muted, You can talk after %d seconds.", User[playerid][accountMuteSec]);
	    SendClientMessage(playerid, COLOR_ORANGE, string);
	    return 0;
	}
	
	#if AntiSpam == true
		if((User[playerid][accountAdmin] == 0 && !IsPlayerAdmin(playerid)))
		{
			if(User[playerid][SpamCount] == 0) User[playerid][SpamTime] = TimeStamp();

		    User[playerid][SpamCount]++;
			if(TimeStamp() - User[playerid][SpamTime] > SPAM_TIMELIMIT)
			{
				User[playerid][SpamCount] = 0;
				User[playerid][SpamTime] = TimeStamp();
			}
			else if(User[playerid][SpamCount] == SPAM_MAX_MSGS)
			{
				format(string, sizeof(string), "** Player %s (ID:%d) has been automatically kicked by Server (Flood/Spam Protection)", pName(playerid), playerid);
				SendClientMessageToAll(COLOR_GREY, string);
				print(string);
				#if LOG == true
					SaveLog("kicklog.txt", string);
				#endif
				KickDelay(playerid);
			}
			else if(User[playerid][SpamCount] == SPAM_MAX_MSGS-1)
			{
				SendClientMessage(playerid, COLOR_RED, "WARNING: Anti Spam Warning! Next is a Kick!");
				return 0;
			}
		}
	#endif
	
	#if ANTI_SWEAR == true
	 	for(new i = 0; i < sizeof(Swears); i++)
	    {
			Cenzura(text, Swears[i]);
		}
	#endif
	return 1;
}

//============================================================================//
//                              	ZCMD                                      //

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	new string[128+50];

	#if ANTI_AD == true
		if(strfind(cmdtext, ":", true) != -1)
		{

			new
				i_numcount,
				i_period,
				i_pos;

			while(cmdtext[i_pos]) {
				if('0' <= cmdtext[i_pos] <= '9') i_numcount++;
				else if(cmdtext[i_pos] == '.') i_period++;
				i_pos++;
			}
			if(i_numcount >= 8 && i_period >= 3)
			{
				format(string, sizeof(string), "ALERT: Player %s(ID: %d) may be server advertising: '%s'.", pName(playerid), playerid, cmdtext);
				foreach(new i : Player)
				{
				    if(User[i][accountLogged] == true)
				    {
				        if(User[i][accountAdmin] >= 1)
				        {
				            SendClientMessage(i, COLOR_RED, string);
				        }
				    }
				}
				SendClientMessage(playerid, -1, "Your command has been successfully sent.");
				return 0;
			}
		}
	#endif

	if(User[playerid][accountCMuted] == 1)
	{
	    format(string, sizeof(string), "You are still muted, You can use all the commands after %d seconds.", User[playerid][accountCMuteSec]);
	    SendClientMessage(playerid, COLOR_ORANGE, string);
	    return 0;
	}

    #if READ_COMMANDS == true
	    format(string, sizeof(string), "*** %s(ID:%d) : '%s'", pName(playerid), playerid, cmdtext);
	    foreach(new i : Player)
	    {
	        if(User[i][accountAdmin] >= 1 && User[i][accountAdmin] > User[playerid][accountAdmin] && i != playerid)
	        {
	            SendClientMessage(i, COLOR_GREY, string);
	        }
	    }
	#endif
    return 1;
}

//============================================================================//
//							Administrative Level 1-5                          //
//============================================================================//

CMD:acmds(playerid, params[])
{
	new string[1246+200];
	
	LoginCheck(playerid);
	LevelCheck(playerid, 1);
	
	strcat(string, ""orange"");
	strcat(string, "Administration Commands\n");
	strcat(string, "Listing all available administrative commands for your admin level.\n\n");
	
	if(User[playerid][accountAdmin] >= 1)
	{
		strcat(string, ""lightblue">>> Moderator (Level 1) <<<\n");
		strcat(string, ""grey"");
		strcat(string, "/announce /kick /asay /a(Admin Chat) /settime /setweather /goto /ip /spawn /gotoco /flip /warn\n");
		strcat(string, "/remwarn /addnos /repair /reports /aduty /weaps /ans\n\n");
	}
	if(User[playerid][accountAdmin] >= 2)
	{
		strcat(string, ""lightblue">>> Administrator (Level 2) <<<\n");
		strcat(string, ""grey"");
		strcat(string, "/disarm /explode /setinterior /setworld /heal /armour /clearchat /setskin /mute /unmute /(un)jail\n");
		strcat(string, "/akill /spec(off) /car /carcolor /eject /setvhealth /givecar /muted /jailed (/un)jail /show\n");
		strcat(string, "/aweapons /jetpack /carpjob /ban\n\n");
	}
	if(User[playerid][accountAdmin] >= 3)
	{
		strcat(string, ""lightblue">>> Lead Administrator (Level 3) <<<\n");
		strcat(string, ""grey"");
		strcat(string, "/setmoney /setscore /setcolor /slap /cname /unban /giveweapon (/un)freeze /getall /bankrupt\n");
		strcat(string, "/armourall /teleplayer /destroycar /sethealth /setfstyle /healall /armourall /force\n");
		strcat(string, "/write /get /oban\n\n");
	}
	if(User[playerid][accountAdmin] >= 4)
	{
		strcat(string, ""lightblue">>> Head Administrator (Level 4) <<<\n");
		strcat(string, ""grey"");
		strcat(string, "/saveallstats /cleardwindow /respawncars /setallweather /setalltime /giveallweapon\n");
		strcat(string, "/giveallcash /giveallscore /setallworld /setallinterior /kickall /disarmall /ejectall\n");
		strcat(string, "/mutecmd /unmutecmd /setallskin /fakedeath /cmdmuted /killall /slapall /explodeall\n");
		strcat(string, "/gmx\n\n");
	}
	if(User[playerid][accountAdmin] >= 5 || IsPlayerAdmin(playerid))
	{
		strcat(string, ""lightblue">>> Owner (Level 5) <<<\n");
		strcat(string, ""grey"");
		strcat(string, "/setlevel /fakechat /fakecmd /removeacc /makemegodadmin");
	}
	
	SD(playerid, DIALOG_BEGIN, DM, ""orange"Administrative Commands", string, "Close", "");
	return 1;
}

//============================================================================//
//							Administrative Level One                          //
//============================================================================//

CMD:ans(playerid,params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);
	
	new string[128],playername[24],playerb;
    if(sscanf(params,"us[128]",playerb,params)) return SendClientMessage(playerid, COLOR_RED,"<!> Syntax Error: /ans [id] [response]");
    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid,0xFF0000FF,""red"[ERROR]: Player is not connected.");
    GetPlayerName(playerid,playername,24);
    format(string,sizeof(string),"Answer: %s",params);
    SendClientMessage(playerb,0x00FF00FF,string);
    GetPlayerName(playerb,playername,24);
    format(string,sizeof(string),"You have replied to %s successfully",playername);
    SendClientMessage(playerid,COLOR_YELLOW,string);

    return 1;
}

CMD:weaps(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

    new
		id,
		Count,
		x,
		string[128],
		string2[64],
		WeapName[24],
		slot,
		weap,
		ammo
	;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: /weaps [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	format(string2, sizeof(string2), "_______ [ %s(ID:%d) Weapons ] _______", pName(id), id);
	SendClientMessage(playerid, COLOR_WHITE, string2);
	for(slot = 0; slot < 14; slot++)
	{
		GetPlayerWeaponData(id, slot, weap, ammo);
		if(ammo != 0 && weap != 0)
		Count++;
	}
	if(Count < 1) return SendClientMessage(playerid, COLOR_RED, "Players has no equipped weapons!");
	if(Count >= 1)
	{
		for (slot = 0; slot < 14; slot++)
		{
			GetPlayerWeaponData(id, slot, weap, ammo);
			if(ammo != 0 && weap != 0)
			{
				GetWeaponName(weap, WeapName, sizeof(WeapName));
				if(ammo == 65535 || ammo == 1)
				format(string, sizeof(string), "%s%s (1)",string, WeapName);
				else format(string, sizeof(string), "%s%s (%d)", string, WeapName, ammo);
				x++;
				if(x >= 5)
				{
 					SendClientMessage(playerid, COLOR_YELLOW, string);
 					x = 0;
					format(string, sizeof(string), "");
				}
				else format(string, sizeof(string), "%s,  ", string);
			}
		}
		if(x <= 4 && x > 0)
		{
			string[strlen(string)-3] = '.';
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
	}
	return 1;
}

CMD:aduty(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
	    string[128]
	;

	switch(User[playerid][pDuty])
	{
	    case 0:
	    {
	        User[playerid][pDuty] = 1;
	        format(string, 128, "Admin %s(ID:%d) goes on \" Admin Mode \"", pName(playerid), playerid);
	        SendClientMessageToAll(COLOR_GREEN, string);
	    }
	    case 1:
	    {
			User[playerid][pDuty] = 0;
			format(string, 128, "Admin %s(ID:%d) goes back on \" Playing Mode \"", pName(playerid), playerid);
			SendClientMessageToAll(COLOR_YELLOW, string);
	    }
	}
	return 1;
}

CMD:reports(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);
	
	new string[1400], string2[136];
	strcat(string, ""red"*** Report Send by the Players ***\n\n");
	strcat(string, ""grey"");
	for(new i=0; i<4; i++)
	{
	    format(string2, sizeof string2, "(%d) %s\n", i, reportmsg[i]);
	    strcat(string, string2);
	}
	
	SD(playerid, DIALOG_BEGIN, DM, ""red"Reports", string, "Close", "");
	return 1;
}

CMD:repair(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	if(IsPlayerInAnyVehicle(playerid))
	{
	    new VehicleID = GetPlayerVehicleID(playerid);
		RepairVehicle(VehicleID);
		GameTextForPlayer(playerid, "~w~~n~~n~~n~~n~~n~~n~Vehicle ~g~Repaired!", 3000, 3);
  		SetVehicleHealth(VehicleID, 1000.0);
	}
	else
		SendClientMessage(playerid, COLOR_RED, "Syntax Error: You must be inside of the vehicle to use this command.");
	return 1;
}

CMD:addnos(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	if(IsPlayerInAnyVehicle(playerid))
	{
        switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
		{
			case 448,461,462,463,468,471,509,510,521,522,523,581,586,449: SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot add nos to this vehicle.");
		}
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
	}
	else
		SendClientMessage(playerid, COLOR_RED, "Syntax Error: You must be inside of the vehicle to use this command.");
	return 1;
}

CMD:warn(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
	    string[128],
	    id,
	    reason[128]
	;

    if(sscanf(params, "uS(No Reason)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /warn [playerid] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
    if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot warn yourself.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	User[id][accountWarn] += 1;

	format(string, sizeof(string), "Administrator %s(%d) warned %s(%d) for %s (Warnings: %d)", pName(playerid), playerid, pName(id), id, reason, User[id][accountWarn]);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:remwarn(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
		string[130],
		id
	;

    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /remwarn [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
    if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot remove warn yourself.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(User[id][accountWarn] == 0) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player has no warnings.");
	User[id][accountWarn] -= 1;
	
	format(string, sizeof(string), "Administrator %s(%d) has removed %s(%d) warnings (Warnings Left: %i)", pName(playerid), playerid, pName(id), id, User[id][accountWarn]);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:flip(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

    new id,
		string[128],
		Float:angle
	;

    if(!sscanf(params, "u", id))
    {
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
		if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
		if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not in a vehicle.");
		GetVehicleZAngle(GetPlayerVehicleID(id), angle);
		SetVehicleZAngle(GetPlayerVehicleID(id), angle);
		format(string, sizeof(string), "You have flipped Player %s's vehicle.", pName(id));
		SendClientMessage(playerid, COLOR_GREEN, string);
		format(string, sizeof(string), "Administrator %s has flipped your vehicle.", pName(playerid));
		SendClientMessage(id, COLOR_GREEN, string);
    }
    else
    {
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You must be in a vehicle to use /flip.");
        GetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
        SetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
		SendClientMessage(playerid, COLOR_YELLOW, "Vehicle Flipped!");
		SendClientMessage(playerid, -1, "Want to flip player's vehicle? Just do "orange"/flip [playerid]");
    }
	return 1;
}

CMD:gotoco(playerid, params[])
{
    LoginCheck(playerid);
    LevelCheck(playerid, 1);

	new
		Float: Pos[3],
		string[128]
	;
    if(sscanf(params, "fff", Pos[0], Pos[1], Pos[2])) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /gotoco [x] [y] [z]");
    if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
    else SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

	format(string, sizeof string, "You have teleported to Coordinates %.1f %.1f %.1f", Pos[0], Pos[1], Pos[2]);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:ip(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
	    id,
	    string[120]
	;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /ip [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	format(string, 120, "> %s's IP: %s <", pName(id), getIP(id));
	SendClientMessage(playerid, GetPlayerColor(id), string);
	return 1;
}

CMD:spawn(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
	    string[128],
	    id
	;

    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /spawn [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
    SetPlayerPos(id, 0.0, 0.0, 0.0);
    SpawnPlayer(id);
    format(string, sizeof(string), "You have respawned Player %s.", pName(id));
    SendClientMessage(playerid, -1, string);
    format(string, sizeof(string), "Administrator %s has respawned you.", pName(playerid));
    SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:goto(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
		id,
		string[130],
		Float:x,
		Float:y,
		Float:z
	;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /goto [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	GetPlayerPos(id, x, y, z);
	SetPlayerInterior(playerid, GetPlayerInterior(id));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
	if(GetPlayerState(playerid) == 2)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), x+3, y, z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(id));
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(id));
	}
	else SetPlayerPos(playerid, x+2, y, z);
	format(string, sizeof(string), "You have been teleported to Player %s.", pName(id));
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), "Administrator %s has teleported to your location.", pName(playerid));
	SendClientMessage(id, COLOR_GREEN, string);
	return 1;
}

CMD:setweather(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
		string[130],
		id,
		weather
	;

	if(sscanf(params, "ui", id, weather)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setweather [playerid] [0/45]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(weather < 0 || weather > 45) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Weather ID. (0/45)");
	SetPlayerWeather(id, weather);
	format(string, sizeof(string), "You have set %s's weather to weatherID %d", pName(id), weather);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Administrator %s has your weather to weatherID %d", pName(playerid), weather);
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:settime(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
		string[130],
		id,
		time
	;

	if(sscanf(params, "ui", id, time)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /settime [playerid] [0/23]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(time < 0 || time > 23) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Time. (0/23)");
	SetPlayerTime(id, time, 0);
	format(string, sizeof(string), "You have set %s's screen time to %d:00", pName(id), time);
	SendClientMessage(id, COLOR_YELLOW, string);
	format(string, sizeof(string), "Administrator %s has set your screen time to %d:00", pName(playerid), time);
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:announce(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);
	if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /announce [message to all]");
	GameTextForAll(params, 4000, 3);
	return 1;
}

CMD:kick(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

    new
		string[128],
		id,
		reason[128]
	;
	if(sscanf(params, "uS(N/A)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /kick [playerid] [reason(Default: N/A)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
    format(string, sizeof(string), "** %s has been kicked by Adminstrator %s [Reason: %s]", pName(id), pName(playerid), reason);
	SendClientMessageToAll(COLOR_GREY, string);
	
	#if LOG == true
		SaveLog("kicklog.txt", string);
	#endif
	
	KickDelay(id);
	return 1;
}

CMD:asay(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	new
		string[128]
	;

    if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /asay [message as asay]");

	format(string, sizeof(string), "** Admin %s: %s", pName(playerid), params);
    SendClientMessageToAll(COLOR_GREEN, string);
	return 1;
}

CMD:a(playerid, params[])
{
	new
	    string[140]
	;

	LoginCheck(playerid);
	LevelCheck(playerid, 1);

	if(isnull(params)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: /a [admin chat]");

	format(string, sizeof( string ), "<!> Admin Chat %s: %s", pName(playerid), params);
	
	#if LOG == true
		SaveLog("adminchat.txt", string);
	#endif
	
	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
	        if(User[i][accountAdmin] >= 1)
	        {
	            SendClientMessage(i, COLOR_YELLOW, string);
	        }
	    }
	}
	return 1;
}

//============================================================================//
//						  	Administrative Level Two                          //
//============================================================================//

CMD:jetpack(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		id,
		string[130]
	;

    if(!sscanf(params, "u", id))
    {
		if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
		if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
        SetPlayerSpecialAction(id, SPECIAL_ACTION_USEJETPACK);
		format(string, sizeof(string), "You have given Player %s(ID:%d) a jetpack.", pName(id), id);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "Administrator %s(ID:%d) has given you a jetpack.", pName(playerid), playerid);
		SendClientMessage(id, COLOR_YELLOW, string);
    }
    else
    {
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
		SendClientMessage(playerid, COLOR_YELLOW, "Jetpack Spawned!");
		SendClientMessage(playerid, -1, "Want to give player a jetpack? Just do "orange"/jetpack [playerid]");
    }
	return 1;
}

CMD:aweapons(playerid, params[])
{
    LoginCheck(playerid);
    LevelCheck(playerid, 2);

    GivePlayerWeapon(playerid, 24, 99999);
    GivePlayerWeapon(playerid, 26, 99999);
    GivePlayerWeapon(playerid, 29, 99999);
    GivePlayerWeapon(playerid, 31, 99999);
    GivePlayerWeapon(playerid, 33, 99999);
    GivePlayerWeapon(playerid, 38, 99999);
    GivePlayerWeapon(playerid, 9, 1);
    
    SendClientMessage(playerid, COLOR_YELLOW, "Admin weapons received!");
    return 1;
}

CMD:show(playerid, params[])
{
    LoginCheck(playerid);
    LevelCheck(playerid, 2);

    new Player,	Show[129];
    if(sscanf(params, "us[129]", Player, Show)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /show [playerid] [text]");
    if(Player == INVALID_PLAYER_ID)	return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[Player][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

    GameTextForPlayer(Player, Show, 6000, 3);

	new string[120];
	format(string, sizeof(string), "Screen text sent to %s(ID:%d).", pName(Player), Player);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Administrator %s(ID:%d) has screen text you.", pName(playerid), playerid);
	SendClientMessage(Player, COLOR_YELLOW, string);
	return 1;
}

CMD:muted(playerid, params[])
{
	new string[128], count = 0;

	SendClientMessage(playerid, -1, "** "orange"Muted Players "white"**");
	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
	        if(User[i][accountMuted] == 1)
	        {
	            format(string, sizeof(string), "(%d) %s - Seconds left %d", i, pName(i), User[i][accountMuteSec]);
	            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	            count++;
	        }
	    }
	}
	if(count == 0) return SendClientMessage(playerid, -1, "No muted players at the server.");
	return 1;
}

CMD:jailed(playerid, params[])
{
	new string[128], count = 0;

	SendClientMessage(playerid, -1, "** "orange"Jailed Players "white"**");
	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
	        if(User[i][accountJail] == 1)
	        {
	            format(string, sizeof(string), "(%d) %s - Seconds left %d", i, pName(i), User[i][accountJailSec]);
	            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	            count++;
	        }
	    }
	}
	if(count == 0) return SendClientMessage(playerid, -1, "No jailed players at the server.");
	return 1;
}

CMD:setvhealth(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		string[130],
	    id,
		hp
	;

	if(sscanf(params, "ud", id, hp)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setvhealth [playerid] [health]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	new Float:hp2 = float(hp);
	
	if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player must be inside of a vehicle!");
	SetVehicleHealth(GetPlayerVehicleID(id), hp2);
	
	format(string, sizeof(string), "You have set Player's %s(ID:%d) vehicle health to %d", pName(id), id, floatround(hp2));
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Admin %s(ID:%d) has set your vehicle health to %d", pName(playerid), playerid, floatround(hp2));
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:eject(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		string[130],
		id
	;

    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /eject [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player must be inside of the vehicle.");
	RemovePlayerFromVehicle(id);
	format(string, sizeof(string), "You have ejected %s(ID:%d) from his/HER vehicle", pName(id), id);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Admin %s(ID:%d) has ejected you from your vehicle.", pName(playerid), playerid);
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:carpjob(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[130],
		id,
		pjob
	;
	if(sscanf(params, "ui", id, pjob)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: /carpjob [playerid] [paintjob(0-3)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player must be inside of a vehicle.");
	if(pjob < 0 || pjob > 3) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Paintjob ID.");

	format(string, sizeof(string), "You have changed the paintjob of %s(ID:%d)'s %s to '%d'", pName(id), id, VehicleNames[GetVehicleModel(GetPlayerVehicleID(id))-400], pjob);
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), "Admin %s(ID:%d) has changed the paintjob of your %s to '%d'", pName(playerid), playerid, VehicleNames[GetVehicleModel(GetPlayerVehicleID(id))-400], pjob);
	SendClientMessage(id, COLOR_YELLOW, string);
	ChangeVehiclePaintjob(GetPlayerVehicleID(id), pjob);
	return 1;
}

CMD:carcolor(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		string[130],
		id,
		col1,
		col2
	;
	if(sscanf(params, "uiI(255)", id, col1, col2)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: /carcolor [playerid] [colour1] [colour2(optional)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player must be inside of a vehicle.");

	if(col2==255) col2=random(256);

	format(string, sizeof(string), "You have changed the color of %s(ID:%d)'s %s to '%d,%d'", pName(id), id, VehicleNames[GetVehicleModel(GetPlayerVehicleID(id))-400], col1, col2);
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), "Admin %s(ID:%d) has changed the color of your %s to '%d,%d'", pName(playerid), playerid, VehicleNames[GetVehicleModel(GetPlayerVehicleID(id))-400], col1, col2);
	SendClientMessage(id, COLOR_YELLOW, string);
	ChangeVehicleColor(GetPlayerVehicleID(id), col1, col2);
	return 1;
}

CMD:givecar(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

    new string[130],
		vID[32],
		id,
		vVW,
		vINT,
		vid,
		Float:x,
		Float:y,
		Float:z,
		Float:ang,
		vehicle,
		col1,
		col2
	;
	if(sscanf(params, "us[32]I(255)I(255)", id, vID, col1, col2)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /givecar [playerid] [vehicleid(or name)] [color1(optional)] [color2(optional)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
    if(isnumeric(vID)) vid = strval(vID);
    else vid = GetVehicleModelIDFromName(vID);
	GetPlayerPos(id, x, y, z);
    GetPlayerFacingAngle(id, ang);
	if(vid < 400 || vid > 611) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Vehicle Model ID!");
	if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player already have a vehicle.");

	if(col1==255) col1=random(256);
	if(col2==255) col2=random(256);

	if(User[id][pCar] != -1 && !IsPlayerAdmin(id))
	EraseVeh(User[id][pCar]);

	vehicle = CreateVehicle(vid, x, y, z, 0, -1, -1, 0);
    vVW = GetPlayerVirtualWorld(id);
    vINT = GetPlayerInterior(id);
    SetVehicleVirtualWorld(vehicle, vVW);
    LinkVehicleToInterior(vehicle, vINT);
    PutPlayerInVehicle(id, vehicle, 0);
	User[id][pCar] = vehicle;
	format(string, sizeof(string), "Admin %s(%d) has given you a \"%s\"(%i)", pName(playerid), playerid, VehicleNames[vid - 400], vid);
	SendClientMessage(id, COLOR_YELLOW, string);
	format(string, sizeof(string), "You have given %s(%d) a \"%s\"(%i)", pName(id), id, VehicleNames[vid - 400], vid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:car(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 0);
	
	new carID[50], car, colour1, colour2, string[128];
	if(sscanf(params, "s[50]I(255)I(255)", carID, colour1, colour2)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /car [VehicleID(Name)] [Color1(Optional)] [Color2(Optional)]");
	if(!isnumeric(carID)) car = GetVehicleModelIDFromName(carID);
	else car = strval(carID);
	if(car < 400 || car > 611) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Vehicle Model ID or Name!");

	if(colour1==255) colour1=random(256);
	if(colour2==255) colour2=random(256);

	if(User[playerid][pCar] != -1 && !IsPlayerAdmin(playerid))
	EraseVeh(User[playerid][pCar]);
	new VehicleID;
	new Float:X, Float:Y, Float:Z;
	new Float:Angle, int1;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, Angle);
	int1 = GetPlayerInterior(playerid);
	VehicleID = CreateVehicle(car, X+3,Y,Z, Angle, colour1, colour2, -1);
	LinkVehicleToInterior(VehicleID, int1);
	SetVehicleVirtualWorld(VehicleID, GetPlayerVirtualWorld(playerid));
	User[playerid][pCar] = VehicleID;
	format(string, sizeof(string), "You have spawned a \"%s\" (Model: %d) with color %d,%d", VehicleNames[car-400], car, colour1, colour2);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:v(playerid, params[])
{
  return cmd_car(playerid, params);
}

CMD:vehicle(playerid, params[])
{
  return cmd_car(playerid, params);
}

CMD:spec(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new string[150], specplayerid;

	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: /spec [playerid]");
	if(specplayerid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[specplayerid][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(specplayerid == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot spectate yourself.");
	if(GetPlayerState(specplayerid) == PLAYER_STATE_SPECTATING && User[specplayerid][SpecID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player is spectating someone.");
	if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not spawned.");
	GetPlayerPos(playerid, SpecPos[playerid][0], SpecPos[playerid][1], SpecPos[playerid][2]);
	GetPlayerFacingAngle(playerid, SpecPos[playerid][3]);
	SpecInt[playerid][0] = GetPlayerInterior(playerid);
	SpecInt[playerid][1] = GetPlayerVirtualWorld(playerid);
	StartSpectate(playerid, specplayerid);
	format(string, sizeof(string), "Now Spectating: %s (ID: %d)", pName(specplayerid), specplayerid);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	SendClientMessage(playerid, -1, "Press SHIFT for Advance Spectating and SPACE for backward spectating.");
	return 1;
}

CMD:specoff(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);
	
    if(User[playerid][SpecType] != ADMIN_SPEC_TYPE_NONE)
	{
		StopSpectate(playerid);
		SetTimerEx("PosAfterSpec", 3000, 0, "d", playerid);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "No longer spectating.");
	}
	else return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You are not spectating anyone.");
	return 1;
}

CMD:akill(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		string[150],
		reason[128],
		id
	;

    if(sscanf(params, "uS(No Reason)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /akill [playerid] [reason(Default: None)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	if(_God[id] == 1)
	{
	    _God[id] = 0;
	}

    SetPlayerHealth(id, 0.0);
    format(string, sizeof(string), "** %s(%d) has been killed by Administrator %s(%d) (Reason: %s)", pName(id), id, pName(playerid), playerid, reason);
    SendClientMessageToAll(COLOR_GREY, string);
	return 1;
}

CMD:jail(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);
	
	new id, sec, reason[128], string[250];
	if(sscanf(params, "uiS(None)[128]", id, sec, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /jail [playerid] [seconds] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(sec < 30) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot jail lower than 30 seconds.");
	if(User[id][accountJail] == 1) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player already jailed.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on yourself.");

	SetCameraBehindPlayer(id);
	SetPlayerPos(id, 197.6661, 173.8179, 1003.0234);
	SetPlayerInterior(id, 3);

	format(string, sizeof(string), "** %s(%d) has been jailed by Administrator %s(%d) for %d seconds [%s]", pName(id), id, pName(playerid), playerid, sec, reason);
	SendClientMessageToAll(COLOR_GREY, string);
	SendClientMessage(id, COLOR_ORANGE, "You have been jailed by an Admin, Press a screenshot (F8) and make a complaint on the forums, if you want to.");

	#if LOG == true
		format(string, sizeof(string), "%s has been jailed by %s (%d seconds, reason %s)", pName(id), pName(playerid), sec, reason);
		SaveLog("jail.txt", string);
	#endif

	User[id][accountJail] = 1, User[id][accountJailSec] = sec;
	return 1;
}

CMD:unjail(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new id, reason[128], string[250];
	if(sscanf(params, "uS(None)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /unjail [playerid] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(User[id][accountJail] == 0) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not in jailed.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on yourself.");

	format(string, sizeof(string), "** %s(%d) has been unjailed by Administrator %s(%d) for %s", pName(id), id, pName(playerid), playerid, reason);
	SendClientMessageToAll(COLOR_GREY, string);
	SendClientMessage(id, COLOR_ORANGE, "You have been released from jail by an Admin.");

	#if LOG == true
		format(string, sizeof(string), "%s has been unjailed by %s for %s", pName(id), pName(playerid), reason);
		SaveLog("jail.txt", string);
	#endif

	User[id][accountJail] = 0, User[id][accountJailSec] = 0;
	SpawnPlayer(id);
	return 1;
}

CMD:mute(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);
	
	new id, sec, reason[128], string[128+50];
	if(sscanf(params, "uiS(None)[128]", id, sec, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /mute [playerid] [seconds] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(sec < 30) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot mute lower than 30 seconds.");
	if(User[id][accountMuted] == 1) return SendClientMessage(playerid,COLOR_RED, "Syntax Error: Player already muted.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on yourself.");

	format(string, sizeof(string), "** %s(%d) has been muted by Administrator %s(%d) for %d seconds [%s]", pName(id), id, pName(playerid), playerid, sec, reason);
	SendClientMessageToAll(COLOR_GREY, string);
	SendClientMessage(id, COLOR_ORANGE, "You have been muted by an Admin, Press a screenshot (F8) and make a complaint on the forums, if you want to.");

	#if LOG == true
		format(string, sizeof(string), "%s has been muted by %s (%d seconds, reason %s)", pName(id), pName(playerid), sec, reason);
		SaveLog("mute.txt", string);
	#endif

	User[id][accountMuted] = 1, User[id][accountMuteSec] = sec;
	return 1;
}

CMD:unmute(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);
	
	new id, reason[128], string[250];
	if(sscanf(params, "uS(None)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /unmute [playerid] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(User[id][accountMuted] == 0) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not muted.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on yourself.");

	format(string, sizeof(string), "* %s(%d) has been unmuted by Administrator %s(%d) for %s", pName(id), id, pName(playerid), playerid, reason);
	SendClientMessageToAll(COLOR_GREY, string);
	SendClientMessage(id, COLOR_ORANGE, "You have been unmuted by an Admin.");

	#if LOG == true
		format(string, sizeof(string), "%s has been unmuted by %s", pName(id), pName(playerid));
		SaveLog("mute.txt", string);
	#endif

	User[id][accountMuted] = 0, User[id][accountMuteSec] = 0;
	return 1;
}

CMD:setskin(playerid, params[])
{
	new
	    string[128+40],
	    id,
	    skin
	;

	LoginCheck(playerid);
	LevelCheck(playerid, 2);
	
	if(sscanf(params, "ui", id, skin)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setskin [playerid] [skin(0-299)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(skin < 0 || skin == 74 || skin > 299) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid skinID.");

	format(string, 128, "You have set Player "orange"%s "white"skinID to "grey"%d", pName(id), skin);
	SendClientMessage(playerid, -1, string);

    format(string, 128, "Administrator "orange"%s "white"has set your skinID to "grey"%d", pName(playerid), skin);
	SendClientMessage(id, -1, string);

    SetPlayerSkin(id, skin);
	return 1;
}

CMD:clearchat(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
	    string[128]
	;

	for(new i=0; i<100; i++)
	{
		SendClientMessageToAll(-1, " ");
	}
	
    format(string, sizeof string, "Administrator "orange"%s "white"has cleared the chat.", pName(playerid));
    SendClientMessageToAll(-1, string);
	return 1;
}

CMD:heal(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		id,
		string[130]
	;

    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /heal [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");

    SetPlayerHealth(id, 100.0);
    format(string, sizeof(string), "You have given Player %s a full pack of health.", pName(id));
    SendClientMessage(playerid, COLOR_YELLOW, string);
    format(string, sizeof(string), "Administrator %s has given you a full pack of health.", pName(playerid));
    SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:armour(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		id,
		string[130]
	;

    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /armour [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");

    SetPlayerArmour(id, 100.0);
    format(string, sizeof(string), "You have given %s an armour.", pName(id));
    SendClientMessage(playerid, COLOR_YELLOW, string);
    format(string, sizeof(string), "Administrator %s has given you a full armour.", pName(playerid));
    SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:setinterior(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		string[130],
		id,
		interior
	;

	if(sscanf(params, "ui", id, interior)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setinterior [playerid] [interior]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	SetPlayerInterior(id, interior);
	format(string, sizeof(string), "Administrator %s has set your interior to %d.", pName(playerid), interior);
	SendClientMessage(id, COLOR_ORANGE, string);
	format(string, sizeof(string), "You have set Player %s's interior to %d.", pName(id), interior);
	SendClientMessage(playerid, COLOR_ORANGE, string);
	return 1;
}

CMD:setworld(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		string[130],
		id,
		vw
	;

	if(sscanf(params, "ui", id, vw)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax error: /setworld [playerid] [virtual world]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	SetPlayerVirtualWorld(id, vw);
	format(string, sizeof(string), "Administrator %s has set your virtual world to %d.", pName(playerid), vw);
	SendClientMessage(id, COLOR_ORANGE, string);
	format(string, sizeof(string), "You have set Player %s's virtual world to %d.", pName(id), vw);
	SendClientMessage(playerid, COLOR_ORANGE, string);
	return 1;
}

CMD:explode(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new string[128],
		id,
		Float:x,
		Float:y,
		Float:z,
		reason[128]
	;

	if(sscanf(params, "uS(N/A)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /explode [playerid] [reason(Default: N/A)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	GetPlayerPos(id, x, y, z);
	format(string, sizeof(string), "** %s(%d) has been exploded by Administrator %s [Reason: %s]", pName(id), id, pName(playerid), reason);
	SendClientMessageToAll(COLOR_GREY, string);
	
	#if LOG == true
		SaveLog("explode.txt", string);
	#endif

	CreateExplosion(x, y, z, 7, 1.00);
	return 1;
}

CMD:disarm(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

	new
		string[130],
		id
	;

	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /disarm [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
    ResetPlayerWeapons(id);
    format(string, sizeof(string), "You have removed Player %s's guns.", pName(id));
    SendClientMessage(playerid, COLOR_YELLOW, string);
    format(string, sizeof(string), "Administrator %s has removed your guns.", pName(playerid));
    SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

//============================================================================//
//						  Administrative Level Three                          //
//============================================================================//

CMD:get(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

    new
		id,
		string[130],
		Float:x,
		Float:y,
		Float:z
	;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /get [playerid]");

	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot teleport yourself to yourself.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	GetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(id, GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));

	if(GetPlayerState(id) == 2)
	{
		new VehicleID = GetPlayerVehicleID(id);
		SetVehiclePos(VehicleID, x+3, y, z);
		LinkVehicleToInterior(VehicleID, GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(GetPlayerVehicleID(id), GetPlayerVirtualWorld(playerid));
	}
	else SetPlayerPos(id, x+2, y, z);

	format(string, sizeof(string), "You have been teleported to Admin %s(ID:%d) location.", pName(playerid), playerid);
	SendClientMessage(id, COLOR_YELLOW, string);
	format(string, sizeof(string), "You have teleported %s(ID:%d) to your location.", pName(id), id);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:write(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		Colour,
		string[130]
	;
	if(sscanf(params, "is[128]", Colour, params))
		return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /write [color] [text]") &&
		SendClientMessage(playerid, COLOR_GREY, "Colors: [0]Black, [1]White, [2]Red, [3]Orange, [4]Yellow, [5]Green, [6]Blue, [7]Purple, [8]Brown, [9]Pink");
	if(Colour > 9) return SendClientMessage(playerid, COLOR_GREY, "Colors: [0]Black, [1]White, [2]Red, [3]Orange, [4]Yellow, [5]Green, [6]Blue, [7]Purple, [8]Brown, [9]Pink");

    if(Colour == 0) {	format(string,sizeof(string),"%s",params); SendClientMessageToAll(COLOR_BLACK,string);return 1;}
    else if(Colour == 1) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_WHITE,string); return 1;}
    else if(Colour == 2) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_RED,string); return 1;}
    else if(Colour == 3) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_ORANGE,string); return 1;}
    else if(Colour == 4) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_YELLOW,string); return 1;}
    else if(Colour == 5) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_GREEN,string); return 1;}
    else if(Colour == 6) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_BLUE,string); return 1;}
    else if(Colour == 7) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_PURPLE,string); return 1;}
    else if(Colour == 8) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_BROWN,string); return 1;}
    else if(Colour == 9) {
	format(string,sizeof(string),"%s",params);SendClientMessageToAll(COLOR_PINK,string); return 1;}
	return 1;
}

CMD:force(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[130],
		id
	;

    if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /force [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	format(string, sizeof(string), "You have force Player %s(ID:%d) to goto class selection.", pName(id), id);
	SendClientMessage(playerid, COLOR_YELLOW, string);

	format(string, sizeof(string), "Admin %s(ID:%d) force you to goto class selection.", pName(playerid), playerid);
	SendClientMessage(id, COLOR_YELLOW, string);

	SetPlayerHealth(id, 0.0);
	ForceClassSelection(id);
	return 1;
}

CMD:healall(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[130]
	;

	foreach(new i : Player)
	{
        if(i != playerid)
        {
			SetPlayerHealth(i, 100.0);
        }
    }
    format(string, sizeof(string), "Admin %s(ID:%d) has heal all players.", pName(playerid), playerid);
    SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:setfstyle(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[128],
		id,
		fstyle,
		style[50]
	;

    if(sscanf(params, "ui", id, fstyle)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setfstyle [playerid] [styles]") &&
	SendClientMessage(playerid, COLOR_GREY, "Styles: [0]Normal, [1]Boxing, [2]Kungfu, [3]Kneehead, [4]Grabkick, [5]Elbow");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(fstyle > 5) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Inavlid Fighting Style.");

	switch(fstyle)
	{
	    case 0:
	    {
	        SetPlayerFightingStyle(id, 4);
	        style = "Normal";
	    }
	    case 1:
	    {
	        SetPlayerFightingStyle(id, 5);
	        style = "Boxing";
	    }
	    case 2:
	    {
	        SetPlayerFightingStyle(id, 6);
	        style = "Kung Fu";
	    }
	    case 3:
	    {
	        SetPlayerFightingStyle(id, 7);
	        style = "Kneehead";
	    }
	    case 4:
	    {
	        SetPlayerFightingStyle(id, 15);
	        style = "Grabkick";
	    }
	    case 5:
	    {
	        SetPlayerFightingStyle(id, 16);
	        style = "Elbow";
	    }
	}
	format(string, sizeof(string), "You have set %s(ID:%d) fighting style to '%s'", pName(id), id, style);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Admin %s(ID:%d) has set your fighting style to '%s'", pName(playerid), playerid, style);
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:sethealth(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[130],
	    id,
	    hp
	;

    if(sscanf(params, "ud", id, hp)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /sethealth [playerid] [heatlh]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");	

	new Float:hp2 = float(hp);

	SetPlayerHealth(id, hp2);
	
	format(string, sizeof(string), "You have set Player %s(ID:%d) health to %d", pName(id), id, floatround(hp2));
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Admin %s(ID:%d) has set your health to %d", pName(playerid), playerid, floatround(hp2));
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:setarmour(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[130],
	    id,
		armour
	;

    if(sscanf(params, "ud", id, armour)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setarmour [playerid] [armour]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	new Float:ar = float(armour);
	SetPlayerArmour(id, ar);
	
	format(string, sizeof(string), "You have set Player %s(ID:%d) armour to %d", pName(id), id, floatround(ar));
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Admin %s(ID:%d) has set your armour to %d", pName(playerid), playerid, floatround(ar));
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:destroycar(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);
	DelVehicle(GetPlayerVehicleID(playerid));
	return 1;
}

CMD:teleplayer(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[128],
		id,
		id2,
		Float:x,
		Float:y,
		Float:z
	;
	if(sscanf(params, "uu", id, id2)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /teleplayer [playerid] to [playerid2]");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(User[playerid][accountAdmin] < User[id2][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(id2 == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(id == playerid && id2 == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot teleport yourself to yourself!");
	GetPlayerPos(id2, x, y, z);
	format(string, sizeof(string), "You have teleported Player %s(%d) to Player %s(%d)", pName(id), id, pName(id2), id2);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "You have been teleported to Player %s(%d) by Admin %s(%d)", pName(id2), id2, pName(playerid), playerid);
	SendClientMessage(id, COLOR_YELLOW, string);
	format(string, sizeof(string), "Admin %s(%d) has port %s(%d) to you", pName(playerid), playerid, pName(id), id);
	SendClientMessage(id2, COLOR_YELLOW, string);
	SetPlayerInterior(id, GetPlayerInterior(id2));
	SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(id2));
	if(GetPlayerState(id) == 2)
	{
		SetVehiclePos(GetPlayerVehicleID(id), x+3, y, z);
		LinkVehicleToInterior(GetPlayerVehicleID(id), GetPlayerInterior(id2));
		SetVehicleVirtualWorld(GetPlayerVehicleID(id), GetPlayerVirtualWorld(id2));
	}
	else SetPlayerPos(id, x+2, y, z);
	return 1;
}

CMD:armourall(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[130]
	;
	foreach(new i : Player)
	{
        if(i != playerid)
        {
		    SetPlayerArmour(i, 100.0);
        }
    }
    format(string, sizeof(string), "Admin %s(ID:%d) has given everyone an armour.", pName(playerid), playerid);
    SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:bankrupt(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

    new
		id,
		string[130]
	;

	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /bankrupt [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	ResetPlayerMoney(id);
	
	format(string, sizeof(string), "Admin %s(ID:%d) has taken all your cash in-hand.", pName(playerid), playerid);
	SendClientMessage(id, COLOR_YELLOW, string);
	format(string, sizeof(string), "You have taken all the money in hand of Player %s(%d).", pName(id), id);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:getall(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new Float:x,
		Float:y,
		Float:z,
		string[130],
		interior = GetPlayerInterior(playerid)
	;

	GetPlayerPos(playerid, x, y, z);
	foreach(new i : Player)
	{
        if(i != playerid)
        {
			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
			SetPlayerPos(i, x+(playerid/4)+1, y+(playerid/4), z);
			SetPlayerInterior(i, interior);
			SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
		}
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has teleported all players to his or HER position!", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:freeze(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[130],
		id,
		reason[128]
	;
	if(sscanf(params, "uS(No Reason)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /freeze [playerid] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot freeze yourself.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	TogglePlayerControllable(id, false);

	format(string, sizeof(string), "You have frozen Player %s(%d) (Reason: %s)", pName(id), id, reason);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Administrator %s(ID:%d) has frozen you (Reason: %s)", pName(playerid), playerid, reason);
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:unfreeze(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		string[128],
		id
	;

	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /unfreeze [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot unfreeze yourself.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	TogglePlayerControllable(id, true);

	format(string, sizeof(string), "You have unfrozen Player %s(%d)", pName(id), id);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Admin %s(%d) has unfrozen you.", pName(playerid), playerid);
	SendClientMessage(id, COLOR_YELLOW, string);
	return 1;
}

CMD:giveweapon(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		id,
		ammo,
		wID[32],
		weap,
		WeapName[32],
		string[130]
	;

	if(sscanf(params, "us[32]i", id, wID, ammo)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /giveweapon [playerid] [weaponid(or weapon name)] [ammo]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(ammo <= 0 || ammo > 99999) ammo = 500;
	if(!isnumeric(wID)) weap = GetWeaponIDFromName(wID);
	else weap = strval(wID);
	if(!IsValidWeapon(weap)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Weapon ID.");
	GetWeaponName(weap, WeapName, 32);
	
	format(string, sizeof(string), "You gave a %s(%d) with %d rounds of ammunation to %s.", WeapName, weap, ammo, pName(id));
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string,sizeof(string),"Administrator %s has given you a %s(%d) with %d rounds of ammunation.", pName(playerid), WeapName, weap, ammo);
	SendClientMessage(id, COLOR_YELLOW, string);
	GivePlayerWeapon(id, weap, ammo);
	return 1;
}

CMD:unban(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);
	
    new
		string[150],
		Account[24],
		DBResult:Result,
		Query[129],
		fIP[30]
	;
	if(sscanf(params, "s[24]", Account)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /unban [account name]");
    format(Query, 129, "SELECT * FROM `bans` WHERE `username` = '%s'", Account);
	Result = db_query(Database, Query);

	if(db_num_rows(Result))
	{
    	db_get_field_assoc(Result, "ip", fIP, 30);

        format(Query, 129, "DELETE FROM `bans` WHERE `username` = '%s'", Account);
	    Result = db_query(Database, Query);
        db_free_result(Result);

		format(string, sizeof string, "Administrator %s has unbanned %s.", pName(playerid), Account);
		SendClientMessageToAll(COLOR_YELLOW, string);
		print(string);
		
		#if LOG == true
			SaveLog("banlog.txt", string);
		#endif
	}
	else
	{
	    db_free_result(Result);
	    SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player is not in the banned database.");
	    return 1;
	}
	return 1;
}

CMD:ban(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 2);

    new
		string[128],
		id,
		reason[128],
		when[128],
		ban_hr, ban_min, ban_sec, ban_month, ban_days, ban_years
	;

	gettime(ban_hr, ban_min, ban_sec);
	getdate(ban_years, ban_month, ban_days);

    if(sscanf(params, "uS(No Reason)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /ban [playerid] [reason(Default: No Reason)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command to yourself.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	format(when, 128, "%02d/%02d/%d %02d:%02d:%02d", ban_month, ban_days, ban_years, ban_hr, ban_min, ban_sec);

    format(string, sizeof(string), "** %s(ID:%d) has been banned by Administrator %s(%d) (Reason: %s)", pName(id), id, pName(playerid), playerid, reason);
    SendClientMessageToAll(COLOR_GREY, string);
    printf(string);
    #if LOG == true
    	SaveLog("banlog.txt", string);
	#endif
	format(string, sizeof(string), "You have banned %s(%d) for %s.", pName(id), id, reason);
    SendClientMessage(playerid, COLOR_YELLOW, string);
    format(string, sizeof(string), "You have been banned by Administrator %s(%d) (Reason: %s)", pName(playerid), playerid, reason);
    SendClientMessage(id, COLOR_YELLOW, string);
    BanAccount(id, pName(playerid), reason);
    ShowBan(id, pName(playerid), reason, when);
    KickDelay(id);
	return 1;
}

CMD:oban(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

    new
		string[150],
		name[24],
		reason[128],
		Query[256],
		admin,
		ip[20],
		DBResult:Result,
		ban_hr, ban_min, ban_sec, ban_month, ban_days, ban_years
	;

	gettime(ban_hr, ban_min, ban_sec);
	getdate(ban_years, ban_month, ban_days);

    if(sscanf(params, "s[24]s[128]", name, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /oban [name in the data] [reason]");
	foreach(new i : Player)
	{
	    if(strcmp(pName(i), name, true) == 0)
	    {
	        SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player that you are trying to banned is online, /ban instead.");
	        return 1;
	    }
	}
    format(Query, sizeof(Query), "SELECT * FROM `users` WHERE `username` = '%s'", DB_Escape(name));
    Result = db_query(Database, Query);
    if(db_num_rows(Result))
    {
        db_get_field_assoc(Result, "admin", Query, 6);
        admin = strval(Query);
        db_get_field_assoc(Result, "IP", ip, 20);

		if(User[playerid][accountAdmin] < admin)
		{
			SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on high ranking admin.");

			#if LOG == true
				format(string, sizeof(string), "%s has attempted to offline banned %s but failed for %s", pName(playerid), name, reason);
				SaveLog("admin.txt", string);
			#endif
			return 1;
		}
		
		BanAccountEx(name, ip, pName(playerid), reason);

	    format(string, sizeof(string), "** %s has been offine banned by Administrator %s(%d) (Reason: %s)", name, pName(playerid), playerid, reason);
	    SendClientMessageToAll(COLOR_GREY, string);
	    printf(string);
	    #if LOG == true
	    	SaveLog("banlog.txt", string);
		#endif
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "Syntax Error: There is no such thing players in the server database.");
	}
    db_free_result(Result);
	return 1;
}

CMD:cname(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
	    string[128],
	    id,
	    newname[24]
	;

	if(sscanf(params, "us[24]", id, newname)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /cname [playerid] [new name]");
	if(strlen(newname) < 3 || strlen(newname) > MAX_PLAYER_NAME) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Name Length.");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	/*
	DO NOT PLACE THESE CODES BELOW SETPLAYERNAME OR IT WILL BUGGED OUT.
	*/
	//Saves the datas you current have on that account.
	SaveData(id);
	//Logs you out.
	User[id][accountLogged] = false;

	#if LOG == true
		format(string, sizeof string, "Administrator %s has set %s's name to %s", pName(playerid), pName(id), newname);
		SaveLog("account.txt", string);
	#endif

	format(string, sizeof(string), "You have set \"%s's\" name to \"%s\".", pName(id), newname); SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Administrator \"%s\" has set your name to \"%s\".", pName(playerid), newname); SendClientMessage(id, COLOR_YELLOW, string);
	SetPlayerName(id, newname);

	SendClientMessage(id, -1, "You have been logged out from your current account, Reconnecting to the server...");
	
	//Reads all the codes from the callback OnPlayerConnect.
	SetPlayerScore(id, 0);
	ResetPlayerMoney(id);
	OnPlayerConnect(id);
	return 1;
}

CMD:slap(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

    new
		Float:x,
		Float:y,
		Float:z,
		Float:health,
		string[128],
		id,
		reason[128]
	;

    if(sscanf(params, "uS(N/A)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /slap [playerid] [reason(Default: N/A)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	GetPlayerPos(id, x, y, z);
    GetPlayerHealth(id, health);
    SetPlayerHealth(id, health-25);
	SetPlayerPos(id, x, y, z+5);
    PlayerPlaySound(playerid, 1190, 0.0, 0.0, 0.0);
    PlayerPlaySound(id, 1190, 0.0, 0.0, 0.0);
	format(string, sizeof(string), "** %s(%d) has been slapped by Administrator %s [Reason: %s]", pName(id), id, pName(playerid), reason);
	SendClientMessageToAll(COLOR_GREY, string);
	return 1;
}

CMD:setcolor(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 3);
	
	new id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setcolor [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	SetPVarInt(playerid, "_Colors_", id);

	SD(playerid, DIALOG_COLORS, DL, ""orange"Colors", ""black"Black\n"white"White\n"red"Red\n"orange"Orange\n"yellow"Yellow\n"green"Green\n"blue"Blue\n"purple"Purple\n"brown"Brown\n"pink"Pink", "Set", "Cancel");
	return 1;
}

CMD:setmoney(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		id,
		string[128],
		amount
	;

    if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setmoney [playerid] [cash]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	ResetPlayerMoney(id);
	GivePlayerMoney(id, amount);
	format(string, sizeof(string), "You have set %s's cash to $%i.", pName(id), amount);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Administrator %s has set your cash to $%i.", pName(playerid), amount);
	SendClientMessage(id, COLOR_YELLOW, string);
	
	#if LOG == true
		format(string, sizeof string, "Administrator %s has set %s's cash to $%i", pName(playerid), pName(id), amount);
		SaveLog("set.txt", string);
	#endif
	return 1;
}

CMD:setscore(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 3);

	new
		id,
		string[128],
		amount
	;

    if(sscanf(params, "ui", id, amount)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setscore [playerid] [score]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");

	SetPlayerScore(id, amount);
	format(string, sizeof(string), "You have set %s's score to %i.", pName(id), amount);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "Administrator %s has set your score to %i.", pName(playerid), amount);
	SendClientMessage(id, COLOR_YELLOW, string);

	#if LOG == true
		format(string, sizeof string, "Administrator %s has set %s's score to %i", pName(playerid), pName(id), amount);
		SaveLog("set.txt", string);
	#endif
	return 1;
}

//============================================================================//
//						   Administrative Level Four                          //
//============================================================================//

CMD:gmx(playerid, params[])
{
	new
		string[128],
		time
	;

	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	if(sscanf(params, "I(0)", time)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /gmx [Restart Timer(optional)") &&
	SendClientMessage(playerid, -1, "Note: You can leave the parameter for a fast restart, no timers.");

	if(time < 10 && time !=0) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Restart Time shouldn't go below ten.");

	if(time >= 10)
	{
	    format(string, sizeof(string), "Admin %s(ID:%d) has announced a server restart which will end in %d seconds.", pName(playerid), playerid, time);
	    SendClientMessageToAll(COLOR_YELLOW, string);
	    
	    SetTimer("RestartTimer", 1000*time, false);
	}
	else
	{
	    format(string, sizeof(string), "Admin %s(ID:%d) has restarted the server.", pName(playerid), playerid);
	    SendClientMessageToAll(COLOR_YELLOW, string);
	    
	    SendRconCommand("gmx");
	}
	return 1;
}

function:RestartTimer()
{
	SendClientMessageToAll(COLOR_YELLOW, "Restart Time has been reached, Restarting the server now.");
	return SendRconCommand("gmx");
}

CMD:fakedeath(playerid, params[])
{
	new
		string[128],
		id,
		killerid,
		weapid
	;

	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	if(sscanf(params, "uui", killerid, id, weapid)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /fakedeath [killer] [victim] [weapon]");
	if(killerid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: KillerID not connected.");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: VictimID not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(User[playerid][accountAdmin] < User[killerid][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(id == playerid && killerid == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You can't be KillerID and VictimID at the same time.");
	if(!IsValidWeapon(weapid)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Weapon ID.");

	SendDeathMessage(killerid, id, weapid);
	
	format(string, sizeof(string), "Fake Death Sent. [ Victim: %s(%d) | Suspect: %s(%d) | WeaponID: %i ]", pName(id), id, pName(killerid), killerid, weapid);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:setallskin(playerid, params[])
{
	new string[128+40], skin;

	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	if(sscanf(params, "i", skin)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setallskin [skin(0-299)]");
	if(skin < 0 || skin == 74 || skin > 299) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid skinID.");

	foreach(new i : Player)
	{
        SetPlayerSkin(i, skin);
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has set everyones skin to %d.", pName(playerid), playerid, skin);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:cmdmuted(playerid, params[])
{
	new string[128], count = 0;

	SendClientMessage(playerid, -1, "** "orange"Command Muted Players "white"**");
	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
	        if(User[i][accountCMuted] == 1)
	        {
	            format(string, sizeof(string), "(%d) %s - Seconds left %d", i, pName(i), User[i][accountCMuteSec]);
	            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	            count++;
	        }
	    }
	}
	if(count == 0) return SendClientMessage(playerid, -1, "No command muted players at the server.");
	return 1;
}

CMD:mutecmd(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);
	
	new id, sec, reason[128], string[250];
	if(sscanf(params, "uiS(None)[128]", id, sec, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /mutecmd [playerid] [seconds] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(sec < 30) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot mute lower than 30 seconds.");
	if(User[id][accountCMuted] == 1) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player already muted from using the commands.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on yourself.");
	
	format(string, sizeof(string), "** %s(%d) has been muted from using commands by Administrator %s(%d) for %d seconds [%s]", pName(id), id, pName(playerid), playerid, sec, reason);
	SendClientMessageToAll(COLOR_GREY, string);
	SendClientMessage(id, COLOR_ORANGE, "You have been muted from using commands by an Admin, Press a screenshot (F8) and make a complaint on the forums, if you want to.");

	#if LOG == true
		format(string, sizeof(string), "%s has been muted from using commands by %s (%d seconds, reason %s)", pName(id), pName(playerid), sec, reason);
		SaveLog("mute.txt", string);
	#endif

	User[id][accountCMuted] = 1, User[id][accountCMuteSec] = sec;
	return 1;
}

CMD:unmutecmd(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);
	
	new id, reason[128], string[250];
	if(sscanf(params, "uS(None)[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /unmutecmd [playerid] [reason]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	if(User[id][accountCMuted] == 0) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not muted from using the commands.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on yourself.");

	format(string, sizeof(string), "* %s(%d) has been unmuted from using commands by Administrator %s(%d) for %s", pName(id), id, pName(playerid), playerid, reason);
	SendClientMessageToAll(COLOR_GREY, string);
	SendClientMessage(id, COLOR_ORANGE, "You have been unmuted from using commands by an Admin.");

	#if LOG == true
		format(string, sizeof(string), "%s has been unmuted from using commands by %s", pName(id), pName(playerid));
		SaveLog("mute.txt", string);
	#endif

	User[id][accountCMuted] = 0, User[id][accountCMuteSec] = 0;
	return 1;
}

CMD:setallinterior(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    id,
	    string[130]
	;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setallinterior [interior]");
	foreach(new i : Player)
	{
		PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
		SetPlayerInterior(i, id);
	}
	format(string, sizeof(string), "Admin %s(ID:%d) has set all players interior to \"%d\"", pName(playerid), playerid, id);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:explodeall(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    string[130],
		Float:x,
		Float:y,
		Float:z
	;

	foreach(new i : Player)
	{
        if(i != playerid)
        {
			GetPlayerPos(i, x, y, z);
			CreateExplosion(x, y, z, 7, 1.00);
		}
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has exploded all players.", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	printf(string);
	return 1;
}

CMD:killall(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    string[130]
	;

	foreach(new i : Player)
	{
        if(i != playerid)
        {
            if(_God[i] == 1)
            {
                _God[i] = 0;
            }
			SetPlayerHealth(i, 0.0);
		}
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has killed all players.", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	printf(string);
	return 1;
}

CMD:slapall(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    string[130],
		Float:x,
		Float:y,
		Float:z,
		Float:health
	;

	foreach(new i : Player)
	{
        if(i != playerid)
        {
			GetPlayerPos(i, x, y, z);
		    GetPlayerHealth(i, health);
		    SetPlayerHealth(i, health-25);
			SetPlayerPos(i, x, y, z+5);
		    PlayerPlaySound(playerid, 1190, 0.0, 0.0, 0.0);
		    PlayerPlaySound(i, 1190, 0.0, 0.0, 0.0);
		}
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has slapped all players.", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	printf(string);
	return 1;
}

CMD:kickall(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    string[130]
	;

	foreach(new i : Player)
	{
        if(i != playerid)
        {
		    KickDelay(i);
		}
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has kicked all players.", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	printf(string);
	#if LOG == true
		SaveLog("kicklog.txt", string);
	#endif
	return 1;
}

CMD:ejectall(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

    new
		string[128]
	;

	foreach(new i : Player)
	{
	    if(IsPlayerInAnyVehicle(i))
	    {
			RemovePlayerFromVehicle(i);
		}
	}
	format(string, sizeof(string), "Admin %s(ID:%d) has eject all players from their vehicle.", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:disarmall(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

    new
		string[128]
	;

	foreach(new i : Player)
	{
		ResetPlayerWeapons(i);
	}
	format(string, sizeof(string), "Admin %s(ID:%d) has remove all players weapon.", pName(playerid), playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:setallworld(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    id,
	    string[130]
	;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setallworld [world]");
	foreach(new i : Player)
	{
		PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
		SetPlayerVirtualWorld(i, id);
	}
	format(string, sizeof(string), "Admin %s(ID:%d) has set all players virtual world to \"%d\"", pName(playerid), playerid, id);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:giveallscore(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    id,
	    string[130]
	;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /giveallscore [score]");
	foreach(new i : Player)
	{
        if(i != playerid)
        {
			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
			SetPlayerScore(i, GetPlayerScore(i) + id);
		}
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has given all players score \"%d\"", pName(playerid), playerid, id);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:giveallcash(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    id,
	    string[130]
	;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /giveallcash [money]");
	foreach(new i : Player)
	{
        if(i != playerid)
        {
			PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
			GivePlayerMoney(i, id);
		}
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has given all players cash \"$%d\"", pName(playerid), playerid, id);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:setalltime(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    id,
	    string[128]
	;

	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setalltime [time(0-23)]");
	if(id < 0 || id > 23) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Time Hour (0-23).");
	foreach(new i : Player)
	{
		PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
		SetPlayerTime(i, id, 0);
	}

	format(string, sizeof(string), "Admin %s(ID:%d) has set all players time to \"%d:00\"", pName(playerid), playerid, id);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:setallweather(playerid, params[])
{
    LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
	    id,
	    string[128]
	;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setallweather [weather(0-45)]");
	if(id < 0 || id > 45) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Weather ID! (0-45)");
	foreach(new i : Player)
	{
		PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
		SetPlayerWeather(i, id);
	}
	format(string, sizeof(string), "Admin %s(ID:%d) has set all players weather to \"%d\"", pName(playerid), playerid, id);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

CMD:respawncars(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	SendClientMessage(playerid, COLOR_GREEN, "You have successfully Respawned all Vehicles!");
	GameTextForAll("~n~~n~~n~~n~~n~~n~~r~Vehicles ~g~Respawned!", 3000, 3);
	for(new cars=0; cars<MAX_VEHICLES; cars++)
	{
	    if(!VehicleOccupied(cars))
	    {
            SetVehicleToRespawn(cars);
        }
	}
	return 1;
}

CMD:cleardwindow(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
		string[128]
	;

    format(string, sizeof(string), "Administrator "orange"%s "white"has cleared the Death Window!", pName(playerid));
    SendClientMessageToAll(-1, string);
	for(new i = 0; i < 20; i++) SendDeathMessage(6000, 5005, 255);
	return 1;
}

CMD:saveallstats(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
		string[130]
	;

    format(string, sizeof string, "Administrator "orange"%s "white"has saved all player's data.", pName(playerid));
	SendClientMessageToAll(-1, string);
	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
	        SaveData(i);
	    }
	}

	#if LOG == true
		format(string, sizeof string, "Administrator %s has  saved all player's data.", pName(playerid));
		SaveLog("account.txt", string);
	#endif
	return 1;
}

CMD:giveallweapon(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 4);

	new
		ammo,
		wID[32],
		weap,
		WeapName[32],
		string[130]
	;
	if(sscanf(params, "s[32]i", wID, ammo)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /giveallweapon [weaponid(or name)] [ammo]");
	if(ammo <= 0 || ammo > 99999) ammo = 500;
	if(!isnumeric(wID)) weap = GetWeaponIDFromName(wID);
	else weap = strval(wID);
	if(!IsValidWeapon(weap)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Weapon ID");
	GetWeaponName(weap, WeapName, 32);
   	foreach(new i : Player)
	{
		GivePlayerWeapon(i, weap, ammo);
		format(string, sizeof string, "~g~%s for all!", WeapName);
		GameTextForPlayer(i, string, 2500, 3);
	}
	format(string,sizeof(string), "Admin %s(ID:%d) has given all players a %s(%d) with %d rounds of ammo.", pName(playerid), playerid, WeapName, weap, ammo);
	SendClientMessageToAll(COLOR_YELLOW, string);
	return 1;
}

//============================================================================//
//						   Administrative Level Five                          //
//============================================================================//

CMD:makemegodadmin(playerid, params[])
{
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Only RCON can use this command.");
	else
	{
	    User[playerid][accountAdmin] = 5;
	    SendClientMessage(playerid, COLOR_GREEN, "You have set your administrative rank to level 5.");
	}
	return 1;
}

CMD:removeacc(playerid, params[])
{
	LoginCheck(playerid);
    LevelCheck(playerid, 5);

    new
		Account[MAX_PLAYER_NAME],
		Reason[100],
		string[128]
	;
    if(sscanf(params, "s[24]s[100]", Account, Reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /removeacc [account name] [reason]");
    if(DataExist(Account))
	{
	    if(!strcmp(pName(playerid), Account, false))
			return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot delete your own account!");

		foreach(new i : Player)
		{
		    if(strcmp(Account, pName(i), true) == 0)
		    {
		        SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player is online, fail to delete the account.");
		        return 1;
		    }
		}

		new Query[128+50];
	    format(Query, 100, "DELETE FROM `users` WHERE `username` = '%s'", Account);
		db_query(Database, Query);
		db_free_result(db_query(Database, Query));

		format(string, 128, "Admin %s(ID: %d) has deleted %s's account [Reason: %s]", pName(playerid), playerid, Account, Reason);
		SendClientMessageToAll(COLOR_YELLOW, string);
		SaveLog("account.txt", string);

		format(string, 128, "You have deleted %s's account [Reason: %s]", Account, Reason);
		SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "Syntax Error: Account does not exist in the database!");
	}
    return 1;
}

CMD:fakecmd(playerid, params[])
{
	new
		string[128],
		id,
		cmdtext[128]
	;

	LoginCheck(playerid);
	LevelCheck(playerid, 5);

	if(sscanf(params, "us[128]", id, cmdtext)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /fakecmd [playerid] [command]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(strfind(params, "/", false) != -1)
	{
        CallRemoteFunction("OnPlayerCommandText", "is", id, cmdtext);
	    format(string, sizeof(string), "Fake command sent to %s with %s", pName(id), cmdtext);
	    SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	else return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Add '/' before putting the command name to avoid the command unknown error.");
	return 1;
}

CMD:fakechat(playerid, params[])
{
	LoginCheck(playerid);
	LevelCheck(playerid, 5);

	new
		string[130],
		id,
		text[128]
	;

	if(sscanf(params, "us[128]", id, text)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /fakechat [playerid] [text]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	format(string, sizeof(string), "You have faked chat %s with %s", pName(id), text);
    SendClientMessage(playerid, COLOR_YELLOW, string);
	SendPlayerMessageToAll(id, text);
	return 1;
}

CMD:setlevel(playerid, params[])
{
	new
	    string[128],
	    id,
	    level
	;

	LoginCheck(playerid);
 	LevelCheck(playerid, 5);

	if(sscanf(params, "ui", id, level)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /setlevel [playerid] [level(0/5)]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(level < 0 || level > 5) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Levels shouldn't go below zero and shouldn't go above five.");
	if(level == User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player is already in that level.");
	if(User[id][accountLogged] == false) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not logged in.");

    if(User[id][accountAdmin] < level)
    {
        format(string, 128, "You have been promoted to level %d administrative rank by %s.", level, pName(playerid));
		SendClientMessage(id, COLOR_YELLOW, string);
		format(string, 128, "You have promoted %s to level %d administrative rank.", pName(id), level);
		SendClientMessage(playerid, COLOR_YELLOW, string);
    }
    else if(User[id][accountAdmin] > level)
    {
        format(string, 128, "You have been demoted to level %d administrative rank by %s.", level, pName(playerid));
		SendClientMessage(id, COLOR_YELLOW, string);
		format(string, 128, "You have demoted %s to level %d administrative rank.", pName(id), level);
		SendClientMessage(playerid, COLOR_YELLOW, string);
    }

    User[id][accountAdmin] = level;

	#if LOG == true
		format(string, sizeof string, "Administrator %s has set %s's administrative level to %d", pName(playerid), pName(id), level);
		SaveLog("account.txt", string);
	#endif

	SaveData(id); //Saving the whole data - Neater version than previously.
	return 1;
}

//============================================================================//
//						   Administrative Level Zero                          //
//============================================================================//

CMD:admins(playerid, params[])
{
	new string[128], count = 0;
	
	SendClientMessage(playerid, -1, "** "orange"Online Administrators "white"**");
	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
	        if(User[i][accountAdmin] >= 1)
	        {
	            format(string, sizeof(string), "(%d) %s - Level %d Admin", i, pName(i), User[i][accountAdmin]);
	            SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	            count++;
	        }
	    }
	}
	if(count == 0) return SendClientMessage(playerid, -1, "No administrators online at the server.");
	return 1;
}

CMD:savestats(playerid, params[])
{
	LoginCheck(playerid);

	if(!DataExist(pName(playerid))) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You do not have account.");

	SaveData(playerid);
	
	SendClientMessage(playerid, COLOR_GREEN, "ACCOUNT: Your account statistics has been saved manually.");
	return 1;
}

CMD:cmds(playerid, params[])
{
	new string[1246];

	LoginCheck(playerid);

	strcat(string, ""orange"");
	strcat(string, "Available Commands For Normal Players\n");
	strcat(string, "Listing all available commands of NGC.\n\n");

	strcat(string, ""yellow"/stats "white"-> Shows selected ID's statistics\n");
	strcat(string, ""yellow"/cpass "white"-> Changes your password\n");
	strcat(string, ""yellow"/report "white"-> Report a hacker, /report (ID) (REASON)\n");
	strcat(string, ""yellow"/admins "white"-> Shows the online Administrators\n");
	strcat(string, ""yellow"/savestats "white"-> Saves your stats\n");
	strcat(string, ""yellow"/god "white"-> Enables GodMode (/god again to disable)\n\n");
	
	strcat(string, ""yellow"/forum "white"-> Gives you a link to our Forums\n");
	strcat(string, ""yellow"/website "white"-> Gives you a link to our Website\n");
	strcat(string, ""yellow"/credits "white"-> Shows the developers of our community\n");
	strcat(string, ""yellow"/pm "white"-> Sends a Private Message to a player\n");
	strcat(string, ""yellow"/r "white"-> Replies to the latest Private Message\n");
	strcat(string, ""yellow"/help "white"-> Helps you with the comprehension of the server\n\n");
	
	strcat(string, ""yellow"/v or /car "white"-> Spawns a car\n");
    strcat(string, ""yellow"/keys "white"-> Displays a dialog with all Available Keys in your Keyboard\n");
    strcat(string, ""yellow"/afk "white"-> Use this command when you are away from keyboard (/afk again when you are back)\n");
    strcat(string, ""yellow"/ask "white"-> Sends a question to all online admins and they help you with your problem\n");
    strcat(string, ""yellow"/tips "white"-> Shows you some useful tips\n");
    strcat(string, ""yellow"/news "white"-> Shows you all updates/changelogs\n\n");
	SD(playerid, DIALOG_BEGIN, DM, ""orange"Player Commands", string, "Close", "");
	return 1;
}

CMD:teles(playerid, params[])
{
	new string[1246];

	LoginCheck(playerid);

	strcat(string, ""orange"");
	strcat(string, "Available Teleports\n");
	strcat(string, "Listing all available teleports of NGC.\n\n");

	strcat(string, ""white"");
	strcat(string, "/ls /sf /lv\n");
	strcat(string, "/lstune /sftune /lvtune\n");
	strcat(string, "/lsa /sfa /lva\n");
	strcat(string, "/loco /beach /docks\n");
	strcat(string, "/mc /4dragons /a51\n");
	strcat(string, "/doherty /drift1 /glen\n");
	strcat(string, "/arch /aa\n\n");

	SD(playerid, DIALOG_BEGIN, DM, ""orange"Teleports", string, "Close", "");
	return 1;
}

CMD:help(playerid, params[])
{
	new string[1246];

	LoginCheck(playerid);

	strcat(string, ""orange"");
	strcat(string, "New Gaming Class Help System\n");
	strcat(string, "Questions and answers for better comprehension of the server.\n\n");
	
	
    strcat(string, ""red"What can I do in the server?\n");
	strcat(string, ""white"");
	strcat(string, "As you notice we are a Freeroam/Stunt/DM server so you can do everything you want WITHOUT limits\n");
	strcat(string, "You can stunt to gain money, you can kill people to gain money and score, you cand find the MoneyBag.\n");
	strcat(string, "You can win in reactions for money and score and much more coming soon\n\n");
	
	strcat(string, ""red"How to gain Money?\n");
	strcat(string, ""white"");
	strcat(string, "You can gain money by finding the Hidden MoneyBag, by killing players but if you die you lose money\n");
	strcat(string, "Also you can gain money by winning in maths/typing reactions.\n\n");

	strcat(string, ""red"How to gain Score?\n");
	strcat(string, ""white"");
	strcat(string, "You can gain score by killing People arround ("green"+2 score and +1500$ cash"white") also you can gain score from Admin's events.\n\n");
	
	strcat(string, ""red"Where I can spent my money?\n");
	strcat(string, ""white"");
	strcat(string, "Currently nowhere every feature and update is for free you can take cars,weapons for free.\n\n");
	
	strcat(string, ""red"Where I can find server's commands?\n");
	strcat(string, ""white"");
	strcat(string, "Every command is written in another command named "red"/commands "white"you will find every new command there.\n\n");
	
	strcat(string, ""red"Where I can find server's Rules?\n");
	strcat(string, ""white"");
	strcat(string, "Every rule is written in another command named "red"/rules "white"you will find every rule there.\n\n");
	
	SD(playerid, DIALOG_BEGIN, DM, ""orange"Help", string, "Close", "");
	return 1;
}

CMD:keys(playerid, params[])
{
	new string[1246];

	LoginCheck(playerid);

	strcat(string, ""orange"");
	strcat(string, "New Gaming Class Keys System.\n");
	strcat(string, "Our server's keys.\n\n");


    strcat(string, ""yellow"Horn Jump ("red"H"yellow")\n");
	strcat(string, ""white"");
	strcat(string, "You can jump with your vehicle with H or CAPS LOCK buttons in your keyboard.\n\n");

	strcat(string, ""yellow"Flip and Fix car ("red"2"yellow")\n");
	strcat(string, ""white"");
	strcat(string, "You can flip and repair your car with 2 button in your keyboard.\n\n");

	strcat(string, ""yellow"Speed Boost ("red"Left Click"yellow")\n");
	strcat(string, ""white"");
	strcat(string, "You can speed up with Fire-key ("red"Mouse Left click"white").\n\n");

	SD(playerid, DIALOG_BEGIN, DM, ""orange"Keys Menu", string, "Close", "");
	return 1;
}

CMD:news(playerid, params[])
{
	new string[1246];

	LoginCheck(playerid);

	strcat(string, ""orange"");
	strcat(string, "All updates and changelogs here.\n\n");


    strcat(string, ""red"NGC Build "yellow"(1a)\n");
	strcat(string, ""white"");
	strcat(string, "*Unknown command replaced with textdraw\n");
	strcat(string, "*Fixed car bug where they didn't spawn properly\n");
	strcat(string, "*Added new KillStreak system\n");
	strcat(string, "*Removed Old Reaction system (Bugged will be added again when its fixed)\n");
	strcat(string, "*Added new commands (/tips, /news)\n");
	strcat(string, "*Fixed some bugs in textdraws\n");
	strcat(string, "*Added new textdraws with colours\n");
	
	strcat(string, ""grey"Read more: http://newgamingclass.boards.net/thread/20/build-1a#ixzz3QNlyx47Y\n");

	SD(playerid, DIALOG_BEGIN, DM, ""orange"Changelog", string, "Close", "");
	return 1;
}

CMD:rules(playerid, params[])
{
	new string[1246];

	LoginCheck(playerid);

	strcat(string, ""orange"");
	strcat(string, "Our Server's Rules\n");
	strcat(string, "You have too follow some rules in order to play on our server.\n");
	strcat(string, "If anyone gets caught abusing the following rules he/she will be punished\n\n");

	strcat(string, ""white"");
	strcat(string, "• You are not allowed to use hacks or third party modifications.\n");
	strcat(string, "• You may not AFK at the Spawn Points.\n");
	strcat(string, "• Exploiting bugs / hidden commands isn't allowed, You may get banned depending on the situation.\n");
	strcat(string, "• Advertising Servers isn't allowed.\n");
	strcat(string, "• Do not ask for money, score etc.\n");
	strcat(string, "• Giving away / trading / selling accounts is highly forbidden.\n");
	strcat(string, "• Abusing the script commands isn't allowed.\n");
	strcat(string, "• Insulting the server, players or staff is not allowed.\n\n");

	strcat(string, ""white"");
	strcat(string, ""red"TIPS:\n");
	strcat(string, "Every bug MUST be reported on our /forum(s).\n");
	strcat(string, "If you find any hacker and/or rule breaker and there is not admins online report him/her on our /forum(s).\n\n");

	SD(playerid, DIALOG_BEGIN, DM, ""orange"Rules", string, "Close", "");
	return 1;
}

CMD:t(playerid, params[])
{
  return cmd_teles(playerid, params);
}

CMD:teleports(playerid, params[])
{
  return cmd_teles(playerid, params);
}

CMD:commands(playerid, params[])
{
  return cmd_cmds(playerid, params);
}

CMD:c(playerid, params[])
{
  return cmd_cmds(playerid, params);
}

CMD:report(playerid, params[])
{
	new id, reason[128], string[136];
	if(sscanf(params, "us[128]", id, reason)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /report [playerid] [reason]");
	if(strlen(reason) <= 4) return SendClientMessage(playerid, -1, "» "red"Reason length shouldn't go lower than four.");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot report yourself.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	new r_hr, r_min, r_sec, r_m, r_d, r_y;
	getdate(r_y, r_m, r_d);
	gettime(r_hr, r_min, r_sec);

	reportmsg[3] = reportmsg[2];
	reportmsg[2] = reportmsg[1];
	reportmsg[1] = reportmsg[0];
	
	format(string, sizeof(string), "(%02d/%02d/%d - %02d:%02d:%02d) %s(ID:%d) has reported %s(ID:%d) for %s", r_m, r_d, r_y, r_hr, r_min, r_sec, pName(playerid), playerid, pName(id), id, reason);
	reportmsg[0] = string;

	format(string, sizeof(string), "REPORT: %s(ID:%d) has reported %s(ID:%d) for %s", pName(playerid), playerid, pName(id), id, reason);
	SendAdmin(COLOR_RED, string);

	foreach(new i : Player)
	{
	    if(User[i][accountLogged] == true)
	    {
	        if(User[i][accountAdmin] >= 1)
	        {
    			PlayerPlaySound(i, 1085, 0.0, 0.0, 0.0);
				#if ReportTD == true
				    TextDrawShowForPlayer(i, Textdraw0);
				    SetTimerEx("HideTD", 3500, false, "d", i);
				#endif
			}
		}
	}

	format(string, sizeof(string), "Your complaint against %s(ID:%d) %s has been sent to Online Admins.", pName(id), id, reason);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	return 1;
}

#if ReportTD == true
	function:HideTD(playerid)
	{
		return TextDrawHideForPlayer(playerid, Textdraw0);
	}
#endif

CMD:register(playerid, params[])
{
	if(User[playerid][accountLogged] == true) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You are logged in and registered already.");

	if(!DataExist(pName(playerid)))
	{
        new
            string[128],
            password[24],
            hashpass[129]
		;

		if(sscanf(params, "s[24]", password)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /register [password]");
        if(!IsValidPassword(password)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Invalid Password Symbols.");
        if(strlen(password) < 4 || strlen(password) > 20) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Password length shouldn't go below 4 and shouldn't go higher 20.");

        WP_Hash(hashpass, 129, password);

        SetPlayerScore(playerid, STARTING_SCORE);
        GivePlayerMoney(playerid, STARTING_CASH);

        //Time = Hours, Time2 = Minutes, Time3 = Seconds
        new time, time2, time3;
        gettime(time, time2, time3);
        new date, date2, date3;
        //Date = Month, Date2 = Day, Date3 = Year
        getdate(date3, date, date2);

        format(User[playerid][accountDate], 150, "%02d/%02d/%d %02d:%02d:%02d", date, date2, date3, time, time2, time3);

		new
			query[750+1000]
		;
	    format(query, sizeof(query),
		"INSERT INTO `users` (`username`, `IP`, `joindate`, `password`, `admin`, `kills`, `deaths`, `score`, `money`, `warn`, `mute`, `mutesec`, `cmute`, `cmutesec`, `jail`, `jailsec`, `hours`, `minutes`, `seconds`, `question`, `answer`) VALUES ('%s','%s','%s','%s',0,0,0,%d,%d,0,0,0,0,0,0,0,0,0,0,'%s','%s')",\
			DB_Escape(pName(playerid)),
			DB_Escape(User[playerid][accountIP]),
			DB_Escape(User[playerid][accountDate]),
			DB_Escape(hashpass),
			User[playerid][accountScore],
			User[playerid][accountCash],
			DB_Escape(User[playerid][accountQuestion]),
			DB_Escape(User[playerid][accountAnswer])
	 	);
		db_query(Database, query);

		User[playerid][accountLogged] = true;

		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

	    new
	        count,
	        DBResult: result
		;
	    result = db_query(Database, "SELECT * FROM `users`");
	    count = db_num_rows(result);
	    db_free_result(result);

	    User[playerid][accountID] = count;
		SendClientMessage(playerid, -1, ""white"You have successfully registered your account.");
		format(string, sizeof(string), ""white"You have received "green"50.000$ "white" for registering your account.", count);
		SendClientMessage(playerid, COLOR_ORANGE, string);

		SendClientMessage(playerid, COLOR_YELLOW, "Proceeding to the Security Question.");

		SD(playerid, DIALOG_QUESTION, DI, ""lightblue"Security Question", ""grey"Security question, Where you'll setup your account's security question.\nYou can use the Security Question incase you forgot your password, you can rely on it 100 percent.\n\nPut your question below:", "Setup", "");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "Syntax Error: You already have an account, /login instead.");
	}
	return 1;
}

CMD:login(playerid, params[])
{
	if(User[playerid][accountLogged] == true) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You are logged in already.");

	if(DataExist(pName(playerid)))
	{
		new
		    hashp[129],
		    string[900],
		    password[24]
		;
		
		if(sscanf(params, "s[24]", password)) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: /login [password]");

		if(strcmp(password, "forget", true) == 0)
		{
		    format(string, sizeof(string), ""grey"You have forgotten your password? If that's the case, answer the question you set on your account and you'll access your account.\n\n%s\n\nAnswer?\nPress Quit if you are willing to quit.", User[playerid][accountQuestion]);
			SD(playerid, DIALOG_FORGET, DI, ""lightblue"Security Question", string, "Answer", "Quit");
		    return 1;
		}

	    WP_Hash(hashp, 129, password);
	    if(!strcmp(hashp, User[playerid][accountPassword], false))
	    {
	        LoginPlayer(playerid);
	    }
	    else
	    {
	        User[playerid][WarnLog]++;

	        if(User[playerid][WarnLog] == 3)
	        {
				SD(playerid, DIALOG_BEGIN, DM, ""lightblue"Kicked", ""grey"You have been kicked from the server having too much wrong passwords!\nTry again, Reconnect (/q then join to the server again.)", "Close", "");
				KickDelay(playerid);
				return 1;
	        }

	        format(string, sizeof(string), "Invalid password! - %d out of 3 Warning Log Tires.", User[playerid][WarnLog]);
	        SendClientMessage(playerid, COLOR_RED, string);

			SendClientMessage(playerid, -1, "LOGIN: Try again, /login [password].");
	    }
	}
	else
	{
	    SendClientMessage(playerid, COLOR_RED, "Syntax Error: You do not have an account, /register first.");
	}
	return 1;
}

CMD:cpass(playerid, params[])
{
    LoginCheck(playerid);

	new OldPass[129], NewPass[129], string[128];
    if(sscanf(params, "s[24]s[24]", OldPass, NewPass)) return SendClientMessage(playerid, COLOR_RED, "<!> Syntax Error: /cpass [old pass] [new pass]");
    if(strlen(NewPass) < 4 || strlen(NewPass) > 20)
        return SendClientMessage(playerid, COLOR_RED, "Syntax Error: New password length shouldn't go below four and shouldn't go below twenty.");

    new Query[300], DBResult:Result, Buf[129];
    WP_Hash(Buf, 129, OldPass);
    format(Query, 300, "SELECT `userid` FROM `users` WHERE `username` = '%s' AND `password` = '%s'", User[playerid][accountName], Buf);
    Result = db_query(Database, Query);

	format(string, sizeof string, "Player %s has changed his/her password.", pName(playerid));
	SaveLog("account.txt", string);

    if(Result)
    {
	    if(db_num_rows(Result))
	    {
	        db_free_result(Result);
	        WP_Hash(Buf, 129, NewPass);
	        format(Query, 300, "UPDATE `users` SET `password` = '%s' WHERE `username` = '%s'", DB_Escape(Buf), DB_Escape(User[playerid][accountName]));
			db_query(Database, Query);

			format(string, 128, "Your password has been changed to '"orange"%s"white"'", NewPass);
			SendClientMessage(playerid, -1, string);
		}
		else
		{
		    db_free_result(Result);
			return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Old Password doesn't match on the current password!");
		}
	}
	return 1;
}

CMD:stats(playerid, params[])
{
	LoginCheck(playerid);
	
	new id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "Syntax: /stats [playerid]");
	if(id == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: Player not connected.");
	if(User[playerid][accountAdmin] < User[id][accountAdmin]) return SendClientMessage(playerid, COLOR_RED, "Syntax Error: You cannot use this command on higher admin.");
	
	ShowStatistics(playerid, id); 
	return 1;
}

CMD:ask(playerid,params[])
{
    new string[128],playername[24];
	if(sscanf(params,"s[128]",params)) return SendClientMessage(playerid, COLOR_RED,"Syntax: /ask [question]");
    GetPlayerName(playerid,playername,24);
    format(string,sizeof(string),"Help: %s has asked a question: %s [Use /ans answer]",playername,params);
    for(new i=0; i<MAX_PLAYERS; i++)
    {
         if(IsPlayerConnected(i))
         {
           LevelCheck(playerid, 0);
           {
              SendClientMessage(i,COLOR_ORANGE,string);
           }
         }
     }
    return 1;
}

//                                                                            //
//============================================================================//

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
    new vehicleid = GetPlayerVehicleID(playerid);

	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
		foreach(new x : Player)
		{
	    	if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] == playerid && User[x][SpecType] == ADMIN_SPEC_TYPE_VEHICLE)
			{
	        	TogglePlayerSpectating(x, 1);
		        PlayerSpectatePlayer(x, playerid);
	    	    User[x][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
			}
		}
	}
	
	if(newstate == PLAYER_STATE_PASSENGER)
	{
		foreach(new x : Player)
		{
		    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] == playerid)
			{
		        TogglePlayerSpectating(x, 1);
		        PlayerSpectateVehicle(x, vehicleid);
		        User[x][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
			}
		}
	}

	if(newstate == PLAYER_STATE_DRIVER)
	{
		foreach(new x : Player)
		{
		    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] == playerid)
			{
		        TogglePlayerSpectating(x, 1);
		        PlayerSpectateVehicle(x, vehicleid);
		        User[x][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
			}
		}
	}
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	#if ANTI_SPAWN == true
		if(User[playerid][accountLogged] == false)
		{
		    SendClientMessage(playerid, COLOR_RED, "Syntax Error: You need to login or register to spawn.");
		    return 0;
		}
	#endif
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	foreach(new x : Player)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] == playerid && User[x][SpecType] == ADMIN_SPEC_TYPE_PLAYER)
   		{
   		    SetPlayerInterior(x,newinteriorid);
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if ( newkeys & KEY_YES )
	{
        if ( !IsPlayerInAnyVehicle( playerid ) ) 		return 	cmd_help( playerid, "lol" );
	}
	if ( newkeys & KEY_NO )
	{
        if ( !IsPlayerInAnyVehicle( playerid ) ) 		return 	cmd_rules( playerid, "lol" );
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && User[playerid][SpecID] != INVALID_PLAYER_ID)
	{
		if(newkeys == KEY_JUMP) AdvanceSpectate(playerid);
		else if(newkeys == KEY_SPRINT) ReverseSpectate(playerid);
	}
	return 1;
}

#if RconProtect == true
	public OnPlayerRconLogin(playerid)
	{
		if(_RCON[playerid] == false)
		{
			SendClientMessage(playerid, COLOR_YELLOW, "The server has 2nd Rcon");
			SD(playerid, DIALOG_RCON, DP, ""green"2nd RCON Password", ""grey"The RCON password is protected by NGC\nPlease type the 2nd RCON Password to access the RCON.", "Access", "Kick");
		}
		return 1;
	}
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch( dialogid )
	{
	    #if RconProtect == true
	    case DIALOG_RCON:
	    {
			new
				string[130]
			;
	        if(!response)
	        {
				format(string, sizeof(string), "** Player %s(ID:%d) has been automatically kicked by the Server (Attempting to logged in RCON)", pName(playerid), playerid);
				SendClientMessageToAll(COLOR_GREY, string);
				print(string);
				#if LOG == true
					SaveLog("rcon.txt", string);
				#endif
				return KickDelay(playerid);
			}
		    if(response)
		    {
	        	if(!strcmp(RconPass, inputtext) && !(!strlen(inputtext)))
				{
				    format(string, sizeof(string), "** Player %s(ID:%d) has accessed the RCON Protection successfully!", pName(playerid), playerid);
					SendAdmin(COLOR_GREY, string);
					print(string);
					#if LOG == true
						SaveLog("rcon.txt", string);
					#endif
					
					_RCON[playerid] = true;
					
					GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~g~Authorized ~w~Access!~n~~y~Welcome Administrator!", 3000, 3);
				}
				else
				{
					if(_RCONwarn[playerid] == MAX_RCON_WARNINGS+1)
					{
						format(string, sizeof(string), "** Player %s(ID:%d) has been kicked by the Server (Attempting to logged in RCON)", pName(playerid), playerid);
						SendClientMessageToAll(COLOR_GREY, string);
						print(string);
						#if LOG == true
							SaveLog("kicklog.txt", string);
						#endif
						KickDelay(playerid);
						return 1;
					}
					_RCONwarn[playerid] ++;
		  			format(string, sizeof(string), "You have been warned for incorrect 2nd RCON Password (Warnings: %i/%i)", _RCONwarn[playerid], MAX_RCON_WARNINGS);
					SendClientMessage(playerid, COLOR_GREY, string);
					SD(playerid, DIALOG_RCON, DP, ""green"2nd RCON Password", ""grey"The RCON password is protected by NGC\nPlease type the 2nd RCON Password to access the RCON.", "Access", "Kick");
				}
	   		}
	    }
	    #endif
	    
	    case DIALOG_QUESTION:
	    {
	        if(!response)
			{
				SD(playerid, DIALOG_QUESTION, DI, ""lightblue"Security Question", ""grey"Security question, Where you'll setup your account's security question.\nYou can use the Security Question incase you forgot your password, you can rely on it 100 percent.\n\nPut your question below:", "Setup", "");
			}
			else
			{
			    if(strlen(inputtext) < 6 || strlen(inputtext) > 90)
			    {
					SD(playerid, DIALOG_QUESTION, DI, ""lightblue"Security Question", ""grey"Security question, Where you'll setup your account's security question.\nYou can use the Security Question incase you forgot your password, you can rely on it 100 percent.\nERROR: Your question shouldn't go below six length and shouldn't go above ninety.\n\nPut your question below:", "Setup", "");
			        return 1;
			    }

				format(User[playerid][accountQuestion], 129, "%s", inputtext);
				
				SendClientMessage(playerid, -1, "Security Question has been set up, Proceeding to Security Answer.");

				SaveData(playerid);
				
				SD(playerid, DIALOG_ANSWER, DI, ""lightblue"Security Answer", ""grey"You have setup the Security Question, Now setup your security answer.\n\nPut your security answer below:", "Setup", "");
			}
		}
		
		case DIALOG_ANSWER:
		{
			if(!response)
			{
				SD(playerid, DIALOG_ANSWER, DI, ""lightblue"Security Answer", ""grey"You have setup the Security Question, Now setup your security answer.\n\nPut your security answer below:", "Setup", "");
			}
			else
			{
			    if(strlen(inputtext) < 2 || strlen(inputtext) > 90)
			    {
					SD(playerid, DIALOG_ANSWER, DI, ""lightblue"Security Answer", ""grey"You have setup the Security Question, Now setup your security answer.\nERROR: Your security answer length shouldn't go below two and shouldn't go above ninety.\n\nPut your security answer below:", "Setup", "");
					return 1;
			    }
			    
			    new hashanswer[129];
			    WP_Hash(hashanswer, 129, inputtext);
			    format(User[playerid][accountAnswer], 129, "%s", hashanswer);
			    
			    SendClientMessage(playerid, COLOR_GREEN, "Security Question setting up is done, Once you've forgotten your account's password on login, Press forgot.");

				SaveData(playerid);
			}
		}
	    
	    case DIALOG_REGISTER:
	    {
	        new
	            string[128],
	            hashpass[129]
			;
			if(response)
			{
		        if(!IsValidPassword(inputtext))
		        {
        			SD(playerid, DIALOG_REGISTER, DP, ""lightblue"NGC - Register", ""grey"Welcome to the NGC!\nYour account doesn't exist on our database, Please insert your password below.\n\nTIPS: Make the password long so no one can hack it.\nERROR: Invalid Password Symbols.", "Register", "Quit");
		            return 0;
		        }
		        if (strlen(inputtext) < 4 || strlen(inputtext) > 20)
		        {
       				SD(playerid, DIALOG_REGISTER, DP, ""lightblue"NGC - Register", ""grey"Welcome to the NGC!\nYour account doesn't exist on our database, Please insert your password below.\n\nTIPS: Make the password long so no one can hack it.\nERROR: Password length shouldn't go below 4 and shouldn't go higher 20.", "Register", "Quit");
		            return 0;
		        }
		        
		        WP_Hash(hashpass, 129, inputtext);
		        
		        SetPlayerScore(playerid, STARTING_SCORE);
		        GivePlayerMoney(playerid, STARTING_CASH);
		        
		        //Time = Hours, Time2 = Minutes, Time3 = Seconds
		        new time, time2, time3;
		        gettime(time, time2, time3);
		        new date, date2, date3;
		        //Date = Month, Date2 = Day, Date3 = Year
		        getdate(date3, date, date2);
		        
		        format(User[playerid][accountDate], 150, "%02d/%02d/%d %02d:%02d:%02d", date, date2, date3, time, time2, time3);
		        
		        format(User[playerid][accountQuestion], 129, "What?");
		        format(User[playerid][accountAnswer], 129, "Yes");
		        
				new
					query[750+1000]
				;
			    format(query, sizeof(query),
				"INSERT INTO `users` (`username`, `IP`, `joindate`, `password`, `admin`, `kills`, `deaths`, `score`, `money`, `warn`, `mute`, `mutesec`, `cmute`, `cmutesec`, `jail`, `jailsec`, `hours`, `minutes`, `seconds`, `question`, `answer`) VALUES ('%s','%s','%s','%s',0,0,0,%d,%d,0,0,0,0,0,0,0,0,0,0,'%s','%s')",\
					DB_Escape(pName(playerid)),
					DB_Escape(User[playerid][accountIP]),
					DB_Escape(User[playerid][accountDate]),
					DB_Escape(hashpass),
					User[playerid][accountScore],
					User[playerid][accountCash],
					DB_Escape(User[playerid][accountQuestion]),
					DB_Escape(User[playerid][accountAnswer])
			 	);
				db_query(Database, query);

				User[playerid][accountLogged] = true;

				PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

			    new
			        count,
			        DBResult: result
				;
			    result = db_query(Database, "SELECT * FROM `users`");
			    count = db_num_rows(result);
			    db_free_result(result);
			    
			    User[playerid][accountID] = count;
				SendClientMessage(playerid, -1, "You have successfully registered from the database.");
				format(string, sizeof(string), "You are now handling accountID %i.", count);
				SendClientMessage(playerid, COLOR_ORANGE, string);
				SendClientMessage(playerid, COLOR_YELLOW, "Proceeding to the Security Question.");
				
				SD(playerid, DIALOG_QUESTION, DI, ""lightblue"Security Question", ""grey"Security question, Where you'll setup your account's security question.\nYou can use the Security Question incase you forgot your password, you can rely on it 100 percent.\n\nPut your question below:", "Setup", "");
			}
			else
			{
			    KickDelay(playerid);
			}
	    }
	    case DIALOG_LOGIN:
	    {
	        new
	            hashp[129],
	            string[900]
			;
			if(response)
			{
			    WP_Hash(hashp, 129, inputtext);
			    if(!strcmp(hashp, User[playerid][accountPassword], false))
			    {
			        LoginPlayer(playerid);
			    }
			    else
			    {
			        User[playerid][WarnLog]++;
			    
			        if(User[playerid][WarnLog] == 3)
			        {
						SD(playerid, DIALOG_BEGIN, DM, ""lightblue"Kicked", ""grey"You have been kicked from the server having too much wrong passwords!\nTry again, Reconnect (/q then join to the server again.)", "Close", "");
						KickDelay(playerid);
						return 0;
			        }
			        
			        format(string, sizeof(string), "Invalid password! - %d out of 3 Warning Log Tires.", User[playerid][WarnLog]);
			        SendClientMessage(playerid, COLOR_RED, string);
			        
			        format(string, sizeof(string), ""grey"Welcome back to the server!\nYour account exists on our database, Please insert your account's password below.\n\nTIPS: If you do not own the account, Please /q and find another username.\nERROR: Wrong password (%d/3 Warnings Log)", User[playerid][WarnLog]);
			        
        			SD(playerid, DIALOG_LOGIN, DP, ""lightblue"NGC - Login", string, "Login", "Forget");
			    }
			}
			else
			{
			    format(string, sizeof(string), ""grey"You have forgotten your password? If that's the case, answer the question you set on your account and you'll access your account.\n\n%s\n\nAnswer?\nPress Quit if you are willing to quit.", User[playerid][accountQuestion]);
				SD(playerid, DIALOG_FORGET, DI, ""lightblue"Security Question", string, "Answer", "Quit");
			}
		}

		case DIALOG_FORGET:
		{
		    if(!response)
		    {
		        KickDelay(playerid);
		    }
		    else
		    {
		        new hashanswer[129];
		        WP_Hash(hashanswer, 129, inputtext);
		    
		        if(strcmp(User[playerid][accountAnswer], hashanswer, true) == 0)
		        {
		            LoginPlayer(playerid);
		            SendClientMessage(playerid, -1, "Access granted.");
		        }
		        else
		        {
					new string[900];
				    format(string, sizeof(string), ""grey"You have forgotten your password? If that's the case, answer the question you set on your account and you'll access your account.\n\n%s\n\nAnswer?\nPress Quit if you are willing to quit.\n\nERROR: Wrong Answer on the question.", User[playerid][accountQuestion]);
					SD(playerid, DIALOG_FORGET, DI, ""lightblue"Security Question", string, "Answer", "Quit");
		        }
		    }
		}
		
		case DIALOG_COLORS:
		{
		    new string[120], id = GetPVarInt(playerid, "_Colors_");
		
			switch( response )
			{
			    case 0:
			    {
			        DeletePVar(playerid, "_Colors_");
			        SendClientMessage(playerid, -1, "Colour setting has been cancelled.");
			    }
			    case 1:
			    {
			        switch( listitem )
			        {
			            case 0:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "black"Black", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_BLACK);
				            DeletePVar(playerid, "_Colors_");
						}
			            case 1:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "white"White", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_WHITE);
				            DeletePVar(playerid, "_Colors_");
						}
			            case 2:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "red"Red", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_RED);
				            DeletePVar(playerid, "_Colors_");
						}
			            case 3:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "orange"Orange", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_ORANGE);
				            DeletePVar(playerid, "_Colors_");
						}
			            case 4:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "yellow"Yellow", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_YELLOW);
				            DeletePVar(playerid, "_Colors_");
						}
			            case 5:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "green"Green", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_GREEN);
				            DeletePVar(playerid, "_Colors_");
						}
			            case 6:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "blue"Blue", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_BLUE);
				            DeletePVar(playerid, "_Colors_");
			            }
			            case 7:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "purple"Purple", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_PURPLE);
				            DeletePVar(playerid, "_Colors_");
			            }
			            case 8:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "brown"Brown", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_BROWN);
				            DeletePVar(playerid, "_Colors_");
			            }
  			            case 9:
			            {
			                format(string, sizeof(string), ""red"Administrator %s "white"has set your name color to "pink"Pink", pName(playerid));
							SendClientMessage(id, -1, string);
							format(string, sizeof(string), "Color Name for Player %s has been set.", pName(id));
							SendClientMessage(playerid, COLOR_YELLOW, string);
							SetPlayerColor(id, COLOR_PINK);
				            DeletePVar(playerid, "_Colors_");
			            }
			        }
			    }
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	new string[128+50];

	format(string, sizeof(string), "You are now viewing '{%06x}%s"white"' statistics.", GetPlayerColor(clickedplayerid) >>> 8, pName(clickedplayerid));
	SendClientMessage(playerid, -1, string);

    ShowStatistics(playerid, clickedplayerid);
	return 1;
}

//============================================================================//

//Stock and functions starts here.

stock pName(playerid)
{
	new GetName[24];
	GetPlayerName(playerid, GetName, 24);
	return GetName;
}

function:ShowStatistics(playerid, playerid2)
{
	if(playerid2 == INVALID_PLAYER_ID) return 1; //Do not proceed.

	new string[1000], string2[556];

	format(string2, 556, ""red"%s Player Statistics "white"- "orange"New Gaming Class\n\n", pName(playerid2), playerid2);
	strcat(string, string2);
	strcat(string, ""lightblue"");
	format(string2, 556, ""lightblue"UserID: "white"%d\n", User[playerid2][accountID]); strcat(string, string2);
	format(string2, 556, ""lightblue"Join Date: "white"%s\n", User[playerid2][accountDate]); strcat(string, string2);
	format(string2, 556, ""lightblue"Online Time: "white"%02d:%02d:%02d\n", User[playerid2][accountGame][2], User[playerid2][accountGame][1], User[playerid2][accountGame][0]); strcat(string, string2);
	format(string2, 556, ""lightblue"Administrative Level: "white"%d\n", User[playerid2][accountAdmin]); strcat(string, string2);
	format(string2, 556, ""lightblue"Score: "white"%d\n", User[playerid2][accountScore]); strcat(string, string2);
	format(string2, 556, ""lightblue"Cash: "white"$%d\n", User[playerid2][accountCash]); strcat(string, string2);
	format(string2, 556, ""lightblue"Kills: "white"%d\n", User[playerid2][accountKills]); strcat(string, string2);
	format(string2, 556, ""lightblue"Deaths: "white"%d\n", User[playerid2][accountDeaths]); strcat(string, string2);
	new Float:ratio = (float(User[playerid2][accountKills])/float(User[playerid2][accountDeaths]));
	format(string2, 556, ""lightblue"Ratio (K/D): "white"%.3f\n", ratio); strcat(string, string2);

	format(string2, 556, "%s Stats", pName(playerid2));
	SD(playerid, DIALOG_BEGIN, DM, string2, string, "Close", "");
	return 1;
}

function:KickMe(playerid)
{
	return Kick(playerid);
}

stock KickDelay(playerid)
{
	SetTimerEx("KickMe", 2000, false, "d", playerid);
	return 1;
}

stock loadb()
{
    Database = db_open(_DB_);
    db_query(Database,
	"CREATE TABLE IF NOT EXISTS `users`\
	(`userid` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT, `IP` TEXT, `joindate` TEXT, `password` TEXT, `admin` NUMERIC, `kills` NUMERIC, `deaths` NUMERIC, `score` NUMERIC, `money` NUMERIC, `warn` NUMERIC, `mute` NUMERIC, `mutesec` NUMERIC, `cmute` NUMERIC, `cmutesec` NUMERIC, `jail` NUMERIC, `jailsec` NUMERIC, `hours` NUMERIC, `minutes` NUMERIC, `seconds` NUMERIC, `question` TEXT, `answer` TEXT)");

	db_query(Database,
	"CREATE TABLE IF NOT EXISTS `bans` (`username` TEXT, `ip` TEXT, `banby` TEXT, `banreason` TEXT, `banwhen` TEXT)");

	print("[AS] "_DB_" loading...");
	return 1;
}
stock closedb()
{
	print("[AS] "_DB_" closing...");
	return db_close(Database);
}

stock SaveData(playerid)
{
    new
        Query[700+1000]
    ;

    format(Query, sizeof(Query), "UPDATE `users` SET `IP` = '%s', `admin` = %d, `kills` = %d, `deaths` = %d, `score` = %d, `money` = %d, `warn` = %d, `mute` = %d, `mutesec` = %d, `cmute` = %d, `cmutesec` = %d, `jail` = %d, `jailsec` = %d, `hours` = %d, `minutes` = %d, `seconds` = %d, `question` = '%s', `answer` = '%s' WHERE `username` = '%s'",
			DB_Escape(User[playerid][accountIP]),
			User[playerid][accountAdmin],
			User[playerid][accountKills],
			User[playerid][accountDeaths],
			User[playerid][accountScore],
			User[playerid][accountCash],
			User[playerid][accountWarn],
			User[playerid][accountMuted],
			User[playerid][accountMuteSec],
			User[playerid][accountCMuted],
			User[playerid][accountCMuteSec],
			User[playerid][accountJail],
			User[playerid][accountJailSec],
			User[playerid][accountGame][2],
			User[playerid][accountGame][1],
			User[playerid][accountGame][0],
			DB_Escape(User[playerid][accountQuestion]),
			DB_Escape(User[playerid][accountAnswer]),
			DB_Escape(User[playerid][accountName])
	);
    db_query(Database, Query);
	db_free_result(db_query(Database, Query));
	return 1;
}

stock getIP(playerid)
{
	new twerp[20];
	GetPlayerIp(playerid, twerp, 20);
	return twerp;
}

stock isnumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
    	if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}

stock GetWeaponIDFromName(WeaponName[])
{
	if(strfind("molotov", WeaponName, true) != -1) return 18;
	for(new i = 0; i <= 46; i++)
	{
		switch(i)
		{
			case 0,19,20,21,44,45: continue;
			default:
			{
				new name[32]; GetWeaponName(i,name,32);
				if(strfind(name,WeaponName,true) != -1) return i;
			}
		}
	}
	return -1;
}

function:LoginPlayer(playerid)
{
    new
        Query[900],
        DBResult:Result,
        string[128+40]
    ;
    format(Query, sizeof(Query), "SELECT * FROM `users` WHERE `username` = '%s'", DB_Escape(pName(playerid)));
    Result = db_query(Database, Query);
    if(db_num_rows(Result))
    {
        db_get_field_assoc(Result, "userid", Query, 7);
        User[playerid][accountID] = strval(Query);

        db_get_field_assoc(Result, "score", Query, 20);
        User[playerid][accountScore] = strval(Query);
        SetPlayerScore(playerid, User[playerid][accountScore]);

        db_get_field_assoc(Result, "money", Query, 20);
        User[playerid][accountCash] = strval(Query);
        GivePlayerMoney(playerid, User[playerid][accountCash]);

        db_get_field_assoc(Result, "kills", Query, 20);
        User[playerid][accountKills] = strval(Query);

        db_get_field_assoc(Result, "deaths", Query, 20);
        User[playerid][accountDeaths] = strval(Query);

        db_get_field_assoc(Result, "admin", Query, 7);
        User[playerid][accountAdmin] = strval(Query);

		db_get_field_assoc(Result, "joindate", Query, 150);
		format(User[playerid][accountDate], 150, "%s", Query);

        db_get_field_assoc(Result, "warn", Query, 5);
        User[playerid][accountWarn] = strval(Query);

        db_get_field_assoc(Result, "mute", Query, 5);
        User[playerid][accountMuted] = strval(Query);

        db_get_field_assoc(Result, "mutesec", Query, 8);
        User[playerid][accountMuteSec] = strval(Query);

        db_get_field_assoc(Result, "cmute", Query, 6);
        User[playerid][accountCMuted] = strval(Query);

        db_get_field_assoc(Result, "cmutesec", Query, 9);
        User[playerid][accountCMuteSec] = strval(Query);

        db_get_field_assoc(Result, "jail", Query, 5);
        User[playerid][accountJail] = strval(Query);

        db_get_field_assoc(Result, "jailsec", Query, 8);
        User[playerid][accountJailSec] = strval(Query);

        db_get_field_assoc(Result, "hours", Query, 6);
        User[playerid][accountGame][2] = strval(Query);

        db_get_field_assoc(Result, "minutes", Query, 8);
        User[playerid][accountGame][1] = strval(Query);

        db_get_field_assoc(Result, "seconds", Query, 8);
        User[playerid][accountGame][0] = strval(Query);

		User[playerid][accountLogged] = true;

		if(User[playerid][accountMuted] == 1)
		{
		    format(string, 200, "PUNISHMENT: You have been muted from using the chat for %d seconds, You are muted the last time you logged out.", User[playerid][accountMuteSec]);
		    SendClientMessage(playerid, COLOR_RED, string);
		}
		if(User[playerid][accountCMuted] == 1)
		{
		    format(string, 200, "PUNISHMENT: You have been muted from using the commands for %d seconds, You are muted the last time you logged out.", User[playerid][accountCMuteSec]);
		    SendClientMessage(playerid, COLOR_RED, string);
		}

		SendClientMessage(playerid, COLOR_YELLOW, "SERVER: You have successfully logged in to the server.");
		if(User[playerid][accountAdmin] >= 1)
		{
		    SendClientMessage(playerid, -1, "You have logged into your administrative account, Good luck doing your duties.");
		}

		PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
    }
	db_free_result(Result);
    return 1;
}

function:IsValidPassword( const password[ ] )
{
    for( new i = 0; password[ i ] != EOS; ++i )
    {
        switch( password[ i ] )
        {
            case '0'..'9', 'A'..'Z', 'a'..'z': continue;
            default: return 0;
        }
    }
    return 1;
}

stock DB_Escape(text[])
{
    new
        ret[80* 2],
        ch,
        i,
        j;
    while ((ch = text[i++]) && j < sizeof (ret))
    {
        if (ch == '\'')
        {
            if (j < sizeof (ret) - 2)
            {
                ret[j++] = '\'';
                ret[j++] = '\'';
            }
        }
        else if (j < sizeof (ret))
        {
            ret[j++] = ch;
        }
        else
        {
            j++;
        }
    }
    ret[sizeof (ret) - 1] = '\0';
    return ret;
}

stock ShowBan(playerid, admin[] = "Server", reason[] = "69 Sex", when[] = "01/01/1970 00:00:00")
{
	new string[256], string2[1500];

	for(new i=0; i<100; i++)
	{
	    SendClientMessage(playerid, -1, " ");
	}

    format(string, 256, "You're banned from server by %s for the following reasons:", admin);
	SendClientMessage(playerid, COLOR_RED, string);
	format(string, 256, "(( %s ))", reason);
	SendClientMessage(playerid, -1, string);

	strcat(string2, ""grey"");
	strcat(string2, "You are banned from this server, Statistics of your ban:\n\n");
	format(string, 256, ""white"Name: "red"%s\n", pName(playerid));
	strcat(string2, string);
	format(string, 256, ""white"Banned By: "red"%s\n", admin);
	strcat(string2, string);
	format(string, 256, ""white"Reason: "red"%s\n", reason);
	strcat(string2, string);
	format(string, 256, ""white"IP: "red"%s\n", User[playerid][accountIP]);
	strcat(string2, string);
	format(string, 256, ""white"Banned since: "red"%s\n\n", when);
	strcat(string2, string);
	strcat(string2, ""grey"");
	strcat(string2, "If you think this is a bugged, false ban or the admin abused his/her power, Please place a ban appeal on forums.\n");
	strcat(string2, "Make sure to take a picture of this by pressing F8, Do not lie on your appeal.");

	SD(playerid, DIALOG_BEGIN, DM, ""red"You are banned from this server.", string2, "Close", "");
	return 1;
}

stock BanAccountEx(name[], ip[], admin[] = "Anticheat", reason[] = "None")
{
	new
		Query[500],
		DBResult:result,
		ban_hr, ban_min, ban_sec, ban_month, ban_days, ban_years, when[128]
	;

	gettime(ban_hr, ban_min, ban_sec);
	getdate(ban_years, ban_month, ban_days);

	format(when, 128, "%02d/%02d/%d %02d:%02d:%02d", ban_month, ban_days, ban_years, ban_hr, ban_min, ban_sec);

	format(Query, 500, "INSERT INTO `bans` (`username`, `ip`, `banby`, `banreason`, `banwhen`) VALUES ('%s', '%s', '%s', '%s', '%s')", DB_Escape(name), DB_Escape(ip), DB_Escape(admin), DB_Escape(reason), DB_Escape(when));
	result = db_query(Database, Query);

	db_free_result(result);
	return 1;
}

stock BanAccount(playerid, admin[] = "Anticheat", reason[] = "None")
{
	new
		Query[500],
		DBResult:result,
		ban_hr, ban_min, ban_sec, ban_month, ban_days, ban_years, when[128]
	;

	gettime(ban_hr, ban_min, ban_sec);
	getdate(ban_years, ban_month, ban_days);

	format(when, 128, "%02d/%02d/%d %02d:%02d:%02d", ban_month, ban_days, ban_years, ban_hr, ban_min, ban_sec);

	format(Query, 500, "INSERT INTO `bans` (`username`, `ip`, `banby`, `banreason`, `banwhen`) VALUES ('%s', '%s', '%s', '%s', '%s')", DB_Escape(pName(playerid)), DB_Escape(User[playerid][accountIP]), DB_Escape(admin), DB_Escape(reason), DB_Escape(when));
	result = db_query(Database, Query);
		
	db_free_result(result);
	return 1;
}

function:j_CountCmds()
{
    new
        cmdBuffer[32],
        commandCount;

    for(new it = 0; it < Scripting_GetPublicsCount(); it++)
	{
        Scripting_GetPublic(it, cmdBuffer);

        if(!strcmp(cmdBuffer, "cmd_", false, 4)) {
            commandCount++;
        }
    }

    return commandCount;
}

function:IsValidWeapon(weaponid)
{
    if (weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47) return 1;
    return 0;
}

function:SaveLog(filename[], text[])
{
	#if LOG == true

	new string[256];

	if(!fexist(_LOG_))
	{
	    printf("[AS] Unable to overwrite '%s' at the '%s', '%s' missing.", filename, _LOG_, _LOG_);
	    print("No logs has been saved to your server database.");
	    
	    format(string, sizeof string, "NGC has attempted to overwrite '%s' at the '%s' which is missing.", filename, _LOG_);
	    SendAdmin(COLOR_RED, string);
	    SendAdmin(-1, "No logs has been saved to the server database, Check the console for further solution.");
	    return 0;
	}
	
	new File:file,
		filepath[128+40]
	;

	new year, month, day;
	new hour, minute, second;

	getdate(year, month, day);
	gettime(hour, minute, second);
	format(filepath, sizeof(filepath), ""_LOG_"%s", filename);
	file = fopen(filepath, io_append);
	format(string, sizeof(string),"[%02d/%02d/%02d | %02d:%02d:%02d] %s\r\n", month, day, year, hour, minute, second, text);
	fwrite(file, string);
	fclose(file);
	#endif
	return 1;
}

stock VehicleOccupied(vehicleid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerInVehicle(i, vehicleid)) return 1;
    }
    return 0;
}

stock DataExist(name[])
{
	new Buffer[180],
		Entry,
		DBResult:Result
	;

	format(Buffer, sizeof(Buffer), "SELECT `userid` FROM `users` WHERE `username` = '%s'", name);
	Result = db_query(Database, Buffer);

	if(Result)
	{
		if(db_num_rows(Result))
		{
			Entry = 1;
			db_free_result(Result);
		}
		else Entry = 0;
	}
	return Entry;
}

stock SendAdmin(color, string[])
{
	foreach(new i : Player)
	{
	    if(User[i][accountAdmin] >= 1)
	    {
	        SendClientMessage(i, color, string);
	    }
	}
}

#if ANTI_SWEAR == true
	stock Cenzura(string[], words[], destch = '*')
	{
		new start_index = (-1),
		    end_index = (-1);

		start_index = strfind(string, words, true);
		if(start_index == (-1)) return false;
		end_index = (start_index+strlen(words));

		for( ; start_index < end_index; start_index++)
			string[start_index] = destch;
		return true;
	}
#endif

stock StartSpectate(playerid, specplayerid)
{
	foreach(new x : Player)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] == playerid)
		{
	    	AdvanceSpectate(x);
		}
	}
	SetPlayerInterior(playerid, GetPlayerInterior(specplayerid));
	TogglePlayerSpectating(playerid, 1);

	if(IsPlayerInAnyVehicle(specplayerid))
	{
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
		User[playerid][SpecID] = specplayerid;
		User[playerid][SpecType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else
	{
		PlayerSpectatePlayer(playerid, specplayerid);
		User[playerid][SpecID] = specplayerid;
		User[playerid][SpecType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	return 1;
}

stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	User[playerid][SpecID] = INVALID_PLAYER_ID;
	User[playerid][SpecType] = ADMIN_SPEC_TYPE_NONE;
	GameTextForPlayer(playerid,"~n~~n~~n~~w~Spectate mode ended",1000,3);
	return 1;
}

stock AdvanceSpectate(playerid)
{
    if(Iter_Count(Player) == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && User[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	    for(new x=User[playerid][SpecID]+1; x<=MAX_PLAYERS; x++)
		{
	    	if(x == MAX_PLAYERS) x = 0;
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ReverseSpectate(playerid)
{
    if(Iter_Count(Player) == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && User[playerid][SpecID] != INVALID_PLAYER_ID)
	{
	    for(new x=User[playerid][SpecID]-1; x>=0; x--)
		{
	    	if(x == 0) x = MAX_PLAYERS;
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && User[x][SpecID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock GetVehicleModelIDFromName(vname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleNames[i], vname, true) != -1 )
		return i + 400;
	}
	return -1;
}

function:EraseVeh(vehicleid)
{
    foreach(new i : Player)
	{
        new Float:X, Float:Y, Float:Z;
    	if(IsPlayerInVehicle(i, vehicleid))
		{
	  		RemovePlayerFromVehicle(i);
	  		GetPlayerPos(i, X, Y, Z);
	 		SetPlayerPos(i, X, Y+3, Z);
	    }
	    SetVehicleParamsForPlayer(vehicleid, i, 0, 1);
	}
    SetTimerEx("VehRes", 1500, 0, "i", vehicleid);
}

function:DelVehicle(vehicleid)
{
    foreach(new players : Player)
    {
        new Float:X, Float:Y, Float:Z;
        if(IsPlayerInVehicle(players, vehicleid))
        {
	        GetPlayerPos(players, X, Y, Z);
	        SetPlayerPos(players, X, Y, Z+2);
	        SetVehicleToRespawn(vehicleid);
        }
        SetVehicleParamsForPlayer(vehicleid, players, 0, 1);
    }
    SetTimerEx("VehRes", 3000, 0, "d", vehicleid);
    return 1;
}

stock Config()
{
	print("\n");

	/*
	Don't blame me, Can't find a nice solution of detecting it, So i will do it
	on my own way - I will find a proper code to optimize this on the next
	version.
	*/
	
	new
	    log,
	    autolog,
	    dialog,
	    readcmd,
	    maxping,
	    antiswear,
	    antiname,
	    antispawn,
	    antiad,
	    rconpass,
	    antispam,
	    on[3] ="ON",
	    off[4] = "OFF"
	;

	log = 0; autolog = 0; dialog = 0; readcmd = 0; maxping = 0; antiswear = 0;
	antiname = 0; antispawn = 0; antiad =0; rconpass=0; antispam = 0;

	#if LOG == true
	    log = 1;
	#endif
	
	#if AUTO_LOGIN == true
	    autolog = 1;
	#endif
	
	#if REGISTER_DIALOG == true
	    dialog = 1;
	#endif
	
	#if READ_COMMANDS == true
	    readcmd = 1;
	#endif
	
	#if MAX_PING == true
	    maxping = 1;
	#endif
	
	#if ANTI_SWEAR == true
	    antiswear = 1;
	#endif
	
	#if ANTI_NAME == true
	    antiname = 1;
	#endif
	
	#if ANTI_SPAWN == true
	    antispawn = 1;
	#endif
	
	#if ANTI_AD == true
	    antiad = 1;
	#endif

	#if RconProtect == true
	    rconpass = 1;
	#endif
	
	#if AntiSpam == true
	    antispam = 1;
	#endif

	print("***** Administration System Configuration *****");
	printf("LogSaving: %s, AutoLogin: %s, Dialog: %s, ReadCommands: %s, MaxPing: %s", log ? on : off, autolog ? on : off, dialog ? on : off, readcmd ? on : off, maxping ? on : off);
	printf("AntiSwear: %s, AntiName: %s, AntiSpawn: %s, AntiAd: %s, RCONProtect: %s", antiswear ? on : off, antiname ? on : off, antispawn ? on : off, antiad ? on : off, rconpass ? on : off);
	printf("AntiSpam: %s", antispam ? on : off);
	#if MAX_PING == true
	    printf("MaxPing Limit: %d", PING_EXCEED);
	#endif
}

function:VehRes(vehicleid)
{
    DestroyVehicle(vehicleid);
}

stock TimeStamp()
{
	new time = GetTickCount() / 1000;
	return time;
}

function:checkfolderEx()
{
	if(!fexist("JakAdmin3/"))
	{
		return 0;
	}
	if(!fexist("JakAdmin3/Logs/"))
	{
	    return 0;
	}
	return 1;
}

function:checkfolder()
{
	if(!fexist("JakAdmin3/"))
	{
		print("\n[AS]: Folder doesn't exist in scriptfiles, Admin System won't start.");
		print("Solution: Create the folder JakAdmin3 on the scriptfiles.");
		print("Continusly using the script with the missing file will not save the target script objective.\n");
		return 0;
	}
	if(!fexist("JakAdmin3/Logs/"))
	{
		print("\n[AS]: Logs folder doesn't exist in scriptfiles, Admin System won't start.");
		print("Solution: Create the folder Logs on the JakAdmin3 folder.");
		print("Continusly using the script with the missing file will not save the target script objective.\n");
	    return 0;
	}
	return 1;
}

function:PosAfterSpec(playerid)
{
	SetPlayerPos(playerid, SpecPos[playerid][0], SpecPos[playerid][1], SpecPos[playerid][2]);
	SetPlayerFacingAngle(playerid, SpecPos[playerid][3]);
	SetPlayerInterior(playerid, SpecInt[playerid][0]);
	SetPlayerVirtualWorld(playerid, SpecInt[playerid][1]);
}
