#include <a_samp>
#include <SpikeStrip>

#define COLOR_GREEN 0x33AA33AA

strtok(const string[], &index)
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
//You can test it now xDD Ok :D
public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256];
	new idx;
	cmd = strtok(cmdtext, idx);

	if (strcmp(cmd,"/ms",true) == 0)
	{
	    new name[MAX_PLAYER_NAME];
	    new Float:plocx,Float:plocy,Float:plocz,Float:ploca;
        GetPlayerPos(playerid, plocx, plocy, plocz);
        GetPlayerFacingAngle(playerid,ploca);
        GetPlayerName(playerid, name, sizeof(name));
        CreateStrip(name, plocx,plocy,plocz,ploca);
	    return 1;
	}
	if (strcmp(cmd,"/ds",true) == 0)
	{
        DeleteClosestStrip(playerid);
        return 1;
    }
	return 0;
}
