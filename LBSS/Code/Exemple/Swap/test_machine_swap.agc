///////******This file has been automatically generated******//////
/*
Your edits are overwritten whenever this file is regenerated.

This file links a lbss signal machine.

To generate, put:
toAGC_run machine_swap.agc configuration_swap.agc test_machine_swap.agc
in a .lbss file and run it with lbss.py

usage:
java -jar agc_2_0.jar test_machine_swap.agc
*/

NB_STEPS .= 10000;
SCALE .= 1/3;
use AGC ;

load "machine_swap.agc";

c := machine_swap.create_configuration_tape(50, 6);

c.{
	load "configuration_swap.agc";;
    
	foreach(s:list_node_output_[0])
		s @ program_position;
	add_clock(22, 0);
};

r .= c.run();
r.step(NB_STEPS);

r.export ("PDF","test_machine_swap.pdf",{
	scale := SCALE;
	}
);
