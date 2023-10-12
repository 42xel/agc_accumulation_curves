# Usage
#TODO Usage
#TODO ubt_agc and ubt_pdf

.DEFAULT_GOAL := .Phony

agcjar = /home/emmanuel/Documents/AGC/agc_2_0.jar
#the agc jar to run agc files and generate pdf out of them.

SRCS := $(patsubst config_%.lbss, %, $(wildcard config_*.lbss)) 
AGC := $(SRCS:%=./agc/%.agc)
#TODO: is it possible to have that after compiler_agc?

.Phony: compiler_agc compiler_pdf ${AGC}

all: interpreter compiler_agc compiler_pdf ubt ${AGC}

interpreter:
	@echo "Running the interpreter tests."
	python3 ../../lbss.py test_interpreter.lbss
ubt:
	@echo "Running the ubt interpreter and compilater tests."
	python3 ../../lbss.py test_ubt.lbss ./agc/

compiler_agc:
	@echo "Running the compiler test: building agcs."
	python3 ../../lbss.py test_compiler.lbss ./agc/

compiler_pdf: compiler_agc ${AGC}
	@echo "Compiler test: running agc, ran."

./agc/%.agc: compiler_agc
	@echo $@
	java -jar ${agcjar} $@

cleantmp:
	@echo "Cleaning up..."
	rm -rvf *.tmp ${SRCS:config_%.lbss=./%.agc}


