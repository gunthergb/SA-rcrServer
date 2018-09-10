#include <a_samp>
#include <zcmd>

#define DIALOG_REGISTER 1335
#define DIALOG_LOGIN    1336

enum pInfo
{
	//Player Data
	Score,
	Money,
	BankMoney,
	PlayerIP,
	AdminLevel,
	RegularPlayer,
	SavedWantedLevel,
	SavedJailTime,
	LastCity,
	BanTime,
	BanReason,
	AdminWhoBanned,
	//Player Stats
	RobRank,
	RapeRank,
	DrugDealerRank,
	GunDealerRank,
	HitmanRank,
	MedicRank,
	MechanicRank,
	BountyHunterRank,
	KidnapperRank,
	TerroristRank,
	//Briefcase
	HasBriefcase,
	BriefcaseMoney,
	BriefcaseC4,
	BriefcaseWeaponSlot1,
	BriefcaseWeaponAmmoSlot1,
	BriefcaseWeaponSlot2,
	BriefcaseWeaponAmmoSlot2,
	BriefcaseWeaponSlot3,
	BriefcaseWeaponAmmoSlot3,
	//Can Use
	CanUseSWAT,
	CanUseFBI,
	CanUseArmy,
	//Law Enforcement Ranks
	CopRank,
	Tazes,
	Cuffs,
	Arrests,
	SWATRank,
	FBIRank,
	ArmyRank,
	//Business Owners
	//Car Dealerships
	GrottiOwner,
	WangCarsOwner,
	OttosAutosOwner,
	AutobahnOwner,
	AerobahnOwner,
	SteamboatWillysOwner,
	//Drug Houses
	LSDrugHouseOwner,
	SFDrugHouseOwner,
	LVDrugHouseOwner,
	//Airports
	LSAirportOwner,
	SFAirportOwner,
	LVAirportOwner,
	YugoAirportOwner,
	bool:Logged
}

new
	PlayerInfo[MAX_PLAYERS][pInfo],
	DB:Database;

public OnFilterScriptInit( )
{
 	new Query[1024] = "CREATE TABLE IF NOT EXISTS `Users' ";
	Database = db_open("SArcr.db");
	//Player Data
    strcat(Query, "(`IP`, \
	`Name`, \
	`Password`, \
	`Money`, \
	`Score`, \
	`LastCity`, \
	`AdminLevel`, \
	`RegularPlayer`, \
	`SavedWantedLevel`, \
	`SavedJailTime`, \
	`BanTime`, \
	`BanReason`, \
	`AdminWhoBanned`,");
	//Player Stats
	strcat(Query, "`RobRank`, \
	`RapeRank`, \
	`DrugDealerRank`, \
	`GunDealerRank`, \
	`HitmanRank`, \
	`MedicRank`, \
	`MechanicRank`, \
	`BountyHunterRank`, \
	`KidnapperRank`, \
	`TerroristRank`,");
	//Briefcase
	strcat(Query, "`HasBriefcase`, \
	`BriefcaseMoney`, \
	`BriefcaseC4`, \
	`BriefcaseWeaponSlot1`, \
	`BriefcaseWeaponAmmoSlot1`, \
	`BriefcaseWeaponSlot2`, \
	`BriefcaseWeaponAmmoSlot2`, \
	`BriefcaseWeaponSlot3`, \
	`BriefcaseWeaponAmmoSlot3`,");
	//Can Use
	strcat(Query, "`CanUseSWAT` \
	`CanUseFBI`, \
	`CanUseArmy`,");
	//Law Enforcement Ranks
	strcat(Query, "`CopRank`, \
	`Tazes`, \
	`Cuffs`, \
	`Arrests`, \
	`SWATRank`, \
	`FBIRank`, \
	`ArmyRank`,");
	//Business Owners
	//Vehicle Dealerships
	strcat(Query, "`GrottiOwner`, \
	`WangCarsOwner`, \
	`OttosAutosOwner`, \
	`AutobahnOwner`, \
	`AerobahnOwner`, \
	`SteamboatWillysOwner`,");
	//Drug Houses
	strcat(Query, "`LSDrugHouseOwner`, \
	`SFDrugHouseOwner`, \
	`LVDrugHouseOwner`,");
	//Airports
	strcat(Query, "`LSAirportOwner`, \
	`SFAirportOwner`, \
	`LVAirportOwner`, \
	`YugoAirportOwner`)");
	db_free_result(db_query(Database, Query));
	return 1;
}

public OnFilterScriptExit( )
{
	db_close(Database);
	return 1;
}

CMD:test(playerid, params[])
{
    if(PlayerInfo[playerid][RobRank] == 1)
	{
	    SendClientMessage(playerid, ~1, "bitch yo chode just got cut");
	    return 1;
	}
	else return SendClientMessage(playerid, ~1, "bitch you got no chode to get cut");
}

stock ShowLoginScreen(playerid)
{
    new string[100];
    format(string, sizeof(string), "Welcome back %s\nBefore playing you must login\nEnter your password below and click login",PlayerName(playerid));
    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_INPUT,"Login required",string,"Login","Cancel");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_REGISTER)
	{
		new Query[1024], DBResult:Result, string[220];

		format(Query, sizeof(Query), "SELECT * FROM `Users` WHERE `Name` = '%s'", PlayerName(playerid));
		Result = db_query(Database,Query);

		if(!db_num_rows(Result))
		{
			if(strlen(inputtext))
			{
				if(strlen(inputtext) > 5 && strlen(inputtext) < 24)
				{
				    //Player Data
				    format(Query, sizeof(Query), "INSERT INTO `Users` (`IP`, \
					`Name`, \
					`Password`, \
					`Money`, \
					`Score`, \
					`AdminLevel`, \
					`RegularPlayer`, \
					`SavedWantedLevel`, \
					`SavedJailTime` \
					`BanTime`, \
					`BanReason`, \
					`AdminWhoBanned`");
					//Player Stats
					strcat(Query, "`RobRank`, \
					`RapeRank`, \
					`DrugDealerRank`, \
					`GunDealerRank`, \
					`HitmanRank`, \
					`MedicRank`, \
					`MechanicRank`, \
					`BountyHunterRank`, \
					`KidnapperRank`, \
					`TerroristRank`");
					//Briefcase
					strcat(Query, "`HasBriefcase`, \
					`BriefcaseMoney`, \
					`BriefcaseC4`, \
					`BriefcaseWeaponSlot1`, \
					`BriefcaseWeaponAmmoSlot1`, \
					`BriefcaseWeaponSlot2`, \
					`BriefcaseWeaponAmmoSlot2`, \
					`BriefcaseWeaponSlot3`, \
					`BriefcaseWeaponAmmoSlot3`");
					//Can Use
					strcat(Query, "`CanUseSWAT`, \
					`CanUseFBI`, \
					`CanUseArmy`");
					//Law Enforcement Ranks
					strcat(Query, "`CopRank`, \
					`Tazes`, \
					`Cuffs`, \
					`Arrests`, \
					`SWATRank`, \
					`FBIRank`, \
					`ArmyRank`");
					//Business Owners
					//Vehicle Dealerships
					strcat(Query, "`GrottiOwner`, \
					`WangCarsOwner`, \
					`OttosAutosOwner`, \
					`AutobahnOwner`, \
					`AerobahnOwner`, \
					`SteamboatWillys`");
					//Drug Houses
					strcat(Query, "`LSDrugHouseOwner`, \
					`SFDrugHouseOwner`, \
					`LVDrugHouseOwner`");
					strcat(Query, "`LSAirportOwner`, \
					`SFAirportOwner`, \
					`LVAirportOwner`, \
					`YugoAirportOwner`)");
					format(string, sizeof(string), "VALUES ('%s', '%s', '%s', '%d', '%d')", GetPlayerIPEx(playerid), PlayerName(playerid), inputtext, GetPlayerMoney(playerid), GetPlayerScore(playerid));
					strcat(Query, string);
					db_free_result(db_query(Database, Query));
					SendClientMessage(playerid, ~1, "Your account has been succesfully registered!");
					format(Query, sizeof(Query), "You have registered using password: %s.", inputtext);
					SendClientMessage(playerid, ~1, Query);
				}
				else
				{
					SendClientMessage(playerid, ~1, "Password must be between 5 and 24 characters.");
					ShowLoginScreen(playerid);
					return 1;
				}
			}
			else
	  		{
	  		    SendClientMessage(playerid, ~1, "You must enter a password.");
	  		    ShowLoginScreen(playerid);
	  		    return 1;
			}
		}
	}
	if(dialogid == DIALOG_LOGIN)
	{
	    if(strlen(inputtext))
		{
			new Query[256], DBResult:Result ;

			format(Query, sizeof(Query), "SELECT * FROM `Users` WHERE `Name` = '%s'", PlayerName(playerid));
			Result = db_query(Database,Query);

			if(db_num_rows(Result))
			{
				format(Query, sizeof(Query), "SELECT * FROM `Users` WHERE `Name` = '%s' AND `Password` = '%s'", PlayerName(playerid), inputtext);
				Result = db_query(Database,Query);
				if(db_num_rows(Result))
				{
					new Field[30];

					db_get_field_assoc(Result, "Money", Field, 30 );
					PlayerInfo[playerid][Money] = strval(Field);

					db_get_field_assoc(Result, "Score", Field, 30 );
					PlayerInfo[playerid][Score] = strval(Field);

					db_get_field_assoc(Result, "RobRank", Field, 30 );
					PlayerInfo[playerid][RobRank] = strval(Field);

					db_get_field_assoc(Result, "AdminLevel", Field, 30 );
					PlayerInfo[playerid][AdminLevel] = strval(Field);

					db_get_field_assoc(Result, "RegularPlayer", Field, 30 );
					PlayerInfo[playerid][RegularPlayer] = strval(Field);

					db_get_field_assoc(Result, "SavedWantedLevel", Field, 30 );
					PlayerInfo[playerid][SavedWantedLevel] = strval(Field);

					db_get_field_assoc(Result, "SavedJailTime", Field, 30 );
					PlayerInfo[playerid][SavedJailTime] = strval(Field);

					db_get_field_assoc(Result, "BanTime", Field, 30 );
					PlayerInfo[playerid][BanTime] = strval(Field);

					db_get_field_assoc(Result, "BanReason", Field, 30 );
					PlayerInfo[playerid][BanReason] = strval(Field);

					db_get_field_assoc(Result, "AdminWhoBanned", Field, 30 );
					PlayerInfo[playerid][AdminWhoBanned] = strval(Field);

					db_get_field_assoc(Result, "RobRank", Field, 30 );
					PlayerInfo[playerid][RobRank] = strval(Field);

					db_get_field_assoc(Result, "RapeRank", Field, 30 );
					PlayerInfo[playerid][RapeRank] = strval(Field);

					db_get_field_assoc(Result, "DrugDealerRank", Field, 30 );
					PlayerInfo[playerid][DrugDealerRank] = strval(Field);

					db_get_field_assoc(Result, "GunDealerRank", Field, 30 );
					PlayerInfo[playerid][GunDealerRank] = strval(Field);

					db_get_field_assoc(Result, "HitmanRank", Field, 30 );
					PlayerInfo[playerid][HitmanRank] = strval(Field);

					db_get_field_assoc(Result, "MedicRank", Field, 30 );
					PlayerInfo[playerid][MedicRank] = strval(Field);

					db_get_field_assoc(Result, "MechanicRank", Field, 30 );
					PlayerInfo[playerid][MechanicRank] = strval(Field);

					db_get_field_assoc(Result, "BountyHunterRank", Field, 30 );
					PlayerInfo[playerid][BountyHunterRank] = strval(Field);

					db_get_field_assoc(Result, "KidnapperRank", Field, 30 );
					PlayerInfo[playerid][KidnapperRank] = strval(Field);

					db_get_field_assoc(Result, "TerroristRank", Field, 30 );
					PlayerInfo[playerid][TerroristRank] = strval(Field);

					db_get_field_assoc(Result, "HasBriefcase", Field, 30 );
					PlayerInfo[playerid][HasBriefcase] = strval(Field);

					db_get_field_assoc(Result, "BriefcaseMoney", Field, 30 );
					PlayerInfo[playerid][BriefcaseMoney] = strval(Field);

					db_get_field_assoc(Result, "BriefcaseC4", Field, 30 );
					PlayerInfo[playerid][BriefcaseC4] = strval(Field);

					db_get_field_assoc(Result, "BriefcaseWeaponSlot1", Field, 30 );
					PlayerInfo[playerid][BriefcaseWeaponAmmoSlot1] = strval(Field);

					db_get_field_assoc(Result, "BriefcaseWeaponAmmoSlot1", Field, 30 );
					PlayerInfo[playerid][BriefcaseWeaponAmmoSlot1] = strval(Field);
					
					db_get_field_assoc(Result, "BriefcaseWeaponSlot2", Field, 30 );
					PlayerInfo[playerid][BriefcaseWeaponSlot2] = strval(Field);

					db_get_field_assoc(Result, "BriefcaseWeaponAmmoSlot2", Field, 30 );
					PlayerInfo[playerid][BriefcaseWeaponAmmoSlot2] = strval(Field);

					db_get_field_assoc(Result, "BriefcaseWeaponSlot3", Field, 30 );
					PlayerInfo[playerid][BriefcaseWeaponSlot3] = strval(Field);

					db_get_field_assoc(Result, "BriefcaseWeaponAmmoSlot3", Field, 30 );
					PlayerInfo[playerid][BriefcaseWeaponAmmoSlot3] = strval(Field);

					db_get_field_assoc(Result, "CanUseSWAT", Field, 30 );
					PlayerInfo[playerid][CanUseSWAT] = strval(Field);

					db_get_field_assoc(Result, "CanUseFBI", Field, 30 );
					PlayerInfo[playerid][CanUseFBI] = strval(Field);

					db_get_field_assoc(Result, "CanUseArmy", Field, 30 );
					PlayerInfo[playerid][CanUseArmy] = strval(Field);

					db_get_field_assoc(Result, "CopRank", Field, 30 );
					PlayerInfo[playerid][CopRank] = strval(Field);

					db_get_field_assoc(Result, "Tazes", Field, 30 );
					PlayerInfo[playerid][Tazes] = strval(Field);

					db_get_field_assoc(Result, "Cuffs", Field, 30 );
					PlayerInfo[playerid][Cuffs] = strval(Field);

					db_get_field_assoc(Result, "Arrests", Field, 30 );
					PlayerInfo[playerid][Arrests] = strval(Field);

					db_get_field_assoc(Result, "SWATRank", Field, 30 );
					PlayerInfo[playerid][SWATRank] = strval(Field);

					db_get_field_assoc(Result, "FBIRank", Field, 30 );
					PlayerInfo[playerid][FBIRank] = strval(Field);

					db_get_field_assoc(Result, "ArmyRank", Field, 30 );
					PlayerInfo[playerid][ArmyRank] = strval(Field);

					db_get_field_assoc(Result, "GrottiOwner", Field, 30 );
					PlayerInfo[playerid][GrottiOwner] = strval(Field);

					db_get_field_assoc(Result, "WangCarsOwner", Field, 30 );
					PlayerInfo[playerid][WangCarsOwner] = strval(Field);

					db_get_field_assoc(Result, "OttosAutosOwner", Field, 30 );
					PlayerInfo[playerid][OttosAutosOwner] = strval(Field);

					db_get_field_assoc(Result, "AutobahnOwner", Field, 30 );
					PlayerInfo[playerid][AutobahnOwner] = strval(Field);

					db_get_field_assoc(Result, "AerobahnOwner", Field, 30 );
					PlayerInfo[playerid][AerobahnOwner] = strval(Field);

					db_get_field_assoc(Result, "SteamboatWillysOwner", Field, 30 );
					PlayerInfo[playerid][BriefcaseWeaponAmmoSlot3] = strval(Field);

					db_get_field_assoc(Result, "LSDrugHouseOwner", Field, 30 );
					PlayerInfo[playerid][LVDrugHouseOwner] = strval(Field);

					db_get_field_assoc(Result, "SFDrugHouseOwner", Field, 30 );
					PlayerInfo[playerid][SFDrugHouseOwner] = strval(Field);

					db_get_field_assoc(Result, "LVDrugHouseOwner", Field, 30 );
					PlayerInfo[playerid][LVDrugHouseOwner] = strval(Field);

					db_get_field_assoc(Result, "LSAirportOwner", Field, 30 );
					PlayerInfo[playerid][LSAirportOwner] = strval(Field);

					db_get_field_assoc(Result, "SFAirportOwner", Field, 30 );
					PlayerInfo[playerid][SFAirportOwner] = strval(Field);

					db_get_field_assoc(Result, "LVAirportOwner", Field, 30 );
					PlayerInfo[playerid][LVAirportOwner] = strval(Field);

					db_get_field_assoc(Result, "YugoAirportOwner", Field, 30 );
					PlayerInfo[playerid][YugoAirportOwner] = strval(Field);

					ResetPlayerMoney(playerid);
					GivePlayerMoney(playerid, PlayerInfo[playerid][Money]);

					SetPlayerScore(playerid, PlayerInfo[playerid][Score]);

					new string[128];
					format(string, sizeof(string), "You have successfully logged in!");
					SendClientMessage(playerid, ~1, string);

					PlayerInfo[playerid][Logged] = true;
				}
				else SendClientMessage(playerid, ~1, "Your password does not match the password in the database! Please try again!");
				db_free_result(Result);
			}
			else
			{
				new string[129];
				format(string, sizeof(string), "Account %s does not exist in the database! Use /register <password>", PlayerName(playerid));
				SendClientMessage(playerid, ~1, string);
			}
			db_free_result(Result);
		}
		else
		{
		    SendClientMessage(playerid, ~1, "You have to enter a password");
			ShowLoginScreen(playerid);
			return 1;
		}
	}
	return 1;
}

stock ShowRegisterScreen(playerid)
{
    new string[100];
    format(string, sizeof(string), "Welcome to the server %s\nThis server requires you to register an account before playing",PlayerName(playerid));
	ShowPlayerDialog(playerid,DIALOG_REGISTER,DIALOG_STYLE_INPUT,"Registration",string,"Register","Cancel");
	return 1;
}

public OnPlayerConnect(playerid)
{
	new Query[256], DBResult:Result ;

	format(Query, sizeof(Query), "SELECT * FROM `Users` WHERE `Name` = '%s'", PlayerName(playerid));
	Result = db_query(Database,Query);

	if(db_num_rows(Result))
	ShowLoginScreen(playerid);
	else
	ShowRegisterScreen(playerid);

	db_free_result(Result);

	PlayerInfo[playerid][Logged] = false;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerInfo[playerid][Logged])
	{
		new Query[256] ;
		format(Query, sizeof(Query), "UPDATE `Users` SET (`Money` = '%d', `Score` = '%d') WHERE `Name` = '%s'",PlayerInfo[playerid][Money], PlayerInfo[playerid][Score], PlayerName(playerid));
		db_free_result(db_query(Database, Query));
		PlayerInfo[playerid][Logged] = false;
	}
	return 1;
}

GetPlayerIPEx(playerid)
{
	new IP[24];
	GetPlayerIp(playerid, IP, 24);
	return IP;
}

stock PlayerName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid,name,MAX_PLAYER_NAME);
    return name;
}
