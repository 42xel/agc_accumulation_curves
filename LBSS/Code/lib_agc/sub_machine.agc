//A libray providing basic way to incorporate a machine or a configuration as a submachine or configuration of another.

//exemple usage :
/*
load "arith.agc";

my_big_machine .= create_signal_machine
{
	load "sub_machine.agc";
};

my_small_machine .= create_signal_machine
{
	//machine defintion
};

my_big_machine.incorporate_machine_fun(my_small_machine, alter_id, alter_speed);

*/
//it will define functions where it is called/used.

//
if (DEF_agclib_arith == undef){
	println("ERROR: module sub_machine.agc requires module arith to be loaded.");
};

create_fun_create_id .= (prefix, suffix) ->
	((base) -> prefix _ base _ suffix);

create_map .= (initSegment, targetSegment) ->
	((s) -> CREATE_FUNCTION_BAR(targetSegment[0], targetSegment[1])(CREATE_FUNCTION_INV_BAR(initSegment[0], initSegment[1])(s)));

incorporate_machine_fun .= (subMachine, alter_id, alter_speed) ->
{//most general function to incorporate the sub-machine "subMachine" into the machine where sub_machine.agc is loaded
//ideally, submachine.agc isn't loaded inside a machine and this function incorporates into the machine from where it is called
//see ?-->
	foreach(ms:subMachine.get_meta_signal_list())
	{
		//add_meta_signal(alter_id(ms.id), alter_speed(ms.speed));
		mslStyle := ms.get("line_style");
		//println(mslStyle);
		mscolor := ms.get("color");
		//println(mscolor);
		//?add_meta_signal(alter_id(ms.id), alter_speed(ms.speed));
		?add_meta_signal(alter_id(ms.id), alter_speed(ms.speed)) {color => mscolor; line_style => mslStyle;};
		//println("adding: " _ alter_id(ms.id));
//see ?--> : necessary for cleaner use, works either way.
	};

	foreach(cr:subMachine.get_rule_list())
	{
		newcrin := [];
		foreach(ms:cr.in)
		{
			newcrin := newcrin _ [alter_id(ms.id)];
		};
		newcrout := [];
		foreach(ms:cr.out)
		{
			newcrout := newcrout _ [alter_id(ms.id)];
		};

		newcrin --> newcrout;
		//newcrin ?--> newcrout;
//Would lead to cleaner use but does not work
	};
};

incorporate_configuration_fun .= (subConfiguration, alter_id, alter_position) ->
{//most general function to incorporate the sub-configuration "subConfiguration" into the configuration from where this funciton is called
	foreach(sig:subConfiguration.get_signal_list)
	{
		if (sig.birth_date != 0)
		{
		//sig.birth_date is assumed to be 0
			println("ERROR, signal birthdate is supposed to be null");
		};
		alter_id(sig.meta_signal.id) ?@ alter_position(sig.birth_position);
	};
};

/*
incorporate_machine_str_aff .= (subMachine, prefix, suffix, mul_const, add_const) ->
{//function to incorporates the sub-machine "subMachine" into the machine where sub_machine.agc is loaded
	:= incorporate_machine_fun(subMachine, create_fun_create_id (prefix, suffix), (s) -> mul_const * s + add_const);	
};

incorporate_configuration_str_aff .= (subConfiguration, prefix, suffix, mul_const, add_const) ->
{//function to incorporate the sub-configuration "subConfiguration" into the configuration from where this funciton is called
	:= incorporate_configuration_fun(subConfiguration, create_fun_create_id (prefix, suffix), (s) -> mul_const * s + add_const);	
};

incorporate_configuration_str_bar .= (subConfiguration, prefix, suffix, subConfSegment, targetSegment) ->
{//function to incorporate the sub-configuration "subConfiguration" into the configuration from where this funciton is called
	:= incorporate_configuration_fun(subConfiguration, create_fun_create_id (prefix, suffix), create_map(subConfSegment, targetSegment));	
};

incorporate_configuration_fun_bar .= (subConfiguration, alter_id, subConfSegment, targetSegment) ->
{//function to incorporate the sub-configuration "subConfiguration" into the configuration from where this funciton is called
	incorporate_configuration_fun(subConfiguration, alter_id, create_map(subConfSegment, targetSegment));
};
//does not work for environement reasons
*/

