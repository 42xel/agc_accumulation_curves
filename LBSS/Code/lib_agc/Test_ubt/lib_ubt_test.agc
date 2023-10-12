//a file to test the lbss ubt agc library

//usage: Inside an agc test file:
/*
load "lib_ubt_test.agc";
*/
use AGC ;

//load "../arith.agc";

lbss_ubt := create_signal_machine()
{
	UBT_DEPTH := 3;
	load "../arith.agc";
	load "../sub_machine.agc";
	load "../lib_ubt_sm.agc";
};

//what is tested:
//rerouting


scale := 1/6;
//Cdist := 10;
//Cratio := 3;
steps := 500;
// the default number of steps for all tests, overridable locally



DIR_Picture := "./";
// This function creates a run and export the corresponding space-time diagram
.make_pic .= ( name , configuration , nb_steps , param ) -> {
    println ( name ) ;
    .run .= configuration . run () ; //Creates a run
    run . step ( nb_steps ) ;  //advance by maximum number_collision_tiks collisions times
    run . export ( "PDF" , DIR_Picture & name , param ) ;//Create a pdf output for the simulated
};



test_rerouting := 
//embeding test function wihin an environnement so as to be able to change scale, Cdist and Cratio for each kind of test, without going so far as making them variables.
//for example:
// test_initial_configuration.Cdist := 20; to change Cdist for the following test but not the other
{
	.create := (prefix, dirin, nodeType, depth, suffix) ->
	{
		//depth mostly seful to test for -1, 0 and 1 here.
		time_before_collision := 1;
		macro_collision_duration := 5;
		speed_bounce := 3;
		//initializing for scope
		speed_tree := "NONE";
		pos_bound := "NONE";
		dir0 := "NONE";
		dir1 := "NONE";
		dir2 := "NONE";
		suff_tree := "NONE";
		suff_bound := "NONE";
		if (dirin != "right" && dirin != "left" && dirin != "upright" && dirin != "upleft")
		{
			println("ERROR in test_rerouting: unknown dirin");
			if (undef) {};
		};


		if (dirin == "right" || dirin == "upright")
		{
			dir1 := "right";
			dir2 := "left";
			speed_bounce := - speed_bounce;
		}
		else
		{
			dir1 := "left";
			dir2 := "right";
		};
		if (dirin == "left" || dirin == "right")
		{
			dir0 := dir1;
			speed_tree := 1;
			pos_bound := speed_tree * time_before_collision;
			suff_tree := "";
			suff_bound := nodeType;
		}
		else
		{
			dir0 := "up";
			speed_tree := 0;
			pos_bound := 3/4 * macro_collision_duration;
			suff_tree := nodeType;
			suff_bound := "";
		};
		if (dirin == "right" || dirin == "upright")
		{
			pos_bound := - pos_bound;
		}
		else
		{
			speed_tree := - speed_tree;
		};

		c .= lbss_ubt.create_configuration_wrap()
		{
			create_id_bounce (?dir2, "") @ - ?speed_bounce * ?time_before_collision;
			create_id_bounce (?dir2, "") @ - ?speed_bounce * (?time_before_collision + ?macro_collision_duration);
			create_id_bound(?dir0 , ?suff_bound) @ ?pos_bound;
			create_id_tree(?dir0 , ?suff_tree, ?depth) @ - ?speed_tree * (?time_before_collision + ?macro_collision_duration);
		};

		make_pic ("Rerouting/" _ prefix _ dirin _ "_" _ nodeType _ "_" _ suffix _ ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};



