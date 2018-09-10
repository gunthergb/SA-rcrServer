//============================================================================//
//=============================|CRRPG Radio In Game|==========================//
//=================================|by [DR]Sc0pe|=============================//
//============================================================================//

//============================================================================//
//                                  Requirements                              //
//============================================================================//
//  In order to run this [FS] you are going to need the following:            //
//																			  //
//	=================================                                         //
//  1.  Incognito's Audio Plugin v0.4                                         //
//  =================================                                         //
//	*	Download: http://www.mediafire.com/?oziymwywxjn                       //
//	*	SA-MP Forums Post: http://forum.sa-mp.com/showthread.php?t=82162      //
//                                                                            //
//  =========================                                                 //
//	2.	Y_Less' Sscanf Plugin                                                 //
//	=========================                                                 //
//	*	Download: http://dl.dropbox.com/u/21683085/sscanf.zip                 //
//	*	SA-MP Forums Post: http://forum.sa-mp.com/showthread.php?t=120356     //
//                                                                            //
//	===============                                                           //
//	3.	Zeex's ZCMD                                                           //
//	===============                                                           //
//	*	Download: http://zeex.pastebin.ca/1650602                             //
//	*	SA-MP Forums Post: http://forum.sa-mp.com/showthread.php?t=91354      //
//                                                                            //
//============================================================================//
//                              End of Requirements                           //
//============================================================================//

//===[Includes]===//
#include <a_samp>
#include <audio>
#include <zcmd>
#include <sscanf2>

//===[Defines (Colors)]===//
#define COLOR_GREEN 0x33AA33AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_ERROR 0xFF0000AA

//===[Defines (Stream URL)]===//
#define STREAM_URL  "URLToStream"


//===[Radio Script Variables]===//
new Radio[MAX_PLAYERS];
new Listening[MAX_PLAYERS];

public OnGameModeInit()
{
	Audio_CreateTCPServer(7777);
	return 1;
}
public OnGameModeExit()
{
	Audio_DestroyTCPServer();
	return 1;
}
public Audio_OnClientConnect(playerid)
{
	new string[128];
	format(string, sizeof(string), "Audio client ID %d connected", playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	Audio_TransferPack(playerid);
	return 1;
}
public Audio_OnClientDisconnect(playerid)
{
	new string[128];
	format(string, sizeof(string), "Audio client ID %d disconnected", playerid);
	SendClientMessageToAll(COLOR_YELLOW, string);
	Audio_Stop(playerid,Radio[playerid]);
	return 1;
}
public Audio_OnTrackChange(playerid, handleid, track[])
{
	new	string[128];
	format(string, sizeof(string), "Now Playing: {FF9900}%s on CRRPG Radio", track);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
}
//===[Radio Script]===//
CMD:listen(playerid, params[])
{
	/*if(Audio_IsClientConnected(playerid))
    {
    	Radio[playerid] = Audio_PlayStreamed(playerid, STREAM_URL, false, false, false);
    	SendClientMessage(playerid, COLOR_LIGHTBLUE, "You are now listening to CRRPG Radio. Use /stopradio to stop listening.");
       	return 1;
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Audio Bot: {FFFFFF}You are not connected to the audio server");
    	SendClientMessage(playerid, COLOR_YELLOW, "You may need to install the audio client, please visit the forums.");
    	return 1;
	}*/
}
CMD:stopradio(playerid, params[])
{
	//PlayAudioStreamForPlayer(playerid, "
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Audio Bot: {FFFFFF}You have shut off the Radio");
	/*if(Audio_IsClientConnected(playerid))
    {
    	if(Listening[playerid] == 1)
		{
		    Audio_Stop(playerid, Radio[playerid]);
   			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Audio Bot: {FFFFFF}You have shut off the Radio");
		    return 1;
		}
		else return SendClientMessage(playerid, COLOR_LIGHTBLUE, "Audio Bot: {FFFFFF}You aren't listening to any radio stations");
	}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTBLUE, "Audio Bot: {FFFFFF}You are not connected to the audio server");
    	SendClientMessage(playerid, COLOR_WHITE, "You may need to install the audio client, please visit the forums.");
    	return 1;
	}*/
}
/*CMD:volume(playerid, params[])
{
    new vol, string[128];
    if(sscanf(params, "i", vol)) return SendClientMessage(playerid, COLOR_ORANGE, "USAGE: {33CCFF}/volume [1-100]");
    if(vol < 0 || vol > 100) return SendClientMessage(playerid, COLOR_ORANGE, "USAGE: {33CCFF}/volume [1-100]");
    Audio_SetVolume(playerid, Radio[playerid], vol);
    format(string, sizeof(string), "Audio Bot: {FFFFFF}Volume has been changed to %d", vol);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}*/
