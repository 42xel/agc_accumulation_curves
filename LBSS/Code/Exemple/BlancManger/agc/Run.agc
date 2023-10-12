///////******This file has been automatically generated******//////
/*
Your edits are overwritten whenever this file is regenerated.

This file links a lbss signal machine.

To generate, put:
toAGC_run ./agc/.anonymous_machine.agc ./agc/.anonymous_config.agc ./agc/Run.agc
in a .lbss file and run it with lbss.py

usage:
java -jar agc_2_0.jar ./agc/Run.agc
*/

NB_STEPS .= 1000;
SCALE .= 1/3;
use AGC ;

load "./agc/.anonymous_machine.agc";

c := anonymous_machine.create_configuration_tape(50, 12);

c.{
	load "./agc/.anonymous_config.agc";
    
	foreach(s:list_node_output_Left[0])
		s @ program_position;
	add_clock(2, 0);
};

r .= c.run();
r.step(NB_STEPS);

r.export ("PDF","./pdf/Run.pdf",{
	scale := SCALE;
	}
);
