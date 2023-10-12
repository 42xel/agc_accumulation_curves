///////******This file has been automatically generated******//////
/*
Your edits are overwritten whenever this file is regenerated.

This file links a lbss signal machine.

To generate, put:
toAGC_ubt ./agc/.anonymous_machine.agc ./agc/.anonymous_config.agc ./agc/parabola.agc
in a .lbss file and run it with lbss.py

usage:
java -jar agc_2_0.jar ./agc/parabola.agc
*/

NB_STEPS .= 1000000;
SCALE .= 1/3;
use AGC ;

load "../../lib_agc/arith.agc";

ubt_machine .= create_signal_machine()
{
	UBT_DEPTH := 8;
	load "../../lib_agc/sub_machine.agc";
	load "../../lib_agc/lib_ubt_sm.agc";
	load "./agc/.anonymous_machine.agc";
};

lbss_conf .= ubt_machine.anonymous_machine.create_configuration_tape(50, 6);

lbss_conf.{
	load "./agc/.anonymous_config.agc";
    //TODO: remove epsilon once get_metasignal_list is fixed.
    epsilon := 1/1000;
	foreach(s:list_node_output_Init[0])
		s @ program_position + epsilon * get_meta_signal(s).speed;

	add_clock(80, 0);
};

ubt_machine.{incorporate_lbss_machine(anonymous_machine, "");}; // needs to be after clock intitialisation
c .= ubt_machine.create_configuration_full(anonymous_machine, lbss_conf, "");
    
r .= c.run();
r.step(NB_STEPS);

r.export ("PDF","./pdf/parabola.pdf",{
	scale := SCALE;
	}
);
