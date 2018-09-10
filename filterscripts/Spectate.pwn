/*******************************************************************************
 Spectate System (With player scrolling and automatic vehicle changes)
 Created 2007 - HAMM3R
 -
 Original code by kyeman - 2007
 Update to 0.2.1 R2 by tafi
*******************************************************************************/

#include <a_samp>

#define COLOR_BASIC 0x0066FFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_GREY 0xAFAFAFAA

#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2

new gSpectateID[MAX_PLAYERS];
new gSpectateType[MAX_PLAYERS];


//Advance players by keypress
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && gSpectateID[playerid] != INVALID_PLAYER_ID) {
		if(newkeys == KEY_JUMP) {
			AdvanceSpectate(playerid);
		}
		else if(newkeys == KEY_SPRINT) {
	    	ReverseSpectate(playerid);
		}
	}
	return 1;
}

public OnFilterScriptInit()
{
    print("   Loaded successful.");
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	// IF ANYONE IS SPECTATING THIS PLAYER, WE'LL ALSO HAVE
	// TO CHANGE THEIR INTERIOR ID TO MATCH
	new x = 0;
	while(x!=MAX_PLAYERS) {
	    if( IsPlayerConnected(x) &&	GetPlayerState(x) == PLAYER_STATE_SPECTATING &&
			gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_PLAYER )
   		{
   		    SetPlayerInterior(x,newinteriorid);
		}
		x++;
	}
}

//Check commands typed
public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256];
	new specid, idx;

	cmd = adminspec_strtok(cmdtext, idx);

 	if(strcmp(cmd, "/spec", true) == 0) {
	    new tmp[256];
		tmp = adminspec_strtok(cmdtext, idx);

		if(!strlen(tmp)) {
			SendClientMessage(playerid, COLOR_GREY, "Correct usage: /spec [playerid]");
			return 1;
		}
		specid = strval(tmp);

		if(!IsPlayerConnected(specid)) {
			SendClientMessage(playerid, COLOR_GREY, "-Spectate- Usage: /spec <id>");
			return 1;
		}
		if(specid == playerid) {
  			SendClientMessage(playerid, COLOR_RED, "You cannot spectate yourself");
			return 1;
		}
		if(GetPlayerState(specid) == PLAYER_STATE_SPECTATING && gSpectateID[specid] != INVALID_PLAYER_ID) {
	   		SendClientMessage(playerid, COLOR_RED, "Spectate: Player spectating someone else");
	   		return 1;
		}
		if(GetPlayerState(specid) != 1 && GetPlayerState(specid) != 2 && GetPlayerState(specid) != 3) {
 			SendClientMessage(playerid, COLOR_RED, "Player isn't spawned.");
	   		return 1;
		}

		StartSpectate(playerid, specid);

 		return 1;
	}
 	if(strcmp(cmd, "/specoff", true) == 0) {
 	    StopSpectate(playerid);
		return 1;
	}
	return 0;
}

//Automatically switch to vehicle spec mode when user enters vehicle
public OnPlayerEnterVehicle(playerid, vehicleid) {
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] == playerid) {
	        TogglePlayerSpectating(x, 1);
	        PlayerSpectateVehicle(x, vehicleid);
	        gSpectateType[x] = ADMIN_SPEC_TYPE_VEHICLE;
		}
	}
	return 1;
}

//Automatically switch to player spec mode when user exits vehicle
public OnPlayerExitVehicle(playerid, vehicleid) {
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_VEHICLE) {
	        TogglePlayerSpectating(x, 1);
	        PlayerSpectatePlayer(x, playerid);
	        gSpectateType[x] = ADMIN_SPEC_TYPE_PLAYER;
		}
	}
	return 1;
}

//Sacky's function modified.  makes falls from bikes register as vehicle exit
public OnPlayerStateChange(playerid, newstate, oldstate){
	switch(newstate){
		case PLAYER_STATE_ONFOOT:{
			switch(oldstate){
				case PLAYER_STATE_DRIVER:OnPlayerExitVehicle(playerid,255);
				case PLAYER_STATE_PASSENGER:OnPlayerExitVehicle(playerid,255);
			}
		}
	}
	return 1;
}

//Advances to next ID when current spectated player dies
public OnPlayerDeath(playerid, killerid, reason)
{
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] == playerid) {
	       AdvanceSpectate(x);
		}
	}
	return 1;
}

//Advances to next ID when current spectated player quits the server
public OnPlayerDisconnect(playerid, reason)
{
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] == playerid) {
	       AdvanceSpectate(x);
		}
	}
	return 1;
}

//Spec a player
stock StartSpectate(playerid, specid)
{
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] == playerid) {
	       AdvanceSpectate(x);
		}
	}
	if(IsPlayerInAnyVehicle(specid)) {
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specid));
		gSpectateID[playerid] = specid;
		gSpectateType[playerid] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else {
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, specid);
		gSpectateID[playerid] = specid;
		gSpectateType[playerid] = ADMIN_SPEC_TYPE_PLAYER;
	}
	new string[100], name[24];
	GetPlayerName(specid,name,sizeof(name));
	format(string,sizeof(string),"~n~~n~~n~~n~~n~~n~~n~~n~~w~%s - ID:%d~n~< Sprint - Jump >", name,specid);
	GameTextForPlayer(playerid,string,9999999999,3);
	return 1;
}

//Stop spectating
stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	gSpectateID[playerid] = INVALID_PLAYER_ID;
	gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;
	GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~w~Spectate off",1000,3);
	return 1;
}

//Advancing spectated player to next valid player: FORWARD
stock AdvanceSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && gSpectateID[playerid] != INVALID_PLAYER_ID) {
	    for(new x=gSpectateID[playerid]+1; x<=MAX_PLAYERS; x++) {
	    	if(x == MAX_PLAYERS) { x = 0; }
	        if(IsPlayerConnected(x) && x != playerid) {
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] != INVALID_PLAYER_ID ||
					(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else {
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

//Advancing spectated player to next valid player: BACKWARDS
stock ReverseSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && gSpectateID[playerid] != INVALID_PLAYER_ID) {
	    for(new x=gSpectateID[playerid]-1; x>=0; x--) {
	    	if(x == 0) { x = MAX_PLAYERS; }
	        if(IsPlayerConnected(x) && x != playerid) {
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] != INVALID_PLAYER_ID ||
					(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else {
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

//Returns number of connected players
stock ConnectedPlayers()
{
	new count;
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(IsPlayerConnected(x)) {
			count++;
		}
	}
	return count;
}

stock adminspec_strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

/*******************************************************************************
 EOF
*******************************************************************************/
