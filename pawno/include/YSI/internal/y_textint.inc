/*----------------------------------------------------------------------------*\
					===========================
					Y Sever Includes - INI Core
					===========================
Description:
	Does some internal processing for the text system.
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
	
	The Original Code is the YSI ini include.
	
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
	01/05/11:
		First version.
Functions:
	Public:
		-
	Core:
		-
	Stock:
		-
	Static:
		-
	Inline:
		-
	API:
		-
Callbacks:
	-
Definitions:
	-
Enums:
	-
Macros:
	-
Tags:
	-
Variables:
	Global:
		-
	Static:
		-
Commands:
	-
Compile options:
	-
Operators:
	-
\*----------------------------------------------------------------------------*/

//#include <YSI\y_master>
#include <YSI\y_amx>
#include <YSI\y_hooks>
#include <YSI\y_utils>
#include <YSI\y_ini>
//#include <YSI\y_styles>
#include <YSI\y_debug>

// End conditions for the recursive calls (strings and publics).
#define _YT@LE@E%0>
#define _YT@LT@E%0> ;

// Recursive wanted text definition.  Needs two levels of indirection to strip
// the excess commas (,%0,%1).
#if defined Y_TEXT_UNIQUE
	#define _YT@LO(,%0,%1) UNIQUE_FUNCTION<%0@%1@...@yX_>();public UNIQUE_FUNCTION<%0@%1@...@yX_>(){}
#else
	#define _YT@LO(,%0,%1) %0@%1@yX_();public %0@%1@yX_(){}
#endif
#define _YT@LE%0[%1]%2> _YT@LO(%0,%1) _YT@LE%2>

// Recursive local default string definition.
#define _YT@LJ(,%0,%1) #%0":"#%1"|"
#define _YT@LT%0[%1]%2> _YT@LJ(%0,%1)_YT@LT%2>

// Entry point for the loaders.
#define text%0[%1]%2; _YT@LE,%0[%1]%2@E>static stock DEFAULT_TEXT_SET[]=_YT@LT,%0[%1]%2@E>

#define Text_RegisterTag(%1) \
	text core[%1]

// Clever macros to load default values when not specified.
//#define Text_Send(%0,%1) _Text_Send(%0,DEFAULT_TEXT_SET,#%1)

#define DEFAULT_TEXT_SET,#%1->%2) #core#:#%1#|,#%2)

// WTF does this do?  I can't even remember what slots are!
//#define core":"#%1:%2"|",%3) %1":"#%2"|",%3)
#define core#:#%1[%2]%9#|,%3) %1#:#%2#|,%3)

#if defined _inc_y_languages
	#define Text_GetLanguageCodes() Languages_GetlanguageCodes()
#else
	// y_languages doesn't really do much TBH...  This used to have three
	// langugages, but then I realised that without the "y_languages"
	// library there was no way for a player to select their language.
	// "XX" is used as a dummy to ensure that the array in the enum is always
	// valid and that the compiler doesn't optimise it out.
	#define Text_GetLanguageCodes() "EN|XX|" //|NL|ES|"
	// Number of "|" separated strings above (always 1).
	#define MAX_LANGUAGES (Language:2)
#endif

// Return types
enum E_TEXT_FIND
{
	E_TEXT_FIND_NONE,
	E_TEXT_FIND_JUST,
	E_TEXT_FIND_MANY
}

// This holds the data for all entry points.
enum e_TEXT_SETS
{
	e_TEXT_SETS_NAME[28],
	e_TEXT_SETS_HASH,
	e_TEXT_SETS_INDEX
}

enum e_TEXT_ENTRY
{
	e_TEXT_ENTRY_NAME[MAX_INI_ENTRY_NAME],// char],
	e_TEXT_ENTRY_HASH,
	e_TEXT_ENTRY_LEFT,
	e_TEXT_ENTRY_RIGHT,
	e_TEXT_ENTRY_POINTERS[MAX_LANGUAGES]
}

#if !defined Y_TEXT_MAX_SETS
	#define Y_TEXT_MAX_SETS             (16)
#endif

#if !defined MAX_TEXT_ENTRIES
	#define MAX_TEXT_ENTRIES (1024 * Y_TEXT_MAX_SETS)
#endif

static stock
	YSI_g_sTextSets[Y_TEXT_MAX_SETS][e_TEXT_SETS],
	YSI_g_sTextEntries[MAX_TEXT_ENTRIES][e_TEXT_ENTRY],
	YSI_g_sTextStrings[MAX_TEXT_ENTRIES * _:MAX_LANGUAGES][MAX_INI_ENTRY_TEXT],// char],
	YSI_g_sUnusedEntry = 0,
	YSI_g_sUnusedSlot = 0,
	YSI_g_sCurLoadTextFile[64],
	Language:YSI_g_sLangIndex;

// OnFilterScriptInit

// =============================================================================
// | ========================================================================= |
// | |                                                                       | |
// | |                   HERE STARTS THE LOADING CODE                        | |
// | |                                                                       | |
// | ========================================================================= |
// =============================================================================

hook OnScriptInit()
{
	P:1("Text_OnScriptInit called");
	// Initialise.
	for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		YSI_g_sTextSets[i][e_TEXT_SETS_NAME][0] = '\1';
		YSI_g_sTextSets[i][e_TEXT_SETS_INDEX] = -1;
	}
	for (new i = 0; i != MAX_TEXT_ENTRIES; ++i)
	{
		YSI_g_sTextEntries[i][e_TEXT_ENTRY_HASH] = i + 1;
	}
	for (new i = 0; i != MAX_TEXT_ENTRIES * _:MAX_LANGUAGES; ++i)
	{
		YSI_g_sTextStrings[i][0] = i + 1;
	}
	// Scan the AMX for all public functions of the type "XX@YY@NN@yX_".  These
	// are the declarations for included texts.
	state y_text_ending:n;
	Text_RefreshLoaded();
	/*for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		new
			idx = YSI_g_sTextSets[i][e_TEXT_SETS_INDEX];
		if (idx != -1)
		{
			printf("Set: \"%s\"", YSI_g_sTextSets[i][e_TEXT_SETS_NAME]);
		}
	}
	for (new i = 0; i != 50; ++i)
	{
		printf("Entry: \"%s\" %d %d %d (%d %d %d)", YSI_g_sTextEntries[i][e_TEXT_ENTRY_NAME], YSI_g_sTextEntries[i][e_TEXT_ENTRY_HASH], YSI_g_sTextEntries[i][e_TEXT_ENTRY_LEFT], YSI_g_sTextEntries[i][e_TEXT_ENTRY_RIGHT], YSI_g_sTextEntries[i][e_TEXT_ENTRY_POINTERS][0], YSI_g_sTextEntries[i][e_TEXT_ENTRY_POINTERS][1], YSI_g_sTextEntries[i][e_TEXT_ENTRY_POINTERS][2]);
		printf("Text: \"%s\"", YSI_g_sTextStrings[i]);
	}*/
}

hook OnScriptExit()
{
	state y_text_ending:y;
	CallRemoteFunction("Text_RefreshLoaded", "");
}

forward Text_RefreshLoaded();

public Text_RefreshLoaded() <y_text_ending:y>
{
	// Do nothing, only called for other scripts to check that all their text
	// items are still loaded.
}

public Text_RefreshLoaded() <y_text_ending:n>
{
	new
		idx = 0,
		buffer[32],
		pos;
	while ((idx = AMX_GetPublicNameSuffix(idx, buffer, _A<@yX_>)))
	{
		strunpack(buffer, buffer);
		pos = chrfind('@', buffer);
		//printf("%d, %x", pos, buffer[0]);
		if (pos != -1)
		{
			buffer[pos] = ':';
			pos = chrfind('@', buffer, pos);
			if (pos != -1)
			{
				buffer[pos] = '\0';
				setproperty(8, "T_CL", 0);
				new
					hash = bernstein(buffer);
				CallRemoteFunction("Text_CheckLoad", "si", buffer, hash);
				if (getproperty(8, "T_CL") == 0)
				{
					Text_AddLocal(buffer, hash);
				}
			}
		}
	}
	Text_LoadLocals();
}

static stock Text_AddLocal(buffer[], hash)
{
	P:4("Text_AddLocal called: \"%s\", %i", buffer, hash);
	for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		if (YSI_g_sTextSets[i][e_TEXT_SETS_NAME][0] == '\1')
		{
			YSI_g_sTextSets[i][e_TEXT_SETS_HASH] = hash;
			strcpy(YSI_g_sTextSets[i][e_TEXT_SETS_NAME], buffer, 28);
			return;
		}
	}
}

forward Text_INILoad(offset, tag[], name[], value[]);

public Text_INILoad(offset, tag[], name[], value[])
{
	// Get the path.
	// Get the file.
	// Get the extension.
	P:5("Text_INILoad: IsPacked? %08x%08x", value[0], value[1]);
	new
		fname[sizeof (YSI_g_sCurLoadTextFile) - (3 + 9)],
		len = strlen(YSI_g_sCurLoadTextFile);
	//format(fname, sizeof (fname
	strcpy(fname, YSI_g_sCurLoadTextFile[9], len - (3 + 9 - 1));
	for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		if (!strcmp(YSI_g_sTextSets[i][e_TEXT_SETS_NAME], fname, true, offset - 1) && !strcmp(YSI_g_sTextSets[i][e_TEXT_SETS_NAME][offset], tag, true))
		{
			//printf("%d \"%s\" \"%s\" \"%s\"", len, fname, YSI_g_sCurLoadTextFile[len - 2], tag);
			new
				hash = bernstein(name);
			new
				slot = Text_FindEntry(YSI_g_sTextSets[i][e_TEXT_SETS_INDEX], hash);
			if (slot == -1)
			{
				Text_AddEntry(i, name, value, hash);
			}
			else
			{
				if (strcmp(name, YSI_g_sTextEntries[slot][e_TEXT_ENTRY_NAME], true))
				{
					P:E("Text collision on \"%s\" and \"%s\"!", name, YSI_g_sTextSets[i][e_TEXT_SETS_NAME]);
					return;
				}
				else if (YSI_g_sTextEntries[slot][e_TEXT_ENTRY_POINTERS][YSI_g_sLangIndex] == -1)
				{
					new
						ss = Text_GetFreeSlot();
					if (ss == -1)
					{
						P:E("Text buffer full!");
						return;
					}
					//strpack(YSI_g_sTextStrings[ss], value, MAX_INI_ENTRY_TEXT * 4);
					Format_Standardise(value, YSI_g_sTextStrings[ss], MAX_INI_ENTRY_TEXT);
					//strcpy(YSI_g_sTextStrings[ss], value, MAX_INI_ENTRY_TEXT * 4);
					YSI_g_sTextEntries[slot][e_TEXT_ENTRY_POINTERS][YSI_g_sLangIndex] = ss;
				}
				else
				{
					P:W("Text repeat on \"%s\"!", name);
				}
			}
			// Add the current value to the current tag.
		}
	}
}

static stock Text_LoadLocals()
{
	P:4("Text_LoadLocals called");
	// This is the interesting part.  Load all the sets which have a name not
	// '\1' and an index of -1.
	for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		if (YSI_g_sTextSets[i][e_TEXT_SETS_INDEX] == -1 && YSI_g_sTextSets[i][e_TEXT_SETS_HASH])
		{
			new
				offset = chrfind(':', YSI_g_sTextSets[i][e_TEXT_SETS_NAME]),
				j = i + 1;
			while (j != Y_TEXT_MAX_SETS)
			{
				if (YSI_g_sTextSets[j][e_TEXT_SETS_INDEX] == -1 && YSI_g_sTextSets[j][e_TEXT_SETS_HASH] && !strcmp(YSI_g_sTextSets[i][e_TEXT_SETS_NAME], YSI_g_sTextSets[j][e_TEXT_SETS_NAME], false, offset))
				{
					break;
				}
				++j;
			}
			if (j != Y_TEXT_MAX_SETS)
			{
				continue;
			}
			//YSI_g_sTextSets[i][e_TEXT_SETS_NAME][offset] = '\0';
			YSI_g_sLangIndex = Language:0;
			new
				langs[YSI_MAX_STRING] = Text_GetLanguageCodes(),
				pos;
			while ((pos = chrfind('|', langs, pos)) != -1)
			{
				format(YSI_g_sCurLoadTextFile, sizeof (YSI_g_sCurLoadTextFile), \"YSI\text\%.*s.%.2s", offset, YSI_g_sTextSets[i][e_TEXT_SETS_NAME], langs[pos - 2]);
				INI_ParseFile(YSI_g_sCurLoadTextFile, "Text_INILoad", _, true, offset + 1, _, true);
				++pos;
				++YSI_g_sLangIndex;
			}
			//YSI_g_sTextSets[i][e_TEXT_SETS_NAME][offset] = ':';
		}
	}
}

forward Text_CheckLoad(buffer[], hash);

public Text_CheckLoad(buffer[], hash) <y_text_ending:y>
{
	for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		YSI_g_sTextSets[i][e_TEXT_SETS_HASH] = 0;
		YSI_g_sTextSets[i][e_TEXT_SETS_NAME][0] = '\1';
		YSI_g_sTextSets[i][e_TEXT_SETS_NAME][1] = '\0';
	}
}

public Text_CheckLoad(buffer[], hash) <y_text_ending:n>
{
	// Check if another script is already in charge of this set.
	if (getproperty(8, "T_CL"))
	{
		return;
	}
	// Nope, are we?
	for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		if (hash == YSI_g_sTextSets[i][e_TEXT_SETS_HASH] && !strcmp(buffer, YSI_g_sTextSets[i][e_TEXT_SETS_NAME]))
		{
			setproperty(8, "T_CL", 1);
			return;
		}
	}
}

forward Text_GetStandard(search[], nh, Language:l);
public Text_GetStandard(search[], nh, Language:l)
{
	if (getproperty(8, YSIM_TXTFND))
	{
		return;
	}
	P:4("Text_GetStandard called");
	new
		sh = bernstein(search);//,
		//fail[MAX_INI_ENTRY_TEXT] = "String not found";
	for (new i = 0; i != Y_TEXT_MAX_SETS; ++i)
	{
		P:7("Text_GetStandard: %d, %d, %d", i, sh, YSI_g_sTextSets[i][e_TEXT_SETS_HASH]);
		if (sh == YSI_g_sTextSets[i][e_TEXT_SETS_HASH] && !strcmp(search, YSI_g_sTextSets[i][e_TEXT_SETS_NAME]))
		{
			// Got the start slot.
			new
				slot = Text_FindEntry(YSI_g_sTextSets[i][e_TEXT_SETS_INDEX], nh);
			if (slot != -1)
			{
				new
					pointer = YSI_g_sTextEntries[slot][e_TEXT_ENTRY_POINTERS][l];
				P:5("Text_GetStandard: %d, %d", slot, pointer);
				if (pointer != -1)
				{
					//P:5("Text_GetStandard: %08x%08x%08x%08x%08x", YSI_g_sTextStrings[pointer][0], YSI_g_sTextStrings[pointer][1], YSI_g_sTextStrings[pointer][2], YSI_g_sTextStrings[pointer][3], YSI_g_sTextStrings[pointer][4]);
					setproperty(9, "", YSIM_STRING, YSI_g_sTextStrings[pointer]);
					//format(fail, sizeof (fail), "%s", YSI_g_sTextStrings[pointer]);
					//printf("fail: %s", fail);
					//break;
				}
			}
		}
	}
	//static const
	//	fail[MAX_INI_ENTRY_TEXT] = "\1";
	setproperty(9, "", YSIM_STRING, "\1");
	//return fail;
}

// Get the loaded standardised version of this string.
//forward Text_GetStandard(start[] name[], Language:l);

static stock Text_GetText(search[], name[], Language:l)
{
	/*new
		start = Text_GetProvider(search),
		slot = Text_FindEntry(*/
	// TODO: Parse multiple search strings.
	//search[strlen(search) - 1] = '\0';
	static
		ret[MAX_INI_ENTRY_TEXT];
	new
		pos,
		lst;
	setproperty(8, YSIM_TXTFND, 0);
	while (search[lst])
	{
		pos = strfind(search[lst], "|");
		P:7("Text_GetText: loop1 %s %d %d %s %d", search, lst, pos, search[lst], search[pos + 1]);
		search[lst + pos] = '\0';
		CallRemoteFunction("Text_GetStandard", "sii", search[lst], bernstein(name), _:l);
		//P:7("Text_GetText: loop2 %s %d %d %s %d %d", search, lst, pos, search[lst], search[pos + 1], ret[0]);
		search[lst + pos] = '|';
		//if (ret[0] != '\1')
		if (getproperty(8, YSIM_TXTFND))
		{
			getproperty(9, "", YSIM_STRING, ret);
			strunpack(ret, ret);
			return ret;
		}
		lst = pos + 1;
		//if (++loops == 10) break;
		//break;
	}
	//if (ret[0] == '\1')
	{
		// Need better error reporting here.
		ret = "Text Not Found";
	}
	return ret;
}

// To be public.
//stock Text_GetProvider(search[])
//{
//}

static stock Text_FindEntry(start, hash)
{
	P:4("Text_FindEntry called: %i, %i", start, hash);
	while (start != -1)
	{
		new
			cmp = YSI_g_sTextEntries[start][e_TEXT_ENTRY_HASH] - hash;
		if (cmp < 0)
		{
			start = YSI_g_sTextEntries[start][e_TEXT_ENTRY_RIGHT];
		}
		else if (cmp > 0)
		{
			start = YSI_g_sTextEntries[start][e_TEXT_ENTRY_LEFT];
		}
		else
		{
			return start;
		}
	}
	return -1;
}

static stock Text_AddEntry(set, name[], value[], hash)
{
	P:4("Text_AddEntry called: %i, \"%s\", \"%s\", %i", set, name, value, hash);
	new
		entry = Text_GetFreeEntry(),
		slot = Text_GetFreeSlot();
	if (entry == -1 || slot == -1)
	{
		P:E("Text buffer full!");
		return;
	}
	// Save the string.
	//strpack(YSI_g_sTextStrings[slot], value, MAX_INI_ENTRY_TEXT * 4);
	Format_Standardise(value, YSI_g_sTextStrings[slot], MAX_INI_ENTRY_TEXT);
	//strpack(YSI_g_sTextStrings[slot], value, MAX_INI_ENTRY_TEXT * 4);
	//strcpy(YSI_g_sTextStrings[slot], value, MAX_INI_ENTRY_TEXT * 4);
	// Save the identifier.
	strpack(YSI_g_sTextEntries[entry][e_TEXT_ENTRY_NAME], name, MAX_INI_ENTRY_NAME * 4);
	//strcpy(YSI_g_sTextEntries[entry][e_TEXT_ENTRY_NAME], name, MAX_INI_ENTRY_NAME * 4);
	YSI_g_sTextEntries[entry][e_TEXT_ENTRY_HASH] = hash;
	YSI_g_sTextEntries[entry][e_TEXT_ENTRY_POINTERS][YSI_g_sLangIndex] = slot;
	// Insert the identifier.
	new
		idx = YSI_g_sTextSets[set][e_TEXT_SETS_INDEX],
		next;
	if (idx == -1)
	{
		YSI_g_sTextSets[set][e_TEXT_SETS_INDEX] = entry;
	}
	else
	{
		for ( ; ; )
		{
			new
				cmp = YSI_g_sTextEntries[idx][e_TEXT_ENTRY_HASH] - hash;
			if (cmp < 0)
			{
				next = YSI_g_sTextEntries[idx][e_TEXT_ENTRY_RIGHT];
				if (next == -1)
				{
					YSI_g_sTextEntries[idx][e_TEXT_ENTRY_RIGHT] = entry;
					return;
				}
			}
			else if (cmp > 0)
			{
				next = YSI_g_sTextEntries[idx][e_TEXT_ENTRY_LEFT];
				if (next == -1)
				{
					YSI_g_sTextEntries[idx][e_TEXT_ENTRY_LEFT] = entry;
					return;
				}
			}
			idx = next;
		}
	}
}

static stock Text_GetFreeSlot()
{
	P:4("Text_GetFreeSlot called");
	if (YSI_g_sUnusedSlot == MAX_TEXT_ENTRIES * _:MAX_LANGUAGES)
	{
		return -1;
	}
	new
		ret = YSI_g_sUnusedSlot;
	YSI_g_sUnusedSlot = YSI_g_sTextStrings[ret][0];
	YSI_g_sTextStrings[ret][0] = '\0';
	return ret;
}

static stock Text_GetFreeEntry()
{
	P:4("Text_GetFreeEntry called");
	if (YSI_g_sUnusedEntry == MAX_TEXT_ENTRIES)
	{
		return -1;
	}
	new
		ret = YSI_g_sUnusedEntry;
	YSI_g_sUnusedEntry = YSI_g_sTextEntries[ret][e_TEXT_ENTRY_HASH];
	YSI_g_sTextEntries[ret][e_TEXT_ENTRY_HASH] = 0;
	YSI_g_sTextEntries[ret][e_TEXT_ENTRY_LEFT] = -1;
	YSI_g_sTextEntries[ret][e_TEXT_ENTRY_RIGHT] = -1;
	// Reset text storage pointers.
	for (new Language:i = Language:0; i != MAX_LANGUAGES; ++i)
	{
		YSI_g_sTextEntries[ret][e_TEXT_ENTRY_POINTERS][i] = -1;
	}
	return ret;
}

// The internal send function.
stock _Text_Send(@PlayerVar:playerid, search[], ident[], {Float, _}:...)
//stock _Text_SendTemp(__ps_addr_t:__ps_addr, search[], ident[], {Float, _}:...)for(new playerid<MAX_PLAYERS>=__PS_S(_:__ps_addr);__PS_M(playerid<MAX_PLAYERS>);__PS_N(_:__ps_addr,playerid<MAX_PLAYERS>))
{
	// Set HOW to display the message (here "SendClientMessage").  Change to
	// "y_render_show_print" for debugging.
	//state y_render_show : y_render_show_scm;
	state y_render_show : y_render_show_print;
	// This is needed, but not always used (as here).
	printf("Show to player: %d", playerid);
	new
		buffer[128];
	// Call the main function.  I've not yet figured out a way to pass all
	// parameters through (or I have, but it's more complicated than the normal
	// method due to "numargs" being used in a special way internally.
	//Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, Text_GetText(DEFAULT_TEXT_SET, ident, Language:0), 3, getarg(0 + 2), getarg(1 + 2), getarg(2 + 2));
	// This uses the variable parameter passing method based on code by Zeex.
	// See page 15 of the code optimisations topic.
	new
		n = (numargs() - 2) * 4;
	// I REALLY could do with a better way of doing this based on stacks.  I
	// wonder if memcpy will work...
	if (n)
	{
		new
			arg_start,
			arg_end;
		// Load the real address of the last static parameter.  Do this by
		// loading the address of the parameter and then adding the value of
		// [FRM] (frame pointer).
		#emit CONST.alt                 ident
		#emit LCTRL                     5
		#emit ADD
		#emit STOR.S.pri                arg_start
		// Load the address of the last variable parameter.  Do this by adding
		// the number of variables on the value just loaded.
		#emit LOAD.S.alt                n
		#emit ADD
		#emit STOR.S.pri                arg_end
		// Push the variable arguments.  This is done by loading the value of
		// each one in reverse order and pushing them.  I'd love to be able to
		// rewrite this to use the values of pri and alt for comparison, instead
		// of having or constantly reload two variables.
		do
		{
			#emit LOAD.I
			#emit PUSH.pri
			arg_end -= 4;
			#emit LOAD.S.pri            arg_end
		}
		while (arg_end > arg_start);
		// Call the function, with an additional parameter for the number of
		// parameters which were already pushed (as "numargs()" won't see them).
		switch (search[0])
		{
			case '\1':
			{
				// Null - error.
			}
			case '\2':
			{
				// None - just print the string directly.
				Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, ident, n / 4);
			}
			case '\3':
			{
				new
					pos = strfind(ident, ">"),
					br = strfind(ident, "[");
				if (pos > 1 && br != -1)
				{
					ident[pos - 2] = '\0';
					if (br)
					{
						ident[br] = ':';
						Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, Text_GetText(ident, ident[pos + 1], Language:0), n / 4);
					}
					else
					{
						Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, Text_GetText(ident[1], ident[pos + 1], Language:0), n / 4);
					}
				}
				else
				{
					// Var - May contain location search information in "name".
					// Maybe add an "all" search parameter...
					Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, "Could not find text source", n / 4);
				}
			}
			default:
			{
				Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, Text_GetText(search, ident, Language:0), n / 4);
			}
		}
		// Remove the extra parameters from the stack.
		#emit LCTRL                     4
		#emit LOAD.S.alt                n
		#emit ADD
		#emit SCTRL                     4
	}
	else
	{
		switch (search[0])
		{
			case '\1':
			{
				// Null - error.
			}
			case '\2':
			{
				// None - just print the string directly.
				Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, ident, 0);
			}
			case '\3':
			{
				new
					pos = strfind(ident, ">"),
					br = strfind(ident, "[");
				if (pos > 1 && br != -1)
				{
					ident[pos - 2] = '\0';
					if (br)
					{
						ident[br] = ':';
						Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, Text_GetText(ident, ident[pos + 1], Language:0), 0);
					}
					else
					{
						Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, Text_GetText(ident[1], ident[pos + 1], Language:0), 0);
					}
				}
				else
				{
					// Var - May contain location search information in "name".
					// Maybe add an "all" search parameter...
					Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, "Could not find text source", 0);
				}
			}
			default:
			{
				Format_Render(playerid, Language:0, buffer, sizeof (buffer) - 1, 0, 0, Text_GetText(search, ident, Language:0), 0);
			}
		}
	}
}


#endinput
// There is actually no reason to free anything ever now!
/*static stock Text_FreeSlot(slot)
{
	P:4("Text_FreeSlot called: %i", slot);
	YSI_g_sTextStrings[slot][0] = YSI_g_sUnusedSlot;
	YSI_g_sUnusedSlot = slot;
}

static stock Text_FreeEntry(entry)
{
	P:4("Text_FreeEntry called: %i", entry);
	// Note that this code DOES NOT deal with hanging binary tree pointers as
	// the only way to free an entry is to free it's entire associated tree, so
	// there's no need for safe intermediates.
	YSI_g_sTextEntries[entry][e_TEXT_ENTRY_HASH] = YSI_g_sUnusedEntry;
	YSI_g_sUnusedEntry = entry;
	// Free associated text storage.
	for (new i = 0; i != MAX_LANGUAGES; ++i)
	{
		new
			slot = YSI_g_sTextEntries[entry][e_TEXT_ENTRY_POINTERS][i];
		if (slot == -1)
		{
			Text_FreeSlot(slot);
		}
	}
}*/

// =============================================================================
// | ========================================================================= |
// | |                                                                       | |
// | |                   HERE STARTS THE DISPLAY CODE                        | |
// | |                                                                       | |
// | ========================================================================= |
// =============================================================================

/*#if !defined PlayerSetArray
	#define PlayerSetArray<%0>%1) __ps_addr %1)for(new PlayerArray:%0<MAX_PLAYERS>=__PS_A(__ps_addr);__ps_addr;__ps_addr=0)
#endif*/

#define Text_Send(%0) PSF(_Text_Send,%0)

stock _Text_Send(@PlayerArray:players<MAX_PLAYERS>, search[], str[], ...)
{
	P:3("_Text_Send called: %s, \"%s\", \"%s\", (+%i)", Bit_Display(Bit:players[1]), search, str, numargs(0 - 3);
	// This code takes a PlayerArray, but one which is defined using the
	// "@PlayerArray" syntax, which means that the function can take a wide
	// range of input types which are then converted to a PlayerArray by the
	// slightly magical "y_playerset" library!  Note that the "@" just
	// represents the fact that this is a "PlayerArray", but that there is
	// something special about it.
	#if MAX_LANGUAGES == 1
		// Use the "ToAll" functions where possible as everyone gets the
		// same text all the time.
	#else
		new
			BitArray:bDoneLang<MAX_LANGUAGES>, // Done format?
			szText[MAX_LANGUAGES][YSI_MAX_STRING],
			style,
			len[MAX_LANGUAGES];
		foreach (new playerid : PA(players))
		{
			new
				lang = Languages_GetPlayerLanguage(playerid),
				pos;
			if (szText[lang][0])
			{
				// Call the send function which can figure out
				// HOW to send the text.
				Text_SendInternal(playerid, szText[lang], style);
				// Skip the first bits.  For extended strings
				// which are more than just one send's worth of
				// text this will not be -1.
				pos = len[lang];
			}
			if (pos != -1)
			{
				// Generate the first string.
				pos = Text_SendInternal(playerid, szText[lang], style);
				len[lang] = pos;
				while (pos != -1)
				{
					// Generate the text and send it to the
					// player.  This is contained within an
					// "if" block to save the first block.
				}
			}
		}
	#endif
}

/*_Text_Send(players, search[], str[], ...)
{
	//printf("%d \"%s\" \"%s\" %d", players, search, str, numargs());
	// Loop through all of the start points to find one which matches.
	new
		idx = 0,
		hash,
		strhash = bernstein(str),
		sidx,
		script;
	do
	{
		// Get the hash of the next search entry.
		hash = Text_Hash(search, idx);
		// Now attempt to send the string using that start point.
		switch (Text_Find(hash, strhash, sidx, script))
		{
			case E_TEXT_FIND_NONE:
			{
				// No match.
				continue;
			}
			case E_TEXT_FIND_JUST:
			{
				// Found the single matching hash.
			}
			case E_TEXT_FIND_MANY:
			{
				// Found multiple matches.
				if (Text_FindEx(search, str, sidx, script) == E_TEXT_FIND_NONE)
				{
					continue;
				}
			}
		}
		// Can only get here if "sidx" is valid.
		// This uses the variable parameter passing method based on code by
		// Zeex.  See page 15 of the code optimisations topic.  Note that this
		// function REALLY has 4 static parameters, it's just that one is hidden
		// by the "PlayerSet:" declaration.
		new
			n = (numargs() - 4) * 4;
		if (n)
		{
			new
				arg_start,
				arg_end;
			
			// Load the real address of the last static parameter.  Do this by
			// loading the address of the parameter and then adding the value of
			// [FRM] (frame pointer).
			#emit CONST.alt                 str
			#emit LCTRL                     5
			#emit ADD
			#emit STOR.S.pri                arg_start
			
			// Load the address of the last variable parameter.  Do this by
			// adding the number of variables on the value just loaded.
			#emit LOAD.S.alt                n
			#emit ADD
			#emit STOR.S.pri                arg_end
			
			// Push the variable arguments.  This is done by loading the value
			// of each one in reverse order and pushing them.  I'd love to be
			// able to rewrite this to use the values of pri and alt for
			// comparison, instead of having or constantly reload two variables.
			do
			{
				#emit LOAD.I
				#emit PUSH.pri
				arg_end -= 4;
				#emit LOAD.S.pri            arg_end
			}
			while (arg_end > arg_start);
			
			// Push the static parameter.
			#emit PUSH.S                    str
			
			// Now push the number of parameters sent and call the function.
			n += 4;
			#emit PUSH.S                    n
			#emit SYSREQ.C                  printf
			
			// Clear the stack, including the return.
			n += 4;
			#emit LCTRL                     4
			#emit LOAD.S.alt                n
			#emit ADD
			#emit SCTRL                     4
		}
		else
		{
			print(str);
		}
		return;
	}
	while (search[idx]);
}

stock Text_Hash(const str[], &idx)
{
	P:3("Text_Hash called: \"%s\", %i", str, idx);
	new
		hash = -1,
		ch;
	while ((ch = str[idx++]) != '|')
	{
		hash = hash * 33 + ch;
	}
	return hash;
}*/
