//TODO adapt text
//a file to test the primitives of the lbss agc library

//Usage:
/*
java -jar <agcjar_path>agc_2_0.jar test_ubt.agc 
*/

use AGC;
load "lib_ubt_test.agc";

depth := 0;
foreach(dirin : ["right", "left", "upright", "upleft"])
{
	test_rerouting.create ("Split/", dirin, "Split", depth, "") ;
};

foreach(dirin : ["right", "left", "upright", "upleft"])
{
	test_rerouting.create ("Delay/", dirin, "Delay", depth, "") ;
};
/*
foreach(dirin : ["right", "left", "upright", "upleft"])
{
	test_rerouting.create ("Delay/", dirin, "Delay", depth, "") ;
};
*/
//TODO (test depth-for cmpt, erase and error)
