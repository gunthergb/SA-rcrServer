#include <a_samp>
#include <streamer>
#include <zcmd>

/*
Scriptname : S.W.A.T Rope
Version : 1.0
Copyright : Trooper (c) 2009
Release : German & English
Contact : ICQ 255070270, EMAIL Nicolas.Giese@web.de, www.Nicksoft.biz
Credits : Blackfox_UD -> Streamer
*/

//===[Config]===//
#define MAX_ROPES 20 //how many ropes server should contain (increasing number,decreases server power)
#define catchtimer 1000 //in ms, time to calculate height
#define maxping 300 //highest ping of sliding units, dont set too high, or death-bugs will increase
#define falltime 25 //low = the best, but beware of server weakness (25 isnt incredible high, think, that you slide around 2-5 secs)
#define MAX_LENGTH 100 //in meter, after what amount of meters you start falling (and rope ends)... Increasing will take server power and realism
#define stopheight 6 //at what height above ground should player get stopped ?

//===[Don't edit unless you know what you're doing]===//
new Float:tempx[MAX_PLAYERS],
	Float:tempy[MAX_PLAYERS],
	Float:tempz[MAX_PLAYERS],
	Float:tempa[MAX_PLAYERS],
	Float:lowz[MAX_PLAYERS],
	vworld[MAX_PLAYERS],
	chopper[MAX_PLAYERS],
	Float:tx[MAX_PLAYERS],
	Float:ty[MAX_PLAYERS],
	Float:tz[MAX_PLAYERS],
	Text:blind,
	Float:helix[MAX_PLAYERS],
	Float:heliy[MAX_PLAYERS],
	Float:heliz[MAX_PLAYERS],
	Rope[9999][MAX_PLAYERS],
	IsPlayerSliding[MAX_PLAYERS],
	tempplayerid[MAX_PLAYERS],
	notstarted[MAX_PLAYERS];
	
forward lowzcatch(playerid,Float:x2,Float:y2,Float:z2);
forward SetPosTimer(playerid);
forward CheckRope(heliid,Float:ropex,Float:ropey,Float:ropez);
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_ORANGE 0xFF9900FF
#define COLOR_BLUE 0x0000FF00


public OnFilterScriptInit()
{
    TextDrawUseBox(blind,1);
    TextDrawBoxColor(blind,0x000000FF);
    TextDrawTextSize(blind,641.000000,10.000000);
    TextDrawAlignment(blind,0);
    TextDrawBackgroundColor(blind,0x00000000);
    TextDrawFont(blind,3);
    TextDrawLetterSize(blind,1.000000,51.000000);
    TextDrawColor(blind,0x000000AA);
    TextDrawSetOutline(blind,1);
    TextDrawSetProportional(blind,1);
    TextDrawSetShadow(blind,1);
    print("\n--------------------------------------");
    print(" Rope RC1 v1 (c) Trooper 2009");
    print("--------------------------------------\n");
    for(new p=0; p<MAX_ROPES; p++)
    {
        for(new i=0; i<MAX_LENGTH; i++)
        { //alte model id = 338
            Rope[i][p] = CreateDynamicObject(3004,0,0,-90000-i,87.640026855469,342.13500976563, 350.07507324219);
        }
    }
    return 1;
}

public OnFilterScriptExit()
{
    TextDrawDestroy(blind);
    for(new p=0; p<MAX_ROPES; p++)
    {
        for(new i=0; i<MAX_LENGTH; i++)
        {
            DestroyDynamicObject(Rope[i][p]);
        }
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
    IsPlayerSliding[playerid] = 0,tempplayerid[playerid] = -1,notstarted[playerid] = 0;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    TextDrawHideForPlayer(playerid,blind);
    return 1;
}

public OnPlayerUpdate(playerid)
{
	Streamer_Update(playerid);
 	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(IsPlayerSliding[playerid] != 0)
   	{
	    SendClientMessage(playerid,COLOR_ORANGE,"Your hands slipped from the rope.");
	    for(new i=0; i<MAX_LENGTH; i++)
		{
	        SetDynamicObjectPos(Rope[i][tempplayerid[playerid]],0,0,-90000);
	    	notstarted[playerid] = 0;
		}
	    IsPlayerSliding[playerid] = 0;
	    IsPlayerSliding[tempplayerid[playerid]] = 0;
	    ClearAnimations(playerid);
    }
	return 1;
}

public CheckRope(heliid,Float:ropex,Float:ropey,Float:ropez)
{
    if(!HeliToPoint(5,heliid,ropex,ropey,ropez))
    {
        for(new p=0; p<MAX_PLAYERS; p++) // rope rei?en
        {
            if(IsPlayerConnected(p) && IsPlayerSliding[p] == heliid)
            {
	            //OnPlayerSnatchRope
                //end
                IsPlayerSliding[p] = 0;
                GameTextForPlayer(p,"Rope snatched",1000,1);
                ClearAnimations(p);
	            notstarted[p] = 0;
                IsPlayerSliding[tempplayerid[p]] = 0;
                for(new i=0; i<MAX_LENGTH; i++)
                {
                    SetDynamicObjectPos(Rope[i][tempplayerid[p]],0,0,-90000+i);
                }
            }
        }
    }
    else
    {
 		SetTimerEx("CheckRope",500,0,"ifff",heliid,ropex,ropey,ropez);
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_SUBMISSION && GetPlayerState(playerid) == 3 && IsPlayerSliding[playerid] == 0 && notstarted[playerid] == 0)
    {
        if(GetPlayerPing(playerid) > maxping) { return GameTextForPlayer(playerid,"Your ping is too high!",1000,1); }
        if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 497 && GetPlayerSkin(playerid) == 285)
        {
            //OnPlayerStartSliding (use for other conditions)
            //end
            for(new p=0; p<MAX_ROPES; p++)
            {
	            if(IsPlayerSliding[p] == 0) { tempplayerid[playerid] = p; }
            }
            if(tempplayerid[playerid] == -1) { return GameTextForPlayer(playerid,"Technical Problem",1000,1); }
            GetVehiclePos(GetPlayerVehicleID(playerid),helix[playerid],heliy[playerid],heliz[playerid]);
            IsPlayerSliding[playerid] = GetPlayerVehicleID(playerid);
            IsPlayerSliding[tempplayerid[playerid]] = 1;
            notstarted[playerid] = 2;
            GetPlayerPos(playerid,tempx[playerid],tempy[playerid],tempz[playerid]); //alte position speichern
            GetPlayerFacingAngle(playerid,tempa[playerid]);
            SetTimerEx("CheckRope",1000,0,"ifff",GetPlayerVehicleID(playerid),helix[playerid],heliy[playerid],heliz[playerid]);
            vworld[playerid] = GetPlayerVirtualWorld(playerid);
            RemovePlayerFromVehicle(playerid); //spieler aus heli raus
            SetPlayerVirtualWorld(playerid,10);
            ApplyAnimation(playerid,"ped","abseil",4.0,0,0,0,1,0); //animation startem
            SetVehiclePos(chopper[playerid],tempx[playerid],tempy[playerid],tempz[playerid]);
            SetPlayerPosFindZ(playerid,tempx[playerid],tempy[playerid],tempz[playerid]);
            SetPlayerCameraPos(playerid,tempx[playerid],tempy[playerid]+10,tempz[playerid]+10);
            SetPlayerCameraLookAt(playerid,helix[playerid],heliy[playerid],heliz[playerid]);
            TextDrawShowForPlayer(playerid,blind);
            SetTimerEx("lowzcatch",catchtimer,0,"ifff",playerid,tempx[playerid],tempy[playerid],tempz[playerid]);
            //OnCalculateZ (use for messages or optical things)
            //end
            for(new i=0; i<MAX_LENGTH; i++)
            {
	            SetDynamicObjectPos(Rope[i][tempplayerid[playerid]],tempx[playerid],tempy[playerid],tempz[playerid] - i);
            }
            return 1;
        }
        return 0;
    }
    if(newkeys == KEY_SUBMISSION && GetPlayerState(playerid) == 3 && IsPlayerSliding[playerid] != 0 && notstarted[playerid] == 1)
    {
        //OnPlayerLetFall
        //end
        new Float:landex,Float:landey,Float:landez;
        GetPlayerPos(playerid,landex,landey,landez);
        SetPlayerPos(playerid,landex,landey,landez);
        IsPlayerSliding[playerid] = 0;
        IsPlayerSliding[tempplayerid[playerid]] = 0;
        notstarted[playerid] = 0;
        GameTextForPlayer(playerid,"You let yourself fall",1000,1);
        for(new i=0; i<MAX_LENGTH; i++)
        {
            SetDynamicObjectPos(Rope[i][tempplayerid[playerid]],tempx[playerid],tempy[playerid],tempz[playerid] - i);
        }
        return 1;
    }
    return 1;
}

// Uncomment if you wish to test
CMD:heli(playerid, params[])
{
    new Float:x1,Float:y1,Float:z1;
    GetPlayerPos(playerid,x1,y1,z1);
    CreateVehicle(497,x1+3,y1+3,z1,0,0,0,9999);
    return 1;
}

CMD:test(playerid, params[])
{
    SetPlayerPosFindZ(playerid,0,0,1000);
    SetPlayerSkin(playerid,285);
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success) return 0;
    return 0;
}

public SetPosTimer(playerid)
{
    if(IsPlayerSliding[playerid] == 0) { return 0; }
    //OnPlayerCheck
    //end
    GetPlayerPos(playerid,tx[playerid],ty[playerid],tz[playerid]);
    if(tz[playerid]-lowz[playerid] < stopheight && tz[playerid]-lowz[playerid] > -stopheight)
    {
        //OnPlayerReady
        //end
        new Float:temphealth;
        GetPlayerHealth(playerid,temphealth);
        if(temphealth <= 0) { return 0; }
        ClearAnimations(playerid);
        SetPlayerPos(playerid,tx[playerid],ty[playerid],tz[playerid]);
        IsPlayerSliding[playerid] = 0;
        notstarted[playerid] = 0;
        IsPlayerSliding[tempplayerid[playerid]] = 0;
        for(new i=0; i<MAX_LENGTH; i++)
        {
            SetDynamicObjectPos(Rope[i][tempplayerid[playerid]],0,0,-90000-i);
        }
        return 1;
    }
    if(heliz[playerid]-tz[playerid] > MAX_LENGTH)
	{
        //OnPlayerRopeEnd
        //end
        ClearAnimations(playerid);
        IsPlayerSliding[playerid] = 0;
        notstarted[playerid] = 0;
        IsPlayerSliding[tempplayerid[playerid]] = 0;
        GameTextForPlayer(playerid,"You've run out of rope",1000,1);
        for(new i=0; i<MAX_LENGTH; i++)
        {
            SetDynamicObjectPos(Rope[i][tempplayerid[playerid]],0,0,-90000-i);
        }
        return 1;
    }
    ApplyAnimation(playerid,"ped","abseil",4.0,0,0,0,1,0);
    SetTimerEx("SetPosTimer",falltime,0,"i",playerid);
    return 1;
}

stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    new Float:oldposx, Float:oldposy, Float:oldposz;
    new Float:tempposx, Float:tempposy, Float:tempposz;
    GetPlayerPos(playerid, oldposx, oldposy, oldposz);
    tempposx = (oldposx -x);
    tempposy = (oldposy -y);
    tempposz = (oldposz -z);
    if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
    {
        return 1;
    }
    return 0;
}

stock ObjectToPoint(Float:radi, objectid, Float:x, Float:y, Float:z)
{
    new Float:oldposx, Float:oldposy, Float:oldposz;
    new Float:tempposx, Float:tempposy, Float:tempposz;
    GetObjectPos(playerid, oldposx, oldposy, oldposz);
    tempposx = (oldposx -x);
    tempposy = (oldposy -y);
    tempposz = (oldposz -z);
    if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
    {
        return 1;
    }
    return 0;
}

stock HeliToPoint(Float:radi, heliid, Float:x, Float:y, Float:z)
{
    new Float:oldposx, Float:oldposy, Float:oldposz;
    new Float:tempposx, Float:tempposy, Float:tempposz;
    GetVehiclePos(heliid, oldposx, oldposy, oldposz);
    tempposx = (oldposx -x);
    tempposy = (oldposy -y);
    tempposz = (oldposz -z);
    if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
    {
        return 1;
    }
    return 0;
}

public lowzcatch(playerid,Float:x2,Float:y2,Float:z2)
{
    new Float:unsinnx[MAX_PLAYERS],Float:unsinny[MAX_PLAYERS];
    GetPlayerPos(playerid,unsinnx[playerid],unsinny[playerid],lowz[playerid]);
    SetPlayerPos(playerid,unsinnx[playerid],unsinny[playerid],z2-2);
    SetCameraBehindPlayer(playerid);
    SetPlayerVirtualWorld(playerid,vworld[playerid]);
    TextDrawHideForPlayer(playerid,blind);
    SetVehiclePos(chopper[playerid],unsinnx[playerid],unsinny[playerid],z2);
    SetTimerEx("SetPosTimer",300,0,"i",playerid);
    notstarted[playerid] = 1;
    return 1;
}
