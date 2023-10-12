description:
a batterie of tests for the lib_agc part of the lbss to agc compiler.


In this file directory, there should be the following files:

- README : this very file
- lib_lbss_test.agc : 		a file providing test functions for the basic operations, with poor to know commentary.
- test_primitives.agc :		a test battery that also serves as example or explanation for the test functions to use them (eg. to generate illustrations).
- test_dummy.agc :		minor tests, such as error raising.

And the following subfolders:

- test_initial_configuration
- test_move
- test_branch
- test_reset
- test_get
- test_add
- test_sub

If some of these subfolders don't exist, the corresponding test function will error.


To run the test file :

java -jar <path>agc_2_0.jar test.agc 

where <path> is whatever path where your agc_2_0.jar lies in.

To run your own tests : copy test.agc and modify it: all test functions are used and summarilly commented.

Q: Why addition and substraction aren't tested?

Adding or substracting something to a register is tested. Getting something from a register then adding it to a register is a sequence of 2 basic operations, and as such is tested elsewhere*.
Think of lbss as an assembler langage where "a += 3 *h;" indeed is a basic operation. What is tested here however is the the machine langage (and the machine itself) where the basic operations are "3*h ->" and "a+= <-".

*It is tested in /../../examples/test/test_compiler.lbss

A more technical reason why it isn't tested here is because it relies on intersections with the program signals, and program metasignals are not handled by lib_lbss_sm.agc , as they depend on the machine.
