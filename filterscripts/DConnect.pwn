#define FILTERSCRIPT
#include <a_samp>
#define CHANNEL_ID "487093414756876302" // Change this to your channel id
#include <discord-connector>
#include <zcmd>
#include <sscanf2>
#include <YSI\y_va>

//////////////////////////////////////////
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_RED 0xAA3333AA

/////////////////////////////////////////


new DCC_Channel:BotChannel;
new DiscordStats[MAX_PLAYERS];
new Spawned[MAX_PLAYERS];

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Discord Connector Filterscript ~ Inferno");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()


#endif


forward DCC_OnChannelMessage(DCC_Channel:channel, DCC_User:author, const message[]);
forward SendDC(channel[], const fmat[], va_args<>);

public OnGameModeInit()
{
    return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerConnect(playerid)
{
	Spawned[playerid] = 0;
	return 1;
}

public SendDC(channel[], const fmat[], va_args<>)
{
    new str[145];
    va_format(str, sizeof (str), fmat, va_start<2>);
	BotChannel = DCC_FindChannelById(channel);
    return DCC_SendChannelMessage(BotChannel, str);
}

public OnPlayerSpawn(playerid)
{
    Spawned[playerid] = 1;
	return 1;
}

public DCC_OnChannelMessage(DCC_Channel:channel, DCC_User:author, const message[])
{
	new channel_name[100 + 1];
	if(!DCC_GetChannelName(channel, channel_name))
		return 0;

	new user_name[32 + 1];
	if (!DCC_GetUserName(author, user_name))
		return 0;

    if(channel != BotChannel) return 0;
	new str[145];
	format(str, sizeof str, "{667aca}[Discord/%s] %s:{ffffff} %s", channel_name, user_name, message);
    for(new i = 0; i < MAX_PLAYERS; i++) {
    if (DiscordStats[i]==0) continue;
    SendClientMessage(i, -1, str); }

    return 1;
}

CMD:dchat(playerid, params[])
{
	new tmp[512], name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	if (Spawned[playerid] == 0) return SendClientMessage(playerid, COLOR_WHITE, "Server: You must be spawned to use this command!");
	if (DiscordStats[playerid]==0) return SendClientMessage(playerid, COLOR_WHITE, "Server: Turn on Discord Chat using /dchaton.");
	if (sscanf(params, "s[512]", tmp)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /dchat [message]");
	SendDC(CHANNEL_ID, "[chat]%s: %s ", name, tmp);
	return 1;
}

CMD:dchaton(playerid, params[])
{
	new playername[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
	if (Spawned[playerid] == 0) return SendClientMessage(playerid, COLOR_WHITE, "Server: You must be spawned to use this command!");
	if (DiscordStats[playerid]==1) return SendClientMessage(playerid, COLOR_WHITE, "Server: Discord Chat is already switched on!");
	DiscordStats[playerid]=1;
	SendClientMessage(playerid, COLOR_WHITE, "Server: Discord Chat turned on.");
	return 1;
}

CMD:dchatoff(playerid, params[])
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	if (Spawned[playerid] == 0) return SendClientMessage(playerid, COLOR_WHITE, "Server: You must be spawned to use this command!");
	if (DiscordStats[playerid]==0) return SendClientMessage(playerid, COLOR_WHITE, "Server: Discord Chat is already switched off!");
	DiscordStats[playerid]=0;
	SendClientMessage(playerid, COLOR_WHITE, "Server: Discord Chat turned off.");
	return 1;
}

