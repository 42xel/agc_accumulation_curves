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
	load "../../lib_agc/lib_lbss_sm.agc";

	//////nodes
	//meta-signals
	create_id_node .= (id) -> "node:" & id;
	create_id_node_aux .= (id) -> create_id_node(id) & ":aux";


	add_meta_signal(create_id_node("Init_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Init := list_node_output_Init _ [[]];

	add_meta_signal(create_id_node("Init_#1"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Init := list_node_output_Init _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Init_#1"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Init_#2"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Init := list_node_output_Init _ [[]];
	create_ms_moved(">", create_id_node("Init_#2"))		{color => COLOR_COMPUTE;};
    create_mscr_move(">", 2);

	add_meta_signal(create_id_node("Left_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Left := list_node_output_Left _ [[]];
	create_ms_moved(">", create_id_node("Left_#0"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Left_#1"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Left := list_node_output_Left _ [[]];

	add_meta_signal(create_id_node("Left_#2"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Left_#2"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Left_#3"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Left_#3"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Left_#4"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Left := list_node_output_Left _ [[]];
	create_ms_moved(">", create_id_node("Left_#4"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Left_#5"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Left := list_node_output_Left _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Left_#5"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Left_#6"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Left := list_node_output_Left _ [[]];
	create_ms_moved("<", create_id_node("Left_#6"))		{color => COLOR_COMPUTE;};
    create_mscr_move("<", 2);

	add_meta_signal(create_id_node("Right_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Right := list_node_output_Right _ [[]];
	create_ms_moved(">", create_id_node("Right_#0"))		{color => COLOR_COMPUTE;};
    create_mscr_move(">", 2);

	add_meta_signal(create_id_node("Right_#1"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Right := list_node_output_Right _ [[]];

	add_meta_signal(create_id_node("Right_#2"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Right_#2"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Right_#3"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Right_#3"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Right_#4"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Right := list_node_output_Right _ [[]];
	create_ms_moved("<", create_id_node("Right_#4"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Right_#5"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Right := list_node_output_Right _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Right_#5"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Right_#6"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Right := list_node_output_Right _ [[]];
	create_ms_moved("<", create_id_node("Right_#6"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Up_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Up := list_node_output_Up _ [[]];

	add_meta_signal(create_id_node("Up_#1"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Up := list_node_output_Up _ [[]];
	create_mscr_get(1, "cell");
	add_meta_signal(create_id_node_aux("Up_#1"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Up_#2"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Up := list_node_output_Up _ [[]];
	create_ms_moved(">", create_id_node("Up_#2"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Up_#3"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Up := list_node_output_Up _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Up_#3"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Up_#4"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Up := list_node_output_Up _ [[]];
	create_ms_moved(">", create_id_node("Up_#4"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Up_#5"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Up := list_node_output_Up _ [[]];
	create_mscr_get(1, "accu");
	add_meta_signal(create_id_node_aux("Up_#5"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("test_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_test := list_node_output_test _ [[]];
	create_mscr_get(1/2, "cell");
	add_meta_signal(create_id_node_aux("test_#0"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("test_#1"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_test := list_node_output_test _ [[]];

	add_meta_signal(create_id_node("Next_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Next := list_node_output_Next _ [[]];
	create_mscr_get(1/2, "cell");
	add_meta_signal(create_id_node_aux("Next_#0"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Next_#1"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Next := list_node_output_Next _ [[]];
	create_ms_moved("<", create_id_node("Next_#1"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Next_#2"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Next := list_node_output_Next _ [[]];
	create_mscr_get(1/2, "cell");
	add_meta_signal(create_id_node_aux("Next_#2"), 0)	{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Next_#3"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Next := list_node_output_Next _ [[]];
	create_ms_moved("<", create_id_node("Next_#3"))		{color => COLOR_COMPUTE;};

	add_meta_signal(create_id_node("Next_#4"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_Next := list_node_output_Next _ [[]];

	add_meta_signal(create_id_node("labelDelay_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_labelDelay := list_node_output_labelDelay _ [[]];

	add_meta_signal(create_id_node("labelDelay_#1"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_labelDelay := list_node_output_labelDelay _ [[]];

	add_meta_signal(create_id_node("labelSplit0_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_labelSplit0 := list_node_output_labelSplit0 _ [[]];
	create_ms_moved("<", create_id_node("labelSplit0_#0"))		{color => COLOR_COMPUTE;};
    create_mscr_move("<", 2);

	add_meta_signal(create_id_node("labelSplit1_#0"), 0)	{color => COLOR_COMPUTE;};
	list_node_output_labelSplit1 := list_node_output_labelSplit1 _ [[]];
                   
        
	////collision rules (second pass)
	//internal rules and half rules

	list_node_output_Init[0] := [create_id_node("Init_#0"), create_id_reset("accu")];

	list_node_output_Init[1] := [create_id_node("Init_#1"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Init_#1"), create_id_return("v")] --> [create_id_node_aux("Init_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Init_#1"), create_id_return("z")] --> [create_id_node("Init_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Init_#1"), create_id_return("z")] --> [create_id_node_aux("Init_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Init_#1"), create_id_return("v")] --> [create_id_node("Init_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_Init[2] := [create_id_node("Init_#2"), create_id_move_init_n(">", 2)];

	[create_id_move(">", "fast"), create_id_node("Init_#2")] --> [create_id_moved(">", create_id_node("Init_#2")), create_id_move(">", "fast")];
	[create_id_moved(">", create_id_node("Init_#2")), create_id_move(">", "fast")] --> [create_id_move(">", "fast"), create_id_node("Init_#2")];

	list_node_output_Left[0] := [create_id_node("Left_#0"), create_id_move_init_n(">", 1)];

	[create_id_move(">", "fast"), create_id_node("Left_#0")] --> [create_id_moved(">", create_id_node("Left_#0")), create_id_move(">", "fast")];
	[create_id_moved(">", create_id_node("Left_#0")), create_id_move(">", "fast")] --> [create_id_move(">", "fast"), create_id_node("Left_#0")];

	list_node_output_Left[1] := [create_id_node("Left_#1"), create_id_reset("accu")];

	list_node_output_Left[2] := [create_id_node("Left_#2"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#2"), create_id_return("v")] --> [create_id_node_aux("Left_#2"), create_id_add("accu", 0)];
	[create_id_node_aux("Left_#2"), create_id_return("z")] --> [create_id_node("Left_#2"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#2"), create_id_return("z")] --> [create_id_node_aux("Left_#2"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Left_#2"), create_id_return("v")] --> [create_id_node("Left_#2"), create_id_sub("accu", "top", 0)];

	list_node_output_Left[3] := [create_id_node("Left_#3"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#3"), create_id_return("v")] --> [create_id_node_aux("Left_#3"), create_id_add("cell", 0)];
	[create_id_node_aux("Left_#3"), create_id_return("z")] --> [create_id_node("Left_#3"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#3"), create_id_return("z")] --> [create_id_node_aux("Left_#3"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Left_#3"), create_id_return("v")] --> [create_id_node("Left_#3"), create_id_sub("cell", "top", 0)];

	list_node_output_Left[4] := [create_id_node("Left_#4"), create_id_move_init_n(">", 1)];

	[create_id_move(">", "fast"), create_id_node("Left_#4")] --> [create_id_moved(">", create_id_node("Left_#4")), create_id_move(">", "fast")];
	[create_id_moved(">", create_id_node("Left_#4")), create_id_move(">", "fast")] --> [create_id_move(">", "fast"), create_id_node("Left_#4")];

	list_node_output_Left[5] := [create_id_node("Left_#5"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Left_#5"), create_id_return("v")] --> [create_id_node_aux("Left_#5"), create_id_add("cell", 0)];
	[create_id_node_aux("Left_#5"), create_id_return("z")] --> [create_id_node("Left_#5"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Left_#5"), create_id_return("z")] --> [create_id_node_aux("Left_#5"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Left_#5"), create_id_return("v")] --> [create_id_node("Left_#5"), create_id_sub("cell", "top", 0)];

	list_node_output_Left[6] := [create_id_node("Left_#6"), create_id_move_init_n("<", 2)];

	[create_id_move("<", "fast"), create_id_node("Left_#6")] --> [create_id_moved("<", create_id_node("Left_#6")), create_id_move("<", "fast")];
	[create_id_moved("<", create_id_node("Left_#6")), create_id_move("<", "fast")] --> [create_id_move("<", "fast"), create_id_node("Left_#6")];

	list_node_output_Right[0] := [create_id_node("Right_#0"), create_id_move_init_n(">", 2)];

	[create_id_move(">", "fast"), create_id_node("Right_#0")] --> [create_id_moved(">", create_id_node("Right_#0")), create_id_move(">", "fast")];
	[create_id_moved(">", create_id_node("Right_#0")), create_id_move(">", "fast")] --> [create_id_move(">", "fast"), create_id_node("Right_#0")];

	list_node_output_Right[1] := [create_id_node("Right_#1"), create_id_reset("accu")];

	list_node_output_Right[2] := [create_id_node("Right_#2"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#2"), create_id_return("v")] --> [create_id_node_aux("Right_#2"), create_id_add("accu", 0)];
	[create_id_node_aux("Right_#2"), create_id_return("z")] --> [create_id_node("Right_#2"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#2"), create_id_return("z")] --> [create_id_node_aux("Right_#2"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Right_#2"), create_id_return("v")] --> [create_id_node("Right_#2"), create_id_sub("accu", "top", 0)];

	list_node_output_Right[3] := [create_id_node("Right_#3"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#3"), create_id_return("v")] --> [create_id_node_aux("Right_#3"), create_id_add("cell", 0)];
	[create_id_node_aux("Right_#3"), create_id_return("z")] --> [create_id_node("Right_#3"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#3"), create_id_return("z")] --> [create_id_node_aux("Right_#3"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Right_#3"), create_id_return("v")] --> [create_id_node("Right_#3"), create_id_sub("cell", "top", 0)];

	list_node_output_Right[4] := [create_id_node("Right_#4"), create_id_move_init_n("<", 1)];

	[create_id_move("<", "fast"), create_id_node("Right_#4")] --> [create_id_moved("<", create_id_node("Right_#4")), create_id_move("<", "fast")];
	[create_id_moved("<", create_id_node("Right_#4")), create_id_move("<", "fast")] --> [create_id_move("<", "fast"), create_id_node("Right_#4")];

	list_node_output_Right[5] := [create_id_node("Right_#5"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Right_#5"), create_id_return("v")] --> [create_id_node_aux("Right_#5"), create_id_add("cell", 0)];
	[create_id_node_aux("Right_#5"), create_id_return("z")] --> [create_id_node("Right_#5"), create_id_add("cell", 0)];
	//get result negative (z received before v)
	[create_id_node("Right_#5"), create_id_return("z")] --> [create_id_node_aux("Right_#5"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Right_#5"), create_id_return("v")] --> [create_id_node("Right_#5"), create_id_sub("cell", "top", 0)];

	list_node_output_Right[6] := [create_id_node("Right_#6"), create_id_move_init_n("<", 1)];

	[create_id_move("<", "fast"), create_id_node("Right_#6")] --> [create_id_moved("<", create_id_node("Right_#6")), create_id_move("<", "fast")];
	[create_id_moved("<", create_id_node("Right_#6")), create_id_move("<", "fast")] --> [create_id_move("<", "fast"), create_id_node("Right_#6")];

	list_node_output_Up[0] := [create_id_node("Up_#0"), create_id_reset("accu")];

	list_node_output_Up[1] := [create_id_node("Up_#1"), create_id_get (1, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Up_#1"), create_id_return("v")] --> [create_id_node_aux("Up_#1"), create_id_add("accu", 0)];
	[create_id_node_aux("Up_#1"), create_id_return("z")] --> [create_id_node("Up_#1"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Up_#1"), create_id_return("z")] --> [create_id_node_aux("Up_#1"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Up_#1"), create_id_return("v")] --> [create_id_node("Up_#1"), create_id_sub("accu", "top", 0)];

	list_node_output_Up[2] := [create_id_node("Up_#2"), create_id_move_init_n(">", 1)];

	[create_id_move(">", "fast"), create_id_node("Up_#2")] --> [create_id_moved(">", create_id_node("Up_#2")), create_id_move(">", "fast")];
	[create_id_moved(">", create_id_node("Up_#2")), create_id_move(">", "fast")] --> [create_id_move(">", "fast"), create_id_node("Up_#2")];

	list_node_output_Up[3] := [create_id_node("Up_#3"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Up_#3"), create_id_return("v")] --> [create_id_node_aux("Up_#3"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Up_#3"), create_id_return("z")] --> [create_id_node("Up_#3"), create_id_sub("cell", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Up_#3"), create_id_return("z")] --> [create_id_node_aux("Up_#3"), create_id_add("cell", 0)];
	[create_id_node_aux("Up_#3"), create_id_return("v")] --> [create_id_node("Up_#3"), create_id_add("cell", 0)];

	list_node_output_Up[4] := [create_id_node("Up_#4"), create_id_move_init_n(">", 1)];

	[create_id_move(">", "fast"), create_id_node("Up_#4")] --> [create_id_moved(">", create_id_node("Up_#4")), create_id_move(">", "fast")];
	[create_id_moved(">", create_id_node("Up_#4")), create_id_move(">", "fast")] --> [create_id_move(">", "fast"), create_id_node("Up_#4")];

	list_node_output_Up[5] := [create_id_node("Up_#5"), create_id_get (1, "accu", 0)];

	//get result positive (v received before z)
	[create_id_node("Up_#5"), create_id_return("v")] --> [create_id_node_aux("Up_#5"), create_id_sub("cell", "bot", 0)];
	[create_id_node_aux("Up_#5"), create_id_return("z")] --> [create_id_node("Up_#5"), create_id_sub("cell", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Up_#5"), create_id_return("z")] --> [create_id_node_aux("Up_#5"), create_id_add("cell", 0)];
	[create_id_node_aux("Up_#5"), create_id_return("v")] --> [create_id_node("Up_#5"), create_id_add("cell", 0)];

	list_node_output_test[0] := [create_id_node("test_#0"), create_id_get (1/2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("test_#0"), create_id_return("v")] --> [create_id_node_aux("test_#0"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("test_#0"), create_id_return("z")] --> [create_id_node("test_#0"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("test_#0"), create_id_return("z")] --> [create_id_node_aux("test_#0"), create_id_add("accu", 0)];
	[create_id_node_aux("test_#0"), create_id_return("v")] --> [create_id_node("test_#0"), create_id_add("accu", 0)];

	list_node_output_test[1] := [create_id_node("test_#1"), "branch"];

	list_node_output_Next[0] := [create_id_node("Next_#0"), create_id_get (1/2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Next_#0"), create_id_return("v")] --> [create_id_node_aux("Next_#0"), create_id_add("accu", 0)];
	[create_id_node_aux("Next_#0"), create_id_return("z")] --> [create_id_node("Next_#0"), create_id_add("accu", 0)];
	//get result negative (z received before v)
	[create_id_node("Next_#0"), create_id_return("z")] --> [create_id_node_aux("Next_#0"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Next_#0"), create_id_return("v")] --> [create_id_node("Next_#0"), create_id_sub("accu", "top", 0)];

	list_node_output_Next[1] := [create_id_node("Next_#1"), create_id_move_init_n("<", 1)];

	[create_id_move("<", "fast"), create_id_node("Next_#1")] --> [create_id_moved("<", create_id_node("Next_#1")), create_id_move("<", "fast")];
	[create_id_moved("<", create_id_node("Next_#1")), create_id_move("<", "fast")] --> [create_id_move("<", "fast"), create_id_node("Next_#1")];

	list_node_output_Next[2] := [create_id_node("Next_#2"), create_id_get (1/2, "cell", 0)];

	//get result positive (v received before z)
	[create_id_node("Next_#2"), create_id_return("v")] --> [create_id_node_aux("Next_#2"), create_id_sub("accu", "bot", 0)];
	[create_id_node_aux("Next_#2"), create_id_return("z")] --> [create_id_node("Next_#2"), create_id_sub("accu", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("Next_#2"), create_id_return("z")] --> [create_id_node_aux("Next_#2"), create_id_add("accu", 0)];
	[create_id_node_aux("Next_#2"), create_id_return("v")] --> [create_id_node("Next_#2"), create_id_add("accu", 0)];

	list_node_output_Next[3] := [create_id_node("Next_#3"), create_id_move_init_n("<", 1)];

	[create_id_move("<", "fast"), create_id_node("Next_#3")] --> [create_id_moved("<", create_id_node("Next_#3")), create_id_move("<", "fast")];
	[create_id_moved("<", create_id_node("Next_#3")), create_id_move("<", "fast")] --> [create_id_move("<", "fast"), create_id_node("Next_#3")];

	list_node_output_Next[4] := [create_id_node("Next_#4"), "branch"];

	list_node_output_labelDelay[0] := [create_id_node("labelDelay_#0"), create_id_reset("accu")];

	list_node_output_labelDelay[1] := [create_id_node("labelDelay_#1"), create_id_ubt ("delay")];

	list_node_output_labelSplit0[0] := [create_id_node("labelSplit0_#0"), create_id_move_init_n("<", 2)];

	[create_id_move("<", "fast"), create_id_node("labelSplit0_#0")] --> [create_id_moved("<", create_id_node("labelSplit0_#0")), create_id_move("<", "fast")];
	[create_id_moved("<", create_id_node("labelSplit0_#0")), create_id_move("<", "fast")] --> [create_id_move("<", "fast"), create_id_node("labelSplit0_#0")];

	list_node_output_labelSplit1[0] := [create_id_node("labelSplit1_#0"), create_id_ubt ("split")];

	//internodes rules
	//two lists of partial collision rules lacking an input MS defined by the ubt library.
	list_cr_delay := [];
	list_cr_split := [];

	[create_id_node("Init_#0"), create_id_return("")] --> list_node_output_Init[1];
	[create_id_node("Init_#1"), create_id_return("")] --> list_node_output_Init[2];
	[create_id_node("Init_#2"), create_id_return("")] --> list_node_output_test[0];
	[create_id_node("Left_#0"), create_id_return("")] --> list_node_output_Left[1];
	[create_id_node("Left_#1"), create_id_return("")] --> list_node_output_Left[2];
	[create_id_node("Left_#2"), create_id_return("")] --> list_node_output_Left[3];
	[create_id_node("Left_#3"), create_id_return("")] --> list_node_output_Left[4];
	[create_id_node("Left_#4"), create_id_return("")] --> list_node_output_Left[5];
	[create_id_node("Left_#5"), create_id_return("")] --> list_node_output_Left[6];
	[create_id_node("Left_#6"), create_id_return("")] --> list_node_output_Up[0];
	[create_id_node("Right_#0"), create_id_return("")] --> list_node_output_Right[1];
	[create_id_node("Right_#1"), create_id_return("")] --> list_node_output_Right[2];
	[create_id_node("Right_#2"), create_id_return("")] --> list_node_output_Right[3];
	[create_id_node("Right_#3"), create_id_return("")] --> list_node_output_Right[4];
	[create_id_node("Right_#4"), create_id_return("")] --> list_node_output_Right[5];
	[create_id_node("Right_#5"), create_id_return("")] --> list_node_output_Right[6];
	[create_id_node("Right_#6"), create_id_return("")] --> list_node_output_Up[0];
	[create_id_node("Up_#0"), create_id_return("")] --> list_node_output_Up[1];
	[create_id_node("Up_#1"), create_id_return("")] --> list_node_output_Up[2];
	[create_id_node("Up_#2"), create_id_return("")] --> list_node_output_Up[3];
	[create_id_node("Up_#3"), create_id_return("")] --> list_node_output_Up[4];
	[create_id_node("Up_#4"), create_id_return("")] --> list_node_output_Up[5];
	[create_id_node("Up_#5"), create_id_return("")] --> list_node_output_test[0];
	[create_id_node("test_#0"), create_id_return("")] --> list_node_output_test[1];

	[create_id_node("test_#1"), create_id_return("lt")] --> list_node_output_Next[0];
	[create_id_node("test_#1"), create_id_return("eq")] --> list_node_output_Next[0];
	[create_id_node("test_#1"), create_id_return("gt")] --> list_node_output_labelSplit0[0];

	[create_id_node("Next_#0"), create_id_return("")] --> list_node_output_Next[1];
	[create_id_node("Next_#1"), create_id_return("")] --> list_node_output_Next[2];
	[create_id_node("Next_#2"), create_id_return("")] --> list_node_output_Next[3];
	[create_id_node("Next_#3"), create_id_return("")] --> list_node_output_Next[4];

	[create_id_node("Next_#4"), create_id_return("lt")] --> list_node_output_labelDelay[0];
	[create_id_node("Next_#4"), create_id_return("eq")] --> list_node_output_labelDelay[0];
	[create_id_node("Next_#4"), create_id_return("gt")] --> list_node_output_labelSplit1[0];

	[create_id_node("labelDelay_#0"), create_id_return("")] --> list_node_output_labelDelay[1];
	list_cr_delay := list_cr_delay _ [[[create_id_node("labelDelay_#1")],
                                list_node_output_Up[0]]];
	[create_id_node("labelSplit0_#0"), create_id_return("")] --> list_node_output_labelSplit1[0];
	list_cr_split := list_cr_split _ [[[create_id_node("labelSplit1_#0")],
                                list_node_output_Left[0],
                                list_node_output_Right[0]]];
};
