#The run compiler

from lbssAGCConfiguration import fun_to_AGC_configuration
from lbssAGCMachine import fun_to_AGC_machine
from lbssFileref import AGCMachineFileref, AGCConfigFileref, AGCFileref
from lbssIO import agc_open as open
import lbssIO

from fractions import Fraction

from lbssMachine import createID
from lbssMachine import splitID
from lbssMachine import ensureID
#to know the default ID createID()

def fun_to_AGC_run (machine, config, destination, pdfDestination = "lbssagc_out.pdf", initialNodeID = createID(), Ctime_Cell = 0, nb_steps = -1, Cdist = 50, scale = Fraction(1,3)):
    '''
        Creates an AGC file, ready to run, that draws a unary binary tree given machine and a given initial configuration.
        machine: the machine to perform the run with, as an AGC file or a machine object
        config: the initial tape to perform the run on, as an AGC file or a configuration object
        destination: the name of the agc file to run
        pdfDestination: the destination of the pdf later to be created by the agc file produced
        initialNodeID: the initial node of the machine from which to start the computation (defaults to the first node defined)
        Ctime_Cell: the time, roughly in number of basic operations, to elapse before the tape is halved so as to ensure the total computation time is finite
        nb_steps: the number of agc collisions to simulate up to
        Cdist: the width of a cell
        scale: the scale of the final render.
    '''
#TODO consider Tape_width instead of Cdist.
    machine = machine if isinstance(machine, AGCMachineFileref) else fun_to_AGC_machine(machine, ".anonymous_machine.agc", "anonymous_machine")
    config = config if isinstance(config, AGCConfigFileref) else fun_to_AGC_configuration(config, ".anonymous_config.agc")
    scale = Fraction(scale)
    Cdist = Fraction(Cdist)
    if Cdist <= 0:
        Cdist = 50
    nb_steps = Fraction(nb_steps)
    if nb_steps < 0:
        nb_steps = 10000
    
    Ctime_Cell = Fraction(Ctime_Cell)
    Ctime_Cell = machine.size if Ctime_Cell == 0 else Fraction(Ctime_Cell)
    Ctime_Cell = max (Ctime_Cell, 2)
            
    initialNodeID = ensureID(initialNodeID)
    label, n = splitID(initialNodeID)
    with open(destination, "w") as file:
        file.write('''///////******This file has been automatically generated******//////
/*
Your edits are overwritten whenever this file is regenerated.

This file links a lbss signal machine.

To generate, put:
toAGC_run {filename_machine} {filename_config} {self_filename}
in a .lbss file and run it with lbss.py

usage:
java -jar agc_2_0.jar {self_filename}
*/

NB_STEPS .= {nb_steps};
SCALE .= {scale};
use AGC ;

load "{filename_machine}";

c := {machine_name}.create_configuration_tape({Cdist}, {MaxR});

c.{{
	load "{filename_config}";
    
	foreach(s:list_node_output_{label}[{pos_label}])
		s @ program_position;
	add_clock({Ctime_Cell}, {Ctime_Tape});
}};

r .= c.run();
r.step(NB_STEPS);

r.export ("PDF","{filename_dest}",{{
	scale := SCALE;
	}}
);
'''
#TODO: releveance of Ctime_Tape? remove?
        .format(filename_machine = lbssIO.join(lbssIO.path_agc, machine.filename),
                filename_config = lbssIO.join(lbssIO.path_agc, config.filename),
                self_filename = lbssIO.join(lbssIO.path_agc, destination),
                nb_steps = nb_steps,
                scale = scale,
                machine_name = machine.machinename,
                #TODO: adjust the values for Cdist and Cratio
                Cdist = Cdist,
                MaxR = 2 * max(machine.MaxCTE, config.MaxValue),
                label = label,
                pos_label = n,
                Ctime_Cell = Ctime_Cell,
                Ctime_Tape = 0,# Fraction(1,2),
                filename_dest = lbssIO.join(lbssIO.path_pdf, pdfDestination)
                )
        )
        
    return AGCFileref(destination, False)