#The run compiler

from lbssAGCConfiguration import fun_to_AGC_configuration
from lbssAGCMachine import fun_to_AGC_machine
from lbssFileref import AGCMachineFileref, AGCFileref
from lbssIO import agc_open as open
import lbssIO as io

from fractions import Fraction

from lbssMachine import createID
from lbssMachine import splitID
from lbssMachine import ensureID
#to know the default ID createID()

def fun_to_AGC_ubt (machine, config, destination, pdfDestination = "lbssagc_out.pdf", ubt_depth = 7, initialNodeID = createID(), nb_steps = -1, Cdist = 50, scale = Fraction(1,3)):
    '''
        Creates an AGC file, ready to run, that simulates a given machine form a given configuration.
    '''
    machine = machine if isinstance(machine, AGCMachineFileref) else fun_to_AGC_machine(machine, ".anonymous_machine.agc", "anonymous_machine")
    config = config if isinstance(config, AGCFileref) else fun_to_AGC_configuration(config, ".anonymous_config.agc")
    scale = Fraction(scale)
    Cdist = Fraction(Cdist)
    if Cdist <= 0:
        Cdist = 50
    nb_steps = Fraction(nb_steps)
    if nb_steps < 0:
        nb_steps = 100000
    #TODO: Cratio, Cdist
    #TODO: CTime
    
    Ctime_Cell = machine.size# if Ctime_Cell == 0 else Fraction(Ctime_Cell)
    Ctime_Cell = max (Ctime_Cell, 2)
    
    initialNodeID = ensureID(initialNodeID)
    label, n = splitID(initialNodeID)
    
    with open(destination, "w") as file:
        file.write('''///////******This file has been automatically generated******//////
/*
Your edits are overwritten whenever this file is regenerated.

This file links a lbss signal machine.

To generate, put:
toAGC_ubt {filename_machine} {filename_config} {self_filename}
in a .lbss file and run it with lbss.py

usage:
java -jar agc_2_0.jar {self_filename}
*/

NB_STEPS .= {nb_steps};
SCALE .= {scale};
use AGC ;

load "{lib_agc_arith}";

{ubt_machine_name} .= create_signal_machine()
{{
	UBT_DEPTH := {ubt_depth};
	load "{lib_agc_sub_machine}";
	load "{lib_agc_ubt}";
	load "{filename_machine}";
}};

{lbss_conf_name} .= {ubt_machine_name}.{lbss_machine_name}.create_configuration_tape({Cdist}, {MaxR});

{lbss_conf_name}.{{
	load "{filename_config}";
    //TODO: remove epsilon once get_metasignal_list is fixed.
    epsilon := {epsilon};
	foreach(s:list_node_output_{label}[{pos_label}])
		s @ program_position + epsilon * get_meta_signal(s).speed;

	add_clock({Ctime_Cell}, {Ctime_Tape});
}};

{ubt_machine_name}.{{incorporate_lbss_machine({lbss_machine_name}, "");}}; // needs to be after clock intitialisation
c .= {ubt_machine_name}.create_configuration_full({lbss_machine_name}, {lbss_conf_name}, "");
    
r .= c.run();
r.step(NB_STEPS);

r.export ("PDF","{filename_dest}",{{
	scale := SCALE;
	}}
);
'''
        .format(filename_machine = io.join(io.path_agc, machine.filename),
                filename_config = io.join(io.path_agc, config.filename),
                self_filename = io.join(io.path_agc, destination),
                lib_agc_arith = io.join(io.path_libagc, io.lib_agc_arith),
                lib_agc_sub_machine = io.join(io.path_libagc, io.lib_agc_sub_machine),
                lib_agc_ubt = io.join(io.path_libagc, io.lib_agc_ubt),
                nb_steps = nb_steps,
                scale = scale,
                lbss_machine_name = machine.machinename,
                ubt_machine_name = "ubt_machine",
                lbss_conf_name = "lbss_conf",
                #init_Node_ID = initialNodeID,
                #TODO: adjust the values for Cdist and Cratio
                Cdist = Cdist,
                Ctime_Cell = Ctime_Cell,
                Ctime_Tape = 0,
                MaxR = max(machine.MaxCTE, config.MaxValue),
                label = label,
                pos_label = n,
                ubt_depth = ubt_depth,
                filename_dest = io.join(io.path_pdf, pdfDestination),
                #TODO: remove epsilon once get_metasignal_list is fixed.
                epsilon = Fraction(1,1000)
                )
        )
        
    return AGCFileref(destination, False)