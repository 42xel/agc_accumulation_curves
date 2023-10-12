///////******This file has been automatically generated******//////
/*
for you own sake, do not edit (you're likely to be overwritten).

This file contains the definition of an lbss signal machine.
To generate, put:
toAGC_machine anonymous_machine .anonymous_machine.agc
in a .lbss file and run it with lbss.py
anonymous_machine must refer to a previously defined machine.

usage (for comprehension purpose):
in an agc file:
    
load ".anonymous_machine.agc";

Creates a signal machine named: anonymous_machine
To create a configuration, prefer create_configuration_tape to create_configuration
*/

use AGC;
load "../../lib_agc/arith.agc";
anonymous_machine .= create_signal_machine()
{
	MaxCTE .= 2;
	MaxMove .= 3;
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

	create_mscr_node("Init_#0");
	list_node_output_Init := list_node_output_Init _ [[]];

	create_mscr_node("Init_#1");
	list_node_output_Init := list_node_output_Init _ [[]];

	create_mscr_node("Init_#2");
	list_node_output_Init := list_node_output_Init _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Init_#2"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Init_#3");
	list_node_output_Init := list_node_output_Init _ [[]];

	create_mscr_node("Init_#4");
	list_node_output_Init := list_node_output_Init _ [[]];
	create_mscr_get(2, "cell");
	add_meta_signal(create_id_node_aux("Init_#4"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Init_#5");
	list_node_output_Init := list_node_output_Init _ [[]];

	create_mscr_node("Init_#6");
	list_node_output_Init := list_node_output_Init _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Init_#6"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Init_#7");
	list_node_output_Init := list_node_output_Init _ [[]];

	create_mscr_node("Init_#8");
	list_node_output_Init := list_node_output_Init _ [[]];

	create_mscr_node("Init_#9");
	list_node_output_Init := list_node_output_Init _ [[]];
	create_mscr_get(1/2, "accu");
	add_meta_signal(create_id_node_aux("Init_#9"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Init_#10");
	list_node_output_Init := list_node_output_Init _ [[]];

	create_mscr_node("Init_#11");
	list_node_output_Init := list_node_output_Init _ [[]];
    create_mscr_move("<", 2);

	create_mscr_node("Left_#0");
	list_node_output_Left := list_node_output_Left _ [[]];

	create_mscr_node("Left_#1");
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(2, "cell");
	add_meta_signal(create_id_node_aux("Left_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Left_#2");
	list_node_output_Left := list_node_output_Left _ [[]];

	create_mscr_node("Left_#3");
	list_node_output_Left := list_node_output_Left _ [[]];

	create_mscr_node("Left_#4");
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Left_#4"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Left_#5");
	list_node_output_Left := list_node_output_Left _ [[]];

	create_mscr_node("Left_#6");
	list_node_output_Left := list_node_output_Left _ [[]];

	create_mscr_node("Left_#7");
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Left_#7"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Left_#8");
	list_node_output_Left := list_node_output_Left _ [[]];
    create_mscr_move("<", 3);

	create_mscr_node("Left_#9");
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Left_#9"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Left_#10");
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Left_#10"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Left_#11");
	list_node_output_Left := list_node_output_Left _ [[]];

	create_mscr_node("Left_#12");
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Left_#12"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Left_#13");
	list_node_output_Left := list_node_output_Left _ [[]];

	create_mscr_node("Right_#0");
	list_node_output_Right := list_node_output_Right _ [[]];

	create_mscr_node("Right_#1");
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(2, "cell");
	add_meta_signal(create_id_node_aux("Right_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Right_#2");
	list_node_output_Right := list_node_output_Right _ [[]];

	create_mscr_node("Right_#3");
	list_node_output_Right := list_node_output_Right _ [[]];

	create_mscr_node("Right_#4");
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Right_#4"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Right_#5");
	list_node_output_Right := list_node_output_Right _ [[]];
    create_mscr_move(">", 3);

	create_mscr_node("Right_#6");
	list_node_output_Right := list_node_output_Right _ [[]];

	create_mscr_node("Right_#7");
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Right_#7"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Right_#8");
	list_node_output_Right := list_node_output_Right _ [[]];

	create_mscr_node("Right_#9");
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Right_#9"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Right_#10");
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Right_#10"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Right_#11");
	list_node_output_Right := list_node_output_Right _ [[]];

	create_mscr_node("Right_#12");
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Right_#12"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Right_#13");
	list_node_output_Right := list_node_output_Right _ [[]];

	create_mscr_node("Up_#0");
	list_node_output_Up := list_node_output_Up _ [[]];

	create_mscr_node("Up_#1");
	list_node_output_Up := list_node_output_Up _ [[]];
	create_mscr_get(1, "unit");
	add_meta_signal(create_id_node_aux("Up_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Up_#2");
	list_node_output_Up := list_node_output_Up _ [[]];

	create_mscr_node("Up_#3");
	list_node_output_Up := list_node_output_Up _ [[]];
	create_mscr_get(1, "unit");
	add_meta_signal(create_id_node_aux("Up_#3"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Up_#4");
	list_node_output_Up := list_node_output_Up _ [[]];

	create_mscr_node("Up_#5");
	list_node_output_Up := list_node_output_Up _ [[]];
	create_mscr_get(1, "unit");
	add_meta_signal(create_id_node_aux("Up_#5"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Up_#6");
	list_node_output_Up := list_node_output_Up _ [[]];

	create_mscr_node("Test_#0");
	list_node_output_Test := list_node_output_Test _ [[]];
    create_mscr_move(">", 2);

	create_mscr_node("Test_#1");
	list_node_output_Test := list_node_output_Test _ [[]];

	create_mscr_node("Test_#2");
	list_node_output_Test := list_node_output_Test _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_#2"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_#3");
	list_node_output_Test := list_node_output_Test _ [[]];

	create_mscr_node("Test_#4");
	list_node_output_Test := list_node_output_Test _ [[]];

	create_mscr_node("Test_a_pos_#0");
	list_node_output_Test_a_pos := list_node_output_Test_a_pos _ [[]];

	create_mscr_node("Test_a_pos_#1");
	list_node_output_Test_a_pos := list_node_output_Test_a_pos _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_pos_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_pos_#2");
	list_node_output_Test_a_pos := list_node_output_Test_a_pos _ [[]];
    create_mscr_move("<", 2);

	create_mscr_node("Test_a_pos_#3");
	list_node_output_Test_a_pos := list_node_output_Test_a_pos _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_pos_#3"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_pos_#4");
	list_node_output_Test_a_pos := list_node_output_Test_a_pos _ [[]];

	create_mscr_node("Test_a_pos1_#0");
	list_node_output_Test_a_pos1 := list_node_output_Test_a_pos1 _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_pos1_#0"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_pos2_#0");
	list_node_output_Test_a_pos2 := list_node_output_Test_a_pos2 _ [[]];

	create_mscr_node("Test_a_pos2_#1");
	list_node_output_Test_a_pos2 := list_node_output_Test_a_pos2 _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_pos2_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_pos3_#0");
	list_node_output_Test_a_pos3 := list_node_output_Test_a_pos3 _ [[]];

	create_mscr_node("Test_a_pos3_#1");
	list_node_output_Test_a_pos3 := list_node_output_Test_a_pos3 _ [[]];
	create_mscr_get(2, "cell");
	add_meta_signal(create_id_node_aux("Test_a_pos3_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_nonpos_#0");
	list_node_output_Test_a_nonpos := list_node_output_Test_a_nonpos _ [[]];

	create_mscr_node("Test_a_nonpos_#1");
	list_node_output_Test_a_nonpos := list_node_output_Test_a_nonpos _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_nonpos_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_nonpos_#2");
	list_node_output_Test_a_nonpos := list_node_output_Test_a_nonpos _ [[]];
    create_mscr_move("<", 2);

	create_mscr_node("Test_a_nonpos_#3");
	list_node_output_Test_a_nonpos := list_node_output_Test_a_nonpos _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_nonpos_#3"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_nonpos_#4");
	list_node_output_Test_a_nonpos := list_node_output_Test_a_nonpos _ [[]];

	create_mscr_node("Test_a_nonpos1_#0");
	list_node_output_Test_a_nonpos1 := list_node_output_Test_a_nonpos1 _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_nonpos1_#0"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_nonpos1_#1");
	list_node_output_Test_a_nonpos1 := list_node_output_Test_a_nonpos1 _ [[]];

	create_mscr_node("Test_a_nonpos2_#0");
	list_node_output_Test_a_nonpos2 := list_node_output_Test_a_nonpos2 _ [[]];

	create_mscr_node("Test_a_nonpos2_#1");
	list_node_output_Test_a_nonpos2 := list_node_output_Test_a_nonpos2 _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Test_a_nonpos2_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_a_nonpos2_#2");
	list_node_output_Test_a_nonpos2 := list_node_output_Test_a_nonpos2 _ [[]];

	create_mscr_node("Test_final_#0");
	list_node_output_Test_final := list_node_output_Test_final _ [[]];
	create_mscr_get(2, "unit");
	add_meta_signal(create_id_node_aux("Test_final_#0"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("Test_final_#1");
	list_node_output_Test_final := list_node_output_Test_final _ [[]];

	create_mscr_node("LDelay_#0");
	list_node_output_LDelay := list_node_output_LDelay _ [[]];

	create_mscr_node("LSplit_#0");
	list_node_output_LSplit := list_node_output_LSplit _ [[]];
    create_mscr_move(">", 2);

	create_mscr_node("LSplit_#1");
	list_node_output_LSplit := list_node_output_LSplit _ [[]];
	create_mscr_get(1/2, "cell");
	add_meta_signal(create_id_node_aux("LSplit_#1"), 0)	{color => COLOR_COMPUTE;};

	create_mscr_node("LSplit_#2");
	list_node_output_LSplit := list_node_output_LSplit _ [[]];
    create_mscr_move("<", 2);

	create_mscr_node("LSplit_#3");
	list_node_output_LSplit := list_node_output_LSplit _ [[]];

	create_mscr_node("LSplit_#4");
	list_node_output_LSplit := list_node_output_LSplit _ [[]];
                   
        
	////collision rules (second pass)
	//internal rules and half rules

	list_node_output_Init[0] := [create_id_node("Init_#0"), create_id_move_init_n("<", 1)];

	list_node_output_Init[1] := [create_id_node("Init_#1"), create_id_reset("accu")];

	list_node_output_Init[2] := [create_id_node("Init_#2"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Init_#2"), create_id_return("v")] --> [create_id_node_aux("Init_#2"), create_id_add("accu", 0)];
	[create_id_node_aux("Init_#2"), create_id_return("z")] --> [create_id_node("Init_#2"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Init_#2"), create_id_return("z")] --> [create_id_node_aux("Init_#2"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Init_#2"), create_id_return("v")] --> [create_id_node("Init_#2"), create_id_sub("accu", "top", 0)];

	list_node_output_Init[3] := [create_id_node("Init_#3"), create_id_move_init_n(">", 1)];

	list_node_output_Init[4] := [create_id_node("Init_#4"), create_id_get (2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Init_#4"), create_id_return("v")] --> [create_id_node_aux("Init_#4"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Init_#4"), create_id_return("z")] --> [create_id_node("Init_#4"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Init_#4"), create_id_return("z")] --> [create_id_node_aux("Init_#4"), create_id_add("accu", 0)];
	[create_id_node_aux("Init_#4"), create_id_return("v")] --> [create_id_node("Init_#4"), create_id_add("accu", 0)];

	list_node_output_Init[5] := [create_id_node("Init_#5"), create_id_move_init_n(">", 1)];

	list_node_output_Init[6] := [create_id_node("Init_#6"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Init_#6"), create_id_return("v")] --> [create_id_node_aux("Init_#6"), create_id_add("accu", 0)];
	[create_id_node_aux("Init_#6"), create_id_return("z")] --> [create_id_node("Init_#6"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Init_#6"), create_id_return("z")] --> [create_id_node_aux("Init_#6"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Init_#6"), create_id_return("v")] --> [create_id_node("Init_#6"), create_id_sub("accu", "top", 0)];

	list_node_output_Init[7] := [create_id_node("Init_#7"), create_id_move_init_n(">", 1)];

	list_node_output_Init[8] := [create_id_node("Init_#8"), create_id_reset("cell")];

	list_node_output_Init[9] := [create_id_node("Init_#9"), create_id_get (1/2, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Init_#9"), create_id_return("v")] --> [create_id_node_aux("Init_#9"), create_id_add("cell", 0)];
	[create_id_node_aux("Init_#9"), create_id_return("z")] --> [create_id_node("Init_#9"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Init_#9"), create_id_return("z")] --> [create_id_node_aux("Init_#9"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Init_#9"), create_id_return("v")] --> [create_id_node("Init_#9"), create_id_sub("cell", "top", 0)];

	list_node_output_Init[10] := [create_id_node("Init_#10"), create_id_reset("accu")];

	list_node_output_Init[11] := [create_id_node("Init_#11"), create_id_move_init_n("<", 2)];

	list_node_output_Left[0] := [create_id_node("Left_#0"), create_id_reset("accu")];

	list_node_output_Left[1] := [create_id_node("Left_#1"), create_id_get (2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#1"), create_id_return("v")] --> [create_id_node_aux("Left_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Left_#1"), create_id_return("z")] --> [create_id_node("Left_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#1"), create_id_return("z")] --> [create_id_node_aux("Left_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Left_#1"), create_id_return("v")] --> [create_id_node("Left_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_Left[2] := [create_id_node("Left_#2"), create_id_move_init_n(">", 1)];

	list_node_output_Left[3] := [create_id_node("Left_#3"), create_id_reset("cell")];

	list_node_output_Left[4] := [create_id_node("Left_#4"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#4"), create_id_return("v")] --> [create_id_node_aux("Left_#4"), create_id_add("cell", 0)];
	[create_id_node_aux("Left_#4"), create_id_return("z")] --> [create_id_node("Left_#4"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#4"), create_id_return("z")] --> [create_id_node_aux("Left_#4"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Left_#4"), create_id_return("v")] --> [create_id_node("Left_#4"), create_id_sub("cell", "top", 0)];

	list_node_output_Left[5] := [create_id_node("Left_#5"), create_id_move_init_n(">", 1)];

	list_node_output_Left[6] := [create_id_node("Left_#6"), create_id_reset("accu")];

	list_node_output_Left[7] := [create_id_node("Left_#7"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#7"), create_id_return("v")] --> [create_id_node_aux("Left_#7"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Left_#7"), create_id_return("z")] --> [create_id_node("Left_#7"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#7"), create_id_return("z")] --> [create_id_node_aux("Left_#7"), create_id_add("accu", 0)];
	[create_id_node_aux("Left_#7"), create_id_return("v")] --> [create_id_node("Left_#7"), create_id_add("accu", 0)];

	list_node_output_Left[8] := [create_id_node("Left_#8"), create_id_move_init_n("<", 3)];

	list_node_output_Left[9] := [create_id_node("Left_#9"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#9"), create_id_return("v")] --> [create_id_node_aux("Left_#9"), create_id_add("accu", 0)];
	[create_id_node_aux("Left_#9"), create_id_return("z")] --> [create_id_node("Left_#9"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#9"), create_id_return("z")] --> [create_id_node_aux("Left_#9"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Left_#9"), create_id_return("v")] --> [create_id_node("Left_#9"), create_id_sub("accu", "top", 0)];

	list_node_output_Left[10] := [create_id_node("Left_#10"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#10"), create_id_return("v")] --> [create_id_node_aux("Left_#10"), create_id_add("cell", 0)];
	[create_id_node_aux("Left_#10"), create_id_return("z")] --> [create_id_node("Left_#10"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#10"), create_id_return("z")] --> [create_id_node_aux("Left_#10"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Left_#10"), create_id_return("v")] --> [create_id_node("Left_#10"), create_id_sub("cell", "top", 0)];

	list_node_output_Left[11] := [create_id_node("Left_#11"), create_id_move_init_n(">", 1)];

	list_node_output_Left[12] := [create_id_node("Left_#12"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#12"), create_id_return("v")] --> [create_id_node_aux("Left_#12"), create_id_add("cell", 0)];
	[create_id_node_aux("Left_#12"), create_id_return("z")] --> [create_id_node("Left_#12"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#12"), create_id_return("z")] --> [create_id_node_aux("Left_#12"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Left_#12"), create_id_return("v")] --> [create_id_node("Left_#12"), create_id_sub("cell", "top", 0)];

	list_node_output_Left[13] := [create_id_node("Left_#13"), create_id_reset("accu")];

	list_node_output_Right[0] := [create_id_node("Right_#0"), create_id_reset("accu")];

	list_node_output_Right[1] := [create_id_node("Right_#1"), create_id_get (2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#1"), create_id_return("v")] --> [create_id_node_aux("Right_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Right_#1"), create_id_return("z")] --> [create_id_node("Right_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#1"), create_id_return("z")] --> [create_id_node_aux("Right_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Right_#1"), create_id_return("v")] --> [create_id_node("Right_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_Right[2] := [create_id_node("Right_#2"), create_id_move_init_n("<", 1)];

	list_node_output_Right[3] := [create_id_node("Right_#3"), create_id_reset("cell")];

	list_node_output_Right[4] := [create_id_node("Right_#4"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#4"), create_id_return("v")] --> [create_id_node_aux("Right_#4"), create_id_add("cell", 0)];
	[create_id_node_aux("Right_#4"), create_id_return("z")] --> [create_id_node("Right_#4"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#4"), create_id_return("z")] --> [create_id_node_aux("Right_#4"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Right_#4"), create_id_return("v")] --> [create_id_node("Right_#4"), create_id_sub("cell", "top", 0)];

	list_node_output_Right[5] := [create_id_node("Right_#5"), create_id_move_init_n(">", 3)];

	list_node_output_Right[6] := [create_id_node("Right_#6"), create_id_reset("accu")];

	list_node_output_Right[7] := [create_id_node("Right_#7"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#7"), create_id_return("v")] --> [create_id_node_aux("Right_#7"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Right_#7"), create_id_return("z")] --> [create_id_node("Right_#7"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#7"), create_id_return("z")] --> [create_id_node_aux("Right_#7"), create_id_add("accu", 0)];
	[create_id_node_aux("Right_#7"), create_id_return("v")] --> [create_id_node("Right_#7"), create_id_add("accu", 0)];

	list_node_output_Right[8] := [create_id_node("Right_#8"), create_id_move_init_n("<", 1)];

	list_node_output_Right[9] := [create_id_node("Right_#9"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#9"), create_id_return("v")] --> [create_id_node_aux("Right_#9"), create_id_add("accu", 0)];
	[create_id_node_aux("Right_#9"), create_id_return("z")] --> [create_id_node("Right_#9"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#9"), create_id_return("z")] --> [create_id_node_aux("Right_#9"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Right_#9"), create_id_return("v")] --> [create_id_node("Right_#9"), create_id_sub("accu", "top", 0)];

	list_node_output_Right[10] := [create_id_node("Right_#10"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#10"), create_id_return("v")] --> [create_id_node_aux("Right_#10"), create_id_add("cell", 0)];
	[create_id_node_aux("Right_#10"), create_id_return("z")] --> [create_id_node("Right_#10"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#10"), create_id_return("z")] --> [create_id_node_aux("Right_#10"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Right_#10"), create_id_return("v")] --> [create_id_node("Right_#10"), create_id_sub("cell", "top", 0)];

	list_node_output_Right[11] := [create_id_node("Right_#11"), create_id_move_init_n("<", 1)];

	list_node_output_Right[12] := [create_id_node("Right_#12"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#12"), create_id_return("v")] --> [create_id_node_aux("Right_#12"), create_id_add("cell", 0)];
	[create_id_node_aux("Right_#12"), create_id_return("z")] --> [create_id_node("Right_#12"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#12"), create_id_return("z")] --> [create_id_node_aux("Right_#12"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Right_#12"), create_id_return("v")] --> [create_id_node("Right_#12"), create_id_sub("cell", "top", 0)];

	list_node_output_Right[13] := [create_id_node("Right_#13"), create_id_reset("accu")];

	list_node_output_Up[0] := [create_id_node("Up_#0"), create_id_move_init_n("<", 1)];

	list_node_output_Up[1] := [create_id_node("Up_#1"), create_id_get (1, "unit", 0)];

	//get result positive (v received before z)
	[create_id_node("Up_#1"), create_id_return("v")] --> [create_id_node_aux("Up_#1"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Up_#1"), create_id_return("z")] --> [create_id_node("Up_#1"), create_id_sub("cell", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Up_#1"), create_id_return("z")] --> [create_id_node_aux("Up_#1"), create_id_add("cell", 0)];
	[create_id_node_aux("Up_#1"), create_id_return("v")] --> [create_id_node("Up_#1"), create_id_add("cell", 0)];

	list_node_output_Up[2] := [create_id_node("Up_#2"), create_id_move_init_n(">", 1)];

	list_node_output_Up[3] := [create_id_node("Up_#3"), create_id_get (1, "unit", 0)];

	//get result positive (v received before z)
	[create_id_node("Up_#3"), create_id_return("v")] --> [create_id_node_aux("Up_#3"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Up_#3"), create_id_return("z")] --> [create_id_node("Up_#3"), create_id_sub("cell", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Up_#3"), create_id_return("z")] --> [create_id_node_aux("Up_#3"), create_id_add("cell", 0)];
	[create_id_node_aux("Up_#3"), create_id_return("v")] --> [create_id_node("Up_#3"), create_id_add("cell", 0)];

	list_node_output_Up[4] := [create_id_node("Up_#4"), create_id_move_init_n(">", 1)];

	list_node_output_Up[5] := [create_id_node("Up_#5"), create_id_get (1, "unit", 0)];

	//get result positive (v received before z)
	[create_id_node("Up_#5"), create_id_return("v")] --> [create_id_node_aux("Up_#5"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Up_#5"), create_id_return("z")] --> [create_id_node("Up_#5"), create_id_sub("cell", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Up_#5"), create_id_return("z")] --> [create_id_node_aux("Up_#5"), create_id_add("cell", 0)];
	[create_id_node_aux("Up_#5"), create_id_return("v")] --> [create_id_node("Up_#5"), create_id_add("cell", 0)];

	list_node_output_Up[6] := [create_id_node("Up_#6"), create_id_move_init_n("<", 1)];

	list_node_output_Test[0] := [create_id_node("Test_#0"), create_id_move_init_n(">", 2)];

	list_node_output_Test[1] := [create_id_node("Test_#1"), create_id_reset("accu")];

	list_node_output_Test[2] := [create_id_node("Test_#2"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_#2"), create_id_return("v")] --> [create_id_node_aux("Test_#2"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_#2"), create_id_return("z")] --> [create_id_node("Test_#2"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_#2"), create_id_return("z")] --> [create_id_node_aux("Test_#2"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_#2"), create_id_return("v")] --> [create_id_node("Test_#2"), create_id_sub("accu", "top", 0)];

	list_node_output_Test[3] := [create_id_node("Test_#3"), create_id_move_init_n("<", 1)];

	list_node_output_Test[4] := [create_id_node("Test_#4"), "branch"];

	list_node_output_Test_a_pos[0] := [create_id_node("Test_a_pos_#0"), create_id_reset("accu")];

	list_node_output_Test_a_pos[1] := [create_id_node("Test_a_pos_#1"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_pos_#1"), create_id_return("v")] --> [create_id_node_aux("Test_a_pos_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_pos_#1"), create_id_return("z")] --> [create_id_node("Test_a_pos_#1"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_pos_#1"), create_id_return("z")] --> [create_id_node_aux("Test_a_pos_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_pos_#1"), create_id_return("v")] --> [create_id_node("Test_a_pos_#1"), create_id_add("accu", 0)];

	list_node_output_Test_a_pos[2] := [create_id_node("Test_a_pos_#2"), create_id_move_init_n("<", 2)];

	list_node_output_Test_a_pos[3] := [create_id_node("Test_a_pos_#3"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_pos_#3"), create_id_return("v")] --> [create_id_node_aux("Test_a_pos_#3"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_pos_#3"), create_id_return("z")] --> [create_id_node("Test_a_pos_#3"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_pos_#3"), create_id_return("z")] --> [create_id_node_aux("Test_a_pos_#3"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_pos_#3"), create_id_return("v")] --> [create_id_node("Test_a_pos_#3"), create_id_sub("accu", "top", 0)];

	list_node_output_Test_a_pos[4] := [create_id_node("Test_a_pos_#4"), "branch"];

	list_node_output_Test_a_pos1[0] := [create_id_node("Test_a_pos1_#0"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_pos1_#0"), create_id_return("v")] --> [create_id_node_aux("Test_a_pos1_#0"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_pos1_#0"), create_id_return("z")] --> [create_id_node("Test_a_pos1_#0"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_pos1_#0"), create_id_return("z")] --> [create_id_node_aux("Test_a_pos1_#0"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_pos1_#0"), create_id_return("v")] --> [create_id_node("Test_a_pos1_#0"), create_id_add("accu", 0)];

	list_node_output_Test_a_pos2[0] := [create_id_node("Test_a_pos2_#0"), create_id_reset("accu")];

	list_node_output_Test_a_pos2[1] := [create_id_node("Test_a_pos2_#1"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_pos2_#1"), create_id_return("v")] --> [create_id_node_aux("Test_a_pos2_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_pos2_#1"), create_id_return("z")] --> [create_id_node("Test_a_pos2_#1"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_pos2_#1"), create_id_return("z")] --> [create_id_node_aux("Test_a_pos2_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_pos2_#1"), create_id_return("v")] --> [create_id_node("Test_a_pos2_#1"), create_id_add("accu", 0)];

	list_node_output_Test_a_pos3[0] := [create_id_node("Test_a_pos3_#0"), create_id_move_init_n(">", 1)];

	list_node_output_Test_a_pos3[1] := [create_id_node("Test_a_pos3_#1"), create_id_get (2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_pos3_#1"), create_id_return("v")] --> [create_id_node_aux("Test_a_pos3_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_pos3_#1"), create_id_return("z")] --> [create_id_node("Test_a_pos3_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_pos3_#1"), create_id_return("z")] --> [create_id_node_aux("Test_a_pos3_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_pos3_#1"), create_id_return("v")] --> [create_id_node("Test_a_pos3_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_Test_a_nonpos[0] := [create_id_node("Test_a_nonpos_#0"), create_id_reset("accu")];

	list_node_output_Test_a_nonpos[1] := [create_id_node("Test_a_nonpos_#1"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_nonpos_#1"), create_id_return("v")] --> [create_id_node_aux("Test_a_nonpos_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_nonpos_#1"), create_id_return("z")] --> [create_id_node("Test_a_nonpos_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_nonpos_#1"), create_id_return("z")] --> [create_id_node_aux("Test_a_nonpos_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_nonpos_#1"), create_id_return("v")] --> [create_id_node("Test_a_nonpos_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_Test_a_nonpos[2] := [create_id_node("Test_a_nonpos_#2"), create_id_move_init_n("<", 2)];

	list_node_output_Test_a_nonpos[3] := [create_id_node("Test_a_nonpos_#3"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_nonpos_#3"), create_id_return("v")] --> [create_id_node_aux("Test_a_nonpos_#3"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_nonpos_#3"), create_id_return("z")] --> [create_id_node("Test_a_nonpos_#3"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_nonpos_#3"), create_id_return("z")] --> [create_id_node_aux("Test_a_nonpos_#3"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_nonpos_#3"), create_id_return("v")] --> [create_id_node("Test_a_nonpos_#3"), create_id_add("accu", 0)];

	list_node_output_Test_a_nonpos[4] := [create_id_node("Test_a_nonpos_#4"), "branch"];

	list_node_output_Test_a_nonpos1[0] := [create_id_node("Test_a_nonpos1_#0"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_nonpos1_#0"), create_id_return("v")] --> [create_id_node_aux("Test_a_nonpos1_#0"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_nonpos1_#0"), create_id_return("z")] --> [create_id_node("Test_a_nonpos1_#0"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_nonpos1_#0"), create_id_return("z")] --> [create_id_node_aux("Test_a_nonpos1_#0"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_nonpos1_#0"), create_id_return("v")] --> [create_id_node("Test_a_nonpos1_#0"), create_id_sub("accu", "top", 0)];

	list_node_output_Test_a_nonpos1[1] := [create_id_node("Test_a_nonpos1_#1"), create_id_move_init_n(">", 1)];

	list_node_output_Test_a_nonpos2[0] := [create_id_node("Test_a_nonpos2_#0"), create_id_reset("accu")];

	list_node_output_Test_a_nonpos2[1] := [create_id_node("Test_a_nonpos2_#1"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_a_nonpos2_#1"), create_id_return("v")] --> [create_id_node_aux("Test_a_nonpos2_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_a_nonpos2_#1"), create_id_return("z")] --> [create_id_node("Test_a_nonpos2_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_a_nonpos2_#1"), create_id_return("z")] --> [create_id_node_aux("Test_a_nonpos2_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_a_nonpos2_#1"), create_id_return("v")] --> [create_id_node("Test_a_nonpos2_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_Test_a_nonpos2[2] := [create_id_node("Test_a_nonpos2_#2"), create_id_move_init_n(">", 1)];

	list_node_output_Test_final[0] := [create_id_node("Test_final_#0"), create_id_get (2, "unit", 0)];

	//get result positive (v received before z)
	[create_id_node("Test_final_#0"), create_id_return("v")] --> [create_id_node_aux("Test_final_#0"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Test_final_#0"), create_id_return("z")] --> [create_id_node("Test_final_#0"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Test_final_#0"), create_id_return("z")] --> [create_id_node_aux("Test_final_#0"), create_id_add("accu", 0)];
	[create_id_node_aux("Test_final_#0"), create_id_return("v")] --> [create_id_node("Test_final_#0"), create_id_add("accu", 0)];

	list_node_output_Test_final[1] := [create_id_node("Test_final_#1"), "branch"];

	list_node_output_LDelay[0] := [create_id_node("LDelay_#0"), create_id_ubt ("delay")];

	list_node_output_LSplit[0] := [create_id_node("LSplit_#0"), create_id_move_init_n(">", 2)];

	list_node_output_LSplit[1] := [create_id_node("LSplit_#1"), create_id_get (1/2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("LSplit_#1"), create_id_return("v")] --> [create_id_node_aux("LSplit_#1"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("LSplit_#1"), create_id_return("z")] --> [create_id_node("LSplit_#1"), create_id_sub("cell", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("LSplit_#1"), create_id_return("z")] --> [create_id_node_aux("LSplit_#1"), create_id_add("cell", 0)];
	[create_id_node_aux("LSplit_#1"), create_id_return("v")] --> [create_id_node("LSplit_#1"), create_id_add("cell", 0)];

	list_node_output_LSplit[2] := [create_id_node("LSplit_#2"), create_id_move_init_n("<", 2)];

	list_node_output_LSplit[3] := [create_id_node("LSplit_#3"), create_id_ubt ("split")];

	list_node_output_LSplit[4] := [create_id_node("LSplit_#4")];

	//internodes rules
	//two lists of partial collision rules lacking an input MS defined by the ubt library.
	list_cr_delay := [];
	list_cr_split := [];

	[create_id_node("Init_#0"), create_id_return("")] --> list_node_output_Init[1];
	[create_id_node("Init_#1"), create_id_return("")] --> list_node_output_Init[2];
	[create_id_node("Init_#2"), create_id_return("")] --> list_node_output_Init[3];
	[create_id_node("Init_#3"), create_id_return("")] --> list_node_output_Init[4];
	[create_id_node("Init_#4"), create_id_return("")] --> list_node_output_Init[5];
	[create_id_node("Init_#5"), create_id_return("")] --> list_node_output_Init[6];
	[create_id_node("Init_#6"), create_id_return("")] --> list_node_output_Init[7];
	[create_id_node("Init_#7"), create_id_return("")] --> list_node_output_Init[8];
	[create_id_node("Init_#8"), create_id_return("")] --> list_node_output_Init[9];
	[create_id_node("Init_#9"), create_id_return("")] --> list_node_output_Init[10];
	[create_id_node("Init_#10"), create_id_return("")] --> list_node_output_Init[11];
	[create_id_node("Init_#11"), create_id_return("")] --> list_node_output_Test[0];
	[create_id_node("Left_#0"), create_id_return("")] --> list_node_output_Left[1];
	[create_id_node("Left_#1"), create_id_return("")] --> list_node_output_Left[2];
	[create_id_node("Left_#2"), create_id_return("")] --> list_node_output_Left[3];
	[create_id_node("Left_#3"), create_id_return("")] --> list_node_output_Left[4];
	[create_id_node("Left_#4"), create_id_return("")] --> list_node_output_Left[5];
	[create_id_node("Left_#5"), create_id_return("")] --> list_node_output_Left[6];
	[create_id_node("Left_#6"), create_id_return("")] --> list_node_output_Left[7];
	[create_id_node("Left_#7"), create_id_return("")] --> list_node_output_Left[8];
	[create_id_node("Left_#8"), create_id_return("")] --> list_node_output_Left[9];
	[create_id_node("Left_#9"), create_id_return("")] --> list_node_output_Left[10];
	[create_id_node("Left_#10"), create_id_return("")] --> list_node_output_Left[11];
	[create_id_node("Left_#11"), create_id_return("")] --> list_node_output_Left[12];
	[create_id_node("Left_#12"), create_id_return("")] --> list_node_output_Left[13];
	[create_id_node("Left_#13"), create_id_return("")] --> list_node_output_Up[0];
	[create_id_node("Right_#0"), create_id_return("")] --> list_node_output_Right[1];
	[create_id_node("Right_#1"), create_id_return("")] --> list_node_output_Right[2];
	[create_id_node("Right_#2"), create_id_return("")] --> list_node_output_Right[3];
	[create_id_node("Right_#3"), create_id_return("")] --> list_node_output_Right[4];
	[create_id_node("Right_#4"), create_id_return("")] --> list_node_output_Right[5];
	[create_id_node("Right_#5"), create_id_return("")] --> list_node_output_Right[6];
	[create_id_node("Right_#6"), create_id_return("")] --> list_node_output_Right[7];
	[create_id_node("Right_#7"), create_id_return("")] --> list_node_output_Right[8];
	[create_id_node("Right_#8"), create_id_return("")] --> list_node_output_Right[9];
	[create_id_node("Right_#9"), create_id_return("")] --> list_node_output_Right[10];
	[create_id_node("Right_#10"), create_id_return("")] --> list_node_output_Right[11];
	[create_id_node("Right_#11"), create_id_return("")] --> list_node_output_Right[12];
	[create_id_node("Right_#12"), create_id_return("")] --> list_node_output_Right[13];
	[create_id_node("Right_#13"), create_id_return("")] --> list_node_output_Up[0];
	[create_id_node("Up_#0"), create_id_return("")] --> list_node_output_Up[1];
	[create_id_node("Up_#1"), create_id_return("")] --> list_node_output_Up[2];
	[create_id_node("Up_#2"), create_id_return("")] --> list_node_output_Up[3];
	[create_id_node("Up_#3"), create_id_return("")] --> list_node_output_Up[4];
	[create_id_node("Up_#4"), create_id_return("")] --> list_node_output_Up[5];
	[create_id_node("Up_#5"), create_id_return("")] --> list_node_output_Up[6];
	[create_id_node("Up_#6"), create_id_return("")] --> list_node_output_Test[0];
	[create_id_node("Test_#0"), create_id_return("")] --> list_node_output_Test[1];
	[create_id_node("Test_#1"), create_id_return("")] --> list_node_output_Test[2];
	[create_id_node("Test_#2"), create_id_return("")] --> list_node_output_Test[3];
	[create_id_node("Test_#3"), create_id_return("")] --> list_node_output_Test[4];

	[create_id_node("Test_#4"), create_id_return("lt")] --> list_node_output_Test_a_nonpos[0];
	[create_id_node("Test_#4"), create_id_return("eq")] --> list_node_output_Test_a_nonpos[0];
	[create_id_node("Test_#4"), create_id_return("gt")] --> list_node_output_Test_a_pos[0];

	[create_id_node("Test_a_pos_#0"), create_id_return("")] --> list_node_output_Test_a_pos[1];
	[create_id_node("Test_a_pos_#1"), create_id_return("")] --> list_node_output_Test_a_pos[2];
	[create_id_node("Test_a_pos_#2"), create_id_return("")] --> list_node_output_Test_a_pos[3];
	[create_id_node("Test_a_pos_#3"), create_id_return("")] --> list_node_output_Test_a_pos[4];

	[create_id_node("Test_a_pos_#4"), create_id_return("lt")] --> list_node_output_Test_a_pos1[0];
	[create_id_node("Test_a_pos_#4"), create_id_return("eq")] --> list_node_output_Test_a_pos2[0];
	[create_id_node("Test_a_pos_#4"), create_id_return("gt")] --> list_node_output_Test_a_pos2[0];

	[create_id_node("Test_a_pos1_#0"), create_id_return("")] --> list_node_output_Test_a_pos3[0];
	[create_id_node("Test_a_pos2_#0"), create_id_return("")] --> list_node_output_Test_a_pos2[1];
	[create_id_node("Test_a_pos2_#1"), create_id_return("")] --> list_node_output_Test_a_pos3[0];
	[create_id_node("Test_a_pos3_#0"), create_id_return("")] --> list_node_output_Test_a_pos3[1];
	[create_id_node("Test_a_pos3_#1"), create_id_return("")] --> list_node_output_Test_final[0];
	[create_id_node("Test_a_nonpos_#0"), create_id_return("")] --> list_node_output_Test_a_nonpos[1];
	[create_id_node("Test_a_nonpos_#1"), create_id_return("")] --> list_node_output_Test_a_nonpos[2];
	[create_id_node("Test_a_nonpos_#2"), create_id_return("")] --> list_node_output_Test_a_nonpos[3];
	[create_id_node("Test_a_nonpos_#3"), create_id_return("")] --> list_node_output_Test_a_nonpos[4];

	[create_id_node("Test_a_nonpos_#4"), create_id_return("lt")] --> list_node_output_Test_a_nonpos1[0];
	[create_id_node("Test_a_nonpos_#4"), create_id_return("eq")] --> list_node_output_Test_a_nonpos2[0];
	[create_id_node("Test_a_nonpos_#4"), create_id_return("gt")] --> list_node_output_Test_a_nonpos2[0];

	[create_id_node("Test_a_nonpos1_#0"), create_id_return("")] --> list_node_output_Test_a_nonpos1[1];
	[create_id_node("Test_a_nonpos1_#1"), create_id_return("")] --> list_node_output_Test_final[0];
	[create_id_node("Test_a_nonpos2_#0"), create_id_return("")] --> list_node_output_Test_a_nonpos2[1];
	[create_id_node("Test_a_nonpos2_#1"), create_id_return("")] --> list_node_output_Test_a_nonpos2[2];
	[create_id_node("Test_a_nonpos2_#2"), create_id_return("")] --> list_node_output_Test_final[0];
	[create_id_node("Test_final_#0"), create_id_return("")] --> list_node_output_Test_final[1];

	[create_id_node("Test_final_#1"), create_id_return("lt")] --> list_node_output_LSplit[0];
	[create_id_node("Test_final_#1"), create_id_return("eq")] --> list_node_output_LDelay[0];
	[create_id_node("Test_final_#1"), create_id_return("gt")] --> list_node_output_LDelay[0];

	list_cr_delay := list_cr_delay _ [[[create_id_node("LDelay_#0")],
                                list_node_output_Up[0]]];
	[create_id_node("LSplit_#0"), create_id_return("")] --> list_node_output_LSplit[1];
	[create_id_node("LSplit_#1"), create_id_return("")] --> list_node_output_LSplit[2];
	[create_id_node("LSplit_#2"), create_id_return("")] --> list_node_output_LSplit[3];
	list_cr_split := list_cr_split _ [[[create_id_node("LSplit_#3")],
                                list_node_output_Left[0],
                                list_node_output_Right[0]]];
};
