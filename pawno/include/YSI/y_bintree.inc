/*----------------------------------------------------------------------------*\
					===================================
					Y Sever Includes - Binary Tree Core
					===================================
Description:
	Provides functions to generate balanced binary search trees for efficient
	searching of large arrays by value.  Left branch is less than, right branch
	is greater than or equal to for multiple matching values.
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
	
	The Original Code is the YSI binary tree include.
	
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
	0.1.3
Changelog:
	12/08/07:
		Fixed a bug with empty trees.
	14/04/07:
		Updated header documentation with more than changelog.
	10/04/07:
		Added parents for easy deletion.
		Added node deletion code.
	08/04/07:
		Added Bintree_Add()
	24/03/07:
		First version.
Functions:
	Public:
		-
	Core:
		Bintree_QSort - Custom implementaion of QSort to keep pointers.
		Bintree_SortHalf - Itteratively balances halves of an array.
	Stock:
		Bintree_Generate - Generates a balanced binary tree from given input.
		Bintree_Reset - Resets a position in a tree.
		Bintree_FindValue - Finds the pointer for a value in the tree.
		Bintree_Add - Adds an item to a generated tree.
		Bintree_Delete - Removes an item from a tree.
		Bintree_UpdatePointers - Updates the pointers after a target change.
	Static:
		Bintree_Compress - Removes space from an altered tree.
		Bintree_FindMin - Finds the smallest value on a branch.
		Bintree_FindMax - Finds the largest value on a branch.
	Inline:
		Bintree_Sort - Entry point for Bintree_QSort.
		Bintree_Fill - Entry point for Bintree_SortHalf.
	API:
		-
Callbacks:
	-
Definitions:
	BINTREE_NO_BRANCH - Nowhere to go from the number in required direction.
	BINTREE_NOT_FOUND - Failure return.
Enums:
	E_BINTREE_TREE - Structure of a leaf of a binary tree.
	E_BINTREE_INPUT - Structure of an array of data to be added to a tree.
Macros:
	-
Tags:
	Bintree - Binary tree type.
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

#include <YSI\internal\y_version>

#include <YSI\y_debug>

#define BINTREE_NO_BRANCH -1
#define BINTREE_NOT_FOUND -1

// If this ever changes, update the size reference in y_users.
enum E_BINTREE_TREE
{
	E_BINTREE_TREE_VALUE,
	E_BINTREE_TREE_LEFT,
	E_BINTREE_TREE_RIGHT,
	E_BINTREE_TREE_PARENT,
	E_BINTREE_TREE_POINTER
}

enum E_BINTREE_INPUT
{
	E_BINTREE_INPUT_VALUE,
	E_BINTREE_INPUT_POINTER
}

//#define leafs<%1> %1][E_BINTREE_TREE
//#define Bintree:%1[%2] Bintree:%1[%2][E_BINTREE_TREE]
#define BinaryTree:%1<%2> Bintree:%1[%2][E_BINTREE_TREE]

// Update at a later date...
#define Bintree_DisplayOutput(%0) "<bintree output>"
#define Bintree_DisplayInput(%0) "<bintree input>"

/*----------------------------------------------------------------------------*\
Function:
	Bintree_Sort
Params:
	input[][E_BINTREE_INPUT] - Data to sort.
	size - Size of data to sort.
Return:
	-
Notes:
	Entry point for Bintree_QSort.
\*----------------------------------------------------------------------------*/

#define Bintree_Sort(%1,%2) \
	Bintree_QSort((%1), 0, (%2) - 1)

/*----------------------------------------------------------------------------*\
Function:
	Bintree_Fill
Params:
	BinaryTree:output<> - Destination for balanced tree.
	data[][E_BINTREE_INPUT] - Source data.
	size - Size of data.
Return:
	Bintree_SortHalf.
Notes:
	Entry point for Bintree_SortHalf.
\*----------------------------------------------------------------------------*/

#define Bintree_Fill(%1,%2,%3) \
	Bintree_SortHalf((%1), (%2), 0, (%3), 0, BINTREE_NO_BRANCH)

/*----------------------------------------------------------------------------*\
Function:
	Bintree_Generate
Params:
	BinaryTree:output<> - Binary tree to store the data in.
	input[][E_BINTREE_INPUT] - Input data to get the data from.
	size - Number of items to sort.
Return:
	-
Notes:
	Just calls the sort and fill routines.
\*----------------------------------------------------------------------------*/

stock Bintree_Generate(BinaryTree:output<>, input[][E_BINTREE_INPUT], size)
{
	P:3("Bintree_Generate called: %s, %s, %i", Bintree_DisplayOutput(output), Bintree_DisplayInput(input), size);
	if (!size)
	{
		output[0][E_BINTREE_TREE_PARENT] = BINTREE_NO_BRANCH;
		output[0][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
		output[0][E_BINTREE_TREE_RIGHT] = BINTREE_NO_BRANCH;
		return 0;
	}
	Bintree_Sort(input, size);
	Bintree_Fill(output, input, size);
	return 1;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_Reset
Params:
	BinaryTree:tree<> - Array to reset.
	pointer - Position to reset.
Return:
	-
Notes:
	Initialises the array for use.
\*----------------------------------------------------------------------------*/

stock Bintree_Reset(BinaryTree:tree<>, pointer = 0)
{
	P:3("Bintree_Reset called: %s, %i", Bintree_DisplayOutput(tree), pointer);
	tree[pointer][E_BINTREE_TREE_VALUE] = 0;
	tree[pointer][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
	tree[pointer][E_BINTREE_TREE_RIGHT] = BINTREE_NO_BRANCH;
	tree[pointer][E_BINTREE_TREE_PARENT] = BINTREE_NO_BRANCH;
	tree[pointer][E_BINTREE_TREE_POINTER] = BINTREE_NOT_FOUND;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_FindValue
Params:
	BinaryTree:tree<> - Tree to find the data in.
	value - Value to search for.
	&cont - Start point.
	&old - The last real leaf.
Return:
	-
Notes:
	Itterates through the array following the various paths till it locates
	the value provided or reaches a dead end.  If the current value is greater
	than the search value, the search goes left, otherwise right.
	
	If cont is not -1 the search will start from the data pointed to by the
	data pointed to by conts' right path, this is to allow collisions to be
	passed over if you want a subsequent one.
\*----------------------------------------------------------------------------*/

stock Bintree_FindValue(BinaryTree:tree<>, value, &cont = 0, &old = 0)
{
	P:3("Bintree_FindValue called: %s, %i, %i, %i", Bintree_DisplayOutput(tree), value, cont, old);
	new
		treeValue;
	while (cont != BINTREE_NO_BRANCH)
	{
		old = cont;
		treeValue = tree[old][E_BINTREE_TREE_VALUE];
		if (value < treeValue) cont = tree[old][E_BINTREE_TREE_LEFT];
		else
		{
			cont = tree[old][E_BINTREE_TREE_RIGHT];
			if (value == treeValue)
			{
				return tree[old][E_BINTREE_TREE_POINTER];
			}
		}
	}
	return BINTREE_NOT_FOUND;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_QSort
Params:
	numbers[][E_BINTREE_INPUT] - Data to sort.
	left - Start index.
	right - End index.
Return:
	-
Notes:
	Custom version of QSort (see YSI_misc) allows for E_BINTREE_INPUT data
	types, preserving the relative pointers for the sorted data.
\*----------------------------------------------------------------------------*/

stock Bintree_QSort(numbers[][E_BINTREE_INPUT], left, right)
{
	P:3("Bintree_QSort called: %s, %i, %i", Bintree_DisplayInput(numbers), left, right);
	new
		pivot = numbers[left][E_BINTREE_INPUT_VALUE],
		pointer = numbers[left][E_BINTREE_INPUT_POINTER],
		l_hold = left,
		r_hold = right;
	while (left < right)
	{
		while ((numbers[right][E_BINTREE_INPUT_VALUE] >= pivot) && (left < right)) right--;
		if (left != right)
		{
			numbers[left][E_BINTREE_INPUT_VALUE] = numbers[right][E_BINTREE_INPUT_VALUE];
			numbers[left][E_BINTREE_INPUT_POINTER] = numbers[right][E_BINTREE_INPUT_POINTER];
			left++;
		}
		while ((numbers[left][E_BINTREE_INPUT_VALUE] <= pivot) && (left < right)) left++;
		if (left != right)
		{
			numbers[right][E_BINTREE_INPUT_VALUE] = numbers[left][E_BINTREE_INPUT_VALUE];
			numbers[right][E_BINTREE_INPUT_POINTER] = numbers[left][E_BINTREE_INPUT_POINTER];
			right--;
		}
	}
	numbers[left][E_BINTREE_INPUT_VALUE] = pivot;
	numbers[left][E_BINTREE_INPUT_POINTER] = pointer;
	pivot = left;
	left = l_hold;
	right = r_hold;
	if (left < pivot) Bintree_QSort(numbers, left, pivot - 1);
	if (right > pivot) Bintree_QSort(numbers, pivot + 1, right);
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_SortHalf
Params:
	BinaryTree:output<> - Destination array.
	data[][E_BINTREE_INPUT] - Source array.
	index - Start index of the source for processing.
	upper - End index of the source for processing.
	offset - Current offset in the destination array for writing.
Return:
	Size of balanced tree.
Notes:
	Recursively calls itself.  Bisects the passed array and passed each half
	back to itself, with the middle value of each half being the left and
	right branches of the middle value of the passed array (which isn't
	included in either bisected half).  This is itterative so those are again
	split and again split.  If the passed array is only one or two elements
	big the behaviour is set and hardcoded.
	
	Equal values SHOULD branch right, the code is designed for this however
	the generation is not fully tested (it mostly branches right but adjacent
	after bisecting values haven't been tested).
	
	Based on code written for PHP by me.
\*----------------------------------------------------------------------------*/

stock Bintree_SortHalf(BinaryTree:output<>, data[][E_BINTREE_INPUT], index, upper, offset, parent)
{
	P:3("Bintree_SortHalf called: %s, %s, %i, %i, %i, %i", Bintree_DisplayOutput(output), Bintree_DisplayInput(data), index, upper, offset, parent);
	new
		num = upper - index;
	if (!num) return offset;
	if (num == 1)
	{
		output[offset][E_BINTREE_TREE_VALUE] = data[index][E_BINTREE_INPUT_VALUE];
		output[offset][E_BINTREE_TREE_POINTER] = data[index][E_BINTREE_INPUT_POINTER];
		output[offset][E_BINTREE_TREE_PARENT] = parent;
		output[offset][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
		output[offset][E_BINTREE_TREE_RIGHT] = BINTREE_NO_BRANCH;
	}
	else if (num == 2)
	{
		output[offset][E_BINTREE_TREE_VALUE] = data[index][E_BINTREE_INPUT_VALUE];
		output[offset][E_BINTREE_TREE_POINTER] = data[index][E_BINTREE_INPUT_POINTER];
		output[offset][E_BINTREE_TREE_PARENT] = parent;
		output[offset][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
		output[offset][E_BINTREE_TREE_RIGHT] = ++offset;
		output[offset][E_BINTREE_TREE_VALUE] = data[++index][E_BINTREE_INPUT_VALUE];
		output[offset][E_BINTREE_TREE_POINTER] = data[index][E_BINTREE_INPUT_POINTER];
		output[offset][E_BINTREE_TREE_PARENT] = offset - 1;
		output[offset][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
		output[offset][E_BINTREE_TREE_RIGHT] = BINTREE_NO_BRANCH;
	}
	else
	{
		new
			half = num / 2,
			off = half + index,
			right;
		while (off && data[off][E_BINTREE_INPUT_VALUE] == data[off - 1][E_BINTREE_INPUT_VALUE]) off--;
		right = Bintree_SortHalf(output, data, index, off, offset + 1, offset);
		output[offset][E_BINTREE_TREE_VALUE] = data[off][E_BINTREE_INPUT_VALUE];
		output[offset][E_BINTREE_TREE_POINTER] = data[off][E_BINTREE_INPUT_POINTER];
		output[offset][E_BINTREE_TREE_PARENT] = parent;
		output[offset][E_BINTREE_TREE_LEFT] = offset + 1;
		output[offset][E_BINTREE_TREE_RIGHT] = right;
		return Bintree_SortHalf(output, data, off + 1, upper, right, offset);
	}
	return offset + 1;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_Add
Params:
	BinaryTree:data<> - Array to add to.
	pointer - Pointer to add.
	value - Value to add.
	offset - Location in the array to store the data.
	maxsize - Size of data.
Return:
	Next free location
Notes:
	-

native Bintree_Add(BinaryTree:tree<>, pointer, value, offset, maxsize = sizeof (data));

\*----------------------------------------------------------------------------*/

stock Bintree_Add(BinaryTree:data<>, pointer, value, offset, maxsize = sizeof (data))
{
	P:3("Bintree_Add called: %s, %i, %i, %i, %i", Bintree_DisplayOutput(data), pointer, value, offset, maxsize);
	if (offset >= maxsize) return BINTREE_NOT_FOUND;
	if (offset)
	{
		new
			leaf,
			old;
		while (Bintree_FindValue(data, value, leaf, old) != BINTREE_NOT_FOUND) continue;
		//Bintree_Reset(data, offset);
		if (value < data[old][E_BINTREE_TREE_VALUE]) data[old][E_BINTREE_TREE_LEFT] = offset;
		else data[old][E_BINTREE_TREE_RIGHT] = offset;
		data[offset][E_BINTREE_TREE_PARENT] = old;
		data[offset][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
		data[offset][E_BINTREE_TREE_RIGHT] = BINTREE_NO_BRANCH;
		data[offset][E_BINTREE_TREE_VALUE] = value;
		data[offset][E_BINTREE_TREE_POINTER] = pointer;
		return offset + 1;
	}
	else
	{
		data[0][E_BINTREE_TREE_PARENT] = BINTREE_NO_BRANCH;
		data[0][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
		data[0][E_BINTREE_TREE_RIGHT] = BINTREE_NO_BRANCH;
		data[0][E_BINTREE_TREE_VALUE] = value;
		data[0][E_BINTREE_TREE_POINTER] = pointer;
		return 1;
	}
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_Delete
Params:
	BinaryTree:tree<> - Data.
	index - Index to remove.
	count - Number of binary tree items.
Return:
	-
Notes:
	The left branch is usually larger due to the division
	method used so we start there.  Even though right is
	>= and left is only < in even sized arrays the greater
	chunk (unless there's only 2 items) goes left.
	
	Called itteratively to ensure branches are maintained.
\*----------------------------------------------------------------------------*/

stock Bintree_Delete(BinaryTree:source<>, index, count)
{
	P:3("Bintree_Delete called: %s, %i, %i", Bintree_DisplayOutput(source), index, count);
	new
		branch,
		old = index;
	while (TRUE)
	{
		if ((branch = source[old][E_BINTREE_TREE_LEFT]) != BINTREE_NO_BRANCH) branch = Bintree_FindMax(source, branch);
		else if ((branch = source[old][E_BINTREE_TREE_RIGHT]) != BINTREE_NO_BRANCH) branch = Bintree_FindMin(source, branch);
		else
		{
			if ((branch = source[old][E_BINTREE_TREE_PARENT]) != BINTREE_NO_BRANCH)
			{
				if (source[branch][E_BINTREE_TREE_LEFT] == old) source[branch][E_BINTREE_TREE_LEFT] = BINTREE_NO_BRANCH;
				else source[branch][E_BINTREE_TREE_RIGHT] = BINTREE_NO_BRANCH;
			}
			return Bintree_Compress(source, old, count);
		}
		new
			value = source[old][E_BINTREE_TREE_VALUE],
			pointer = source[old][E_BINTREE_TREE_POINTER];
		source[old][E_BINTREE_TREE_VALUE] = source[branch][E_BINTREE_TREE_VALUE];
		source[old][E_BINTREE_TREE_POINTER] = source[branch][E_BINTREE_TREE_POINTER];
		source[branch][E_BINTREE_TREE_VALUE] = value;
		source[branch][E_BINTREE_TREE_POINTER] = pointer;
		old = branch;
	}
	return BINTREE_NO_BRANCH;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_Compress
Params:
	BinaryTree:tree<> - Array to compress.
	index - Point to start at.
	count - Number of items total.
Return:
	-
Notes:
	-
\*----------------------------------------------------------------------------*/

static stock Bintree_Compress(BinaryTree:data<>, index, count)
{
	P:4("Bintree_Compress called: %s, %i, %i", Bintree_DisplayOutput(data), index, count);
	new
		index2 = index + 1;
	while (index < count)
	{
		new
			left = (data[index][E_BINTREE_TREE_LEFT] = data[index2][E_BINTREE_TREE_LEFT]),
			right = (data[index][E_BINTREE_TREE_RIGHT] = data[index2][E_BINTREE_TREE_RIGHT]),
			parent = (data[index][E_BINTREE_TREE_PARENT] = data[index2][E_BINTREE_TREE_PARENT]);
		data[index][E_BINTREE_TREE_VALUE] = data[index2][E_BINTREE_TREE_VALUE];
		data[index][E_BINTREE_TREE_POINTER] = data[index2][E_BINTREE_TREE_POINTER];
		if (left != BINTREE_NO_BRANCH) data[left][E_BINTREE_TREE_PARENT] = index;
		if (right != BINTREE_NO_BRANCH) data[right][E_BINTREE_TREE_PARENT] = index;
		if (parent != BINTREE_NO_BRANCH)
		{
			if (data[parent][E_BINTREE_TREE_LEFT] == index2) data[parent][E_BINTREE_TREE_LEFT] = index;
			else if (data[parent][E_BINTREE_TREE_RIGHT] == index2) data[parent][E_BINTREE_TREE_RIGHT] = index;
		}
		index++;
		index2++;
	}
	return count - 1;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_FindMin
Params:
	BinaryTree:data<> - Array to search.
	offset - Start of branch to search.
Return:
	-
Notes:
	Finds the smallest value on a branch
\*----------------------------------------------------------------------------*/

static stock Bintree_FindMin(BinaryTree:data<>, offset)
{
	P:4("Bintree_FindMin called: %s, %i", Bintree_DisplayOutput(data), offset);
	new
		branch;
	while ((branch = data[offset][E_BINTREE_TREE_LEFT]) != BINTREE_NO_BRANCH) offset = branch;
	return offset;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_FindMax
Params:
	BinaryTree:data<> - Array to search.
	offset - Start of branch to search.
Return:
	-
Notes:
	Finds the largest value on a branch
\*----------------------------------------------------------------------------*/

static stock Bintree_FindMax(BinaryTree:data<>, offset)
{
	P:4("Bintree_FindMax called: %s, %i", Bintree_DisplayOutput(data), offset);
	new
		branch;
	while ((branch = data[offset][E_BINTREE_TREE_RIGHT]) != BINTREE_NO_BRANCH) offset = branch;
	return offset;
}

/*----------------------------------------------------------------------------*\
Function:
	Bintree_UpdatePointers
Params:
	BinaryTree:data<> - Data to modify.
	offset - Pointer to modify values after.
	mod - Value to modify by.
Return:
	-
Notes:
	Used for updating pointers when the target data has been modifed (i.e. a
	value has been removed from the array and the array shifted).
\*----------------------------------------------------------------------------*/

stock Bintree_UpdatePointers(BinaryTree:data<>, offset, size, mod = -1)
{
	P:3("Bintree_UpdatePointers called: %s, %i, %i, %i", Bintree_DisplayOutput(data), offset, size, mod);
	for (new i = 0; i < size; i++)
	{
		if (data[i][E_BINTREE_TREE_POINTER] > offset) data[i][E_BINTREE_TREE_POINTER] += mod;
	}
}
