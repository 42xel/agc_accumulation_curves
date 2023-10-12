#The machine compilers
#creates an agc file that defines a signal machine

from lbssMachine import splitID
from lbssFileref import AGCMachineFileref
from lbssIO import agc_open as open
import lbssIO as io

from fractions import Fraction

def verbose_ah(x):
    return {'u': "unit", 'a': "accu", 'h': "cell"}[x]
    
def fun_to_AGC_machine(source, destination, name):
    """
    Creates an agc file that defines a signal machine
    source: the machine to create (as a machine object, as created by lbssmachine.py)
    destination: the destination filename
    name: the name of the machine defined
    """
    with open(destination, "w") as file:
        file.write('''///////******This file has been automatically generated******//////
/*
for you own sake, do not edit (you're likely to be overwritten).

This file contains the definition of an lbss signal machine.
To generate, put:
toAGC_machine {name} {self_FileName}
in a .lbss file and run it with lbss.py
{name} must refer to a previously defined machine.

usage (for comprehension purpose):
in an agc file:
    
load "{self_FileName}";

Creates a signal machine named: {name}
To create a configuration, prefer create_configuration_tape to create_configuration
*/
'''
            .format(self_FileName = destination,
                   name = name
            )
        )
            
            
        MaxCTE = 2
        MaxMove = 1
        size = 0
        for _, N in source.items():
            size = size + 1
            if N.value.type == "computation":
                MaxCTE = max(MaxCTE, N.value.constant)
            elif N.value.type == "move":
                MaxMove = max(MaxMove, N.value.move, -N.value.move)
        file.write('''
use AGC;
load "{lib_agc_arith}";
{name} .= create_signal_machine()
{{
	MaxCTE .= {MaxCTE};
	MaxMove .= {MaxMove};
	load "{lib_agc_sm}";
'''
            .format(self_FileName = destination,
                   name = name,
                   MaxCTE = MaxCTE,
                   MaxMove = MaxMove,
                   lib_agc_arith = io.join(io.path_libagc, io.lib_agc_arith),
                   lib_agc_sm = io.join(io.path_libagc, io.lib_agc_sm)
            )
        )
                
            
        file.write('''
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
	
	
	//MS definition (first pass)'''
        )
        
        """first pass to define the metasignal"""
        for ID, N in source.items():
            file.write('''

	create_mscr_node("{}");'''
            .format(ID)
            )
            l, i = splitID(ID)
            #let us add something to store the output half rule for each node
            if i == 0:
                file.write('''
	list_node_output_{} := [[]];'''
                .format(l)
                )
            else:
                file.write('''
	list_node_output_{0} := list_node_output_{0} _ [[]];'''
                .format(l)
                )
            if N.value.type == "move":
                d = '<' if N.value.move < 0 else '>'
#               file.write('''
#	create_ms_moved("{1}", create_id_node("{0}"))		{{color => COLOR_COMPUTE;}};'''
#                .format(ID, d)
 #               )
                n = N.value.move if 0< N.value.move else - N.value.move
                if n > 1:
                    file.write('''
    create_mscr_move("{0}", {1});'''
                        .format(d, n)
                        )
                    
            elif N.value.type == "computation":
                if N.value.token != "=0":
                    file.write('''
	create_mscr_get({}, "{}");'''
                    .format(N.value.constant, verbose_ah(N.value.operand))
                    )
                    file.write('''
	add_meta_signal(create_id_node_aux("{0}"), 0)	{{color => COLOR_COMPUTE;}};'''
                    .format(ID)
                    )
                
        """second pass to determine the half rule of each node (output rule at the beginning of the exe of a node)"""
        file.write('''
                   
        
	////collision rules (second pass)
	//internal rules and half rules
'''
            )
        for ID, N in source.items():
            l, i = splitID(ID)
            if N.value.type == "move":
                r = ', create_id_move_init_n("{}", {})'.format(
                        '<' if N.value.move < 0 else '>', N.value.move if 0 < N.value.move else - N.value.move )
            elif N.value.type == "branch":
                r = ', "branch"'
            elif N.value.type == "computation":
                if N.value.token == "=0":
                    r = ', create_id_reset("{}")'.format(verbose_ah(N.value.recipient))
                else:
                    r = ', create_id_get ({}, "{}", 0)'.format(N.value.constant, verbose_ah(N.value.operand))
                    
            elif N.value.type == "delay" or N.value.type == "split":
                r = ', create_id_ubt ("{}")'.format(N.value.type)
                
            elif N.value.type == "end":
                r = ""
                #TODO see if something else should be returned
            file.write('''
	list_node_output_{0}[{1}] := [create_id_node("{2}"){3}];
'''
                .format(l, i, ID, r)
            )
            
            if N.value.type == "move":
#                        file.write('''
#	[create_id_move("{1}", "fast"), create_id_node("{0}")] --> [create_id_moved("{1}", create_id_node("{0}")), create_id_move("{1}", "fast")];
#	[create_id_moved("{1}", create_id_node("{0}")), create_id_move("{1}", "fast")] --> [create_id_move("{1}", "fast"), create_id_node("{0}")];
#'''
#                            .format(ID, '<' if N.value.move < 0 else '>')
#                        )
                continue
                
            elif N.value.type == "computation":
                #intermediate program collision
                if N.value.token != "=0":
                    if N.value.token == "+=":
                        file.write('''
	//get result positive (v received before z)
	[create_id_node("{0}"), create_id_return("v")] --> [create_id_node_aux("{0}"), create_id_add("{1}", 0)];
	[create_id_node_aux("{0}"), create_id_return("z")] --> [create_id_node("{0}"), create_id_add("{1}", 0)];
	//get result negative (z received before v)
	[create_id_node("{0}"), create_id_return("z")] --> [create_id_node_aux("{0}"), create_id_sub("{1}", "bot", 0)];
	[create_id_node_aux("{0}"), create_id_return("v")] --> [create_id_node("{0}"), create_id_sub("{1}", "top", 0)];
'''
                            .format(ID, verbose_ah(N.value.recipient))
                        )
                        
                    elif N.value.token == "-=":
                        file.write('''
	//get result positive (v received before z)
	[create_id_node("{0}"), create_id_return("v")] --> [create_id_node_aux("{0}"), create_id_sub("{1}", "bot", 0)];
	[create_id_node_aux("{0}"), create_id_return("z")] --> [create_id_node("{0}"), create_id_sub("{1}", "top", 0)];
	//get result negative (z received before v)
	[create_id_node("{0}"), create_id_return("z")] --> [create_id_node_aux("{0}"), create_id_add("{1}", 0)];
	[create_id_node_aux("{0}"), create_id_return("v")] --> [create_id_node("{0}"), create_id_add("{1}", 0)];
'''
                            .format(ID, verbose_ah(N.value.recipient))
                        )
                        
        """third pass to do the plumbing"""
        file.write('''
	//internodes rules
	//two lists of partial collision rules lacking an input MS defined by the ubt library.
	list_cr_delay := [];
	list_cr_split := [];
'''
            )
        for ID, N in source.items():
            l, i = splitID(ID)
            if N.value.type == "branch":
                nl, ni = splitID(N.nextID[0])
                file.write('''

	[create_id_node("{}"), create_id_return("lt")] --> list_node_output_{}[{}];'''
                .format(ID, nl, ni)
                )
                nl, ni = splitID(N.nextID[1])
                file.write('''
	[create_id_node("{}"), create_id_return("eq")] --> list_node_output_{}[{}];'''
                .format(ID, nl, ni)
                )
                nl, ni = splitID(N.nextID[2])
                file.write('''
	[create_id_node("{}"), create_id_return("gt")] --> list_node_output_{}[{}];
'''
                .format(ID, nl, ni)
                )
            elif N.value.type == "end":
                #end nodes should not generate return signals
                pass
            elif N.value.type == "delay":
                nl, ni = splitID(N.nextID[0])
                file.write('''
	list_cr_delay := list_cr_delay _ [[[create_id_node("{}")],
                                list_node_output_{}[{}]]];'''
                .format(ID, nl, ni)
                )
            elif N.value.type == "split":
                nl, ni = splitID(N.nextID[0])
                nl1, ni1 = splitID(N.nextID[1])
                file.write('''
	list_cr_split := list_cr_split _ [[[create_id_node("{}")],
                                list_node_output_{}[{}],
                                list_node_output_{}[{}]]];'''
                .format(ID, nl, ni, nl1, ni1)
                )
            else:
                nl, ni = splitID(N.nextID[0])
                file.write('''
	[create_id_node("{}"), create_id_return("")] --> list_node_output_{}[{}];'''
                .format(ID, nl, ni)
                )
                
        file.write('''
};
'''
        )
    
    return AGCMachineFileref(destination, name, size, MaxCTE, MaxMove, False)