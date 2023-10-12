///////******This file has been automatically generated******//////
/*
for you own sake, do not edit (you're likely to be overwritten).

This file contains the definition of an lbss signal machine.
To generate, put:
toAGC_machine machine_swap machine_swap.agc
in a .lbss file and run it with lbss.py
machine_swap must refer to a previously defined machine.

usage (for comprehension purpose):
in an agc file:
    
load "machine_swap.agc";

Creates a signal machine named: machine_swap
To create a configuration, prefer create_configuration_tape to create_configuration
*/

use AGC;
load "../../lib_agc/arith.agc";
machine_swap .= create_signal_machine()
{
	MaxCTE .= 2;
	MaxMove .= 1;
	load "../../lib_agc/lib_lbss_sm.agc";

	//////nodes
	//meta-signals
	create_id_node .= (id) -> "node:" & id;
	create_id_node_aux .= (id) -> create_id_node(id) & ":aux";
	create_mscr_node .= (node_id) -> 
	{
		.ms_id .= create_id_node(node_id);
		////Redirections
		//MS definitions
		foreach (p:[
			[(x) -> x, 0], 
			[(x) -> create_id_moved(">", x), COMPUTING_SPEED], [(x) -> create_id_moved("<", x), -COMPUTING_SPEED], 
			[create_id_OOM_movedLeft, OOM_contraction_speedLeft], 
			[create_id_OOM_movedRight, OOM_contraction_speedRight],
			[create_id_OOT_moved, OOM_contraction_speedLeft]
			])
		{
			.a .= p[0];
			.s .= p[1];
			add_meta_signal(a(ms_id), s)	{color => COLOR_COMPUTE;};
		};
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
			[sig, ms_id] --> [a(ms_id), sig];
		};
		//second redirection
		foreach (p: [
				[(x) -> create_id_moved(">", x), create_id_move(">", "fast")], [(x) -> create_id_moved("<", x), create_id_move("<", "fast")], 
				[(x) -> create_id_moved(">", x), create_id_move(">", "fastOOM")], [(x) -> create_id_moved("<", x), create_id_move("<", "fastOOM")], 
				[create_id_OOM_movedLeft, create_id_meta("OOMTOP")], 
				[create_id_OOM_movedRight, create_id_meta("OOMBACK")],
				[create_id_OOT_moved, create_id_meta("OOTTOP")]
				])
		{
			.a .= p[0];
			.sig .= p[1];
			[sig, a(ms_id)] --> [ms_id, sig];
		};
	};
	
	
	//MS definition (first pass)

	create_mscr_node("_#0");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#1");
	list_node_output_ := list_node_output_ _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("_#2");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#3");
	list_node_output_ := list_node_output_ _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("_#3"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("_#4");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#5");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#6");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#7");
	list_node_output_ := list_node_output_ _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("_#7"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("_#8");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#9");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#10");
	list_node_output_ := list_node_output_ _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("_#10"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("_#11");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#12");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#13");
	list_node_output_ := list_node_output_ _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("_#13"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("_#14");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#15");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#16");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#17");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#18");
	list_node_output_ := list_node_output_ _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("_#18"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("_#19");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#20");
	list_node_output_ := list_node_output_ _ [[]];

	create_mscr_node("_#21");
	list_node_output_ := list_node_output_ _ [[]];
                   
        
	////collision rules (second pass)
	//internal rules and half rules

	list_node_output_[0] := [create_id_node("_#0"), create_id_reset("accu")];

	list_node_output_[1] := [create_id_node("_#1"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("_#1"), create_id_return("v")] --> [create_id_node_aux("_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("_#1"), create_id_return("z")] --> [create_id_node("_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("_#1"), create_id_return("z")] --> [create_id_node_aux("_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("_#1"), create_id_return("v")] --> [create_id_node("_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_[2] := [create_id_node("_#2"), create_id_move_init_n("<", 1)];

	list_node_output_[3] := [create_id_node("_#3"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("_#3"), create_id_return("v")] --> [create_id_node_aux("_#3"), create_id_add("cell", 0)];
	[create_id_node_aux("_#3"), create_id_return("z")] --> [create_id_node("_#3"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("_#3"), create_id_return("z")] --> [create_id_node_aux("_#3"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("_#3"), create_id_return("v")] --> [create_id_node("_#3"), create_id_sub("cell", "top", 0)];

	list_node_output_[4] := [create_id_node("_#4"), create_id_move_init_n(">", 1)];

	list_node_output_[5] := [create_id_node("_#5"), create_id_move_init_n(">", 1)];

	list_node_output_[6] := [create_id_node("_#6"), create_id_reset("accu")];

	list_node_output_[7] := [create_id_node("_#7"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("_#7"), create_id_return("v")] --> [create_id_node_aux("_#7"), create_id_add("accu", 0)];
	[create_id_node_aux("_#7"), create_id_return("z")] --> [create_id_node("_#7"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("_#7"), create_id_return("z")] --> [create_id_node_aux("_#7"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("_#7"), create_id_return("v")] --> [create_id_node("_#7"), create_id_sub("accu", "top", 0)];

	list_node_output_[8] := [create_id_node("_#8"), create_id_move_init_n("<", 1)];

	list_node_output_[9] := [create_id_node("_#9"), create_id_reset("cell")];

	list_node_output_[10] := [create_id_node("_#10"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("_#10"), create_id_return("v")] --> [create_id_node_aux("_#10"), create_id_add("cell", 0)];
	[create_id_node_aux("_#10"), create_id_return("z")] --> [create_id_node("_#10"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("_#10"), create_id_return("z")] --> [create_id_node_aux("_#10"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("_#10"), create_id_return("v")] --> [create_id_node("_#10"), create_id_sub("cell", "top", 0)];

	list_node_output_[11] := [create_id_node("_#11"), create_id_move_init_n("<", 1)];

	list_node_output_[12] := [create_id_node("_#12"), create_id_reset("accu")];

	list_node_output_[13] := [create_id_node("_#13"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("_#13"), create_id_return("v")] --> [create_id_node_aux("_#13"), create_id_add("accu", 0)];
	[create_id_node_aux("_#13"), create_id_return("z")] --> [create_id_node("_#13"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("_#13"), create_id_return("z")] --> [create_id_node_aux("_#13"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("_#13"), create_id_return("v")] --> [create_id_node("_#13"), create_id_sub("accu", "top", 0)];

	list_node_output_[14] := [create_id_node("_#14"), create_id_reset("cell")];

	list_node_output_[15] := [create_id_node("_#15"), create_id_move_init_n(">", 1)];

	list_node_output_[16] := [create_id_node("_#16"), create_id_move_init_n(">", 1)];

	list_node_output_[17] := [create_id_node("_#17"), create_id_reset("cell")];

	list_node_output_[18] := [create_id_node("_#18"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("_#18"), create_id_return("v")] --> [create_id_node_aux("_#18"), create_id_add("cell", 0)];
	[create_id_node_aux("_#18"), create_id_return("z")] --> [create_id_node("_#18"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("_#18"), create_id_return("z")] --> [create_id_node_aux("_#18"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("_#18"), create_id_return("v")] --> [create_id_node("_#18"), create_id_sub("cell", "top", 0)];

	list_node_output_[19] := [create_id_node("_#19"), create_id_move_init_n("<", 1)];

	list_node_output_[20] := [create_id_node("_#20"), create_id_reset("accu")];

	list_node_output_[21] := [create_id_node("_#21")];

	//internodes rules
	//two lists of partial collision rules lacking an input MS defined by the ubt library.
	list_cr_delay := [];
	list_cr_split := [];

	[create_id_node("_#0"), create_id_return("")] --> list_node_output_[1];
	[create_id_node("_#1"), create_id_return("")] --> list_node_output_[2];
	[create_id_node("_#2"), create_id_return("")] --> list_node_output_[3];
	[create_id_node("_#3"), create_id_return("")] --> list_node_output_[4];
	[create_id_node("_#4"), create_id_return("")] --> list_node_output_[5];
	[create_id_node("_#5"), create_id_return("")] --> list_node_output_[6];
	[create_id_node("_#6"), create_id_return("")] --> list_node_output_[7];
	[create_id_node("_#7"), create_id_return("")] --> list_node_output_[8];
	[create_id_node("_#8"), create_id_return("")] --> list_node_output_[9];
	[create_id_node("_#9"), create_id_return("")] --> list_node_output_[10];
	[create_id_node("_#10"), create_id_return("")] --> list_node_output_[11];
	[create_id_node("_#11"), create_id_return("")] --> list_node_output_[12];
	[create_id_node("_#12"), create_id_return("")] --> list_node_output_[13];
	[create_id_node("_#13"), create_id_return("")] --> list_node_output_[14];
	[create_id_node("_#14"), create_id_return("")] --> list_node_output_[15];
	[create_id_node("_#15"), create_id_return("")] --> list_node_output_[16];
	[create_id_node("_#16"), create_id_return("")] --> list_node_output_[17];
	[create_id_node("_#17"), create_id_return("")] --> list_node_output_[18];
	[create_id_node("_#18"), create_id_return("")] --> list_node_output_[19];
	[create_id_node("_#19"), create_id_return("")] --> list_node_output_[20];
	[create_id_node("_#20"), create_id_return("")] --> list_node_output_[21];
};
