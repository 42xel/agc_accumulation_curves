#The configuration compilers
#not directely used since also depends on mahcine, but used by toAGC_run

from lbssFileref import AGCConfigFileref
from lbssIO import agc_open as open

from fractions import Fraction

def fun_to_AGC_configuration(config, destination):
    sourceTape = config['x']
    accu = 0 if 'a' not in config else config['a']
    MaxValue = max(i for i in sourceTape[sourceTape.start():sourceTape.stop()])
    MaxValue = max(MaxValue, Fraction(accu), 6)
#FRIDGE: remove accu, add it to run instead (for both the compiler and the interpreter, in both the .py and the .agc), and test
    with open(destination, "w") as file:
        file.write('''///////******This file has been automatically generated******//////
/*
for you own sake, do not edit (you're likely to be overwritten).

This file contains the definition of a Tape configuration.
To generate, use toAGC_machine in a .lbss file and run it with lbss.py

usage (for comprehension purpose):
myConfiguration.{{
	load "{self_FileName}";
}};
where myConfiguration is a configuration genereated by using the machine method create_configuration_tape as provided by lib_lbss_sm.agc
*/

add_left_margin(MaxMove);

foreach(v:[{neg_tape}])
	add_cell(v);
add_accu_cell({accu}, {current});
foreach(v:[{pos_tape}])
	add_cell(v);

add_right_margin(MaxMove);
'''
           .format(self_FileName = destination,
                   neg_tape = ", ".join([str(i) for i in sourceTape[sourceTape.start():sourceTape.center]]),
                   pos_tape = ", ".join([str(i) for i in sourceTape[sourceTape.center + 1: sourceTape.stop()]]),
                   accu = accu,
                   current = sourceTape.read()
           )
        )
    return AGCConfigFileref(destination, MaxValue, False)