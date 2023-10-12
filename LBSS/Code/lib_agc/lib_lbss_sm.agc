/*
An AGC file to build the backbone of an agc machine with lbss abilites
usage:

lbss .= create_signal_machine()
{
	////Initialisation of constants
	MAX_CTE := 4;
	MAX_MOVE := 1;
	//MaxCompTime := 0;
	DIST_PROG_ROOM := 4;

	load "lib_lbss_sm.agc";
};
*/

use AGC ;


COMPUTING_SPEED := 5;
SLOW_COMPUTING_SPEED := COMPUTING_SPEED/2;
COMPUTING_SPEED_FAST := 2 * COMPUTING_SPEED;
//the baseline speed of computing signals

COLOR_ZERO .= "Blue";
COLOR_NEG .= "DarkRed";
COLOR_POS .= "Green";
COLOR_COMPUTE := "Purple";
//COLOR_COMPUTE .= "White";	//used for some pictures
COLOR_VALUE .= "Blue";
LINESTYLE_VALUE .= "densely dashed";
LINE_STYLE_META .= "densely dashed";

COLOR_META .= "Purple";
COLOR_ERROR .= "Red";

///////////////tape/////////////
////meta-signals
.create_id_register .= (place, base, value) -> place & ":" & base & value;
	//creates a the name of a given signal used to store numbers
	//place: is it the accumulator or a cell? ("accu or "cell")
	//base: marker, bounds or zero ("", "m", "b" or "z")
	//value: does the value signal overlaps with the base signal ("" or "v")
.create_id_accu .= (v) -> create_id_register("accu", v, "");
foreach(place:["accu", "cell", "unit"])
{
//some of the "unit" meta signal are unused, but it's simpler to define that way
	add_meta_signal(create_id_register(place, "b-", ""), 0)	{color => COLOR_NEG;};
	add_meta_signal(create_id_register(place, "b+", ""), 0)	{color => "Dark" & COLOR_POS;};
	add_meta_signal(create_id_register(place, "z", ""), 0)	{color => COLOR_ZERO;};
	add_meta_signal(create_id_register(place, "", "v"), 0)	{color => COLOR_VALUE;
		line_style => LINESTYLE_VALUE;};
	add_meta_signal(create_id_register(place, "b-", "v"), 0)	{color => COLOR_NEG;
		line_style => LINESTYLE_VALUE;};
	add_meta_signal(create_id_register(place, "b+", "v"), 0)	{color => "Dark" & COLOR_POS;
		line_style => LINESTYLE_VALUE;};
	add_meta_signal(create_id_register(place, "z", "v"), 0)	{color => COLOR_ZERO;
		line_style => LINESTYLE_VALUE;};
};
add_meta_signal("Cell_marker", 0)	{color => DarkGray;};
//A marker to ease moving the head around. The program gets to be placed near one.

create_id_meta .= (suff) -> "META_" & suff;
	//creates a the name of a given signal used to control meta stuff: growing the band, rescaling values and contracting the computation.
foreach(s:["", "WAIT_OOML", "WAIT_OOMR", "WAIT_OOB", "WAIT_OOT", "WAIT_", "WAIT_lt", "WAIT_eq", "WAIT_gt"])
	add_meta_signal(create_id_meta(s), 0)	{color => COLOR_META;};
foreach(s:["MarkerFarLeft", "MarkerLeft", "MarkerRight", "MarkerFarRight"])
	add_meta_signal(create_id_meta(s), 0)	{color => DarkGray; line_style => LINE_STYLE_META;};

create_id_clock .= (suff) -> create_id_meta("CLOCK" _ suff);
add_meta_signal(create_id_clock("0"), 0)	{color => COLOR_META;};
////Initialisation
//Default values, and to define scope
if (MAX_CTE == undef)
	MAX_CTE .= 4;
if (MAX_CTE < 2)
	println("ERROR, MAX_CTE must be no lesser than 2");
//if (MAX_R == undef)
//	MAX_R .= 10;
DELTA .= 1/MAX_CTE;		//1 unit of space is converted to DELTA unit of time.

if (MAX_MOVE == undef)
	MAX_MOVE .= 1;
if (MAX_MOVE < 1)
	println("ERROR, MAX_MOVE must be a positive integer");

if (DIST_PROG_ROOM == undef)
	DIST_PROG_ROOM .= 4;
if (DIST_PROG_ROOM <= 0)
	println("ERROR, DIST_PROG_ROOM must be positive");

//MaxCompTime := 0;

CLOCK_SPEED := 0;
CLOCK_TIME := 1/100;



////configuration
//how much extra room for the program
//TODO put at the right place
create_configuration_tape .= (Cdist, MaxR) ->
{
	.MaxR := MAX(MaxR, MAX_CTE);
//TODO: deal with MaxCompTime and csq

//creates a tape configuration with "methods" and "attributes" to initialize it and to "export" it (insert it as a sub conf of another configuration)
//Cdist is the size of a cell
//MaxR is the maximal value held by a register (technically an upperbound more than a max).

//Cdist = 2 * unitWidth + 2 * Rdist + DIST_PROG_ROOM
//Rradius = MaxR * unitWidth
//Rdist = 2 * Rradius * (1 + Cratio)
//DIST_PROG_ROOM = 4 * unitWidth
//
//Rdist = 2 * Rradius * (1 + Cratio) = 2 * (1 + Cratio) * MaxR * unitWidth
//Cdist = (2 + 2 * 2 * (1 + Cratio) * MaxR + 4) * unitWidth

	.Cratio .= MAX_CTE;
//Cratio is the ratio between the distance inbetween two registers (cell or accu) and the diameter of a register
//	.unitWidth .= Cdist / (2 + 2 * 2 * (1 + Cratio) * MaxR + 4);
	.unitWidth .= Cdist / (6  + 4 * (1 + Cratio) * MaxR );
	//The length of a unit.
	.Rradius .= MaxR * unitWidth;
	//Rradius is the distance between zero and bound (half the diameter, bound to bound, of a register)
	.Rdist .= 2 * Rradius * (1 + Cratio);
	//the distance between two registers
	.DIST_PROG_ROOM := 4 * unitWidth;
	//.Cdist .= 2 * unitWidth + 2 * Rdist + DIST_PROG_ROOM;
	//the distance between two Cells: room for the cell value and an accumulator, as well as for the program
	:= ..create_configuration()
	{
		.program_position := "DUMMY";  // dummy value, will be set to right constant value by add_accu_cell
		.meta_position := "DUMMY";  // dummy value, will be set to right constant value by add_accu_cell
		.start := 0;
		.end := 0;
		.len := 0;	//the number of cells

		.add_register .= (p, value) ->
		{
			..end := ..end + Rdist/2;
			//centers on the center of the register
			create_id_register(p, "b-", "") ..@ ..end - Rradius;
			create_id_register(p, "b+", "") ..@ ..end + Rradius;
			if (value == 0)
			{
				create_id_register(p, "z", "v") ..@ ..end;
			}
			else
			{
				create_id_register(p, "z", "") ..@ ..end;
				create_id_register(p, "", "v") ..@ ..end + value * unitWidth ;
			};
			..end := ..end + Rdist/2;
		};
		.add_cell .= (value) ->
		{	//adds a single cell to the configuration
			"Cell_marker" ..@ ..end;
			..end := ..end + 2 * unitWidth + DIST_PROG_ROOM + Rdist;
			..add_register("cell", value);
			..len := ..len + 1 ;
		};
		.add_accu_cell .= (accu_value, cell_value) ->
		{
			"Cell_marker" ..@ ..end;
			if (program_position != "DUMMY")
			{
				println("Error: 'add_accu_cell' can only be used once (the configuration has only one head!)"); 
			};
			..program_position .= ..end + DIST_PROG_ROOM / 5 ;
			//the position of the program. It's a constant since it's defined at most once.
			..meta_position .= program_position + 3 * DIST_PROG_ROOM / 5 ;

			..create_id_meta("") ..@ meta_position;
			//the signal to handle mishaps.

			..end := ..end + DIST_PROG_ROOM;
			create_id_register("unit", "z", "") ..@ ..end;
			..end := ..end + unitWidth;
			create_id_register("unit", "", "v") ..@ ..end;
			..end := ..end + unitWidth;
			create_id_register("unit", "b+", "") ..@ ..end;

			..add_register("accu", accu_value);
			..add_register("cell", cell_value);
			..len := ..len + 1 ;
		};
		//////Clock
		//////////////////////
//TODO: releveance of Ctime_Tape? remove?
		.add_clock .= (Ctime_Cell, Ctime_Tape) ->
		{
			Ctime := (Ctime_Cell * Cdist + Ctime_Tape * (..end - ..start));

			.clockWidth .= 2 * DIST_PROG_ROOM / 5;
//			CLOCK_SPEED := 2 * clockWidth / Ctime;//.clockWidth / Ctime;		//not a constant to allow the "same" machine to be used with different clocks
			..init_clock(Ctime);

			..create_id_clock(0) ..@ meta_position - clockWidth;
			//FRIDGE: remove epsilon once get_metasignal_list is fixed.
			.epsilon .= clockWidth / 1000; //1/1000;
			..create_id_clock("<" _ Ctime) ..@ meta_position - epsilon;
		};

		//margins
		.add_special_cell .= (value, marker) ->
		{	//adds a single cell to the configuration
			marker ..@ ..end;
			..end := ..end + unitWidth + DIST_PROG_ROOM + Rdist;
			..add_register("cell", value);
			..len := ..len + 1 ;
		};
		.add_left_margin .= (n) ->
		{
			..add_special_cell(0, ..create_id_meta("MarkerFarLeft"));
			foreach(i:1...(n-1))
			{
				..add_cell(0);
			};
			..add_special_cell(0, ..create_id_meta("MarkerLeft"));
		};
		.add_right_margin .= (n) ->
		{
			add_special_cell(0, ..create_id_meta("MarkerRight"));
			foreach(i:1...(n-1))
			{
				..add_cell(0);
			};
			//..add_special_cell(0, ..create_id_meta("MarkerFarRight"));
			..create_id_meta("MarkerFarRight") ..@ ..end;
			..end .= ..end;
			//marks the end as constant: the Tape can no longer be extended. Fridge: handle verbosely
		};
		/*.conclude .= () ->
		{
		};*/
	};
};

///////////////********************basic manip*********************/////////////
.create_id_return .= (suffix) -> "<<" & suffix;
foreach(s:[""])
add_meta_signal(create_id_return(s), - COMPUTING_SPEED)	{color => COLOR_COMPUTE;};
//branch related returns
add_meta_signal(create_id_return("lt"), - COMPUTING_SPEED)	{color => COLOR_NEG;};
add_meta_signal(create_id_return("eq"), - COMPUTING_SPEED)	{color => COLOR_ZERO;};
add_meta_signal(create_id_return("gt"), - COMPUTING_SPEED)	{color => COLOR_POS;};
//(compute) get related returns
add_meta_signal(create_id_return("z"), - COMPUTING_SPEED)	{color => COLOR_ZERO;};
add_meta_signal(create_id_return("v"), - COMPUTING_SPEED)	{color => COLOR_VALUE;
		line_style => LINESTYLE_VALUE;};
add_meta_signal(create_id_return("zv"), - COMPUTING_SPEED)	{color => COLOR_ZERO;
		line_style => LINESTYLE_VALUE;};
//(META) set related returns
foreach(s:["OOB", "OOMR", "OOML", "OOT"])
	add_meta_signal(create_id_return(s), - COMPUTING_SPEED)	{color => COLOR_ERROR;};
	//out of bounds and out of memory.
	//FRIDGE: make it do something.

///////////////move///////////
////metasignals
.create_id_move .= (direction, suffix) -> "move" & direction & suffix;
.create_id_moved .= (direction, suffix) -> create_id_move(direction, "") &  "moved:" & suffix;
.create_ms_moved .= (direction, suffix) -> add_meta_signal(create_id_moved(direction, suffix), if (direction==">") COMPUTING_SPEED else -COMPUTING_SPEED);

.create_id_move_init_n .= (direction, n) -> create_id_move(direction, "0_" _ n);
.create_id_move_n .= (direction, n) -> create_id_move(direction, "_" _ n);

foreach(d:[">", "<"])
{
//	add_meta_signal(create_id_move(d, "0"), - COMPUTING_SPEED)		{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_move_init_n(d, 1), - COMPUTING_SPEED)		{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_move(d, "fast"), COMPUTING_SPEED_FAST)	{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_move(d, "fastOOM"), COMPUTING_SPEED_FAST)	{color => COLOR_COMPUTE;};

	.speed := if (d==">") COMPUTING_SPEED else -COMPUTING_SPEED;
//	add_meta_signal(create_id_move(d, "up"), speed)	{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_move_n(d, 1), speed)	{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_move_n(d, "1OOM"), speed)	{color => COLOR_COMPUTE;};

	create_ms_moved(d, create_id_accu("b-"))		{color => "Dark" & COLOR_NEG;};
	create_ms_moved(d, create_id_accu("b+"))		{color => "Dark" & COLOR_POS;};
	create_ms_moved(d, create_id_accu("z"))			{color => COLOR_ZERO;};
	create_ms_moved(d, create_id_accu("v"))			{color => COLOR_VALUE;
		line_style => LINESTYLE_VALUE;};
	create_ms_moved(d, create_id_register("accu", "z", "v")){color => COLOR_ZERO;
		line_style => LINESTYLE_VALUE;};

	create_ms_moved(d, create_id_register("unit", "", "b+"))	{color => "Dark" & COLOR_POS;};
	create_ms_moved(d, create_id_register("unit", "z", ""))		{color => COLOR_ZERO;};
	create_ms_moved(d, create_id_register("unit", "", "v"))		{color => COLOR_VALUE;
		line_style => LINESTYLE_VALUE;};

	foreach(s:["", "WAIT_OOT"])
		create_ms_moved(d, create_id_meta(s))	{color => COLOR_META;};
	create_ms_moved(d, create_id_clock(0))		{color => COLOR_META;};
};

////Collision rules
foreach(d:[">", "<"])
{
	//accelerating
	[create_id_move_init_n(d, 1), "Cell_marker"] --> ["Cell_marker", create_id_move(d, "fast"), create_id_move_n(d, 1)];
	.baseNVect .= [
			create_id_accu("b-"), create_id_accu("z"), create_id_accu("v"), create_id_accu("zv"),
			create_id_register("unit", "", "b+"), create_id_register("unit", "z", ""), create_id_register("unit", "", "v"),
			create_id_meta(""), create_id_meta("WAIT_OOT"), create_id_clock(0)
			];
	foreach(baseN:baseNVect)
		[create_id_move(d, "fast"), baseN] --> [create_id_moved(d, baseN), create_id_move(d, "fast")];
	[create_id_move(d, "fast"), create_id_accu("b+")] --> [create_id_moved(d, create_id_accu("b+"))];
	//decelerating
	[create_id_move_n(d, 1), "Cell_marker"] --> ["Cell_marker", create_id_move(d, "fast")];
	.Dir := if (d==">") "Right" else "Left";
	.D := if (d==">") "R" else "L";
	[create_id_move_n(d, 1), create_id_meta("Marker"_ Dir)] --> [create_id_meta("Marker"_ Dir), create_id_move(d, "fastOOM")];
	[create_id_move_n(d, "1OOM"), "Cell_marker"] --> ["Cell_marker", create_id_move(d, "fastOOM")];

	foreach(baseN:baseNVect)
	{
		[create_id_move(d, "fast"), create_id_moved(d, baseN)] --> [baseN, create_id_move(d, "fast")];
		[create_id_move(d, "fastOOM"), create_id_moved(d, baseN)] --> [baseN, create_id_move(d, "fastOOM")];
	};
	[create_id_move(d, "fast"), create_id_moved(d, create_id_accu("b+"))] --> [create_id_accu("b+"), "<<"];
	[create_id_move(d, "fastOOM"), create_id_moved(d, create_id_accu("b+"))] --> [create_id_accu("b+"), "<<OOM" _ D];
};


.create_mscr_move .= (d, n) -> if (get_meta_signal(create_id_move_init_n(d, n)) == void)
{
////recursivity
	if (n <= 0)
	{
		println("Error: move number must be positive"); 
	};
	create_mscr_move(d, n - 1);
////metasignals
	add_meta_signal(create_id_move_init_n(d, n), - COMPUTING_SPEED)		{color => COLOR_COMPUTE;};
	speed := if (d==">") COMPUTING_SPEED else -COMPUTING_SPEED;
	.Dir := if (d==">") "Right" else "Left";
	.D := if (d==">") "R" else "L";
	add_meta_signal(create_id_move_n(d, n), speed)	{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_move_n(d, n _ "OOM"), speed)	{color => COLOR_COMPUTE;};
////collision rules
//accelerating
	[create_id_move_init_n(d, n), "Cell_marker"] --> ["Cell_marker", create_id_move(d, "fast"), create_id_move_n(d, n)];
//decelerating
	[create_id_move_n(d, n), "Cell_marker"] --> ["Cell_marker", create_id_move_n(d, n - 1)];
	[create_id_move_n(d, n _ "OOM"), "Cell_marker"] --> ["Cell_marker", create_id_move_n(d, (n - 1) _ "OOM")];
	[create_id_move_n(d, n), create_id_meta("Marker"_ Dir)] --> [create_id_meta("Marker"_ Dir), create_id_move_n(d, (n - 1) _ "OOM")];
};

//////Out Of Memory
//Trying to access cells which don't exist at one end of the tape.
	//Each cell is splitted in such a way that the tape become a juxtaposition of its former self contracted (factor 2) and an empty tape of the same size. the tape take as much space but holds twice as much cells, and non empty cell are pushed back within the margin. Empty meaning cells that have never been visited.
////metasignals
.COMPUTING_SPEED_VERY_FAST .= 3 * COMPUTING_SPEED_FAST;
//COMPUTING_SPEED_VERY_FAST > 2* COMPUTING_SPEED_FAST necessary
.OOM_contraction_speedLeft .= 1/(-1/COMPUTING_SPEED_FAST + 2/COMPUTING_SPEED_VERY_FAST);
.OOM_contraction_speedRight .= COMPUTING_SPEED_FAST;
add_meta_signal(create_id_meta("OOMR"), COMPUTING_SPEED_VERY_FAST)	{color => COLOR_META;};
add_meta_signal(create_id_meta("OOML"), COMPUTING_SPEED_VERY_FAST)	{color => COLOR_META;};
add_meta_signal(create_id_meta("OOMTOP"), COMPUTING_SPEED_FAST)		{color => COLOR_META;};
add_meta_signal(create_id_meta("OOMBACK"), OOM_contraction_speedLeft)	{color => COLOR_META;};
add_meta_signal(create_id_meta("OOMEND"), COMPUTING_SPEED_VERY_FAST)	{color => COLOR_META;};

.create_id_OOM_moved .= (suffix) -> "OOMmoved:" & suffix;
.create_id_OOM_movedLeft .= (suffix) -> "OOMmoved:L:" & suffix;
.create_id_OOM_movedRight .= (suffix) -> "OOMmoved:R:" & suffix;
.create_ms_OOM_movedLeft .= (suffix) -> add_meta_signal(create_id_OOM_movedLeft(suffix), OOM_contraction_speedLeft);
.create_ms_OOM_movedRight .= (suffix) -> add_meta_signal(create_id_OOM_movedRight(suffix), OOM_contraction_speedRight);

foreach(a:[create_ms_OOM_movedLeft, create_ms_OOM_movedRight])
{
	foreach(place:["accu", "cell", "unit"])
	{
		//some of the "unit" meta signal are unused, but it's simpler to define that way
		a(create_id_register(place, "b-", ""))	{color => "Dark" & COLOR_NEG;};
		a(create_id_register(place, "b+", ""))	{color => "Dark" & COLOR_POS;};
		a(create_id_register(place, "z", ""))	{color => COLOR_ZERO;};
		a(create_id_register(place, "", "v"))	{color => COLOR_VALUE;
			line_style => LINESTYLE_VALUE;};
		a(create_id_register(place, "z", "v"))	{color => COLOR_ZERO;
			line_style => LINESTYLE_VALUE;};
		a(create_id_register(place, "b-", "v"))	{color => "Dark" & COLOR_NEG;
			line_style => LINESTYLE_VALUE;};
		a(create_id_register(place, "b+", "v"))	{color => "Dark" & COLOR_POS;
			line_style => LINESTYLE_VALUE;};
	};
	a("Cell_marker")	{color => DarkGray;};

	foreach(s:["", "WAIT_OOT"])
		a(create_id_meta(s))	{color => COLOR_META;};
	a(create_id_clock(0))		{color => COLOR_META;};
};
create_ms_OOM_movedLeft(create_id_meta("MarkerLeft"))	{color => COLOR_META; line_style => LINE_STYLE_META;};
create_ms_OOM_movedRight(create_id_meta("MarkerRight"))	{color => COLOR_META; line_style => LINE_STYLE_META;};

////collision rules
///drawing the prism.
foreach(s:["OOMR", "OOML"])
{
	[create_id_return(s), create_id_meta("MarkerFarLeft")] --> [create_id_meta("MarkerFarLeft"), create_id_meta(s), create_id_meta("OOMTOP")];
	[create_id_meta(s), create_id_meta("MarkerFarRight")] --> [create_id_meta("OOMBACK"), create_id_meta("MarkerFarRight")];
};
[create_id_meta("OOMTOP"), create_id_meta("OOMBACK")] --> [create_id_meta("OOMEND"), "Cell_marker"];
[create_id_meta("OOMEND"), create_id_meta("MarkerFarRight")] --> [create_id_return(""), create_id_meta("MarkerFarRight")];

///Splitting
foreach(d:["L", "R"])
{
	[create_id_meta("OOM" & d), create_id_meta("MarkerLeft")] --> [create_id_OOM_movedLeft(create_id_meta("MarkerLeft")), create_id_OOM_movedRight("Cell_marker"), create_id_meta("OOM" & d)];
	[create_id_meta("OOM" & d), create_id_meta("MarkerRight")] --> [create_id_OOM_movedLeft("Cell_marker"), create_id_OOM_movedRight(create_id_meta("MarkerRight")), create_id_meta("OOM" & d)];
	[create_id_meta("OOM" & d), "Cell_marker"] --> [create_id_OOM_movedLeft("Cell_marker"), create_id_OOM_movedRight("Cell_marker"), create_id_meta("OOM" & d)];

	foreach(base:["b-", "b+", "zv"])
		[create_id_meta("OOM" & d), create_id_register("cell", base, "")] -->
			[create_id_OOM_movedLeft(create_id_register("cell", base, "")), create_id_OOM_movedRight(create_id_register("cell", base, "")), create_id_meta("OOM" & d)];
};

//L

foreach(place:["accu", "unit"])
{
	foreach(base:["b-", "b+", "z", ""])
	{
		foreach(value:["", "v"])
		{
			if (base _ value != "")
				[create_id_meta("OOML"), create_id_register(place, base, value)] -->
					[create_id_OOM_movedRight(create_id_register(place, base, value)), create_id_meta("OOML")];
		};
	};
};
foreach(b:[create_id_meta(""), create_id_meta("WAIT_OOT"), create_id_clock(0)])
	[create_id_meta("OOML"), b] -->
		[create_id_OOM_movedRight(b), create_id_meta("OOML")];

[create_id_meta("OOML"), create_id_register("cell", "z", "")] -->
	[create_id_OOM_movedLeft(create_id_register("cell", "z", "v")), create_id_OOM_movedRight(create_id_register("cell", "z", "")), create_id_meta("OOML")];
foreach(base:["b-", "b+"])
	[create_id_meta("OOML"), create_id_register("cell", base, "v")] -->
		[create_id_OOM_movedLeft(create_id_register("cell", base, "")), create_id_OOM_movedRight(create_id_register("cell", base, "v")), create_id_meta("OOML")];
[create_id_meta("OOML"), create_id_register("cell", "", "v")] -->
	[create_id_OOM_movedRight(create_id_register("cell", "", "v")), create_id_meta("OOML")];

//R
foreach(place:["accu", "unit"])
{
	foreach(base:["b-", "b+", "z", ""])
	{
		foreach(value:["", "v"])
		{
			if (base _ value != "")
				[create_id_meta("OOMR"), create_id_register(place, base, value)] -->
					[create_id_OOM_movedLeft(create_id_register(place, base, value)), create_id_meta("OOMR")];
		};
	};
};
foreach(b:[create_id_meta(""), create_id_meta("WAIT_OOT"), create_id_clock(0)])
	[create_id_meta("OOMR"), b] -->
		[create_id_OOM_movedLeft(b), create_id_meta("OOMR")];

[create_id_meta("OOMR"), create_id_register("cell", "z", "")] -->
	[create_id_OOM_movedLeft(create_id_register("cell", "z", "")), create_id_OOM_movedRight(create_id_register("cell", "z", "v")), create_id_meta("OOMR")];
foreach(base:["b-", "b+"])
	[create_id_meta("OOMR"), create_id_register("cell", base, "v")] -->
		[create_id_OOM_movedLeft(create_id_register("cell", base, "v")), create_id_OOM_movedRight(create_id_register("cell", base, "")), create_id_meta("OOML")];
[create_id_meta("OOMR"), create_id_register("cell", "", "v")] -->
	[create_id_OOM_movedLeft(create_id_register("cell", "", "v")), create_id_meta("OOMR")];

///final redirection
[create_id_meta("OOMTOP"), create_id_OOM_movedLeft("Cell_marker")] --> ["Cell_marker", create_id_meta("OOMTOP")];
[create_id_meta("OOMBACK"), create_id_OOM_movedRight("Cell_marker")] --> ["Cell_marker", create_id_meta("OOMBACK")];
[create_id_meta("OOMTOP"), create_id_OOM_movedLeft(create_id_meta("MarkerLeft"))] --> [create_id_meta("MarkerLeft"), create_id_meta("OOMTOP")];
[create_id_meta("OOMBACK"), create_id_OOM_movedRight(create_id_meta("MarkerRight"))] --> [create_id_meta("MarkerRight"), create_id_meta("OOMBACK")];


foreach(place:["accu", "cell", "unit"])
{
	foreach(base:["b-", "b+", "z", ""])
	{
		foreach(value:["", "v"])
		{
			if (base _ value != "")
			{
				[create_id_meta("OOMTOP"), create_id_OOM_movedLeft(create_id_register(place, base, value))] --> [create_id_register(place, base, value), create_id_meta("OOMTOP")];
				[create_id_meta("OOMBACK"), create_id_OOM_movedRight(create_id_register(place, base, value))] --> [create_id_register(place, base, value), create_id_meta("OOMBACK")];
			};
		};
	};
};
foreach(b:[create_id_meta(""), create_id_meta("WAIT_OOT"), create_id_clock(0)])
{
	[create_id_meta("OOMTOP"), create_id_OOM_movedLeft(b)] --> [b, create_id_meta("OOMTOP")];
	[create_id_meta("OOMBACK"), create_id_OOM_movedRight(b)] --> [b, create_id_meta("OOMBACK")];
};

//TODO similar stuff in the python

///////////////branch (the test part)///////////
////metasignals
add_meta_signal("branch", COMPUTING_SPEED)	{color => COLOR_COMPUTE;};
////collision rules
foreach(p:[["v","lt"], ["z", "gt"], ["zv","eq"]])
	["branch", create_id_accu(p[0])] --> [create_id_accu(p[0]), create_id_return(p[1])];

///////////////computation///////////
//////reset//////
////metasignals
.create_id_reset .= (recipient) -> "reset:" & recipient;
foreach(r:["accu", "cell"])
	add_meta_signal(create_id_reset(r), COMPUTING_SPEED)	{color => COLOR_COMPUTE;};
////collision rules
foreach(r:["accu", "cell"])
{
	[create_id_reset(r), create_id_register(r,"","v")] --> [create_id_reset(r)];
	[create_id_reset(r), create_id_register(r,"z","")] --> [create_id_register(r,"z","v"), create_id_reset(r)];
	[create_id_reset(r), create_id_register(r,"z","v")] --> [create_id_register(r,"z","v"), create_id_reset(r)];	//transparent but meaningful
	[create_id_reset(r), create_id_register(r,"b+","")] --> [create_id_register(r,"b+",""), "<<"];
};

//////get//////
////metasignals
.create_id_get .= (constant, operand, suffix) -> "get:" & constant & "*" & operand & "_" & suffix;
.compute_get_signal_speed .= (a) -> NUMBER_HARMONIC_SUM(COMPUTING_SPEED, 1/(a * DELTA));

////collision rules
.create_mscr_get .= (constant, operand) -> if (get_meta_signal(create_id_get(constant, operand, 0)) == void)
{
	add_meta_signal(create_id_get(constant, operand, 0), COMPUTING_SPEED)	{color => COLOR_COMPUTE;};
	.speed .= compute_get_signal_speed(constant);
	foreach(s:["z", "v"])
	{
		add_meta_signal(create_id_get(constant, operand, s), speed)	{color => COLOR_COMPUTE;};

		[create_id_get(constant, operand, 0), create_id_register(operand, s,"")] --> [create_id_register(operand, s,""), create_id_get(constant, operand, s), create_id_get(constant, operand, 0)];
		[create_id_get(constant, operand, s), create_id_register(operand, "b+","")] --> [create_id_register(operand, "b+",""), create_id_return(s)];
	};
	[create_id_get(constant, operand, 0), create_id_register(operand, "z","v")] --> [create_id_register(operand, "z","v"), create_id_return("")];

	[create_id_get(constant, operand, 0), create_id_register(operand, "b+","")] --> [create_id_register(operand, "b+","")];
	:= undef;
};
//////add//////
////metasignals
.create_id_add .= (recipient, suffix) -> "addto:" & recipient & suffix;
.speed_addsub .= compute_get_signal_speed(1);
foreach(r:["accu", "cell"])
{
	add_meta_signal(create_id_add(r, 0), COMPUTING_SPEED)		{color => COLOR_POS;};
	add_meta_signal(create_id_add(r, 1), speed_addsub)		{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_add(r, "1OOB"), speed_addsub)	{color => COLOR_POS;};
};
////collision rules
foreach(r:["accu", "cell"])
{
	[create_id_add(r, 0), create_id_register(r, "","v")] --> [create_id_add(r, 1)];
	[create_id_add(r, 0), create_id_register(r, "z","v")] --> [create_id_register(r, "z",""), create_id_add(r, 1)];
	[create_id_add(r, 1), create_id_register(r, "b+","")] --> [create_id_register(r, "b+",""), create_id_add(r, "1OOB")];				//out of bound

	foreach(s:["", "OOB"])
	{
		[create_id_add(r, 0), create_id_add(r, 1 & s)] --> [create_id_register(r, "","v"), create_id_return(s)];
	};
	[create_id_add(r, 0), create_id_add(r, 1), create_id_register(r, "z","")] --> [create_id_register(r, "z","v"), create_id_return("")];
	[create_id_add(r, 0), create_id_add(r, 1), create_id_register(r, "b+","")] --> [create_id_register(r, "b+","v"), create_id_return("OOB")];
};
//////subtract//////
////metasignals
.create_id_sub .= (recipient, position, suffix) -> "subfrom:" & recipient & position & suffix;
foreach(r:["accu", "cell"])
{
	foreach(p:["bot", "top"])
		add_meta_signal(create_id_sub(r, p, 0), COMPUTING_SPEED)		{color => COLOR_NEG;};
	add_meta_signal(create_id_sub(r, "bot", 1), - speed_addsub)			{color => COLOR_COMPUTE;};
	add_meta_signal(create_id_sub(r, "top", 1), - COMPUTING_SPEED)			{color => COLOR_NEG;};
	add_meta_signal(create_id_sub(r, "bot", "1OOB"), - speed_addsub)		{color => COLOR_NEG;};
};
////collision rules
foreach(r:["accu", "cell"])
{
	[create_id_sub(r, "bot", 0), create_id_register(r, "","v")] --> [create_id_register(r, "","v"), create_id_sub(r, "bot", 1)];
	[create_id_sub(r, "top", 0), create_id_register(r, "","v")] --> [create_id_sub(r, "top", 1)];
	[create_id_sub(r, "bot", 0), create_id_register(r, "z","v")] --> [create_id_register(r, "z","v"), create_id_sub(r, "bot", 1)];
	[create_id_sub(r, "top", 0), create_id_register(r, "z","v")] --> [create_id_register(r, "z",""), create_id_sub(r, "top", 1)];
	[create_id_sub(r, "bot", 1), create_id_register(r, "b-","")] --> [create_id_register(r, "b-",""), create_id_sub(r, "bot", "1OOB")];				//out of bound

	foreach(s:["", "OOB"])
	{
		[create_id_sub(r, "top", 1), create_id_sub(r, "bot", 1 & s)] --> [create_id_register(r, "","v"), create_id_return(s)];
	};
	[create_id_sub(r, "top", 1), create_id_sub(r, "bot", 1), create_id_register(r, "z","")] --> [create_id_register(r, "z","v"), create_id_return("")];
	[create_id_sub(r, "top", 1), create_id_sub(r, "bot", 1), create_id_register(r, "b-","")] --> [create_id_register(r, "b-","v"), create_id_return("OOB")];
};


///////////////********************advanced manip/META*********************/////////////
//////Out Of Bound
////metasignals
add_meta_signal(create_id_meta("OOB1"), COMPUTING_SPEED_FAST)	{color => COLOR_META;};
add_meta_signal(create_id_meta("OOB2"), COMPUTING_SPEED_FAST)	{color => COLOR_META;};
////collision rules
//start:
[create_id_meta("MarkerFarLeft"), create_id_return("OOB")] --> [create_id_meta("MarkerFarLeft"), create_id_meta("OOB1")];
//end
[create_id_meta("OOB1"), create_id_meta("MarkerFarRight")] --> [create_id_return(""), create_id_meta("MarkerFarRight")];
//contraction
.compute_OOB_contraction_speed .= (x) -> COMPUTING_SPEED_FAST * (x+1) / (x-1);
foreach (t:["accu", "cell"])	//when the value to contract is negative
{
	add_meta_signal(create_id_meta("OOB_" _ t _ "_N1"), -compute_OOB_contraction_speed(1/MAX_CTE));
	add_meta_signal(create_id_meta("OOB_" _ t _ "_N2"), compute_OOB_contraction_speed(1/MAX_CTE));
	
	[create_id_meta("OOB1"), create_id_register(t, "", "v")] --> [create_id_meta("OOB1"), create_id_meta("OOB_" _ t _ "_N1")];
	[create_id_meta("OOB1"), create_id_register(t, "b-", "v")] --> [create_id_meta("OOB1"), create_id_meta("OOB_" _ t _ "_N1"), create_id_register(t, "b-", "")];

	[create_id_meta("OOB_" _ t _ "_N1"), create_id_register(t, "z", "")] --> [create_id_meta("OOB_" _ t _ "_N2"), create_id_register(t, "z", "")];
	[create_id_meta("OOB_" _ t _ "_N2"), create_id_meta("OOB1")] --> [create_id_meta("OOB2"), create_id_register(t, "", "v")];
//		[create_id_meta("OOB2"), create_id_register(t, "b-", "")] --> [??]; //Still out of bound, should not happen, but here is the left part of the collision to check whether it does
	[create_id_meta("OOB2"), create_id_register(t, "z", "")] --> [create_id_meta("OOB1"), create_id_register(t, "z", "")];
};

foreach (t:["accu", "cell", "unit"])	//when the value to contract is positve
{
	add_meta_signal(create_id_meta("OOB_" _ t _ "_P1"), -compute_OOB_contraction_speed(1 - 1/MAX_CTE));
	add_meta_signal(create_id_meta("OOB_" _ t _ "_P2"), compute_OOB_contraction_speed(1 - 1/MAX_CTE));
	
	[create_id_meta("OOB1"), create_id_register(t, "z", "")] --> [create_id_register(t, "z", ""), create_id_meta("OOB2"), create_id_meta("OOB_" _ t _ "_P1")];

	[create_id_meta("OOB_" _ t _ "_P1"), create_id_register(t, "", "v")] --> [create_id_meta("OOB_" _ t _ "_P2")];
	[create_id_meta("OOB_" _ t _ "_P1"), create_id_register(t, "b+", "v")] --> [create_id_meta("OOB_" _ t _ "_P2"), create_id_register(t, "b+", "")];

	[create_id_meta("OOB_" _ t _ "_P2"), create_id_meta("OOB2")] --> [create_id_meta("OOB1"), create_id_register(t, "", "v")];
//		[create_id_meta("OOB2"), create_id_register(t, "b+", "")] --> [??]; //Still out of bound, should not happen, but here is the left part of the collision to check whether it does
};

foreach (t:["accu", "cell"])	//when the value to contract is null (transparent but meaningful)
	[create_id_meta("OOB1"), create_id_register(t, "z", "v")] --> [create_id_meta("OOB1"), create_id_register(t, "z", "v")];

//////Out Of Time
///////////////////////
////metasignals
add_meta_signal(create_id_meta("OOT"), COMPUTING_SPEED_VERY_FAST)	{color => COLOR_META;};
add_meta_signal(create_id_meta("OOTTOP"), COMPUTING_SPEED_FAST)		{color => COLOR_META;};
add_meta_signal(create_id_meta("OOTBACK"), OOM_contraction_speedLeft)	{color => COLOR_META;};

.create_id_OOT_moved .= (suffix) -> "OOTmoved:" & suffix;
.create_ms_OOT_moved .= (suffix) -> add_meta_signal(create_id_OOT_moved(suffix), OOM_contraction_speedLeft);

foreach(place:["accu", "cell", "unit"])
{
	//some of the "unit" meta signal are unused, but it's simpler to define that way
	create_ms_OOT_moved(create_id_register(place, "b-", ""))	{color => "Dark" & COLOR_NEG;};
	create_ms_OOT_moved(create_id_register(place, "b+", ""))	{color => "Dark" & COLOR_POS;};
	create_ms_OOT_moved(create_id_register(place, "z", ""))	{color => COLOR_ZERO;};
	create_ms_OOT_moved(create_id_register(place, "", "v"))	{color => COLOR_VALUE;
		line_style => LINESTYLE_VALUE;};
	create_ms_OOT_moved(create_id_register(place, "z", "v"))	{color => COLOR_ZERO;
		line_style => LINESTYLE_VALUE;};
	create_ms_OOT_moved(create_id_register(place, "b-", "v"))	{color => "Dark" & COLOR_NEG;
		line_style => LINESTYLE_VALUE;};
	create_ms_OOT_moved(create_id_register(place, "b+", "v"))	{color => "Dark" & COLOR_POS;
		line_style => LINESTYLE_VALUE;};
};
create_ms_OOT_moved("Cell_marker")	{color => DarkGray;};
create_ms_OOT_moved(create_id_meta("MarkerLeft"))	{color => COLOR_META; line_style => LINE_STYLE_META;};
create_ms_OOT_moved(create_id_meta("MarkerRight"))	{color => COLOR_META; line_style => LINE_STYLE_META;};
foreach(s:["WAIT_OOML", "WAIT_OOMR", "WAIT_OOB", "WAIT_", "WAIT_lt", "WAIT_eq", "WAIT_gt"])
	create_ms_OOT_moved(create_id_meta(s))	{color => COLOR_META;};

//The clock

//Clock definition
foreach (p:[
		//[(x) -> x, 0], 
		//[(x) -> create_id_moved(">", x), COMPUTING_SPEED], [(x) -> create_id_moved("<", x), -COMPUTING_SPEED], 
		//[create_id_OOM_movedLeft, OOM_contraction_speedLeft], 
		//[create_id_OOM_movedRight, OOM_contraction_speedRight],
		[create_id_OOT_moved, OOM_contraction_speedLeft]
		])
{
	.a .= p[0];
	.s .= p[1];
	add_meta_signal(a(create_id_meta("")), s)				{color => COLOR_COMPUTE;};
	add_meta_signal(a(create_id_meta("WAIT_OOT")), s)			{color => COLOR_COMPUTE; line_style => "dotted";};
	add_meta_signal(a(create_id_clock(0)), s)				{color => COLOR_COMPUTE;};
};

init_clock .= (time) -> if (get_meta_signal(create_id_clock(">" _ time)) == void)
{
//anything related to the clock which depends on the clock period.
//FRIDGE: make MS independent of clock period (encode the period in the configuraiton instead)
	.clockWidth .= 2 * DIST_PROG_ROOM / 5;
	CLOCK_SPEED := 2 * clockWidth / time;//.clockWidth / time;		//not a constant to allow the "same" machine to be used with different clocks

	//Clock ms definition and Clock Running
	foreach (p:[
			[(x) -> x, 0], 
			[(x) -> create_id_moved(">", x), COMPUTING_SPEED], [(x) -> create_id_moved("<", x), -COMPUTING_SPEED], 
			[create_id_OOM_movedLeft, OOM_contraction_speedLeft], 
			[create_id_OOM_movedRight, OOM_contraction_speedRight],
			[create_id_OOT_moved, OOM_contraction_speedLeft]
			])
	{
		.a .= p[0];
		.v .= p[1];
		add_meta_signal(a(create_id_clock(">" _ time)), v + CLOCK_SPEED)		{color => COLOR_COMPUTE;};
		add_meta_signal(a(create_id_clock("<" _ time)), v - CLOCK_SPEED)		{color => COLOR_COMPUTE;};
		[a(create_id_clock("<" _ time)), a(create_id_clock("0"))] --> [a(create_id_clock("0")), a(create_id_clock(">" _ time))];	//bounce
		[a(create_id_clock(">" _ time)), a(create_id_meta(""))] --> [a(create_id_meta("WAIT_OOT"))];	//mark meta and stop the clock
	};

	////clock being moved. Rque: init_clock happens after create_mscr_move
	//first redirection
	foreach (p: [
			[(x) -> create_id_moved(">", x), create_id_move(">", "fast")], [(x) -> create_id_moved("<", x), create_id_move("<", "fast")], 
			[create_id_OOM_movedLeft, create_id_meta("OOMR")], 
			[create_id_OOM_movedRight, create_id_meta("OOML")],
			[create_id_OOT_moved, create_id_meta("OOT")]
			])
	{
		.a .= p[0];
		.sig .= p[1];
		foreach (b:["0", "<" _ time, ">" _ time])
			[sig, create_id_clock(b)] --> [a(create_id_clock(b)), sig];	//cross

		[sig, create_id_clock("<" _ time), create_id_clock("0")] --> [a(create_id_clock("0")), a(create_id_clock(">" _ time)), sig];	//cross while bouncing
		[sig, create_id_clock(">" _ time), create_id_meta("")] --> [a(create_id_meta("WAIT_OOT")), sig];	//cross at the end
	};
	//second redirection
	foreach (p: [
			[(x) -> create_id_moved(">", x), create_id_move(">", "fast")], [(x) -> create_id_moved("<", x), create_id_move("<", "fast")], 
			[create_id_OOM_movedLeft, create_id_meta("OOMTOP")], 
			[create_id_OOM_movedRight, create_id_meta("OOMBACK")],
			[create_id_OOT_moved, create_id_meta("OOTTOP")]
			])
	{
		.a .= p[0];
		.sig .= p[1];
		foreach (b:["0", "<" _ time, ">" _ time])
			[sig, a(create_id_clock(b))] --> [create_id_clock(b), sig];

		[sig, a(create_id_clock("<" _ time)), a(create_id_clock("0"))] --> [create_id_clock("0"), create_id_clock(">" _ time), sig];	//bounce
		[sig, a(create_id_clock(">" _ time)), a(create_id_meta(""))] --> [create_id_meta("WAIT_OOT"), sig];	//end
	};


	foreach(s:["", "lt", "eq", "gt", "OOB", "OOML", "OOMR"])
	{
		//Start of OOT, special case
		[create_id_clock(">" _ time), create_id_meta(""), create_id_return(s)] --> [create_id_meta("WAIT_" _ s), create_id_return("OOT")];
		//restarting the clock
		[create_id_meta("WAIT_" _ s), create_id_return("")] --> [create_id_meta(""), create_id_return(s), create_id_clock("<" _ time)] ;
	};
};

//Start and end of OOT
foreach(s:["", "lt", "eq", "gt", "OOB", "OOML", "OOMR"])
{
	[create_id_meta("WAIT_OOT"), create_id_return(s)] --> [create_id_meta("WAIT_" _ s), create_id_return("OOT")];
};

/////Handling OOT
///drawing the prism.
[create_id_return("OOT"), create_id_meta("MarkerFarLeft")] --> [create_id_meta("MarkerFarLeft"), create_id_meta("OOT"), create_id_meta("OOTTOP")];
[create_id_meta("OOT"), create_id_meta("MarkerFarRight")] --> [create_id_meta("OOTBACK")];

[create_id_meta("OOTTOP"), create_id_meta("OOTBACK")] --> [create_id_return(""), create_id_meta("MarkerFarRight")];

///Redirections
foreach(base:[create_id_meta("MarkerLeft"), create_id_meta("MarkerRight"), "Cell_marker"])
{
	[create_id_meta("OOT"), base] --> [create_id_OOT_moved(base), create_id_meta("OOT")];
	[create_id_OOT_moved(base), create_id_meta("OOTTOP")] --> [create_id_meta("OOTTOP"), base];
};
foreach(s:["", "lt", "eq", "gt", "OOB", "OOML", "OOMR"])
{
	.base .= create_id_meta("WAIT_" _ s);
	[create_id_meta("OOT"), base] --> [create_id_OOT_moved(base), create_id_meta("OOT")];
	[create_id_OOT_moved(base), create_id_meta("OOTTOP")] --> [create_id_meta("OOTTOP"), base];
};
[create_id_meta("OOT"), create_id_clock(0)] --> [create_id_OOT_moved(create_id_clock(0)), create_id_meta("OOT")];
[create_id_OOT_moved(create_id_clock(0)), create_id_meta("OOTTOP")] --> [create_id_meta("OOTTOP"), create_id_clock(0)];

foreach(place:["accu", "unit", "cell"])
{
	foreach(base:["b-", "b+", "z", ""])
	{
		foreach(value:["", "v"])
		{
			if (base _ value != "")
			{
				[create_id_meta("OOT"), create_id_register(place, base, value)] -->
					[create_id_OOT_moved(create_id_register(place, base, value)), create_id_meta("OOT")];
				[create_id_meta("OOTTOP"), create_id_OOT_moved(create_id_register(place, base, value))] -->
					[create_id_register(place, base, value), create_id_meta("OOTTOP")];
			};
		};
	};
};

//////split/delay//////
////meta-signals
.create_id_ubt .= (typ) -> typ;
//typ is "delay or "split"
foreach(typ:["delay", "split"])
{
	add_meta_signal(create_id_ubt(typ), COMPUTING_SPEED) 	{color => COLOR_COMPUTE;};
};





