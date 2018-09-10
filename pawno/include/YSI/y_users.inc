// y_uvars
#if !defined MODE_NAME
	#error Please define "MODE_NAME" before including y_users.
#endif

#include <YSI\internal\y_version>

#include <YSI\internal\y_shortfunc>
#include <YSI\y_stringhash>

#include <YSI\y_amx>
#include <YSI\y_debug>

#include <YSI\y_hooks>

// Can we make this better?  Yes, yes we can!
// This also now strips off all leading and ending spaces.
// Now defines "K@", which may be dangerous as that is also a function used
// elsewhere.
#define M@:K@:#%0[%1]# N@:@Uv:#%0[%1]#
#define K@:#%2:%0# L@:@Uu:#%2:%0#
// Don't care about normal tags!
#define L@:@Uu:#%2:%0<%1># #>#%2@#%0,_:(%1)
#define @Uu:#%2:%0# #%0#
// Also don't care about tagged arrays.
#define N@:@Uv:#%2:%0[%1]# #]#%0,_:(%1)
#define @Uv:#%0[%1]# #]#%0,_:(%1)

#define _YA@LT@E%0|||
#define _YA@LT%0,%1||| ,M@:K@:#%0#_YA@LT%1|||

// I am frankly VERY happy with this now!  It fully stores the sizes and
// structures of all the enums with full compile-time value resolution (or
// MOSTLY full compile-time resolution, things like "BitArray:x<MAX_PLAYERS>"
// will return their size as "MAX_PLAYERS", requiring later processing).  It
// also doesn't duplicate effort, only the names are stored as strings and the
// sizes as numbers (making our job VASTLY easier)!
#define uvar%0[%2]%3{%1}%4; enum%0_E{%1}new%0[MAX_PLAYERS][%0_E];%0@yA_();public%0@yA_()N@(_:%0,#....#%0 _YA@LT %1,@E|||);

// This is a structure defining the data stored on the enum structure.
enum E_USERS_FAKE_DATA
{
	E_USERS_FAKE_DATA_NEXT,
	E_USERS_FAKE_DATA_DATA,
	E_USERS_FAKE_DATA_LEN,
	E_USERS_FAKE_DATA_STR[2]
}

// The special names.  NEVER change the existing ones, only ever add to the end!
#define PlayerArray@ 1
#define @PlayerVar@ 2
#define @PlayerArray@ 3
#define BinaryTree@ 4
#define Iterator@ 5
#define IteratorArray@ 6
#define BitArray@ 7
// I need to add a function to allow users to define their own serialisation
// functions for custom data (or at least functions to define data sizes if they
// are using "special" arrays (I've seen Double-O-Seven define their own
// implementation of "bit" arrays using this style).

static stock
	YSI_g_sFirstUVarData = -1,
	YSI_g_sDoDataPrintAddr = 0,
	YSI_g_sDoDataResetAddr = 0;

// Define "volatile" as nothing.
#if !defined volatile
	#define volatile
#endif

/*----------------------------------------------------------------------------*\
Function:
	N@
Params:
	val[][] - Handle to the PAWN data array.
	volatile vardata[] - Handle to the memory location in which to store info.
	{K@, L@, M@, N@, _}:... - Array slot size information.
Return:
	-
Notes:
	This function modifies "vardata" well beyond its original limits to contain
	information on the structure of the enum used to define "val".  This code
	uses the name and size information passed in the additional parameters as
	strings, and makes assumptions about how the compiler lays out memory to
	combine all the passed strings in to one big string in what could be ROM,
	but in SA:MP isn't.  This takes a human readable(ish) description of the
	array elements and converts it in to a much simpler to read format for the
	computer to use later when loading and storing data.
\*----------------------------------------------------------------------------*/

//stock N@(len, &val, volatile const str[])
stock N@(val[][], volatile vardata[/*E_USERS_FAKE_DATA*/], /*volatile const varname[],*/ {K@, L@, M@, N@, _}:...)
{
	// I've confirmed that in most cases the constant data, even when there are
	// multiple identical copies from many calls, are stored in contiguous
	// memory locations, which can be exploited to create a huge array from
	// individual memory items.
	//#emit PUSH.adr varname
	//#emit PUSH.adr vardata
	//#emit PUSH.adr val
	// (%i, %i, %i)
	P:4("N@ called: %i, %x, %s (%i)"/*, \"%s\" (%i)*/" <use code above>", numargs(), val, vardata, vardata /*, unpack(varname), varname*/);
	new
		sAddr;
	// Store the basic data, including linked-list pointers and a pointer to the
	// location at which the data is stored.
	#emit LOAD.S.pri vardata
	#emit STOR.S.pri sAddr
	printf("", YSI_g_sFirstUVarData);
	#emit LOAD.pri   YSI_g_sFirstUVarData
	#emit SREF.S.pri sAddr
	YSI_g_sFirstUVarData = sAddr;
	sAddr += 4;
	#emit LOAD.S.pri val
	#emit SREF.S.pri sAddr
	// Now make all the bits of strings in to one long string (they're all in
	// constant memory).
	new
		offset = 4,
		len,
		size = -1,
		vars = 2,
		tmp,
		nums = numargs();
	while (vars <= nums)
	{
		len = strlen(vardata[offset]);
		//vardata[offset + len] = '_';
		vardata[offset - 1] = len;
		switch (vardata[offset])
		{
			case '>':
			{
				// Array - get the length.
				if ('0' <= vardata[offset + 1] <= '9')
				{
					// Known special array type.
					//vardata[offset] = 0x00000000 | len - 2;
					//--vardata[offset - 1];
					vardata[offset - 1] |= 0x10000000;
				}
				else
				{
					P:E("Unknown special array type: \"%s\".", vardata[offset + 1]);
					//vardata[offset] = 0xC0000000 | len - 1;
					vardata[offset - 1] |= 0x30000000;
				}
				tmp = getarg(vars++);
				P:6("N@: size = %d", tmp);
				vardata[offset] = tmp;
				// Modify the size based on the rules of the special array.
				switch (vardata[offset + 1])
				{
					case '0' + BitArray@:
					{
						P:6("N@: Adding BitArray");
						tmp = (tmp + cellbits - 1) / cellbits;
					}
					case '0' + BinaryTree@:
					{
						P:6("N@: Adding BinaryTree");
						// I doubt per-player binary trees will actually work!
						tmp = tmp * 5;
					}
					case '0' + PlayerArray@:
					{
						P:6("N@: Adding PlayerArray");
						tmp = (tmp + cellbits - 1) / cellbits + 1;
					}
					default:
					{
						P:E("Unsupported special array type: \"%c\".", vardata[offset + 1]);
					}
				}
				size += tmp;
			}
			/*case '<':
			{
				// Not an array.
				//vardata[offset] = 0x40000000 | len;
				vardata[offset - 1] |= 0x20000000;
				goto N@_end_of_loop;
			}*/
			case ']':
			{
				//vardata[offset] = 0x20000000 | len - 1;
				vardata[offset - 1] |= 0x20000000;
				tmp = getarg(vars++);
				P:6("N@: size = %d", tmp);
				vardata[offset] = tmp;
				size += tmp;
			}
			default:
			{
				//++vardata[offset - 1];
				++size;
				//goto N@_end_of_loop;
			}
		}
//N@_end_of_loop:
		offset = offset + len + 1;
		++vars;
	}
	sAddr += 4;
	// Store the total size of the array in bytes.
	#emit LOAD.S.pri size
	#emit SREF.S.pri sAddr
	P:C(for (new i = 0; vardata[i]; ++i)P:1("N@: %d = %04x%04x (%c)", i, vardata[i] >>> 16, vardata[i] & 0xFFFF, vardata[i]););
	// If I could declare str as volatile I would (and now have)!
	//P:4("N@ called: %i, %x, %s (%i)"/*, \"%s\" (%i)*/" <use code above>", numargs(), val, vardata, vardata /*, unpack(varname), varname*/);
}

hook OnScriptInit()
{
	// List them all.
	YSI_g_sFirstUVarData = -1;
	/*new
		idx = 0,
		buffer[32]*//*,
		fake[E_USERS_FAKE_DATA];
	Users_DoDataPrint(fake, "", 0)*/
	// Initialise the function pointers.
	Users_DoDataPrint(0, 0, "", 0, "");
	Users_DoDataReset("", 0);
	/*while ((idx = AMX_GetPublicNameSuffix(idx, buffer, _A<@yA_>)))
	{
		//printf("Public: %x", func);
		CallLocalFunction(buffer, "");
	}*/
	new
		idx,
		buffer;
	while ((idx = AMX_GetPublicPointerSuffix(idx, buffer, _A<@yA_>)))
	{
		#emit PUSH.C     0
		#emit LCTRL      6
		#emit ADD.C      28
		#emit PUSH.pri
		#emit LOAD.S.pri buffer
		#emit SCTRL      6
	}
	// That is basically it for initialisation!  Now we just need the writing
	// code, which may actually be more complex than previously thought.
}

/*stock Users_Debug()
{
	// Print the first value from every array.
}*/

//#endinput

Users_DoDataPrint(const playerid, const uid, data[], len, const structure[])
{
	#pragma unused len
	// DO NOT CHANGE THE CODE BELOW HERE!!!
	// Find and save the information on this function for later.  We don't even
	// need any checks here because we are saving the address of the instruction
	// after this code then returning in an invisible way.
	#emit LCTRL    6
	#emit ADD.C    20
	#emit STOR.pri YSI_g_sDoDataPrintAddr
	#emit RETN
	// DO NOT CHANGE THE CODE ABOVE HERE!!!
	//new
	//	str[64];
	//strunpack(str, structure);
	//printf("%d, %d", playerid, uid);
	//printf("structure: %s, len: %d, data: %d %d", str, len, data[0], data[1]);
	P:5("Users_DoDataPrint: len: %d, data: %d %d", len, data[0], data[1]);
	P:C(for(new _i = 0, _j = strlen(structure); _i != _j; ++_i) {P:5("%d: %08x (%c", _i, structure[_i], structure[_i]);});
	//printf("%d, %d, %d, %s", data[E_USERS_FAKE_DATA_NEXT], data[E_USERS_FAKE_DATA_DATA], data[E_USERS_FAKE_DATA_LEN], str);
	//printf("hi");
	//return data[E_USERS_FAKE_DATA_NEXT];
	//return -1;
	// OK, let's get started on trying to write code to output these various
	// arrays, even if at this point they are only printed to the console, it is
	// still a step in the right direction (and with the speed I'm currently
	// going ANY step is a good step)!
	// Print the user data.
	if (IsPlayerConnected(playerid))
	{
		printf("Users_DoDataPrint: %d (%d) = %s", playerid, uid, ReturnPlayerName(playerid));
	}
	// Print the variable name.
	new
		namelen = structure[0],
		datalen,
		datatype,
		dataOffset = 0,
		indexOffset = 1;
	printf("Users_DoDataPrint: %d: %.*s", namelen, namelen, structure[indexOffset]);
	for ( ; ; )
	{
		indexOffset = indexOffset + namelen + 1;
		namelen = structure[indexOffset - 1];
		if (!namelen)
		{
			// If the returned length is 0, that means we have reached a null
			// character, and thus the end of the string.
			break;
		}
		else switch (namelen & 0xFF000000)
		{
			case 0x00000000:
			{
				printf("Variable: %d: %.*s", namelen, namelen, structure[indexOffset]);
				++dataOffset;
			}
			case 0x10000000:
			{
				datalen = structure[indexOffset++] + dataOffset;
				//datalen = structure[indexOffset++];
				datatype = structure[indexOffset++] - '0';
				// Remove the flag and excess length at the same time.
				namelen -= 0x10000002;
				printf("Special array %d: %d: %.*s (%d)", datatype, namelen, namelen, structure[indexOffset], datalen - dataOffset);
				switch (datatype)
				{
					case BitArray@:
					{
						printf("data = %s", Bit_Display(BitArray:data[dataOffset], bit<datalen>));
					}
				}
				dataOffset = datalen;
			}
			case 0x20000000:
			{
				datalen = structure[indexOffset++] + dataOffset;
				// Remove the flag and excess length at the same time.
				namelen -= 0x20000001;
				printf("Array: %d: %.*s (%d)", namelen, namelen, structure[indexOffset], datalen - dataOffset);
				for (new i = dataOffset; i != datalen; ++i)
				{
					printf("data[%d] = %d", i, data[i]);
				}
				dataOffset = datalen;
			}
			default:
			{
				// Error!
				P:E("Attempted to save unknown data type, failing!");
				return;
			}
		}
	}
	//printf("
}

Users_DoDataReset(data[], len)
{
	// OK, since it says not to change anything here, I should briefly explain
	// what it does so that people know why not to change it.  This basically
	// gets the address of the code after the "#emit" blocks and stores that
	// address in a variable, then ends the function in a compiler-invisible
	// way.  This variable is used to call this function directly later on in
	// the code from more "#emit" blocks so that pure addresses can be passed
	// instead of having the compiler complain that a variable is not an array
	// (it isn't, but it holds a reference to an array, and the method used to
	// pass the variable means the run-time thinks this is correct).
	// DO NOT CHANGE THE CODE BELOW HERE!!!
	#emit LCTRL    6
	#emit ADD.C    20
	#emit STOR.pri YSI_g_sDoDataResetAddr
	#emit RETN
	// DO NOT CHANGE THE CODE ABOVE HERE!!!
	// Need "memset" really!  I have written a memset function based on looping
	// through a sub-set of an array, then using memcpy to copy that subset over
	// the rest of the array (which has shown nice speed-ups), but it needs more
	// testing to confirm that it does what I think it does.  I also need to
	// determine the optimal block size (for which I have a script written, I
	// just need to run it).
	/*while (len--)
	{
		data[len] = 0;
	}*/
	// The "0" is the default parameter, but I've specified it anyway.
	memset(data, len, 0);
}

hook OnPlayerLogout(playerid, uid)
{
//	Users_DoLogout(playerid, uid);
//}
//
//stock Users_DoLogout(playerid, uid)
//{
	P:1("hook Users_OnPlayerLogout called: %i, %i", playerid, uid);
	new
		p = YSI_g_sFirstUVarData,
		temp;
	while (p != -1)
	{
		// DO NOT CHANGE THE CODE BELOW HERE!!!
		// Call a function sort of.  This allows us to push an arbitrary address
		// as an array to a function.
		#emit LOAD.S.pri p
		// Get the structure.
		#emit ADD.C      12
		#emit PUSH.pri
		// Get the length.
		#emit ADD.C      0xFFFFFFFC // -4
		#emit STOR.S.pri temp
		#emit LREF.S.pri temp
		#emit PUSH.pri
		// Get the data offset.
		#emit LOAD.S.alt playerid
		#emit SMUL
		#emit SMUL.C     4
		#emit MOVE.alt
		// Get the data pointer.
		#emit LOAD.S.pri p
		#emit ADD.C      4
		#emit STOR.S.pri temp
		#emit LREF.S.alt temp
		#emit LOAD.S.pri playerid
		#emit IDXADDR
		#emit MOVE.alt
		#emit LOAD.i
		#emit ADD
		#emit PUSH.pri
		// Save the next pointer.
		#emit LREF.S.pri p
		#emit STOR.S.pri p
		// Push the other parameters.
		#emit PUSH.S     uid
		#emit PUSH.S     playerid
		// Now push the size of data put on the stack.
		#emit PUSH.C     20
		// Now get the return address and push it.
		#emit LCTRL      6
		#emit ADD.C      32
		#emit PUSH.pri
		// Now start the function to store certain data.
		#emit PROC
		// Now jump in to the middle of the function.
		#emit LOAD.pri   YSI_g_sDoDataPrintAddr
		#emit SCTRL      6
		// Now store the return value.
		/*#emit STOR.S.pri p*/
		// DO NOT CHANGE THE CODE ABOVE HERE!!!
	}
}

hook OnPlayerConnect(playerid)
{
//	Users_DoLogout(playerid, uid);
//}
//
//stock Users_DoLogout(playerid, uid)
//{
	P:1("hook Users_OnPlayerConnect called: %i", playerid);
	new
		p = YSI_g_sFirstUVarData,
		temp;
	while (p != -1)
	{
		// DO NOT CHANGE THE CODE BELOW HERE!!!
		// Call a function sort of.  This allows us to push an arbitrary address
		// as an array to a function.
		#emit LOAD.S.pri p
		// Get the structure.
		//#emit ADD.C      12
		//#emit PUSH.pri
		// Get the length.
		//#emit ADD.C      0xFFFFFFFC // -4
		#emit ADD.C      8
		#emit STOR.S.pri temp
		#emit LREF.S.pri temp
		#emit PUSH.pri
		// Get the data offset.
		#emit LOAD.S.alt playerid
		#emit SMUL
		#emit SMUL.C     4
		#emit MOVE.alt
		// Get the data pointer.
		#emit LOAD.S.pri p
		#emit ADD.C      4
		#emit STOR.S.pri temp
		#emit LREF.S.alt temp
		#emit LOAD.S.pri playerid
		#emit IDXADDR
		#emit MOVE.alt
		#emit LOAD.i
		#emit ADD
		#emit PUSH.pri
		// Save the next pointer.
		#emit LREF.S.pri p
		#emit STOR.S.pri p
		/*// Push the other parameters.
		#emit PUSH.S     uid
		#emit PUSH.S     playerid*/
		// Now push the size of data put on the stack.
		#emit PUSH.C     8
		// Now get the return address and push it.
		#emit LCTRL      6
		#emit ADD.C      32
		#emit PUSH.pri
		// Now start the function to store certain data.
		#emit PROC
		// Now jump in to the middle of the function.
		#emit LOAD.pri   YSI_g_sDoDataResetAddr
		#emit SCTRL      6
		// Now store the return value.
		//#emit STOR.S.pri p
		// DO NOT CHANGE THE CODE ABOVE HERE!!!
	}
}
