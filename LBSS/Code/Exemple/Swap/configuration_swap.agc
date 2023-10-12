///////******This file has been automatically generated******//////
/*
for you own sake, do not edit (you're likely to be overwritten).

This file contains the definition of a Tape configuration.
To generate, use toAGC_machine in a .lbss file and run it with lbss.py

usage (for comprehension purpose):
myConfiguration.{
	load "configuration_swap.agc";
};
where myConfiguration is a configuration genereated by using the machine method create_configuration_tape as provided by lib_lbss_sm.agc
*/

add_left_margin(MaxMove);

foreach(v:[0])
	add_cell(v);
add_accu_cell(3, 3/5);
foreach(v:[-7])
	add_cell(v);

add_right_margin(MaxMove);
