// A library providing basic arithmetics common with signal machines
//barycenter, harmonic sum, etc
//usage :
/*
load "arith.agc";
*/
//it will define functions where it is called/used.

//
if (DEF_agclib_arith == undef){
	////// basic arith
	..MAX .= (a, b) -> ( if (a < b) b else a);
	..MIN .= (a, b) -> ( if (a < b) a else b);

	//creates a function v -> bar((r,v), (l,1-v))
	..CREATE_FUNCTION_BAR .= (l,r) -> ((v) -> v * r + (1-v) * l);
	//creates a function bar((r,v), (l,1-v)) -> v
	..CREATE_FUNCTION_INV_BAR .= (l,r) -> ((x) -> (x -l)/(r-l));

	..NUMBER_HARMONIC_SUM .= (a,b) -> 1 / (1/a + 1/b);
	..NUMBER_HARMONIC_BAR .= (a, b, beta) -> NUMBER_HARMONIC_SUM(a/(1-beta), b/beta);

	..SV := (a,b) -> NUMBER_HARMONIC_SUM(a, b/2); //Split Velocity
	//intermediate speed of a signal between the split and the crossing of its former up border, or its bounce signal, upon which the signal must have been reduced by half. a is the speed of the crossed signal, b is the target speed.


	..DEF_agclib_arith .= true;
};

