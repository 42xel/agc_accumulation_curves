///////******This file has been automatically generated******//////
/*
Your edits are overwritten whenever this file is regenerated.

This file links a lbss signal machine.

To generate, put:
toAGC_run ./agc/.anonymous_machine.agc ./agc/.anonymous_config.agc ./agc/lbss_slanted.agc
in a .lbss file and run it with lbss.py

usage:
java -jar agc_2_0.jar ./agc/lbss_slanted.agc
*/

NB_STEPS .= 10000;
SCALE .= 1/3;
use AGC ;

load "./agc/.anonymous_machine.agc";

c := anonymous_machine.create_configuration_tape(10, 3);

c.{
	load "./agc/.anonymous_config.agc";
	foreach(s:list_node_output_[0])
		s @ program_position;
};

r .= c.run();
r.step(NB_STEPS);

r.export ("PDF","./pdf/lbss_slanted.pdf",{
	scale := SCALE;
	}
);
