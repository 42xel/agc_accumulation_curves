//a file to test the primitives of the lbss agc library

//Usage:
/*
java -jar <agcjar_path>agc_2_0.jar test_primitives.agc 
*/
use AGC;
load "lib_lbss_test.agc";

/*
////test of initial configuration
//a single register
test_initial_configuration_register.create(
"unit",		//the type of register: "cell", "accu", "unit"
1,		//the value held by the register
""		//the suffix of the name of the desired generated file
);
test_initial_configuration_register.create(
"accu",		//the type of register: "cell", "accu", "unit"
4,		//the value held by the register
""		//the suffix of the name of the desired generated file
);
test_initial_configuration_register.create(
"cell",		//the type of register: "cell", "accu", "unit"
0,		//the value held by the register
""		//the suffix of the name of the desired generated file
);
test_initial_configuration_register.create(
"cell",		//the type of register: "cell", "accu", "unit"
-5,		//the value held by the register
""		//the suffix of the name of the desired generated file
);

//the head
test_initial_configuration_head.create(
4,		//the accumulator value (at the head)
true,		//whether to show a dummy program signal
true,		//whether to show the signal for overflow
"full"		//the name of the desired generated file
);
test_initial_configuration_head.create(
4,		//the accumulator value (at the head)
false,		//whether to show a dummy program signal
false,		//whether to show the signal for overflow
"minimal"		//the name of the desired generated file
);

//a single Cell
test_initial_configuration_cells.create(
[],	//the part of the tape right of the head
[],	//the part of the tape left of the head
4,		//the value at the head
"NONE",		//the accumulator value (at the head)
"singleCell_noAccu"		//the name of the desired generated file
);
test_initial_configuration_cells.create(
[],	//the part of the tape right of the head
[],	//the part of the tape left of the head
4,		//the value at the head
3,		//the accumulator value (at the head)
"singleCell"		//the name of the desired generated file
);

//3 Cells
test_initial_configuration_cells.time .=  Cdist/3;
test_initial_configuration_cells.create(
[0],	//the part of the tape right of the head
[-5],	//the part of the tape left of the head
4,		//the value at the head
3,		//the accumulator value (at the head)
"3cells"		//the name of the desired generated file
);

//The signals does not show somehow. playing with scale does not help
test_initial_configuration_cells.create(
[4/5, -7/3],	
[0, -5],	//the part of the tape left of the head
4,		//the value at the head
3,		//the accumulator value (at the head)
"5cells"		//the name of the desired generated file
);

test_initial_configuration_cells.create(
[0],	//the part of the tape right of the head
[-5],	//the part of the tape left of the head
4,		//the value at the head
"NONE",		//the accumulator value (at the head)
"3cells_noAccu"		//the name of the desired generated file
);

//3 cells with margins
test_initial_configuration_margins.create(
[0],	//the part of the tape right of the head
[-5],	//the part of the tape left of the head
4,		//the value at the head
3,		//the accumulator value (at the head)
1,	//the margin size
""		//the name of the desired generated file
);


////Test of move.
test_move.create (
[0, -7/3],	//tape, center in the middle
4,		//accu
">",		//direction
""		//filename
);

test_move.create (
[4/5, 0],	
4,		
"<",		
""		
);


////Test of branch
test_branch.create (
-5/3,		//current
-3/2,		//accu
"negative"	//filename
);

test_branch.create (
0,		
0,		
"zero"	
);

test_branch.create (
5/3,		
5/2,		
"positive"	
);


////Test of reset
//test of targets
foreach(target:["accu", "cell"])
{
	test_reset.create (
	4,		//current
	-3/2,		//accu
	target,		//target
	""	//filename
	);
};

foreach(value:[34/9, 0, -23/6])
{
	test_reset.create (
	value,		
	7/4,
	"cell",
	value	
	);
};


////Test of get
//test of targets
foreach(target:["accu", "cell", "unit"])
//testing for different targets
{
	test_get.create (
	4,			//current
	-3/2,			//accu
	1,			//mutliplicative constant
	target,			//target
	""	//filename
	);
};

foreach(value:[7/3, 0, -3/2])
//testing for different values
{
	test_get.create (
	value,
	4/3,
	1,
	"cell",
	"_" & value
	);
};

foreach(cte:[1, 1/7, 7/2])
//testing for different multiplicative constants
{
	test_get.create (
	3,
	-5,
	cte,
	"accu",
	"_times" & cte
	);
};

////Test of add:
//test of targets
foreach(target:["accu", "cell"])
//testing for different targets
{

	test_add.create (
	4/3,			//current
	-3/2,			//accu
	4/3,		//value to add
	target,			//target
	""	//filename
	);
};

//testing for adding to zero
test_add.create (
	-4,
	0,
	4,
	"cell",
	"_add_to0"
	);

//testing for summing up to zero
test_add.create (
	0,
	-5,
	5,
	"accu",
	"_sumsup_to0"
	);

////Test of sub:
//test of targets
foreach(target:["accu", "cell"])
//testing for different targets
{
	test_sub.create (
	4/3,			//current
	-3/2,			//accu
	4,		//value to subtract
	target,			//target
	""	//filename
	);
};
//testing for subtracting from zero
test_sub.create (
	0,
	0,
	4,
	"cell",
	"sub_from0"
	);

//testing for subtracting down to zero
test_sub.create (
	0,
	5,
	5,
	"accu",
	"sub_to0"
	);

*/
////Test of OOB:
//add
test_Out_Of_Bound.create ("add",
	[],			//what's left of the current cell
	[5],			//what's right of the current cell
	-4/3,			//current
	-3/2,			//accu
	16,		//value to add
	"accu",			//target
	""	//filename
	);
//sub
test_Out_Of_Bound.create ("sub",
	[],			//what's left of the current cell
	[],			//what's right of the current cell
	4/3,			//current
	3/2,			//accu
	16,		//value to add
	"cell",			//target
	""	//filename
	);

//add, exactly on bound
test_Out_Of_Bound.create ("add",
	[],			//what's left of the current cell
	[],			//what's right of the current cell
	-4/3,			//current
	0,			//accu
	6,		//value to add
	"accu",			//target
	"bound"	//filename
	);

//sub, exactly on bound
test_Out_Of_Bound.create ("sub",
	[],			//what's left of the current cell
	[],			//what's right of the current cell
	0,			//current
	-3/2,			//accu
	6,			//value to add
	"cell",			//target
	"bound"	//filename
	);
/*
//test OOM:
test_Out_Of_Memory.create(
	[3, 5],	//what's left of the current cell
	[],	//what's right of the current cell
	4/3,	//the current cell's value
	-3/2,	//the accumulator's value
	1,	//the size of the margins
	-2,	//the oriented amount of cells by which to move the head
	"noOOM"	//the filename suffix
	);
test_Out_Of_Memory.create(
	[0],	//what's left of the current cell
	[],	//what's right of the current cell
	4/3,	//the current cell's value
	-3/2,	//the accumulator's value
	1,	//the size of the margins
	1,	//the oriented amount of cells by which to move the head
	""	//the filename suffix
	);
test_Out_Of_Memory.create(
	[],	//what's left of the current cell
	[2],	//what's right of the current cell
	4/3,	//the current cell's value
	-3/2,	//the accumulator's value
	1,	//the size of the margins
	-1,	//the oriented amount of cells by which to move the head
	""	//the filename suffix
	);

test_Out_Of_Memory.create(
	[-2],	//what's left of the current cell
	[2],	//what's right of the current cell
	1,	//the current cell's value
	0,	//the accumulator's value
	3,	//the size of the margins
	3,	//the oriented amount of cells by which to move the head
	""	//the filename suffix
	);
test_Out_Of_Memory.create(
	[3],	//what's left of the current cell
	[],	//what's right of the current cell
	0,	//the current cell's value
	1,	//the accumulator's value
	3,	//the size of the margins
	-2,	//the oriented amount of cells by which to move the head
	""	//the filename suffix
	);

/*
//test_Out_Of_Time
foreach(s:["", "lt", "eq", "gt"])
{
	test_Out_Of_Time.create (
		1/100,	//The cell factor of the clock period
		0,	//The tape factor of the clock period
		s,	//the suffix of the return signal triggering the OOT operation
		[3],	//what's left of the current cell
		[],	//what's right of the current cell
		-2,	//the current cell's value
		1,	//the accumulator's value) ;
		200,	//the numbers of steps;
		"normalReturn_"	//the filename suffix
	);
};

foreach(s:["OOB", "OOML", "OOMR"])
{
	test_Out_Of_Time.create (
		1,	//The cell factor of the clock period
		1/10,	//The tape factor of the clock period
		s,	//the suffix of the return signal triggering the OOT operation
		[3],	//what's left of the current cell
		[],	//what's right of the current cell
		0,	//the current cell's value
		1,	//the accumulator's value) ;
		1000,	//the numbers of steps;
		""	//the filename suffix
	);
};*/
