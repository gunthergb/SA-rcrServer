#include <a_samp>

// Server Time
static i_ServerSeconds;
static i_ServerMinutes;
static i_ServerHour;
static i_ServerHours;
static i_ServerDays;
static i_ServerWeeks;

// Server Time
SetTimer("ProcessGameTime",1000, true);

// Server Time
forward ProcessGameTime();
public ProcessGameTime()
{
	i_ServerSeconds++;
	if(i_ServerSeconds == 60)
	{
		i_ServerSeconds = 0;
		i_ServerMinutes++;
		if(i_ServerMinutes == 60)
		{
			i_ServerMinutes = 0;
			i_ServerHour++;
			i_ServerHours++;
			if(i_ServerHour == 0 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 1 AM");
			    SetWorldTime(1);
			}
			if(i_ServerHour == 1 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 2 AM");
			    SetWorldTime(2);
			}
			if(i_ServerHour == 2 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 3 AM");
			    SetWorldTime(3);
			}
			if(i_ServerHour == 3 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 4 AM");
			    SetWorldTime(4);
			}
			if(i_ServerHour == 4 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 5 AM");
			    SetWorldTime(5);
			}
			if(i_ServerHour == 5 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 6 AM");
			    SetWorldTime(6);
			}
			if(i_ServerHour == 6 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 7 AM");
			    SetWorldTime(7);
			}
			if(i_ServerHour == 7 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 8 AM");
			    SetWorldTime(8);
			}
			if(i_ServerHour == 8 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 9 AM");
			    SetWorldTime(9);
			}
			if(i_ServerHour == 9 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 10 AM");
			    SetWorldTime(10);
			}
			if(i_ServerHour == 10 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 11 AM");
			    SetWorldTime(11);
			}
			if(i_ServerHour == 11 && i_ServerHours == 0)
			{
			    SendClientMessageToAll(0x2587CEAA,"Game Time: 12 AM");
			    SetWorldTime(12);
			}
			if(i_ServerHour == 0 && i_ServerHours == 12)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 1 PM");
                SetWorldTime(13);
			}
			if(i_ServerHour == 1 && i_ServerHours == 13)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 2 PM");
                SetWorldTime(14);
			}
			if(i_ServerHour == 2 && i_ServerHours == 14)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 3 PM");
                SetWorldTime(15);
			}
			if(i_ServerHour == 3 && i_ServerHours == 15)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 4 PM");
                SetWorldTime(16);
			}
			if(i_ServerHour == 4 && i_ServerHours == 16)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 5 PM");
                SetWorldTime(17);
			}
			if(i_ServerHour == 5 && i_ServerHours == 17)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 6 PM");
                SetWorldTime(18);
			}
			if(i_ServerHour == 6 && i_ServerHours == 18)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 7 PM");
                SetWorldTime(19);
			}
			if(i_ServerHour == 7 && i_ServerHours == 19)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 8 PM");
                SetWorldTime(20);
			}
			if(i_ServerHour == 8 && i_ServerHours == 20)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 9 PM");
                SetWorldTime(21);
			}
			if(i_ServerHour == 9 && i_ServerHours == 21)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 10 PM");
                SetWorldTime(22);
			}
			if(i_ServerHour == 10 && i_ServerHours == 22)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 11 PM");
                SetWorldTime(23);
			}
			if(i_ServerHour == 11 && i_ServerHours == 23)
			{
                SendClientMessageToAll(0x2587CEAA,"Game Time: 12 PM");
                SetWorldTime(24);
			}
			if(i_ServerHour == 11 && i_ServerHours == 23 && i_ServerMinutes == 59)
			{
			    i_ServerHour = 0;
			    i_ServerHours++;
			    i_ServerMinutes = 0;
			}
			if(i_ServerHours == 24)
			{
				i_ServerHour = 0;
				i_ServerHours = 0;
				i_ServerDays++;
				if(i_ServerDays == 0)
				{
					SendClientMessageToAll(0x2587CEAA,"Game Day: Monday");
				}
				if(i_ServerDays == 1)
				{
				    SendClientMessageToAll(0x2587CEAA,"Game Day: Tuesday");
				|
				if(i_ServerDays == 2)
				{
				    SendClientMessageToAll(0x2587CEAA,"Game Day: Wednesday");
				}
				if(i_ServerDays == 3)
				{
				    SendClientMessageToAll(0x2587CEAA,"Game Day: Thursday");
				}
				if(i_ServerDays == 4)
				{
				    SendClientMessageToAll(0x2587CEAA,"Game Day: Friday");
				}
				if(i_ServerDays == 5)
				{
				    SendClientMessageToAll(0x2587CEAA,"Game Day: Saturday");
				}
				if(i_ServerDays == 6)
				{
					SendClientMessageToAll(0x2587CEAA,"Game Day: Sunday");
				}
				if(i_ServerDays == 6)
				{
				    i_ServerDays = 0;
				    i_ServerWeeks++;
				    if(i_ServerWeeks == 0)
				    {
                        SendClientMessageToAll(0x2587CEAA,"Game Week: 1");
					}
					if(i_ServerWeeks == 1)
					{
					    SendClientMessageToAll(0x2587CEAA,"Game Week: 2");
					}
					if(i_ServerWeeks == 2)
					{
					    SendClientMessageToAll(0x2587CEAA,"Game Week: 3");
					{
					if(i_ServerWeeks == 3)
					{
					    SendClientMessageToAll(0x2587CEAA,"Game Week: 4");
					}
				    if(i_ServerHours == 23 && i_ServerDays == 7 && i_ServerWeeks == 3)
					{
					    SendClientMessageToAll(0x2587CEAA,"*AutoAdmin: This month is over. The gamemode will restart in one game hour");
						SendClientMessageToAll(0x2587CEAA,"*AutoAdmin: Dont forget to visit our website at www.SArcr.com");
					}
				    if(i_ServerHours == 0 && i_ServerDays == 7 && i_ServerWeeks == 4)
				    {
				        SendRconCommand("gmx");
					}
				}
			}
		}
	}
}

stock UpdatePlayerTime(playerid)
{
	SetPlayerTime(playerid, i_ServerHour, i_ServerMinutes);
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	UpdatePlayerTime(playerid);
}
