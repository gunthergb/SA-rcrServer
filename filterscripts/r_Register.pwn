/*



						r_MySQL Register v0.1
						     By Raimis_R
						     
						     
																				*/





#define FILTERSCRIPT

#include <a_samp>
#include "../pawno/include/a_mysql.inc"

enum data{

	pName[MAX_PLAYER_NAME],
	pIp[17],
	pPassword,
	pMoney
}
new pInfo[MAX_PLAYERS][data];


// You'r MySQL configuration settings

#define MySQL_HOST "localhost"
#define MySQL_USER "root"
#define MySQL_DATA "sa-mp"
#define MySQL_PASS ""

new Security[MAX_PLAYERS];

new Text:Picture[MAX_PLAYERS];

native sscanf(const data[], const format[], {Float,_}:...);
native unformat(const data[], const format[], {Float,_}:...) = sscanf;


public OnFilterScriptInit()
{
	mysql_debug(true);
	print("FilterScript r_Register Loading...");
	mysql_connect(MySQL_HOST,MySQL_USER,MySQL_DATA,MySQL_PASS);
	if(mysql_ping()>=1)
	{
	    print("MySQL Connected sucesfull");

	}
	else
	{
	    print("Cannot connect to MySQL");
	    SendRconCommand("exit");
	}
	for(new playerid = 0; playerid != MAX_PLAYERS; playerid++)
	{
	 	Picture[playerid] = TextDrawCreate(38.000000, 161.000000, "_");
		TextDrawBackgroundColor(Picture[playerid], 255);
		TextDrawFont(Picture[playerid], 1);
		TextDrawLetterSize(Picture[playerid], 0.500000, 2.000000);
		TextDrawColor(Picture[playerid], 16711935);
		TextDrawSetOutline(Picture[playerid], 1);
		TextDrawSetProportional(Picture[playerid], 1);
	}
	return 1;
}

public OnFilterScriptExit()
{
	print("FilterScript r_Register UnLoaded....");
	mysql_close();
	return 1;
}


public OnPlayerConnect(playerid)
{
	
	new Query[300];
	format(Query,sizeof(Query),"SELECT `Name` FROM `players` WHERE `Name` = '%s'",GetPlayerEscapeName(playerid));
	mysql_query(Query);
	mysql_store_result();
	if(mysql_num_rows())
	{
		format(Query,sizeof(Query),"SELECT `Ip` FROM `players` WHERE `Ip` = '%s'",GetPlayerIpEx(playerid));
		mysql_query(Query);
        mysql_store_result();
		if(mysql_num_rows())
		{
			LoadPlayerVariables(playerid);
		}
		else
		{
		    ShowPlayerDialog(playerid,666,DIALOG_STYLE_INPUT,"Password","Your IP adress is not same as register ip adress, please enter your password to continue","Enter","Close");
		}
	}
	else
	{
		ShowPlayerDialog(playerid,100,DIALOG_STYLE_INPUT,"Security","Please enter security code from image \nThis is security metod to make sure that you are human.","Enter","Close");
		TextDrawShowForPlayer(playerid,Picture[playerid]);
		GenerateTextInPicture(playerid);
	}
	mysql_free_result();
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	switch(reason)
	{
	    case 0: SavePlayerVariables(playerid);
	    case 1: SavePlayerVariables(playerid);
	    case 2: SavePlayerVariables(playerid);
	}
	TextDrawHideForPlayer(playerid,Picture[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawHideForPlayer(playerid,Picture[playerid]);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 666)
	{
		if(!response)
		{
		    Kick(playerid);
		}
	    if(response)
	    {
			new Pass = strval(inputtext);
	        if(!strlen(inputtext))
	            return ShowPlayerDialog(playerid,666,DIALOG_STYLE_INPUT,"Password","Your IP adress is not same as register ip adress, please enter your password to continue","Enter","Close");
			new Query[200];
			format(Query,sizeof(Query),"SELECT * FROM `players` WHERE `Name` = '%s' AND `Password` = '%i'",GetPlayerEscapeName(playerid),Pass);
			mysql_query(Query);
			mysql_store_result();
			
			if( mysql_num_rows())
			{
			    LoadPlayerVariables(playerid);
				SendClientMessage(playerid,0xFF63DAFF,"* You Logged in!");
			}
			else
			{
			    Kick(playerid);
			}
		}
		mysql_free_result();
		return 1;
	}
	if(dialogid == 100)
	{
	    if(response)
	    {
	        new Text = strval(inputtext);
	        if(Text != Security[playerid])
	        {
	            if(!strlen(inputtext))
	                return ShowPlayerDialog(playerid,100,DIALOG_STYLE_INPUT,"Security","Please enter security code from image \nThis is security metod to make sure that you are human.","Enter","Close");
	            SendClientMessage(playerid,-1,"* Code from image is not valid!");
		    	ShowPlayerDialog(playerid,100,DIALOG_STYLE_INPUT,"Security","Please enter security code from image \nThis is security metod to make sure that you are human.","Enter","Close");
			    GenerateTextInPicture(playerid);
			}
			else
			{
			    SendClientMessage(playerid,-1,"* Please wait generating password....");
				GeneratePassword(playerid);
				TextDrawHideForPlayer(playerid,Picture[playerid]);
   				
			}
		}
		if(!response)
		{
 			SendClientMessage(playerid,-1,"* Code from image is not valid!");
   			ShowPlayerDialog(playerid,100,DIALOG_STYLE_INPUT,"Security","Please enter security code from image \nThis is security metod to make sure that you are human.","Enter","Close");
		}
		return 1;
	}
	return 1;
}

stock SavePlayerVariables(playerid)
{
	new Query[200];
	format(Query,sizeof(Query),"UPDATE `players` SET `Money` = '%i' WHERE `Name` = '%s'",GetPlayerMoney(playerid),GetPlayerEscapeName(playerid));
	mysql_query(Query);
}

stock LoadPlayerVariables(playerid)
{
	new Query[200];
	
	mysql_fetch_row_format(Query,"|");
	sscanf(Query,"p<|>s[24]s[17]ii",
	pInfo[playerid][pName],
	pInfo[playerid][pIp],
	pInfo[playerid][pPassword],
	pInfo[playerid][pMoney]);
	
	GivePlayerMoney(playerid,pInfo[playerid][pMoney]);
}

stock GeneratePassword(playerid)
{
	new Query[300],
	Password = random(98*98);
	format(Query,sizeof(Query),"INSERT INTO `players` (Name,Ip,Password) VALUES ('%s','%s','%i')",GetPlayerEscapeName(playerid),GetPlayerIpEx(playerid),Password);
	mysql_query(Query);
	new String[50];
	format(String,sizeof(String),"* You'r password: %i",Password);
	SendClientMessage(playerid,0xFF63DAFF,String);
}

stock GenerateTextInPicture(playerid)
{
	new Code = random(98*98);
	Security[playerid] = Code;
	new
		String[5];
	format(String,sizeof(String),"%i",Code);
	TextDrawSetString(Picture[playerid],String);
	TextDrawShowForPlayer(playerid,Picture[playerid]);
}



stock GetPlayerIpEx(playerid)
{
	new Ip[17];
	GetPlayerIp(playerid,Ip,17);
	return Ip;
}

stock GetPlayerEscapeName(playerid)
{
	new Name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,Name,MAX_PLAYER_NAME);
	mysql_real_escape_string(Name,Name);
	return Name;
}
