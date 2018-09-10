#include <YSI\y_utils>
#include <YSI\y_colours>
#include <YSI\y_debug>
#include <YSI\internal\y_shortfunc>

#define Y_RENDER_SCM_COLOUR_LEN (8)

//#define Y_RENDER_ONE_ARG 
//	if ((arg = getarg(curArg++) || TRUE))

// Loops through all possible arguments in lists, functions and singles.
#define Y_RENDER_ARG for(new _i=0,_b=4;_i!=2;++_i)if(_i==0){if(ch&_:e_COMPRESS_FORMAT_DATA_FUNC){_b=1,func="@yR_";for(new _k=4;_k!=32;++_k)if(!(func[_k]=getarg(curArg,_k-4)))break;if(funcidx(func)==-1)func[2]='r',_b=2;}else if(ch&_:e_COMPRESS_FORMAT_DATA_LIST)_b=3;}else for(new _j=0;(arg=_b==1?W@(func,"iii",pid,(_:l),_j):_b==2?W@(func,"ii",(_:l),_j):_b==3?getarg(curArg,_j++):getarg(curArg)),(_j!=-1&&_b)?TRUE:++curArg&&FALSE;_b=_b==4?0:_b)

// Make the correct specifier string for the data stored in the compressed
// specifier data.
#define Y_RENDER_SPECIFIER(%0) ((ch&_:e_COMPRESS_FORMAT_DATA_ZERO)?((ch&_:e_COMPRESS_FORMAT_DATA_LEFT)?(scFormats[3][6]='%0',scFormats[3]):(scFormats[2][5]='%0',scFormats[2])):((ch&_:e_COMPRESS_FORMAT_DATA_LEFT)?(scFormats[1][5]='%0',scFormats[1]):(scFormats[0][4]='%0',scFormats[0])))

// This makes hex and binary format specifiers display correctly with negative
// numbers in all cases (e.g. %5x etc).
#define Y_RENDER_FIX_NEGATIVE(%0:%1) if(width>%1)arg=(ch&_:e_COMPRESS_FORMAT_DATA_LEFT)?((ch&_:e_COMPRESS_FORMAT_DATA_ZERO)?format(ts,128,"%"#%0"%0-*"#%0,arg>>>32/%1,width-(%1-1),arg&(1<<32/%1)-1):format(ts,128,"%"#%0"%-*"#%0,arg>>>32/%1,width-(%1-1),arg&(1<<32/%1)-1)):(ch&_:e_COMPRESS_FORMAT_DATA_ZERO)?format(ts,128,"%0*"#%0"%"#%0,width-1,arg>>>32/%1,arg&(1<<32/%1)-1):format(ts,128,"%*"#%0"%"#%0,width-1,arg>>>32/%1,arg&(1<<32/%1)-1);else format(ts,128,"%"#%0"%"#%0,arg>>>32/%1,arg&(1<<32/%1)-1)

// Try add a string to the current output.  This needs modifying to reset the
// whole function after a string is displayed.  "onlyOne" is set in the case
// where any line excess is cut off (e.g. in marquees).
//#define Y_RENDER_ADD(%1) switch(Format_DoAddString(pid,output,%1,p,maxlen,llen,strlen(%1),fakepos,fade)){case 1:++one;case 2:Format_DoTryShow(output,fade);}

#define Y_RENDER_ADD(%1) for(new __added,__len=strlen((%1)),__done;(__added=Format_DoAddString(output,%1[__done],p,__len,llen,fakePos));__done+=__added,__len-=__added){if(fade)state y_render_fade:y_render_fade_fake;else{Format_DoDisplay(pid,colour,output,p);if(onlyOne)return one;llen=maxlen;++one;}}
#define Y_RENDER_CHAR(%1) while(!Format_DoAddChar(output,(%1),p,llen,fakePos)){if(fade)state y_render_fade:y_render_fade_fake;else{Format_DoDisplay(pid,colour,output,p);if(onlyOne)return one;llen=maxlen;++one;}}

// Helper macros to determine what a character is.  This could be modified to
// take in to account unicode letters, but that's hard.  I don't know enough
// about unicode, and frankly there are WAY too many characters to be listed
// here.  If other people want to modify this to support their language then
// good on them.
#define Y_TEXT_LETTER(%0) ('a'<=(%0)<='z'||'A'<=(%0)<='Z')
#define Y_TEXT_NUMBER(%0) ('0'<=(%0)<='9')

#define Y_RENDER_SCM_COLOUR_LEN (8)

#define e_FORMAT_FLAGS_INDEX (0x00FFFFFF)
#define e_FORMAT_FLAGS_REDO  (0x01000000)
#define e_FORMAT_FLAGS_ONE   (0x02000000)

static stock
	YSI_g_sFadeRedoTarget,
	YSI_g_sFadeLength,
	YSI_g_sFadeColour;

static stock Format_InsertColour(str[], pos, &rem, &curCol, newCol, step) //<y_render_display : send_client_message>
{
	// This code doesn't yet deal with colours which are too close to have their
	// differences detected by the human eye (especially when there are spaces).
	curCol = newCol;
	if (pos == 0)
	{
		// Don't add the colour - this is handled in the text display function.
		return 0;
	}
	// Now try add the string version of the colour.
	//printf("rem: %d, required: %d", rem, Y_RENDER_SCM_COLOUR_LEN);
	if (rem < Y_RENDER_SCM_COLOUR_LEN + step)
	{
		// Not enough space to add a new colour.
		str[pos] = '\0';
		return -1;
	}
	// This may well cut characters off the end of the string, but don't worry,
	// well, you can worry because it may mean that some characters are parsed
	// multiple times, but there's not a lot you can do about it...  This is one
	// of the few places where the extra "+ 1" is taken in to account as format
	// uses it internally.
	format(str[pos], rem + 1, "{%06x}%s", newCol & 0xFFFFFF, str[pos]);
	rem -= Y_RENDER_SCM_COLOUR_LEN;
	return Y_RENDER_SCM_COLOUR_LEN;
}

static stock Format_AddColour(str[], pos, &rem, &curCol, newCol) //<y_render_display : send_client_message>
{
	// This code doesn't yet deal with colours which are too close to have their
	// differences detected by the human eye (especially when there are spaces).
	curCol = newCol;
	if (pos == 0)
	{
		// Don't add the colour - this is handled in the text display function.
		return 0;
	}
	// Now try add the string version of the colour.
	if (rem < Y_RENDER_SCM_COLOUR_LEN)
	{
		// Not enough space to add a new colour.
		str[pos] = '\0';
		return -1;
	}
	format(str[pos], rem + 1, "{%06x}", newCol & 0xFFFFFF);
	rem -= Y_RENDER_SCM_COLOUR_LEN;
	//curCol = newCol;
	return Y_RENDER_SCM_COLOUR_LEN;
}

// str = input and output write array.
// pos = start position of the string to be faded.
// len = total remaining space in the string.
// endColour = target colour.
// initialColour = start and current colour.
// step = number of characters for each colour.
// offset = number of characters in the fade not being shown.
static stock Format_AddFade(str[], &pos, len, endColour, &initialColour, step, offset) //<y_render_display : send_client_message>
{
	// Add a fade for a SendClientMessage.  This is called if a string is filled
	// up during a fade or the end of a fade is reached correctly.  In either
	// case the current fade will constiture the end of the known current string
	// so in actual fact no additionl text after the end of the fade will be
	// dropped.  This is also where we can save the data to appear in the fade
	// on the next line and re-show it.
	// Work out how many colours can be inserted at the specified step value
	// (i.e. how often a new colour appears) within the length from "pos" to the
	// end of "str".  This may be more than is required.  "len" is from "pos" to
	// the end of the string, NOT to the end of the characters requiring the
	// fade.  The length of the required fade is in "YSI_g_sFadeLength" so that the
	// value can be used in the future.
	new
		parts = (YSI_g_sFadeLength + step - 1) / step + offset,
		// We can insert all the colours and their texts in the given space.
		// Now we just need to figure out how...
		// First get the start and end colours.
		start = str[pos + 1] & 0xFFFFFF;
	// Remove the start and end colour markers.
	strdel(str, pos, pos + 2);
	// Find the colour components and component deltas.
	endColour &= 0xFFFFFF;
	new
		red = start >>> 16 & 0xFF,
		dred = ((endColour >>> 16 & 0xFF) - red) / parts,
		blue = start >>> 0 & 0xFF,
		dblue = ((endColour >>> 0 & 0xFF) - blue) / parts,
		green = start >>> 8 & 0xFF,
		dgreen = ((endColour >>> 8 & 0xFF) - green) / parts;
	// Take old strings in to account.
	red += dred * offset;
	blue += dblue * offset;
	green += dgreen * offset;
	//strdel(str, pmax, pmax + 2);
	//startColour = initialColour;
	do
	{
		// Insert the new colour, if it is sufficiently different from the
		// existing colour to warrant being added new.
		new
			upd = Format_InsertColour(str, pos, len, initialColour, red << 16 | green << 8 | blue, step);
		if (upd == -1)
		{
			// Didn't quite finish everything.  This is the number of characters
			// left to process.
			return YSI_g_sFadeLength;
		}
		//initial += step;
		pos += step + upd;
		YSI_g_sFadeLength -= step;
		len -= step;
		red = red + dred & 0xFF;
		green = green + dgreen & 0xFF;
		blue = blue + dblue & 0xFF;
		// Could do something with "len" here if it runs out to signify that
		// more text needs to go on the next line of output.
	}
	while (YSI_g_sFadeLength > 0);
	// Correct for any excess characters.
	pos += YSI_g_sFadeLength;
	// This doesn't add the actual destination colour - that is added by virtue
	// of the fact that it is actually just a normal colour, so we can use the
	// standard colour code (whatever that may be) to add it in a more generic
	// way.
	return 0;
}

static stock Format_DoEndFade(output[], &start, end, &rem, colour, &initial) //<>
{
	// If "colour" is 0 this is the end of a strign before the close colour is
	// reached.  This fact is enforced by "Y_FORMAT_ALWAYS_SET", which ensures
	// that all colours, including black, are not 0 in the string to avoid PAWN
	// treating the colour as a NULL terminator or, as here, a no-colour marker.
	if (colour)
	{
		new
			offset = 0;
		if (YSI_g_sFadeLength)
		{
			initial = YSI_g_sFadeColour;
			offset = end - start - YSI_g_sFadeLength;
			//printf("parts: %d, %d, %d", offset, YSI_g_sFadeLength, end - start);
		}
		else
		{
			YSI_g_sFadeLength = end - start;
		}
		// "rem" will hold the number of characters AFTER the fade string on
		// entry, this needs fixing here to exclude them as they're being messed
		// with.
		rem += YSI_g_sFadeLength;
		//printf("length: %d", YSI_g_sFadeLength);
		// I wrote this code for the case where too much data has been found and
		// we needed a fake render to get the full length, but then found that
		// exactly the same code was needed for the default case too...
		//printf("Format_DoEndFade: %d %d %x %x %d", YSI_g_sFadeLength, /*YSI_g_sFadeLength +*/ rem, colour, initial, start);
		// Default step value is 1 and there is currently no way to change it.
		new
			ret = Format_AddFade(output, start, /*YSI_g_sFadeLength +*/ rem, colour, initial, 1, offset);
		//printf("Format_DoEndFade: %d %d %x %x %d", YSI_g_sFadeLength, /*YSI_g_sFadeLength +*/ rem, colour, initial, start);
		YSI_g_sFadeColour = initial;
		return ret;
	}
	else
	{
		//printf("colour: %d", YSI_g_sFadeColour);
		// Quite simply, we just change state and return to the calling
		// function.  This allows this function to be called again when the true
		// fade end is reached and the length to be determined.  After that some
		// re-parsing will need to be done I'm afraid, but that will be handled
		// by code dealing with fades which fall over the end of a string, be it
		// due to this or to a known length string being pushed over the end due
		// to the insertion of the colour codes.  Note that this code is display
		// method independent - it works for SendClientMessage, GameText and
		// others.
		state y_render_fade : y_render_fade_fake;
		// The return here causes remaining code to continue as normal, but
		// makes certain functions just not run.
	}
	return 0;
}

/*----------------------------------------------------------------------------*\
Function:
	Format_DoAddString
Params:
	out[] - The destination string.
	in[] - The data to add.
	&oidx - The index in "out" at which to add data.
	len - The length of "in".
	&orem - Space remaining in "out".
	&fakePos - Like "oidx", but cumulative over line breaks.
Return:
	The amount of data from "in" not added to "out".
Notes:
	Takes an input string and adds it to an output string.  If the input string
	is too long to fit in the remainder of the output string, what has been
	added already (including part of the input string) is displayed and a new
	string is added.  Format_TryShow handles this, including adding formatting
	of colour fades, which may involve fake rendering of more of the string to
	determine how much of the remainder of the string needs processing to get
	the right colour.  This will also require a method of winding back the state
	to the point just after the initial input string was added to continue on to
	show the next string including newly determined fade data.
\*----------------------------------------------------------------------------*/

static stock Format_DoAddString(out[], const in[], &oidx, const len, &orem, &fakepos) <y_render_fade : y_render_fade_fake>
{
	#pragma unused out, in, oidx, orem
	fakepos += len;
	return 0;
}

static stock Format_DoAddString(out[], const in[], &oidx, const len, &orem, &fakepos) <y_render_fade : y_render_fade_redo>
{
	new
		temp = fakepos + len - YSI_g_sFadeRedoTarget;
	if (temp > 0)
	{
		state y_render_fade : y_render_fade_real;
		// This is where the string passes the target point of re-rendering.
		new
			other = YSI_g_sFadeRedoTarget - fakepos;
		fakepos += other;
		return Format_DoAddString(out, in[other], oidx, temp, orem, fakepos);
	}
	else
	{
		fakepos += len;
		return 0;
	}
}

static stock Format_DoAddString(out[], const in[], &oidx, const len, &orem, &fakepos) <y_render_fade : y_render_fade_real>
{
	P:4("Format_DoAddString <y_render_fade : render_real> called: \"%s\", \"%s\", %i, %i, %i, %i", out, in, oidx, len, orem, fakepos);
	// For now don't worry about fades over boundaries - they're just too hard
	// to get the code working on to start with, maybe later once this is all
	// working they can be added in.  It is a shame though as it will mean fades
	// don't always work.  I can cheat slightly though and have the full fade on
	// both halves of the break.  Or just warn people about fades like that.
	// 
	// NOTE: This code assumes that orem (output remaining) is always 1 less
	// than the true value.  This avoids awkward calculations when appending the
	// NULL terminator to strings.  When we run out of space it simply appends
	// it regardless of wether it thinks there is space or not.
	// 
	fakepos += len;
	if (len <= orem)
	{
		P:5("Format_DoStringSCM: p0.");
		memcpy(out[oidx], in, 0, len * 4, orem);
		orem -= len;
		oidx += len;
		// The whole string fit in - return true.
		return 0;
	}
	else
	{
		// Not the end of the string, but the end is required.
		// Change state to ignore future inputs.
		P:5("Format_DoStringSCM: p1.");
		// Copy as much data as possible.
		memcpy(out[oidx], in, 0, orem * 4, orem);
		//orem -= orem;
		//oidx += orem;
		// Don't need to adjust this further down as all the characters will be
		// added before the recursive call.
		oidx += orem;
		return len - orem;
	}
}

static stock bool:Format_DoAddChar(out[], const in, &oidx, &orem, &fakepos) <y_render_fade : y_render_fade_fake>
{
	#pragma unused out, in, oidx, orem
	++fakepos;
	return true;
}

static stock bool:Format_DoAddChar(out[], const in, &oidx, &orem, &fakepos) <y_render_fade : y_render_fade_redo>
{
	if (fakepos == YSI_g_sFadeRedoTarget)
	{
		state y_render_fade : y_render_fade_real;
		// This should never actually fail...
		if (!orem) return false;
		out[oidx++] = in;
	}
	++fakepos;
	return true;
}

static stock bool:Format_DoAddChar(out[], const in, &oidx, &orem, &fakepos) <y_render_fade : y_render_fade_real>
{
	if (!orem) return false;
	out[oidx++] = in;
	++fakepos;
	return true;
}

static stock Format_DoDisplay(playerid, colour, out[], &idx) <y_render_show : y_render_show_scm>
{
	out[idx] = '\0';
	SendClientMessage(playerid, colour, out);
	idx = 0;
	//out[0] = '\0';
}

static stock Format_DoDisplay(playerid, colour, out[], &idx) <y_render_show : y_render_show_print>
{
	out[idx] = '\0';
	P:0("Format_DoDisplay: %d, %06x, \"%s\"", playerid, colour >>> 8, out);
	idx = 0;
	//out[0] = '\0';
}

static stock Format_DoDisplay(playerid, colour, out[], &idx) <y_render_show : y_render_show_gt>
{
	#pragma unused colour, playerid
	out[idx] = '\0';
	//GameTextForPlayer(playerid, out, 
	//SendClientMessage(playerid, colour, out);
	idx = 0;
	//out[0] = '\0';
}

// Generic function to handle rendering for all types of outputs.  Other
// functions such as Format_AddColour are specialised for different text styles.
// The faster way to do this would be to store the characters removed from a
// string when adding in fade data, but this is hard to code.  The simpler
// method is to fake re-render the string, having previously determined the
// length of the string which will be faded across.  Note that this may mean
// that some parts of the string can get rendered many times, but we can just
// issue a performance warning when the player uses fades which go over a line
// boundary.  That is the only time in which it is a problem, more specifically
// it is only a problem when text in a fade goes over a line boundardy before
// the end fade marker has been reached.
stock Format_Render(pid, Language:l, output[], maxlen, idx, target, string[], argCount, {Float,_}:...)
{
// This is used to fake tail-recursion.
Format_Render_start:
	P:3("Format_Render called: %i, %i, %s, %i, %i, %i, %s, %i (+%i)", pid, _:l, output, maxlen, idx, target, string, argCount, numargs() - 8);
	//state y_text_colour_fade:full_render;
	new
		colour = 0x00FF00AA;
	static
		scFormats[][8] =
			{
				"%*.*d",  // 6 (6)
				"%-*.*d", // 7 (13)
				"%0*.*d", // 7 (20)
				"%0-*.*d" // 8 (28)
			},
		scSpecifier[8],
		// =====================================================================
		//  UPDATE Y_RENDER_FIX_NEGATIVE MACRO ON CHANGE!!!!!!!
		ts[128],
		//  Max handleable input string length is 128 (hopefully sufficient).
		// =====================================================================
		func[32];
	new
		ch,
		llen = maxlen,
		//output[128], // Always 128.
		p = 0,
		curArg = 8,
		numArgs = numargs() + argCount,
		//llen = sizeof (output) - 1,
		arg,
		onlyOne = target & e_FORMAT_FLAGS_ONE,
		fakePos = 0,
		bool:fade = false,
		// Was only "one" string display used and is this not per-player text?
		one = 0,
		// Start location of the current fade.
		fadeStart,
		fadeStartIdx;
	if (target & e_FORMAT_FLAGS_REDO)
	{
		// We need to skip data, ignore everything before "target1".
		target &= e_FORMAT_FLAGS_INDEX;
		state y_render_fade : y_render_fade_redo;
	}
	else
	{
		state y_render_fade : y_render_fade_real;
	}
	/*new
		fadeCurArg,
		fadeArg,
		fadeIdx;*/
	if ((YSI_g_sFadeRedoTarget = target))
	{
		YSI_g_sFadeRedoTarget &= ~Y_FORMAT_ALWAYS_SET;
		state y_render_fade : y_render_fade_redo;
	}
	else
	{
		state y_render_fade : y_render_fade_real;
	}
	while ((ch = string[idx++]))
	{
		// TODO: Add {*} and #* format for variable colours.
		switch (ch)
		{
			case '\01':
			{
				// Null.
				break;
			}
			case '\02':
			{
				P:6("Text_Render: Format specifier %d", curArg);
				if (curArg == numArgs)
				{
					// Skip.
					P:W("Insufficient parameters to YSI format.");
					ts = "(null)";
					Y_RENDER_ADD(ts)
					continue;
				}
				// Format.
				ch = string[idx++];
				new
					width = (ch & _:e_COMPRESS_FORMAT_DATA_WIDTH),
					prec  = (ch & _:e_COMPRESS_FORMAT_DATA_PREC) >>> 12;
				// Get the true values of the various data bits.
				if (width == 0x0800)
				{
					width = getarg(curArg++);
				}
				if (prec == 0x0800)
				{
					prec = getarg(curArg++);
				}
				else if (prec == 0x0FFF)
				{
					prec = -1;
				}
				// Output the correct data type.
				switch (ch & 0xF0000000)
				{
					case e_COMPRESS_FORMAT_DATA_DEC:
					{
						P:6("Text_Render: Add d");
						scSpecifier = Y_RENDER_SPECIFIER(d);
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							format(ts, sizeof (ts), scSpecifier, width, prec, arg);
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_HEX:
					{
						// This completely fixes (I hope) the problems with
						// displaying negative numbers as %h/%x numbers.
						P:6("Text_Render: Add h");
						scSpecifier = Y_RENDER_SPECIFIER(x);
						Y_RENDER_ARG
						{
							if (arg & 0x80000000)
							{
								Y_RENDER_FIX_NEGATIVE(x:8);
							}
							else
							{
								format(ts, sizeof (ts), scSpecifier, width, prec, arg);
							}
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_BIN:
					{
						P:6("Text_Render: Add b");
						scSpecifier = Y_RENDER_SPECIFIER(b);
						Y_RENDER_ARG
						{
							if (arg & 0x80000000)
							{
								Y_RENDER_FIX_NEGATIVE(b:32);
							}
							else
							{
								format(ts, sizeof (ts), scSpecifier, width, prec, arg);
							}
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_CHAR:
					{
						scSpecifier = Y_RENDER_SPECIFIER(c);
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							format(ts, sizeof (ts), scSpecifier, width, prec, arg);
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_FLOAT:
					{
						scSpecifier = Y_RENDER_SPECIFIER(f);
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							format(ts, sizeof (ts), scSpecifier, width, prec, arg);
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_IEEE:
					{
						Y_RENDER_ARG
						{
							if ((arg & 0x7F800000) == 0x7F800000)
							{
								scSpecifier = Y_RENDER_SPECIFIER(s);
								// One of the special numbers.
								if (arg & 0x007FFFFF)
								{
									// NAN.
									if (arg & 0x00400000)
									{
										// QNAN
										format(ts, sizeof (ts), scSpecifier, width, cellmax, "QNAN");
										Y_RENDER_ADD(ts)
									}
									else
									{
										// SNAN
										format(ts, sizeof (ts), scSpecifier, width, cellmax, "SNAN");
										Y_RENDER_ADD(ts)
									}
								}
								else
								{
									if (arg & 0x80000000)
									{
										// -INFINITY
										format(ts, sizeof (ts), scSpecifier, width, cellmax, "-INFINITY");
										Y_RENDER_ADD(ts)
									}
									else
									{
										// INFINITY
										format(ts, sizeof (ts), scSpecifier, width, cellmax, "INFINITY");
										Y_RENDER_ADD(ts)
									}
								}
							}
							else
							{
								scSpecifier = Y_RENDER_SPECIFIER(f);
								format(ts, sizeof (ts), scSpecifier, width, prec, arg);
								Y_RENDER_ADD(ts)
							}
						}
					}
					case e_COMPRESS_FORMAT_DATA_STRING:
					{
						scSpecifier = Y_RENDER_SPECIFIER(s);
						if (ch & _:e_COMPRESS_FORMAT_DATA_FUNC)
						{
							func = "@yR_";
							// Get the function name.
							for (new _k = 4; _k != 32; ++_k)
							{
								if (!(func[_k] = getarg(curArg, _k - 4)))
								{
									break;
								}
							}
							if (funcidx(func) == -1)
							{
								// Normal version.  This is ended by a null.
								// Other functions get the count in advance when
								// an index of -1 is passed.
								func[2] = 'r';
								// This code mimicks much of the internal
								// y_master code because wrapping this in a
								// macro is a) pointless and b) hard.  This code
								// is ALWAYS like this because of the nature of
								// it.
								new
									lst = setproperty(8, YSIM_CALLER),
									_j = 0;
								setproperty(8, YSIM_CALLER, _@);
								for ( ; ; )
								{
									CallRemoteFunction(func, "ii", _:l, _j);
									// Resolve the string.
									getproperty(9, "", YSIM_STRING, Q@);
									strunpack(Q@, Q@);
									if (Q@[0])
									{
										if (_j)
										{
											// Separate the strings - hard coded
											// list format currently I'm afraid.
											ts = ", ";
											Y_RENDER_ADD(ts)
										}
										format(ts, sizeof (ts), scSpecifier, width, prec, Q@);
										Y_RENDER_ADD(ts)
									}
									else
									{
										break;
									}
									++_j;
								}
								setproperty(8, YSIM_CALLER, lst);
							}
							else
							{
								// Player specific version.
								// Normal version.  This is ended by a null.
								// Other functions get the count in advance when
								// an index of -1 is passed.
								func[2] = 'r';
								// This code mimicks much of the internal
								// y_master code because wrapping this in a
								// macro is a) pointless and b) hard.  This code
								// is ALWAYS like this because of the nature of
								// it.
								new
									lst = setproperty(8, YSIM_CALLER),
									_j = 0;
								setproperty(8, YSIM_CALLER, _@);
								for ( ; ; )
								{
									CallRemoteFunction(func, "iii", pid, _:l, _j);
									// Resolve the string.
									getproperty(9, "", YSIM_STRING, Q@);
									strunpack(Q@, Q@);
									if (Q@[0])
									{
										if (_j)
										{
											// Separate the strings - hard coded
											// list format currently I'm afraid.
											ts = ", ";
											Y_RENDER_ADD(ts)
										}
										// Could do with configuring this to not
										// need to call "Y_RENDER_SPECIFIER" every
										// time.
										format(ts, sizeof (ts), scSpecifier, width, prec, Q@);
										Y_RENDER_ADD(ts)
									}
									else
									{
										break;
									}
									++_j;
								}
								setproperty(8, YSIM_CALLER, lst);
								// Force the string to be rebuilt every time.
								++one;
							}
						}
						else
						{
							// Single parameter.
							for (new _k = 0; _k != sizeof (ts); ++_k)
							{
								if (!(ts[_k] = getarg(curArg, _k)))
								{
									break;
								}
							}
							format(ts, sizeof (ts), scSpecifier, width, prec, ts);
							Y_RENDER_ADD(ts)
						}
						++curArg;
					}
					/*case e_COMPRESS_FORMAT_DATA_OCT:
					{
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							//format(ts, sizeof (ts), Y_RENDER_SPECIFIER(f), width, prec, arg);
							ts[Format_AddOct(ts, sizeof (ts) - 1, arg, width, ch)] = '\0';
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_COMM:
					{
					}
					case e_COMPRESS_FORMAT_DATA_SUFFIX:
					{
						scSpecifier = Y_RENDER_SPECIFIER(s);
						// TODO: Add language to this.
						//p += Format_AddSuffix(output[p], llen, getarg(curArg++), l);
						Y_RENDER_ARG
						{
							format(ts, sizeof (ts), scSpecifier, width, cellmax, Format_AddSuffix(arg, l));
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_UNSIGNED:
					{
						if (prec < 0) prec = 10;
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							//format(ts, sizeof (ts), Y_RENDER_SPECIFIER(f), width, prec, arg);
							//ts[Format_AddOct(ts, sizeof (ts) - 1, arg, width, ch)] = '\0';
							ts[Format_AddNum(ts, sizeof (ts) - 1, arg, width, ch, prec, false)] = '\0';
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_SIGNED:
					{
						if (prec < 0) prec = 10;
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							//format(ts, sizeof (ts), Y_RENDER_SPECIFIER(f), width, prec, arg);
							ts[Format_AddNum(ts, sizeof (ts) - 1, arg, width, ch, prec, true)] = '\0';
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_PLAYER:
					{
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							GetPlayerName(arg, ts, sizeof (ts));
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_LOGICAL: 
					{
						scSpecifier = Y_RENDER_SPECIFIER(s);
						Y_RENDER_ARG
						{
							//p += Format_AddInt(output[p], llen, arg, width, ch);
							format(ts, sizeof (ts), scSpecifier, width, prec, arg ? ("true") : ("false"));
							Y_RENDER_ADD(ts)
						}
					}
					case e_COMPRESS_FORMAT_DATA_DATE:
					{
						// Hard one - needs more interaction.
					}*/
				}
			}
			case '\03':
			{
				P:6("Text_Render: Colour");
				if (fade)
				{
					p = fadeStart;
					P:6("Format_Render: pre-DoEndFade: %d", p);
					new
						rem = Format_DoEndFade(output, p, fakePos, llen, string[idx], colour);
					P:6("Format_Render: post-DoEndFade: %d", p);
					if (rem)
					{
						// "rem" is the number of characters not processed.
						YSI_g_sFadeColour = colour;
						Format_DoDisplay(pid, colour, output, p);
						if (onlyOne)
						{
							return one;
						}
						llen = maxlen;
						++one;
						/*output[p] = '\0';
						printf("one stage: \"%s\"", output);
						output[0] = '\0';*/
						// Subtract 2 to get the index in to the fade where the
						// letters start.  This is not as easy as it used to be
						// as we need to manipulate the stack to push the extra
						// parameters somehow.  Actually, this is a tail-
						// recursive call, so no stack manipulation is required,
						// we just need to modify parameters and jump back to
						// the start as if nothing happened.
						idx = fadeStartIdx;
						target = fakePos - fadeStart - rem | e_FORMAT_FLAGS_REDO | (onlyOne ? e_FORMAT_FLAGS_ONE : 0);
						goto Format_Render_start;
						//return Format_Render(pid, l, output, maxlen, fadeStartIdx, fakePos - fadeStart - rem | e_FORMAT_FLAGS_REDO | (onlyOne ? e_FORMAT_FLAGS_ONE : 0), string);
					}
					fakePos += p - fadeStart;
					fade = false;
				}
				if (string[idx] & Y_FORMAT_START_FADE)
				{
					P:6("Format_Render: Add fade");
					fade = true;
					fadeStart = p;
					fadeStartIdx = idx - 1;
					if (p < maxlen - 1)
					{
						output[p++] = '\03';
						output[p++] = string[idx++];
					}
				}
				else
				{
					P:6("Format_Render: Add colour");
					arg = Format_AddColour(output, p, llen, colour, string[idx++]);
					switch (arg)
					{
						case -1:
						{
							Format_DoDisplay(pid, colour, output, p);
							if (onlyOne)
							{
								return one;
							}
							llen = maxlen;
							++one;
						}
						case 0:
						{
							// Do nothing.
						}
						default:
						{
							p += arg;
							fakePos += arg;
						}
					}
					// Just add the colour here normally.
					/*currentColour = string[idx++];
					if (maxlen - pos > Y_RENDER_SCM_COLOUR_LEN)
					{
						format(output[pos], maxlen - pos, "{%06x}", currentColour & ~(Y_FORMAT_START_FADE | Y_FORMAT_ALWAYS_SET));
						pos += Y_RENDER_SCM_COLOUR_LEN;
					}
					else
					{
						output[pos] = '\0';
						printf("some stage: \"%s\"", output);
						output[0] = '\0';
						pos = 0;
					}*/
					//++idx;
				}
			}
			case '\04':
			{
				P:6("Text_Render: Key");
				++idx;
			}
			case '\05':
			{
				// String extension.
				P:6("Text_Render: Extension");
				++idx;
				// TODO!
			}
			case '\n':
			{
				P:6("Text_Render: NL");
				// Check for 2 character new lines (\n\r).
				if (string[idx] == '\r') ++idx;
				// Output the last string.
				output[p] = '\0';
				Format_DoDisplay(pid, colour, output, p);
				output[0] = '\0';
				//p = 0;
				//llen = sizeof (output) - 1;
			}
			case '\r':
			{
				P:6("Text_Render: NL");
				// Check for 2 character new lines (\r\n).
				if (string[idx] == '\n') ++idx;
				// Output the last string.
				output[p] = '\0';
				Format_DoDisplay(pid, colour, output, p);
				output[0] = '\0';
				//p = 0;
				//llen = sizeof (output) - 1;
			}
			case '\t':
			{
				// Somehow display a tab.  Maybe keep track of characters
				// displayed and show "n % 4" spaces.
				arg = 4 - (p & 0x03); // The number of spaces to add.
				static
					sTabs[] = "    ";
				for (new __added; (__added = Format_DoAddString(output, sTabs[4 - arg], p, arg, llen, fakePos)); arg -= __added)
				{
					if (fade)
					{
						state y_render_fade : y_render_fade_fake;
					}
					else
					{
						Format_DoDisplay(pid, colour, output, p);
						if (onlyOne)
						{
							return one;
						}
						llen = maxlen;
						++one;
					}
				}
			}
			case '\06' .. '\08', '\11', '\12', '\14' .. '\32':
			{
				// Whitespace.  Just show a space, not the fancy character, no
				// idea what it could do.  Note that this range includes spaces.
				P:6("Text_Render: Space");
				Y_RENDER_CHAR(' ')
			}
			default:
			{
				P:6("Text_Render: Char");
				Y_RENDER_CHAR(ch)
			}
		}
		P:6("Text_Render: Loop: p = %d, llen = %d, output = \"%s\"", p, llen, output);
	}
	P:5("Text_Render: Final render?");
	if (p)
	{
		P:5("Text_Render: Yes!");
		output[p] = '\0';
		Format_DoDisplay(pid, colour, output, p);
		++one;
	}
	P:5("Text_Render: p = %d, output = \"%s\"", p, output);
	P:C(idx=0;while ((ch = output[idx++]))printf("%04x%04x = %c", ch >>> 16, ch & 0xFFFF, ch););
	P:5("Text_Render end");
	return one;
}
