//a file to test the lbss agc library, most notably basic operations

//usage: Inside an agc test file:
/*
load "lib_lbss_test.agc";
*/
use AGC ;

load "../arith.agc";

scale := 1/60;
Cdist := 20;
MaxR .= 6;
steps := 1000;

time := Cdist/7;
margin := Cdist/500; 

lbss := create_signal_machine()
{	
	.MAX_CTE .= 3;
	.MAX_MOVE .= 3;

	load "../lib_lbss_sm.agc";

	//signals helping framing
	.create_id_test_framing .= (time, margin) -> "test_framing_" _ time _ "_" _ margin;
	add_meta_signal(create_id_test_framing(0, 0), 0) {color=> White; line_style => dotted;};
	.create_ms_test_framing .= (time, margin) -> if (get_meta_signal(create_id_test_framing(time, margin)) == void)
	{
		add_meta_signal(create_id_test_framing(time, margin), - margin / (2 * time)) {color=> White; line_style => dotted;};
		[create_id_test_framing(time, margin), create_id_test_framing(0, 0)] --> [];
	};

	//dummy program signal
	add_meta_signal("test_program_dummy", 0) {color => Black; line_style => dashed;};
	foreach(s:["", "lt", "eq", "gt", "z", "v"])
		["test_program_dummy", create_id_return(s)] --> ["test_program_dummy"];

	foreach (p:[
		//[(x) -> x, 0], 
		[(x) -> create_id_moved(">", x), COMPUTING_SPEED], [(x) -> create_id_moved("<", x), -COMPUTING_SPEED], 
		[create_id_OOM_movedLeft, OOM_contraction_speedLeft], 
		[create_id_OOM_movedRight, OOM_contraction_speedRight],
		[create_id_OOT_moved, OOM_contraction_speedLeft]
		])
	{
		.a .= p[0];
		.s .= p[1];
		add_meta_signal(a("test_program_dummy"), s)	{color => Black; line_style => dashed;};
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
		[sig, "test_program_dummy"] --> [a("test_program_dummy"), sig];
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
		[sig, a("test_program_dummy")] --> ["test_program_dummy", sig];
	};

};
//println(lbss.create_id_get);


//what is tested:
//initial configuration/ encoding
//move
//Out of memory
//branch
//reset
//get
//add
//sub
//Out of bounds
//Out of Time

DIR_Picture := "./";
// This function creates a run and export the corresponding space-time diagram
.make_pic .= ( name , configuration , nb_steps , param ) -> {
    println ( name ) ;
    .run .= configuration . run () ; //Creates a run
    run . step ( nb_steps ) ;  //advance by maximum number_collision_tiks collisions times
    run . export ( "PDF" , DIR_Picture & name , param ) ;//Create a pdf output for the simulated
};

//initial configuration test: register
test_initial_configuration_register := 
//embeding test function wihin an environnement so as to be able to change scale, Rradius and Cratio for each kind of test, without going so far as making them variables.
//for example:
// test_initial_configuration_register.Rradius := 20; to change Rradius for the following test but not the other
{
	.Cdist := 100;
	.steps := 0;
	create := (place, value, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		c.add_register (place, value);
		.time := c.unitWidth * 15;
		.margin := c.unitWidth / 5;
		c.{
			.register_end .= start + Rdist/2 + Rradius;

			create_ms_test_framing(?time, ?margin);
			create_id_test_framing(0, 0) @ register_end + ?margin/2;
			create_id_test_framing(?time, ?margin) @ register_end + ?margin;

			.register_start .= start + Rdist/2 - Rradius;
			create_id_test_framing(0, 0) @ register_start - ?margin/2;
			create_id_test_framing(?time, ?margin) @ register_start - ?margin;
		};
		make_pic ("test_initial_configuration/" & "register_" & place & value & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};
//initial configuration test: head
test_initial_configuration_head := 
{
	.Cdist := 50;
	.time := Cdist/8;
	.margin := Cdist/500; 
	.steps := 0;
	create := (value, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR)
		{
			program_position .= end + DIST_PROG_ROOM / 5 ;
			"test_program_dummy" @ program_position;
				
			//The position of the program. It's a constant since it's defined at most once.
			meta_position .= program_position + 3 * DIST_PROG_ROOM / 5 ;
			create_id_meta("") @ meta_position;

			//create_id_meta("") @ meta_position;
			//the signal to handle mishaps.

			end := end + lbss.DIST_PROG_ROOM;
			create_id_register("unit", "z", "") @ end;
			end := end + unitWidth/2;
			create_id_register("unit", "", "v") @ end;
			end := end + unitWidth/2;
			create_id_register("unit", "b+", "") @ end;

			add_register("accu", ?value);

		};
		c.{
			.head_end .= start + lbss.DIST_PROG_ROOM + unitWidth + Rdist/2 + Rradius;

			create_ms_test_framing(?time, ?margin);
			create_id_test_framing(0, 0) @ head_end + ?margin/2;
			create_id_test_framing(?time, ?margin) @ head_end + ?margin;

			.head_start .= start + c.DIST_PROG_ROOM/5;//
			create_id_test_framing(0, 0) @ head_start - ?margin/2;
			create_id_test_framing(?time, ?margin) @ head_start - ?margin;
		};

		make_pic ("test_initial_configuration/" & "head_" & value & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};
//initial configuration test
test_initial_configuration_cells := {
	.steps := 0;
	clip_left := 0;
	create := (positive, negative, current, accu, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		foreach(v:negative)
		{
			c.add_cell(v);
		};
		if (accu != "NONE")
		{
			c.add_accu_cell(accu, current);
			c.{
				"test_program_dummy" @ program_position;
			}
		}
		else
		{
			//manual hack to demonstrate a single cell without accu
			c.program_position .= c.end + 4 / 2 ; 		//I dunno how to access DIST_PROG_ROOM
			c.add_cell(current);
		};
		foreach(v:positive)
		{
			c.add_cell(v);
		};

		c.{
			create_ms_test_framing(?time, ?margin);
			create_id_test_framing(0, 0) @ end + ?margin/2;
			create_id_test_framing(?time, ?margin) @ end + ?margin;

			create_id_test_framing(0, 0) @ start - ?margin/2;
			create_id_test_framing(?time, ?margin) @ start - ?margin;
		};

		make_pic ("test_initial_configuration/" & "cells_" & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};
//initial configuration with margins test
test_initial_configuration_margins := 
{
time := Cdist;
margin := Cdist/500; 
	.steps := 8;
	create := (positive, negative, current, accu, margins, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		c.add_left_margin(margins);
		foreach(v:negative)
		{
			c.add_cell(v);
		};
		c.add_accu_cell(accu, current);
		
		foreach(v:positive)
		{
			c.add_cell(v);
		};
		c.add_right_margin(margins);

		c.{		
			"test_program_dummy" @ program_position;

			create_ms_test_framing(?time, ?margin);
			create_id_test_framing(0, 0) @ end + ?margin/2;
			create_id_test_framing(?time, ?margin) @ end + ?margin;

			create_id_test_framing(0, 0) @ start - ?margin/2;
			create_id_test_framing(?time, ?margin) @ start - ?margin;
		};

		make_pic ("test_initial_configuration/" & "margins_" & margins & "_" & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};


//move test
test_move := 
{
	create := (tape, accu, direction, suffix) ->
	{
		//print("test move: ");// already in make_pic
		//println(suffix);
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		if (direction == ">")
		{
			c.add_accu_cell(accu, tape[0]);
			c.add_cell(tape[1]);
			suffix := "right" & suffix;
		}
		else
		{
			c.add_cell(tape[0]);
			c.add_accu_cell(accu, tape[1]);
			suffix := "left" & suffix;
		};
		c.{
			"test_program_dummy" @ program_position;
			create_id_move_init_n( ?direction, 1) @ program_position + 5 * Rradius; 
			"Cell_marker" @ end;					//better framing (allow to see the positive bound of the right most cell value)
		};
		make_pic ("test_move/" & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};
//move test, OutOfMemory
test_Out_Of_Memory := 
{
	create := (leftTape, rightTape, current, accu, margins, move, suffix) ->
	{
		.direction;
		if (move < 0)
		{
			..direction .= "<";
			move := -move;
			suffix := "left" _ move _ suffix;
		}
		else
		{
			..direction .= ">";
			suffix := "right" _ move _ suffix;
		};
	
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		c.add_left_margin(margins);
		foreach(v:leftTape)
			c.add_cell(v);
		c.add_accu_cell(accu, current);

		c.create_mscr_move(direction, move);
		c.create_id_move_init_n(direction, move) c.@ c.program_position + 5 * c.Rradius; 
//		create_id_move_init_n( ?direction, move) @ program_position + 5 * ?Rradius; 

		foreach(v:rightTape)
			c.add_cell(v);
		c.add_right_margin(margins);


		c.{"test_program_dummy" @ program_position;};

		make_pic ("test_OutOfMemory/" & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};


//branch test
test_branch := 
{
	create := (current, accu, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		c.add_accu_cell(accu, current);
		c.{
			"branch" @ program_position; 
			"Cell_marker" @ end;
			"test_program_dummy" @ program_position;
		};

		make_pic ("test_branch/" & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};

//reset test
test_reset := 
{
	create := (current, accu, target, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		c.add_accu_cell(accu, current);
		c.{
			create_id_reset(?target) @ program_position; 
			"Cell_marker" @ end;
			"test_program_dummy" @ program_position;
		};

		make_pic ("test_reset/" & target & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};

//get test
test_get := 
{
	create := (current, accu, cte, target, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		c.add_accu_cell(accu, current);
		c.{
			create_mscr_get(?cte, ?target);
			create_id_get(?cte, ?target, 0) @ program_position; 
			"Cell_marker" @ end;
			"test_program_dummy" @ program_position;
		};

		make_pic ("test_get/" & target & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};

//add test
//TODO investigate hv ratio (DELTA and such)
test_add := 
{
	create := (current, accu, value, target, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		f := (v) -> v * lbss.DELTA * lbss.COMPUTING_SPEED * c.unitWidth;
		c.add_accu_cell(accu, current);
		c.{
			create_id_add(?target, 0) @ program_position;
			create_id_add(?target, 0) @ program_position + ?f(?value);
			"test_program_dummy" @ program_position;
			"Cell_marker" @ end;
		};

		make_pic ("test_add/" & target & value & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};

//sub test
test_sub := 
{
	create := (current, accu, value, target, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		f := (v) -> v * lbss.DELTA * lbss.COMPUTING_SPEED * c.unitWidth;
		c.add_accu_cell(accu, current);
		c.{
			create_id_sub(?target, "top", 0) @ program_position;
			create_id_sub(?target, "bot", 0) @ program_position + ?f(?value);
			"test_program_dummy" @ program_position;
			"Cell_marker" @ end;
		};

		make_pic ("test_sub/" & target & value & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};


//Add/Sub test: Out Of Bounds
test_Out_Of_Bound := 
{
	create := (operation, leftTape, rightTape, current, accu, value, target, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		f := (v) -> v * lbss.COMPUTING_SPEED * lbss.DELTA * c.unitWidth;
		c.add_left_margin(1);
		foreach(v:leftTape)
			c.add_cell(v);
		c.add_accu_cell(accu, current);
		if (operation == "add")
		{
			c.{
				create_id_add(?target, 0) @ program_position;
				create_id_add(?target, 0) @ program_position + ?f(?value);
				"test_program_dummy" @ program_position;
			};
		}
		else if (operation == "sub")
		{
			c.{
				create_id_sub(?target, "top", 0) @ program_position;
				create_id_sub(?target, "bot", 0) @ program_position + ?f(?value);
				"test_program_dummy" @ program_position;
			};
		}
		else
		{
			println ("ERROR: wrong opertation for test_Out_Of_Bound. Expected \"add\" or \"add\", got:");
			println (operation);
		};

		foreach(v:rightTape)
			c.add_cell(v);
		c.add_right_margin(1);

		make_pic ("test_OutOfBound/" & operation & value & target & suffix & ".pdf", c, steps, {
			scale := 1/100;
			}
			);
	};
};



test_Out_Of_Time .=
{
	create := (Ctime_Cell, Ctime_Tape, returnsig, leftTape, rightTape, current, accu, steps, suffix) ->
	{
		c .= lbss.create_configuration_tape(Cdist, MaxR);
		c.add_left_margin(1);
		foreach(v:leftTape)
			c.add_cell(v);
		c.add_accu_cell(accu, current);

		c.{
			create_id_return(?returnsig) @ meta_position + Rradius;
			
			"test_program_dummy" @ program_position;
			
			add_clock(?Ctime_Cell, ?Ctime_Tape);
		};

		foreach(v:rightTape)
			c.add_cell(v);
		c.add_right_margin(1);


		make_pic ("test_OutOfTime/" & returnsig & suffix & ".pdf", c, steps, {
			scale := scale;
			}
			);
	};
};
