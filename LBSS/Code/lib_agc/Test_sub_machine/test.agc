//
//a File for testing sub_machine.agc

use AGC;

load "../arith.agc";

machine_zigzag .= create_signal_machine
{
	zig .= add_meta_signal("zig", 3)		{color => "Red"; line_style => "densely dotted";};
	zag .= add_meta_signal("zag", -3)		{color => "Blue"; line_style => "densely dotted";};
	border_right .= add_meta_signal("br", 1/2)	{color => "impossiblium"; line_style => "not recognized";};
//	border_left .= add_meta_signal("bl", -1/2)	{color => "impossiblium"; line_style => "not recognized";};
	border_left .= add_meta_signal("bl", -1/2)	;	//errors!
	
	[zig, border_left] --> [border_left, zag];
	[zag, border_right] --> [border_right, zig];
};
if(false)
{
	foreach(ms:machine_zigzag.get_meta_signal_list())
	{
		println(ms);
		println(ms.id);
		println(ms.speed);
	//	println(ms.get);
	//NullPointerException: TODO ask about it
	//	println(ms.get("color"));
	//	println(ms.get("linestyle"));
		println();
	};
	foreach(cr:machine_zigzag.get_rule_list())
	{
		println(cr);
		println(cr.in);
		println(cr.out);
		println();
	};
};

conf_zigzag .= machine_zigzag.create_configuration
{
	"br" @ -10;
	"bl" @ 10;
	"zig" @ 0;
};

if(false)
{
foreach(sig:conf_zigzag.get_signal_list)
{
	println(sig);
	println(sig.meta_signal);
	println(sig.birth_date);
	println(sig.birth_position);
	println();
};
};

run_zigzag .= conf_zigzag.run();

run_zigzag.step(50);
//run_zigzag.step(358);
//TODO investigate 359;
run_zigzag.export( "PDF" , "zigzag" , {} ) ;
//println(run_zigzag.get_signal_list);
//TODO, ask how to query run, if at all possible.
//println(conf_zigzag.get_signal_list);

zagzig_alter_id .= (id) -> "pre_" _ id _ "_suff";

machine_zagzig .= create_signal_machine
{
	load "../sub_machine.agc";
	incorporate_machine_fun(machine_zigzag, zagzig_alter_id, (s) -> -s + 1/2);
};

if(false)
{
	foreach(ms:machine_zagzig.get_meta_signal_list())
	{
		println(ms);
	};
	println();
	foreach(cr:machine_zagzig.get_rule_list())
	{
		println(cr);
	};
	println();
};


conf_zagzig .= machine_zagzig.create_configuration
{
	machine_zagzig.incorporate_configuration_fun(conf_zigzag, zagzig_alter_id, machine_zagzig.create_map([-10, 10], [110, 90]) );
};

if(false)
{
	foreach(sig:conf_zagzig.get_signal_list)
	{
		println(sig);
	};
	println();
};

run_zagzig .= conf_zagzig.run();

run_zagzig.step(50);
run_zagzig.export( "PDF" , "zagzig" , {} ) ;
