#a file to handle the ipunt and output of lbss.py

import sys
from os.path import split, join
from os import remove

path_py, main_py = split(sys.argv[0])
path_libagc = join(path_py, "lib_agc")
lib_agc_sm = "lib_lbss_sm.agc"
lib_agc_arith = "arith.agc"
lib_agc_sub_machine = "sub_machine.agc"
lib_agc_ubt = "lib_ubt_sm.agc"

path_lbss, main_lbss = split(sys.argv[1])

path_agc = sys.argv[2] if 2 < len (sys.argv) else path_lbss

path_pdf = sys.argv[3] if 3 < len (sys.argv) else path_agc

def lbss_open (file = main_lbss, *args, **kwargs):
    return open(join(path_lbss, file), *args, **kwargs)

def lbss_remove (file = main_lbss, *args, **kwargs):
    return remove(join(path_lbss, file), *args, **kwargs)

def agc_open (file, *args, **kwargs):
    return open(join(path_agc, file), *args, **kwargs)