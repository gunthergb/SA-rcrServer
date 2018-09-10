/*----------------------------------------------------------------------------*\
					=======================================
					 y_playerset - Collections of players! 
					=======================================
Description:
	This code is a huge abstraction of collections of players.  It allows you to
	define functions which take one or more players, specified in a number of
	formats, and perform the code for all those player.  Essentially it is an
	abstraction of loops over players.
Legal:
	Version: MPL 1.1
	
	The contents of this file are subject to the Mozilla Public License Version 
	1.1 (the "License"); you may not use this file except in compliance with 
	the License. You may obtain a copy of the License at 
	http://www.mozilla.org/MPL/
	
	Software distributed under the License is distributed on an "AS IS" basis,
	WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
	for the specific language governing rights and limitations under the
	License.
	
	The Original Code is the YSI playerset include.
	
	The Initial Developer of the Original Code is Alex "Y_Less" Cole.
	Portions created by the Initial Developer are Copyright (C) 2011
	the Initial Developer. All Rights Reserved.
	
	Contributors:
		ZeeX, koolk, JoeBullet/Google63, g_aSlice/Slice
	
	Thanks:
		JoeBullet/Google63 - Handy arbitrary ASM jump code using SCTRL.
		ZeeX - Very productive conversations.
		koolk - IsPlayerinAreaEx code.
		TheAlpha - Danish translation.
		breadfish - German translation.
		Fireburn - Dutch translation.
		yom - French translation.
		50p - Polish translation.
		Zamaroht - Spanish translation.
		Dracoblue, sintax, mabako, Xtreme, other coders - Producing other modes
			for me to strive to better.
		Pixels^ - Running XScripters where the idea was born.
		Matite - Pestering me to release it and using it.
	
	Very special thanks to:
		Thiadmer - PAWN, whose limits continue to amaze me!
		Kye/Kalcor - SA:MP.
		SA:MP Team past, present and future - SA:MP.
	
Version:
	1.0
Changelog:
	30/04/11:
		First version
\*----------------------------------------------------------------------------*/

#include <a_samp>
#include <YSI\y_iterate>
#include <YSI\y_playerarray>
#include <YSI\y_debug>

#if !defined MAX_PLAYER_SET_STACK
    #define MAX_PLAYER_SET_STACK (3)
#endif

enum e_PLAYER_SET_HACK
{
	e_PLAYER_SET_HACK_PA[bits<MAX_PLAYERS> + 1] = 0,
	e_PLAYER_SET_HACK_DATA[MAX_PLAYERS] = 0,
	e_PLAYER_SET_HACK_EXCESS[MAX_PLAYERS - (bits<MAX_PLAYERS> + 1)]
}

enum e_PLAYER_SET_TYPE
{
	e_PLAYER_SET_TYPE_NONE = 0,
	e_PLAYER_SET_TYPE_GROUP,
	e_PLAYER_SET_TYPE_ID,
	e_PLAYER_SET_TYPE_PA,
	e_PLAYER_SET_TYPE_BOOL,
	e_PLAYER_SET_TYPE_ARRAY,
	e_PLAYER_SET_TYPE_CUSTOM
}

// ========================================================================== //
// ========================================================================== //
//         WARNING: THE CODE BELOW IS VERY FRAGILE - DO NOT TOUCH IT!         //
// ========================================================================== //
// ========================================================================== //

// DO NOT change the order of these variables!
stock
	e_PLAYER_SET_TYPE:__ps_type[MAX_PLAYER_SET_STACK char],
	__ps_stack[MAX_PLAYER_SET_STACK][MAX_PLAYERS],
	__ps_data[e_PLAYER_SET_HACK],
	__ps_pointer = -1;

/*
// DO NOT change the order of these macros!  This allows for the "PlayerVar:x"
// syntax with many parameters or only one, removing any trailing commas without
// making any assumptions about the type of the next parameter (to avoid using
// the standard _:, macro).  This works because we control function defintion
// AND function calls.  Almost every symbol in this file is double defined!
#define @PlayerVar:%0) __ps_addr_t:__ps_addr,__ps_drop_t:%0)for(new %0=__PS_S(_:__ps_addr);__PS_M(%0);__PS_N(_:__ps_addr,%0))
#define @PlayerArray:%0<%1>%2) __ps_addr_t:__ps_addr%2)for(new PlayerArray:%0<MAX_PLAYERS>;__PS_A(_:__ps_addr,%0); )

// This is VERY unportable and gready code.  It redefines "for" under certain
// circumstances...
#define for(new%0,%1=__PS_S(_:__ps_addr) for(new%0=__PS_S(_:__ps_addr)
#define __PS_M(%0,%1) __PS_M(%0)
#define __PS_N(_:__ps_addr,%0,%1) __PS_N(_:__ps_addr,%0)

// Strip excess "PlayerVar" definitions.  These are the ones which are important
// to keep in order or you can destroy parameters.
#define __ps_addr_t:__ps_addr,__ps_drop_t:%0,%1) __ps_addr_t:__ps_addr,%1)
#define __ps_addr,__ps_drop_t:%0) __ps_addr)
*/

#define @PlayerVar:%0) __ps_addr_t:__ps_addr,__ps_drop_t:%0)for(new %0=__PS_S(_:__ps_addr);__PS_M(%0);__PS_N(_:__ps_addr,%0))

// More than one parameter.  This removes the need to redefine "for", which I'm
// very happy about, by doing all detection in one go.
#define __ps_addr_t:__ps_addr,__ps_drop_t:%0,%1)for(new%2,%3=__PS_S(_:__ps_addr);__PS_M(%4,%5);__PS_N(_:__ps_addr,%6,%7)) __ps_addr_t:__ps_addr,%1)for(new%2=__PS_S(_:__ps_addr);__PS_M(%4);__PS_N(_:__ps_addr,%6))
// Only one parameter (not caught by the above statement).
#define __ps_addr,__ps_drop_t:%0) __ps_addr)

// This is not affected by any of the macros above.
#define @PlayerArray:%0<%1>%2) __ps_addr_t:__ps_addr%2)for(new PlayerArray:%0<MAX_PLAYERS>;__PS_A(_:__ps_addr,%0); )

// This code is now less fragile than before (and I understand it far more
// having done much more work with this style of macro in the interim).

// ========================================================================== //
// ========================================================================== //
//         WARNING: THE CODE ABOVE IS VERY FRAGILE - DO NOT TOUCH IT!         //
// ========================================================================== //
// ========================================================================== //

// Strip excess "PlayerSet" definitions.
//#define new%0,%1<MAX_PLAYERS>;__PS_A( new%0<MAX_PLAYERS>;__PS_A(
//#define __PS_A(_:__ps_addr,%0,%1) __PS_A(_:__ps_addr,%0)

//#define PlayerSet:%0) __ps_addr_t:__ps_addr,__ps_drop_t:%0)for(new Bit:%0<500>=__PS_A(_:__ps_addr);__ps_addr;__ps_addr=__ps_addr_t:0)
//#define PlayerVar<%0>%1) __ps_addr_t:__ps_addr %1)for(new %0=__PS_S(_:__ps_addr);__PS_M(%0);__PS_N(_:__ps_addr,%0))
//#define PlayerSet<%0>%1) __ps_addr_t:__ps_addr %1)for(new PlayerArray:%0<MAX_PLAYERS>=__PS_A(__ps_addr);__ps_addr;__ps_addr=0)

//#define new%0,%1<MAX_PLAYERS>=__PS_A(_:__ps_addr) new%0<MAX_PLAYERS>=__PS_A(_:__ps_addr)
//#define __ps_addr,__ps_drop_t:%0,%1) __ps_addr,%1)
//#define __ps_drop_t:%0) )

//#define __ps_addr,__ps_drop_t:%0,%1) __ps_addr,%1)
//#define __ps_addr,__ps_drop_t:%0,%1) __ps_addr,%1)
//#define __ps_done_t:%1) %1)
//#define __ps_addr_t:__ps_addr,%0) __ps_addr)
//#define __ps_addr_t:__ps_addr%0,%1) __ps_addr,%1)

// This function determines the type of data passed and gets the first player.
stock __PS_S(&addr)
{
	P:3("__PS_S called: %i", addr);
	// Increment the "stack" pointer.
	++__ps_pointer;
	if (__ps_pointer == MAX_PLAYER_SET_STACK)
	{
		P:E("y_playerset stack overflow - increase \"MAX_PLAYER_SET_STACK\"");
		return -1;
	}
	new
		begin = __ps_data[e_PLAYER_SET_HACK_DATA][0];
	if (addr == begin)
	{
		// Increase the stack pointer for recursive/multi-layered calls.
		// Should really add error-checking code for overflows.
		__ps_stack[__ps_pointer][0] = addr;
		// Single value - either a playerid or a groupid.
		#if defined _YSI_HAS_GROUP_SYSTEM
			if (addr & GROUP_MASK)
			{
				// Use the pre-made iterator functionality.
				__ps_type{__ps_pointer} = e_PLAYER_SET_TYPE_GROUP;
				return YSI_gSGroupFunc(addr);
			}
		#endif
		// May not always want this check - tough, they can't really have one
		// inside the function because that's just silly.
		__ps_type{__ps_pointer} = e_PLAYER_SET_TYPE_ID;
		return addr;
	}
	else
	{
		// It's an array - addr contains the address of the target.
		memcpy(__ps_stack[__ps_pointer], __ps_data[e_PLAYER_SET_HACK_DATA], 0, MAX_PLAYERS * 4);
		// Try to determine what sort of array it is.  Note that there are three
		// possible types.
		if (begin == PA_TYPE_PA)
		{
			// Easy to handle - the systems were designed for each other.
			// This one needs work...
			__ps_type{__ps_pointer} = e_PLAYER_SET_TYPE_PA;
			return YSI_gSPAFunc(Bit:__ps_stack[__ps_pointer]);
		}
		else if (begin & 0xFF0000FF == 0x0F0000F0)
		{
			__ps_type{__ps_pointer} = e_PLAYER_SET_TYPE_CUSTOM;
			addr = 0;
			return (begin >>> 8) & 0x0000FFFF;
		}
		else if (begin > 1 || __ps_data[e_PLAYER_SET_HACK_DATA][1] > 1 || __ps_data[e_PLAYER_SET_HACK_DATA][2] > 1)
		{
			// List of players.  One of the first three will normally be greater
			// than 1 in a list of players.
			__ps_type{__ps_pointer} = e_PLAYER_SET_TYPE_ARRAY;
			addr = 0;
			return begin;
		}
		else
		{
			// Boolean array.
			__ps_type{__ps_pointer} = e_PLAYER_SET_TYPE_BOOL;
			// Find the first set player.
			foreach (new i : Player)
			{
				begin = __ps_data[e_PLAYER_SET_HACK_DATA][i];
				if (begin > 1)
				{
					// Retry.
					printf("*** Internal Warning: Late PlayerArray detection");
					__ps_type{__ps_pointer} = e_PLAYER_SET_TYPE_ARRAY;
					addr = 0;
					return __ps_data[e_PLAYER_SET_HACK_DATA][0];
				}
				else if (begin == 1)
				{
					addr = i;
					return i;
				}
			}
			// No players specified.
			return -1;
		}
	}
}

// This function checks for loop end conditions.  It also cleans up after nested
// PlayerVar: function calls.
stock bool:__PS_M(cur)
{
	P:3("bool:__PS_M called: %i", cur);
	// Each mode has a different end condition.
	switch (__ps_type{__ps_pointer})
	{
		#if defined _YSI_HAS_GROUP_SYSTEM
			case e_PLAYER_SET_TYPE_GROUP:
			{
				if (cur != -1)
				{
					return true;
				}
			}
		#endif
		case e_PLAYER_SET_TYPE_BOOL, e_PLAYER_SET_TYPE_PA:
		{
			if (cur != -1)
			{
				return true;
			}
		}
		case e_PLAYER_SET_TYPE_ID:
		{
			if (PS_IS_PLAYER_CONNECTED(cur))
			{
				return true;
			}
		}
		case e_PLAYER_SET_TYPE_ARRAY, e_PLAYER_SET_TYPE_CUSTOM:
		{
			if (cur != INVALID_PLAYER_ID)
			{
				return true;
			}
		}
	}
	--__ps_pointer;
	return false;
}

// This function gets the next player in the loop.
stock __PS_N(&addr, &cur)
{
	P:3("__PS_N called: %i, %i", addr, cur);
	// Each mode has a different end condition.
	switch (__ps_type{__ps_pointer})
	{
		#if defined _YSI_HAS_GROUP_SYSTEM
			case e_PLAYER_SET_TYPE_GROUP:
			{
				cur = YSI_gAGroupFunc(addr, cur);
			}
		#endif
		case e_PLAYER_SET_TYPE_PA:
		{
			cur = YSI_gAPAFunc(Bit:__ps_stack[__ps_pointer], cur);
		}
		case e_PLAYER_SET_TYPE_BOOL:
		{
			for ( ; ; )
			{
				cur = Player_YSI_gA[cur];
				if (cur == -1 || __ps_stack[__ps_pointer][cur])
				{
					return;
				}
				// Could add extra late checks here (Error, not Warning, now).
			}
		}
		case e_PLAYER_SET_TYPE_ID:
		{
			cur = INVALID_PLAYER_ID;
		}
		case e_PLAYER_SET_TYPE_ARRAY:
		{
			do
			{
				if (++addr == MAX_PLAYERS)
				{
					cur = INVALID_PLAYER_ID;
				}
				else
				{
					cur = __ps_stack[__ps_pointer][addr];
				}
			}
			while (cur != INVALID_PLAYER_ID && !PS_IS_PLAYER_CONNECTED(cur));
		}
		case e_PLAYER_SET_TYPE_CUSTOM:
		{
			if (++addr == MAX_PLAYERS)
			{
				cur = INVALID_PLAYER_ID;
			}
			else
			{
				cur = __ps_stack[__ps_pointer][addr];
			}
		}
	}
}

// This function gets the required data from custom format (enum) arrays.
stock __PS_C(source[MAX_PLAYERS][], idx)//, size = sizeof (source []))
{
	static
		sFake[MAX_PLAYERS] = {(INVALID_PLAYER_ID << 8) | 0x0F0000F0};
	new
		ret = (__ps_data[e_PLAYER_SET_HACK_DATA] = sFake),
		e_PLAYER_SET_HACK:i = e_PLAYER_SET_HACK:0;
	foreach (new playerid : Player)
	{
		if (source[playerid][idx])
		{
			if (i)
			{
				__ps_data[i++] = playerid;
			}
			else
			{
				__ps_data[i++] = (playerid << 8) | 0x0F0000F0;
			}
		}
	}
	if (i < e_PLAYER_SET_HACK:MAX_PLAYERS)
	{
		__ps_data[i] = INVALID_PLAYER_ID;
	}
	return ret;
}

// This function converts a playerset to a playerarray.
stock __PS_A(addr, PlayerArray:ret<MAX_PLAYERS>)
{
	P:3("__PS_A called: %i, %s", addr, Bit_Display(Bit:ret[1]));
	if (ret[0])
	{
		return 0;
	}
	new
		begin = __ps_data[e_PLAYER_SET_HACK_DATA][0];
	if (addr == begin)
	{
		// Single value - either a playerid or a groupid.
		#if defined _YSI_HAS_GROUP_SYSTEM
			if (addr & GROUP_MASK)
			{
				// Use the pre-made iterator functionality.  Don't alter addr as
				// it MUST not be 0 because "GROUP_MASK" is set, so even group 0
				// will be non-zero.
				//return YSI_gGroupPlayers[GROUP_TEMP_FIX(addr)];
				//pa = 
				ret = YSI_gGroupPlayers[GROUP_TEMP_FIX(addr)];
			}
			else
		#endif
		{
			// Single player.
			//new
			//	PlayerArray:ret<MAX_PLAYERS>;
			PA_FastInit(ret);
			PA_Let(ret, addr);
			//addr = 1;
			//return ret;
		}
	}
	else
	{
		//new
		//	PlayerArray:ret<MAX_PLAYERS>;
		PA_FastInit(ret);
		if (begin & 0xFF0000FF == 0x0F0000F0)
		{
			// Custom array.
			PA_Let(ret, (begin >>> 8) & 0x0000FFFF);
			// NOT foreach.
			for (new i = 1; i != MAX_PLAYERS; ++i)
			{
				begin = __ps_data[e_PLAYER_SET_HACK_DATA][i];
				if (begin == INVALID_PLAYER_ID)
				{
					break;
				}
				PA_Let(ret, begin);
			}
		}
		else if (begin == PA_TYPE_PA)
		{
			memcpy(_:ret, __ps_data[e_PLAYER_SET_HACK_DATA], 0, (bits<MAX_PLAYERS> + 1) * 4, (bits<MAX_PLAYERS> + 1) * 4);
		}
		// Figure out the type from the data contents.
		else if (begin > 1 || __ps_data[e_PLAYER_SET_HACK_DATA][1] > 1 || __ps_data[e_PLAYER_SET_HACK_DATA][2] > 1)
		{
			// List of players.
			// NOT foreach.
			for (new i = 0; i != MAX_PLAYERS; ++i)
			{
				begin = __ps_data[e_PLAYER_SET_HACK_DATA][i];
				if (begin == INVALID_PLAYER_ID)
				{
					break;
				}
				PA_Let(ret, begin);
			}
		}
		else
		{
			// Boolean array.
			foreach (new i : Player)
			{
				begin = __ps_data[e_PLAYER_SET_HACK_DATA][i];
				if (begin > 1)
				{
					// Retry.
					printf("*** Internal Warning: Late PlayerArray detection");
					PA_Init(ret);
					// NOT foreach.
					for (new j = 0; j != MAX_PLAYERS; ++j)
					{
						begin = __ps_data[e_PLAYER_SET_HACK_DATA][j];
						if (begin == INVALID_PLAYER_ID)
						{
							break;
						}
						PA_Let(ret, begin);
					}
					break;
				}
				else if (begin == 1)
				{
					// Add the current player.
					PA_Let(ret, i);
				}
			}
		}
		// Return.  I *think* addr should never be 0 here, but juat in case...
		//addr = 1;
		//return ret;
	}
	return 1;
}

// This SHOULD handle excess parameters correctly, simply because I left out the
// extra brackets.
#define PSF:%0(%1) %0(__ps_addr_t:__ps_data[e_PLAYER_SET_HACK_PA]=__ps_addr_t:%1)

// This redefines e_PLAYER_SET_HACK_DATA in the case of passing player arrays.
#define e_PLAYER_SET_HACK_PA]=__ps_addr_t:@%0) e_PLAYER_SET_HACK_DATA]=__ps_addr_t:%0)

// This redefines __ps_data in the case of custom arrays.
#define __ps_data[e_PLAYER_SET_HACK_DATA]=%0<%1> __ps_addr_t:__PS_C(%0,%1)

//#define PA:%0, PS(%0),
