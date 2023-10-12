# Usage
#TODO Usage
#TODO ubt_agc and ubt_pdf

.DEFAULT_GOAL := .Phony

agcjar = /home/emmanuel/Documents/AGC/agc_2_0.jar
#the agc jar to run agc files and generate pdf out of them.

filename = slanted
#the basename of the stuff to compile from lbss up to pdf

.Phony: redoagc redopdf

redoagc:
	python3 ../../lbss.py ${filename}.lbss ./agc/ ./pdf/ &&

redopdf:
	java -jar ${agcjar} ./agc/${filename}.agc &&

agc/${filename}.agc:
	python3 ../../lbss.py ${filename}.lbss ./agc/ ./pdf/

pdf/${filename}.pdf:
	java -jar ${agcjar} ./agc/${filename}.agc

show: redoagc redopdf
	xdg-open ./pdf/${filename}.pdf &


