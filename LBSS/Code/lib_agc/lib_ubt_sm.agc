/*
An AGC file to build the backbone of an agc machine with ubt lbss abilites
usage:

lbss .= create_signal_machine()
{
	UBT_DEPTH := 7;		//being variable is much recommended
	load "sub_machine.agc";
	load "lib_ubt_sm.agc";
};
*/

use AGC ;

//constant
if (UBT_DEPTH == undef)
	UBT_DEPTH .= 7;
if (UBT_DEPTH < 0)
{
	if (UBT_DEPTH < -1)
		println("Warning, nonesensical maximum depth. Infinite depth is encoded -1. Corrected to -1.");
	UBT_DEPTH .=  -1 ;
};
SPEED_SHRINK .= 3/7;
SPEED_SHRINK_BACK .= 1/3;
SPEED_BOUNCE_SHRINK .= 1;
SPEED_BOUNCE_SHRINK_BACK .= 3/5;
SPEED_FAST_SHRINK .= 3/5;
SPEED_COMPUTE .= 4;
SPEED_ERROR .= 101/1093;
//small, so as not to blow out pdf size making it unreadable, but not too small so as not to overlap with 0 speed signals, and weird, so as to be unique.

//Colors and style
COLOR_TREE_UP .= "DarkGreen";
COLOR_TREE_RIGHT .= "DarkRed";
COLOR_TREE_LEFT .= "DarkBlue";
COLOR_BOUNCE .= "Gray";
COLOR_BOUND .= "Black";
.COLOR_COMPUTE := "Purple";
COLOR_ERASE .= "Red";
COLOR_BORDER .= "Black";
COLOR_WALL .= "Black";
COLOR_ERROR := "Red";

LINESTYLE_DELAY .= "densely dashed";
LINESTYLE_SPLIT .= "densely dotted";
LINESTYLE_ERASE .= "dashed";
LINESTYLE_ERROR .= "";

////Border Meta-Signals
add_meta_signal("||", 0)	{color => COLOR_BORDER;};
add_meta_signal("||Erase", 0)	{color => COLOR_BORDER;};
//a border signal that already receive one erase Bouncer.

////Main Meta-Signals
create_id_tree .= (dir, suff, remaining_depth) -> "Tree_" _ dir _ suff _ "_" _ remaining_depth;

foreach(n:-1...UBT_DEPTH)
//-1 is for infinite depth, presumably the stopping conditions are handled from the lbss side.
{
	//initial branch, for the initial computaion, not really tree.
	add_meta_signal(create_id_tree("up", "init:", n), 0)		{color => "black";};
	tmpS := -1;
	foreach(p:[["left", COLOR_TREE_LEFT], ["up", COLOR_TREE_UP], ["right", COLOR_TREE_RIGHT]])
	{
		col := p[1];
		//This manipulation (giving p[1] a name) is necessary somehow. TODO: Ask why.
		add_meta_signal(create_id_tree(p[0], "", n), tmpS)	{color => col;};
		tmpS := tmpS + 1;		
	};
	foreach(t:[["Delay", LINESTYLE_DELAY], ["Split", LINESTYLE_SPLIT]])
	{
		lstyle := t[1];
		add_meta_signal(create_id_tree("up", t[0], n), 0)	{color => COLOR_TREE_UP; line_style => lstyle;};
		//initial branch, for the initial computaion, not really tree.
		add_meta_signal(create_id_tree("up", "init:" _ t[0], n), 0)	{color => "black"; line_style => lstyle;};
	};
};

////Bouncing Meta-Signals
create_id_bounce .= (dir, suffix) -> "Bounce_" _ dir _ "_" _ suffix;
tmpS := -3;
foreach(dir:["left", "right"])
{
	add_meta_signal(create_id_bounce(dir, ""), tmpS)	{color => COLOR_BOUNCE;};
	add_meta_signal(create_id_bounce(dir, "slow"), tmpS/2)	{color => COLOR_BOUNCE;};
	add_meta_signal(create_id_bounce(dir, "Split"), tmpS)	{color => COLOR_BOUNCE; line_style => LINESTYLE_SPLIT;};
	add_meta_signal(create_id_bounce(dir, "Erase"), tmpS)	{color => COLOR_ERASE; line_style => LINESTYLE_ERASE;};
	tmpS := -tmpS;
};


////Bounding Meta-Signals
create_id_bound .= (dir, suffix) -> "Bound_" _ dir _ "_" _ suffix;
tmpS := -1;
foreach(dir:["left", "up", "right"])
{
	add_meta_signal(create_id_bound(dir, ""), tmpS)	{color => COLOR_BOUND;};
	if (dir != "up")	//for up, that info is held in the Tree.
	{
		foreach(t:[["Delay", LINESTYLE_DELAY], ["Split", LINESTYLE_SPLIT]])
		{
			lstyle := t[1];
			add_meta_signal(create_id_bound(dir, t[0]), tmpS)	{color => COLOR_BOUND; line_style => lstyle;};
		};
	};
	tmpS := tmpS + 1;
};

////Wall Meta-Signals
//Wall is the vertical part right before node of the tree.
create_id_wall .= (suffix) -> "Wall_" _ suffix;
foreach(t:[["Delay", LINESTYLE_DELAY], ["Split", LINESTYLE_SPLIT]])
{
	lstyle := t[1];
	add_meta_signal(create_id_wall(t[0]), 0)		{color => COLOR_WALL; line_style => lstyle;};
	foreach (d:-1...UBT_DEPTH)
	{
		//the next ms is functionally the same as the above, but is used when the wall overlaps with the tree.
		add_meta_signal(create_id_wall("up_" _ t[0] _ "_" _ d), 0)	{color => COLOR_TREE_UP; line_style => lstyle;};
	};
};
add_meta_signal(create_id_wall("Erase"), 0)		{color => COLOR_ERASE; line_style => LINESTYLE_ERASE;};
//the next ms is functionally the same as the above, but is used when the wall overlaps with the tree.
add_meta_signal(create_id_wall("up_" _ "Erase"), 0)	{color => COLOR_TREE_UP;  line_style => LINESTYLE_ERASE;};

////PreComputation metasignals
create_id_precmp .= (dir, suffix) -> "Precmp_" _ dir _ "_" _ suffix;
tmpS := SPEED_COMPUTE;
foreach(dir:["right", "left"])
{
	foreach(i:0...1)
	{
		add_meta_signal(create_id_precmp(dir, i), tmpS){color => COLOR_COMPUTE;};
	};
	add_meta_signal(create_id_precmp(dir, "Error"), SPEED_ERROR){color => COLOR_ERROR; linestyle => LINESTYLE_ERROR;};
	tmpS := - tmpS;
};

////Bouncing rules
foreach(p:[["left", "right"],["right", "left"]])
{
	din := p[0];
	dout := p[1];
	foreach(ms_border:["||", "||Erase"])
	{
		[create_id_bounce(din, ""), ms_border] --> [ms_border, create_id_bounce(dout, "")];
		[create_id_bounce(din, "slow"), ms_border] --> [ms_border, create_id_bounce(dout, "")];
	};
	//non-transparent double collisons:
	[create_id_bounce(din, "slow"), "||", create_id_bounce(dout, "")] --> [create_id_bounce(din, ""), "||", create_id_bounce(dout, "")];
};
[create_id_bounce("left", "slow"), "||", create_id_bounce("right", "slow")] --> [create_id_bounce("left", ""), "||", create_id_bounce("right", "")];

////Stopping condition
//No info (delay/split) = stop
foreach(p:[["left", "right"],["right", "left"]])
{
	dir := p[0];
	dir2 := p[1];

	foreach (d:-1...UBT_DEPTH)
	{
		foreach(pre:["","init:"])
		{
		//at the beginning of an up branch
			[create_id_bounce(dir2, ""), create_id_tree("up", pre, d)] --> [create_id_wall("up_" _ "Erase")];
		};
		//at the end of a split branch
		[create_id_bounce(dir2, ""), create_id_wall("Erase"), create_id_tree(dir, "", d)] --> [create_id_bounce("left", "Erase"), create_id_bounce("right", "Erase")];
	};

	//at the beginning of a split branch
	[create_id_bounce(dir, ""), create_id_bound(dir2, "")] --> [create_id_wall("Erase")];

	//at the end of an up branch
	[create_id_bounce(dir2, ""), create_id_wall("up_" _ "Erase")] --> [create_id_bounce("left", "Erase"), create_id_bounce("right", "Erase")];
	[create_id_bound("up", ""), create_id_bounce(dir, "Erase")] --> [create_id_bounce(dir, "Erase")];
	
	[create_id_bounce(dir, "Erase"), "||"] --> ["||Erase"];
	[create_id_bounce(dir, "Erase"), "||Erase"] --> [];
	foreach(a:["", "slow"])
	{
		[create_id_bounce(dir, "Erase"), "||", create_id_bounce(dir2, a)] --> [create_id_bounce(dir, ""), "||Erase"];
	};
};
[create_id_bounce("right", "Erase"), "||", create_id_bounce("left", "Erase")] --> [];

//////Rerouting
//Halving the Macro signal is done after split branch (on split to split and split to delay but not on delay to split)
////Split
//metasignals
create_id_reroute .= (base, din, dout, suffix) -> "Route_" _ base _ "_" _ din _ "2" _ dout _ "_" _ suffix;
tmpS := 1;
foreach(dir:["right", "left"])
{
	foreach(t:[["Bound", SPEED_SHRINK],["Bounce", SPEED_BOUNCE_SHRINK]])
	{
		add_meta_signal(create_id_reroute(t[0], dir, dir, "Split"), tmpS * t[1]);
	};
	tmpS := - tmpS;
};

tmpS := 1;
foreach(p:[["left", "right"],["right", "left"]])
{
	foreach(t:[["Bound", SPEED_SHRINK_BACK],["Bounce", SPEED_BOUNCE_SHRINK_BACK]])
	{
		add_meta_signal(create_id_reroute(t[0], p[0], p[1], "Split"), tmpS * t[1]);
	};
	tmpS := - tmpS;
};

//Collision rules
foreach(p:[["left", "right"],["right", "left"]])
{
	dir1 := p[0];
	dir0 := dir1;
	//direction of the macro signal. goes toward right (frome the left) => dir1 = "right"
	dir2 := p[1];
	//opposite direction, used for example for the bouncers.
	ms_bounce := create_id_bounce(dir2, "");
	ms_list_init_bot := [create_id_bound(dir0, "Split")];
	ms_list_init_top := [];
	ms_init_top := undef;
	ms_wall := create_id_wall("Split");
	ms_list_wall := [ms_wall];
	cr_out_init := [create_id_reroute("Bounce", dir1, dir2, "Split"), create_id_reroute("Bound", dir1, dir2, "Split"),
			create_id_reroute("Bounce", dir1, dir1, "Split"), create_id_reroute("Bound", dir1, dir1, "Split")];
	cr_in_list_final := [];
	foreach (d:-1...UBT_DEPTH)
	{
		ms_init_top := create_id_tree(dir0, "", d);
		ms_list_init_top := ms_list_init_top _ [ms_init_top];
		cr_in_list_final := cr_in_list_final _ [[ms_init_top, ms_wall, ms_bounce]];
	};
	
	foreach(f:["", "up"])
	{
		
		//initial collision
		tmpI := 0;
		foreach (ms_init_bot:ms_list_init_bot)
		{
			[ms_init_bot, ms_bounce] --> cr_out_init _ [ms_list_wall[tmpI]];
			tmpI := tmpI + 1;
		};
		if (f == "up")
		{
			//extra work from delay
			[create_id_bounce(dir2, "Split"), create_id_bound(dir0, "")] --> [ms_init_top];
		};
		
		foreach(base:["Bound", "Bounce"])
		{
			foreach (ms_init_top:ms_list_init_top)	
			{//Reridecting Back signal
				[create_id_reroute(base, dir1, dir2, "Split"), ms_init_top] --> [ms_init_top, base _ "_" _ dir2 _ "_" _ ""];
			};
			//Redirecting Through signals
			[create_id_reroute(base, dir1, dir1, "Split"), ms_bounce] --> [ms_bounce, base _ "_" _ dir1 _ "_" _ ""];
		};

		//final collision
		foreach (d:1...UBT_DEPTH)
		{
			cr_in_list_final[d+1] --> [create_id_bounce(dir2, ""), create_id_tree(dir1, "", d - 1), "||", create_id_tree(dir2, "", d - 1), create_id_bounce(dir1, "")];
		};
		foreach (d:-1...0)	
		{
			cr_in_list_final[d+1] --> [create_id_bounce(dir2, ""), create_id_tree(dir1, "", d), "||", create_id_tree(dir2, "", d), create_id_bounce(dir1, "")];
		};

		//Changing a bunch of stuffs for "up"
		if (f=="up") break; //"break" does nothing, but does not error either. Not necessary but will become useful if ever implemented.
		
		dir0 := "up";
		ms_list_init_bot := [];
		ms_init_top := create_id_bound(dir1, "");
		ms_list_init_top := [ms_init_top];
		ms_list_wall := [];
		cr_out_init := cr_out_init _ [create_id_bounce(dir2, "Split")];
		cr_in_list_final := [];
		foreach (d:-1...UBT_DEPTH)
		{
			ms_init_bot := create_id_tree(dir0, "Split", d);
			ms_list_init_bot := ms_list_init_bot _ [ms_init_bot];
			ms_wall := create_id_wall(dir0 _ "_Split_" _ d);
			ms_list_wall := ms_list_wall _ [ms_wall];
			cr_in_list_final := cr_in_list_final _ [[ms_init_top, ms_wall, ms_bounce]];
		};
		foreach (d:-1...UBT_DEPTH)
		{
		//extra work for initial computation
			ms_init_bot := create_id_tree(dir0, "init:Split", d);
			ms_list_init_bot := ms_list_init_bot _ [ms_init_bot];
			ms_wall := create_id_wall(dir0 _ "_Split_" _ d);
			ms_list_wall := ms_list_wall _ [ms_wall];
		};
	};
};


////Delay
//from delay
//Collisions rules
foreach(p:[["left", "right"],["right", "left"]])
{
	dir1 := p[0];
	//direction of the macro signal. goes toward right (frome the left) => dir1 = "right"
	dir2 := p[1];
	foreach (d:-1...UBT_DEPTH)
	{
		//initial collision
		foreach(pre:["", "init:"])
		{
			[create_id_tree("up", pre _ "Delay", d), create_id_bounce(dir2, "")] --> [create_id_wall("up_Delay_" _ d), create_id_bounce(dir1, "slow")];
		};
		//final collision
		[create_id_wall("up_Delay_" _ d), create_id_bounce(dir2, "")] --> [create_id_tree("up", "", d), create_id_bounce(dir1, "slow"), create_id_precmp(dir2, 0)];
	};
	//do not launch computation if depth = 0. Overwrites the definition in the loop. TODO test.
	[create_id_wall("up_Delay_" _ 0), create_id_bounce(dir2, "")] --> [create_id_tree("up", "", 0), create_id_bounce(dir1, "slow")];
};

//from split
tmpS := 1;
foreach(p:[["right", "left"], ["left", "right"]])
{
	dir1 := p[0];
	//direction of the macro signal. goes toward right (from the left) => dir1 = "right"
	dir2 := p[1];
	//metasignals
	ms_rr_bound := add_meta_signal(create_id_reroute("Bound", dir2, "up", "Delay"), - tmpS * SPEED_BOUNCE_SHRINK_BACK);
	ms_rr_bounce := add_meta_signal(create_id_reroute("Bounce", dir1, "up", "Delay"), tmpS * SPEED_FAST_SHRINK);
	
	//collision rules
	//initial collision
	[create_id_bound(dir1, "Delay"), create_id_bounce(dir2, "")] --> [ms_rr_bound,
		create_id_wall("Delay"), ms_rr_bounce];	
	
	//redirecting
	[create_id_bounce(dir2, ""), ms_rr_bounce] -->
		[create_id_bounce(dir1, "slow"), create_id_bounce(dir2, "")];
	foreach (d:-1...UBT_DEPTH)
	{
		[create_id_tree(dir1, "", d), ms_rr_bound] -->
			[create_id_bound("up", ""), create_id_tree(dir1, "", d)];
	
	//final collision
		[create_id_tree(dir1, "", d), create_id_wall("Delay"), create_id_bounce(dir2, "")] --> [create_id_tree("up", "", d), create_id_bounce(dir1, "slow"), create_id_precmp(dir2, 0)];
	};
	//do not launch computation if depth = 0. Overwrites the definition in the loop. TODO test.
	[create_id_tree(dir1, "", 0), create_id_wall("Delay"), create_id_bounce(dir2, "")] --> [create_id_tree("up", "", 0), create_id_bounce(dir1, "slow")];
	
	tmpS := -tmpS;
};


//////PreComputation Collision rules
//Delay (part of it is already accounted for)
foreach(p:[["right", "left"], ["left", "right"]])
{
	dir1 := p[0];
	dir2 := p[1];
	[create_id_bound("up", ""), create_id_precmp(dir2, 0)] --> [create_id_bound("up", ""), create_id_precmp(dir1, 1)];

	//Error (when tree is reached)
	foreach (d:-1...UBT_DEPTH)
	{
		[create_id_precmp(dir1, 1), create_id_tree("up", "", d)] --> [create_id_tree("up", "", d), create_id_precmp(dir1, "Error")];
	};
};

//Split
foreach(p:[["right", "left"], ["left", "right"]])
{
	dir1 := p[0];
	dir2 := p[1];
	[create_id_bounce(dir1, ""), create_id_bound(dir1, "")] --> [create_id_bounce(dir1, ""), create_id_bound(dir1, ""), create_id_precmp(dir2, 0)];

	foreach (d:-1...UBT_DEPTH)
	{
		[create_id_tree(dir1, "", d), create_id_precmp(dir2, 0)] --> [create_id_tree(dir1, "", d), create_id_precmp(dir1, 1)];
	};
	//do not launch computation if depth = 0. Overwrites the definition in the loop. TODO test.
	[create_id_tree(dir1, "", 0), create_id_precmp(dir2, 0)] --> [create_id_tree(dir1, "", 0)];

	//Error (when bound is reached)
	[create_id_precmp(dir1, 1), create_id_bound(dir1, "")] --> [create_id_bound(dir1, ""), create_id_precmp(dir1, "Error")];
};


//////incoporating lbss

create_id_lbss .= (alteration, base, dir) ->
	"lbss" _ alteration _ "_" _ base _ "_" _ dir;

incorporate_lbss_machine .= (lbssMachine, alt) ->
{
	tmpF := 1;
	foreach(dir1:["right", "left"])
	{
		tmpS := 1;
		foreach(f:["", "up"])
		{
			dir := f _ dir1;		//"left", "right", "upleft", "upright"
			////incorporates the machine
			incorporate_machine_fun(lbssMachine, create_fun_create_id("lbss" _ alt _ "_", "_" _ dir), (s) -> tmpF * (s + tmpS));

			tmpS := tmpS - 1;
		};
		tmpF := - tmpF;
	};

	//////rerouting
	////split to split
	//meta-signals
	tmpS := 1;
	foreach(dir:["right", "left"])
	{
		foreach(ms:lbssMachine.get_meta_signal_list())
		{
			if (ms.speed == 0)
			{//not sure how necessary it is, relative to how rerouting works in general, though here, you surely want an error if there are still non-stationary by the time rerouting occurs.
				add_meta_signal(create_id_reroute(ms.id, dir, dir, "Split"), tmpS * SPEED_SHRINK);
			};
		};
		tmpS := - tmpS;
	};

	tmpS := 1;
	foreach(p:[["left", "right"],["right", "left"]])
	{
		foreach(ms:lbssMachine.get_meta_signal_list())
		{
			if (ms.speed == 0)
			{
				add_meta_signal(create_id_reroute(ms.id, p[0], p[1], "Split"), tmpS * SPEED_SHRINK_BACK);
			};
		};
		tmpS := - tmpS;
	};

	//collision rules
	foreach(p:[["right", "left"], ["left", "right"]])
	{
		dir1 := p[0];
		//direction of the macro signal. goes toward right (from the left) => dir1 = "right"
		dir2 := p[1];
		dir0 := dir1;

		foreach(ms:lbssMachine.get_meta_signal_list())
		{
			if (ms.speed == 0)
			{
				//diffracting on the wall
				[create_id_wall("Split"), create_id_lbss(alt, ms.id, dir1)] -->
					[create_id_reroute(ms.id, dir1, dir2, "Split"), create_id_wall("Split"), create_id_reroute(ms.id, dir1, dir1, "Split")];
				//
				foreach (d:-1...UBT_DEPTH)
				{//redirecting back signals
					[create_id_reroute(ms.id, dir1, dir2, "Split"), create_id_tree(dir0, "", d)] --> [create_id_tree(dir0, "", d), create_id_lbss(alt, ms.id, dir2)];
				};
				//redirecting through signals
				ms_bounce := create_id_bounce(dir2, "");
				[create_id_reroute(ms.id, dir1, dir1, "Split"), ms_bounce] --> [ms_bounce, create_id_lbss(alt, ms.id, dir1)];
			};
		};
	};
	////up to Split
	//collision rules
	foreach(p:[["right", "left"], ["left", "right"]])
	{
		dir1 := p[0];
		//direction of the macro signal. goes toward right (from the left) => dir1 = "right"
		dir2 := p[1];
		dir0 := "up";

		foreach(ms:lbssMachine.get_meta_signal_list())
		{
			if (ms.speed == 0)
			{
				//initial rerouting
				[create_id_lbss(alt, ms.id, "up" _ dir1), create_id_bounce(dir2, "Split")] --> [create_id_bounce(dir2, "Split"), create_id_lbss(alt, ms.id, dir1)];
				//diffracting on wall
				foreach(d:-1...UBT_DEPTH)
				{
					[create_id_wall(dir0 _ "_Split_" _ d), create_id_lbss(alt, ms.id, dir1)] -->
						[create_id_reroute(ms.id, dir1, dir2, "Split"), create_id_wall(dir0 _ "_Split_" _ d), create_id_reroute(ms.id, dir1, dir1, "Split")];
				};
				//redirecting back signals
				[create_id_reroute(ms.id, dir1, dir2, "Split"), create_id_bound(dir1, "")] --> [create_id_bound(dir1, ""), create_id_lbss(alt, ms.id, dir2)];
			};
		};
	};

	////Split to up
	foreach(p:[["right", "left"], ["left", "right"]])
	{
		dir1 := p[0];
		//direction of the macro signal. goes toward right (from the left) => dir1 = "right"
		dir2 := p[1];
		
		foreach(ms:lbssMachine.get_meta_signal_list())
		{
			if (ms.speed == 0)
			{
				[create_id_lbss(alt, ms.id, dir1), create_id_reroute("Bound", dir2, "up", "Delay")] -->
					[create_id_reroute("Bound", dir2, "up", "Delay"), create_id_lbss(alt, ms.id, "up" _ dir1)];
			};
		};
	};

	////Start of computation
	//after a split
	tmpT := 1;
	foreach(dir:["left", "right"])
	{
		foreach(p:lbssMachine.list_cr_split)
		{
			input_cr := [create_id_precmp(dir ,1)];
			foreach(id:p[0])
			{
				input_cr := input_cr _ [create_id_lbss (alt, id, dir)];
			};
			output_cr := [];
			foreach(id:p[tmpT])
			{
				output_cr := output_cr _ [create_id_lbss (alt, id, dir)];
			};
			input_cr --> output_cr;
		};
		tmpT := tmpT + 1;
	};
	//after a delay
	foreach(dir:["left", "right"])
	{
		foreach(p:lbssMachine.list_cr_delay)
		{
			input_cr := [create_id_precmp(dir ,1)];
			foreach(id:p[0])
			{
				input_cr := input_cr _ [create_id_lbss (alt, id, "up" _ dir)];
			};
			output_cr := [];
			foreach(id:p[1])
			{
				output_cr := output_cr _ [create_id_lbss (alt, id, "up" _ dir)];
			};
			input_cr --> output_cr;
		};
	};

	////Return
	foreach(p:[["left", "right"],["right", "left"]])
	{
		dir1 := p[0];
		dir0 := dir1;
		//direction of the macro signal. goes toward right (frome the left) => dir1 = "right"
		dir2 := p[1];
		//opposite direction
		foreach(p:[["delay", "Delay"], ["split", "Split"]])
		{
			typ := p[0];
			Typ := p[1];
			//right/left
			[create_id_lbss (alt, lbssMachine.create_id_ubt (typ), dir1), create_id_bound(dir1, "")] --> [create_id_bound(dir1, Typ)];

			foreach (d:-1...UBT_DEPTH)
			{
			//up
				[create_id_lbss (alt, lbssMachine.create_id_ubt (typ), "up" _ dir1), create_id_tree("up", "", d)] --> [create_id_tree("up", Typ, d)];
				[create_id_lbss (alt, lbssMachine.create_id_ubt (typ), "up" _ dir1), create_id_tree("up", "init:", d)] --> [create_id_tree("up", "init:" _ Typ, d)];
			};
		};
	};

	////Stopping condition
	foreach(p:[["left", "right"],["right", "left"]])
	{
		dir1 := p[0];
		dir0 := dir1;
		dir2 := p[1];
		foreach(ms:lbssMachine.get_meta_signal_list())
		{
			if (ms.speed == 0)
			{
				//up
				[create_id_lbss(alt, ms.id, "up" _ dir1), create_id_bounce(dir2, "Erase")] -->
					[create_id_bounce(dir2, "Erase")];
				//split
				[create_id_lbss(alt, ms.id, dir1), create_id_wall("Erase")] -->
					[create_id_wall("Erase")];
			};
		};
	};
};


create_configuration_wrap .= (machine) ->
{
//creates configuration within an environment allowing to access create_id function without having to refer to a machine. That way,
//conf.{ machine.create_id_bound(dir, suf) @ pos;}
//becomes
//conf.{create_id_bound(dir, suf) @ pos;}

//Also contains method for ease of configuration creation.

	//the distance between two Cells: room for the cell value and an accumulator, as well as for the program
	:= ..create_configuration()
	{//TODO methods go here
	};
};

INTERVAL_WIDTH .= 500;
//the total width of the configuration.
MACRO_WIDTH .= 12;
//the initial width of the macro signal. Might be worth being a variable/automatically generated 
MACRO_MARGIN .= 1;
//the space between the macro border signals and the embedded lbss machine.
depth := UBT_DEPTH;
//I'm not sure it'll stay constant
//TODO, check that it's within bounds
INIT_TIME .= 30;
//I'm not sure it'll stay constant

create_configuration_full .= (lbss_machine, lbss_conf, alt) ->
{
	:= ..create_configuration()
	{
		"||Erase" @ - INTERVAL_WIDTH/2;
//		"||Erase" @ + INTERVAL_WIDTH/2;		//TODO: it errors, reports
		"||Erase" @ INTERVAL_WIDTH/2;
		
		create_id_tree("up", "init:", depth) @ 0;
		create_id_bound("up", "") @ - MACRO_WIDTH;

		map .= create_map([lbss_conf.start, lbss_conf.end], [-MACRO_WIDTH + MACRO_MARGIN, - MACRO_MARGIN]);
		alter_id .= create_fun_create_id("lbss" _ alt _ "_", "_upright");
		incorporate_configuration_fun(lbss_conf, alter_id, map);

		create_id_bounce("left", "") @ 3 * INIT_TIME;
		create_id_bounce("left", "") @ 3 * INIT_TIME + 4 * MACRO_WIDTH; //the 4 comes from 4/3 * 3
	};
};
