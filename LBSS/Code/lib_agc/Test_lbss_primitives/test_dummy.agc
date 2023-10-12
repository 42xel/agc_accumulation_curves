//various minor test of the gc library, notably error messages

//Usage:
/*
java -jar <agcjar_path>agc_2_0.jar test_dummy.agc 
*/

use AGC;
load "lib_lbss_test.agc";

println("Hello" & "World");
foreach(n:1...3)
{
	println("Hello" _ "World");
	if (true) break;
};

//double use of add_accu_cell (should error)

println("test single use of add_accu_cell: ");
c := lbss.create_configuration_tape(3, 10);
c.add_accu_cell(1, 0);
println("everything fine");
c.add_accu_cell(1, 0);
printl("This message should not appear (error should occurs before)");

