//
//a File for testing sub_machine.agc

use AGC;

load "../arith.agc";

machine_zigzag .= create_signal_machine
{
	zig .= add_meta_signal("zig", 3)		{color => "Red"; line_style => "densely dotted";};
	zag .= add_meta_signal("zag", -3)		{color => "Blue"; line_style => "densely dotted";};
	border_right .= add_meta_signal("br", 1/2)	{color => "impossiblium"; line_style => "not recognized";};
	border_left .= add_meta_signal("bl", -1/2)	{color => "impossiblium"; line_style => "not recognized";};
//	border_left .= add_meta_signal("bl", -1/2)	;	//errors!
	
	[zig, border_left] --> [border_left, zag];
	[zag, border_right] --> [border_right, zig];
};

conf_zigzag .= machine_zigzag.create_configuration
{
	"br" @ 0;
	"bl" @ 0;
	"zig" @ 0;
};

run_zigzag .= conf_zigzag.run();

run_zigzag.step(50);
//run_zigzag.step(358);
//TODO investigate 359;
run_zigzag.export( "PDF" , "dummy" , {} ) ;

foreach(sig:conf_zigzag.get_signal_list)
{
	println(sig); //only zig is printed!

};

conf_zigzag2 .= machine_zigzag.create_configuration
{
//	["br", "bl"] @ 0;	//errors
};

foreach(sig:conf_zigzag2.get_signal_list)
{
	println(sig); //only zig is printed!

};
