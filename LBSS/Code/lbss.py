#The main

#use:
# python3 lbss.py test.lbss


#import sys #to have access to "myFile.lbss"
from lbssIO import lbss_open as open, main_lbss, lbss_remove as remove
import re


#keywords = [
#	"load_lbss_machine",
#	"create_lbss_machine",
#	"load_lbss_configuration",
#	"create_lbss_configuration",
#	"run",
#	"toAGC_machine",
#	"toAGC_config"
#	]

from lbssMachine import fun_create_machine
from lbssConfiguration import fun_create_configuration
from lbssRun import fun_run
#from lbssFileref import Fileref
from lbssAGCConfiguration import fun_to_AGC_configuration
from lbssAGCMachine import fun_to_AGC_machine
from lbssAGCRun import fun_to_AGC_run
from lbssubt import fun_ubt
from lbssAGCubt import fun_to_AGC_ubt



def read_up_to(file, line, endMarker):
    """reads the file from current position up to the first occurence of endMarker.
    It returns 3 strings:
        - what's before end
        - endMarker itself
        - the end of the line where endMarker was find
    If endMarker is not found, it returns the rest of the file as a string and two empty strings
    similar to str.partition
    end is a string."""
    r = []
    ar, e, p = line.partition(endMarker)
    r.append(ar)
    while e == "" and line != "":
        line = file.readline()
        ar, e, p = line.partition(endMarker)
        r.append(ar)
    return str.join("", r), e, p

patternNocom1 = re.compile(r"(//|/\*)")
patternNocom2 = re.compile(r"(\*/)")

def create_aux_filename (filename, hidden = True):
    """creates the name of an auxiliary file"""
    return ('.' if hidden else "") + filename + ".auxiliary"

tmp_list = {}       #list of temporary files to delete later on
def create_tmp_filename (filename, hidden = True):
    """creates the name of a temporary file"""
    r = ('.' if hidden else "") + filename + ".tmp"
    tmp_list[r] = True
    return r

def noCommentOpen(filename):
    """first pass to remove comments"""
    """FRIDGE: quotes are ignored, so "//" or "/*" probably have catastrophic results.
    Let us just say that the language does not support quotes (or string for what matter)."""
    aux_name = create_tmp_filename(create_aux_filename(filename))
    with open(filename) as file:
        with open(aux_name, "w") as file2:
            p = patternNocom1
            line = file.readline()
            while line != "":
                l = line.rstrip("\n")
                m = p.split(l, 1)
                while len(m) > 1:
                    if p == patternNocom1:
                        if m[1] == "//":
                            file2.write(m[0])
                            l = ""
                            break
                        elif m[1] == "/*":
                            file2.write(m[0])
                            p = patternNocom2
                            l = m[2]
                        else:
                            raise Exception("impossible case")
                    elif p == patternNocom2:
                        p = patternNocom1
                        l = m[2]
                    else:
                        raise Exception("impossible case")
                    m = p.split(l, 1)
                if p == patternNocom1:
                    file2.write(l)
                file2.write("\n")
                line = file.readline()
                
    return open(aux_name)

with noCommentOpen(main_lbss) as file: 
    line = ""
    environment = {}
    environment["environment"] = environment
    oldreadline = file.readline
    global lineNumber, lineNumber0
    lineNumber = 0
    def newreadline():
        global lineNumber
        lineNumber = lineNumber + 1
        return oldreadline()
    file.readline = newreadline
    
    line = file.readline()
    while line != "":
        if line.strip() == "":
            #empty line
            line = file.readline()
            continue
        lineNumber0 = lineNumber
        sep, text, name = None, "", ""
        if line.startswith("create"):
            sep = "<<"
            #FRIDGE : pooper parsing of pipes and such?
            #FRIDGE : proper stdin and stdout interactions?
        arguments = line.split(sep)
        #FRIDGE : refine the above line to allow pathnames within quotes
        
        if line.startswith("create"):
            # << construction
            arguments[0] = arguments[0].rstrip()
            arguments[-1] = arguments[-1].lstrip()
            endMarker = arguments[-1] #.rstrip('\n')
            arguments = arguments[0].split('>')
            if len(arguments) >= 2:
                arguments[0] = arguments[0].rstrip()
                name = arguments[-1].lstrip()
            else:
                raise Exception("no name found while interpreting:\n" + line)
                #name = "anonymous_something"
            line = file.readline()
            text, m, e = read_up_to(file, line, endMarker)
            if m == "":
                raise Exception(str. format ("line {0}, {1}: no valid terminator found, was expecting \n {2}", lineNumber0, lineNumber, endMarker)) #todo test
            arguments[0] = arguments[0][7:]
        elif line.startswith("load"):
            # arguments [1:2] is [path, name]
            if len(arguments) > 2:
                name = arguments[2] 
            elif arguments[1].endswith(".lbss"):
                name = arguments[1][:-5]
            else:
                raise Exception("no name found while interpreting:\n" + line)
            with noCommentOpen(arguments[1]) as file2:
                text = file2.read()
            arguments[0] = arguments[0][5:]
        elif line.startswith("run") or line.startswith("toAGC") or line.startswith("print") or line.startswith("draw_ubt"):
            pass
        else:
            raise Exception("At line : {0}, can't parse as anything meaningful:\n {1}".format(lineNumber, line))
        
        if arguments[0] == "print":
            print(environment[arguments[1]] if 1 < len(arguments) else "")
        elif arguments[0] == "lbss_machine":
#            print("creating machine:\n" + name + '\n')
#FRIDGE: write that in a log file instead of printing it
            environment[name] = fun_create_machine(text)
        elif arguments[0] == "lbss_configuration":
#            print("creating configuration:\n" + name + '\n')
            #FRIDGE logfile
            environment[name] = fun_create_configuration(text)
        elif arguments[0] == "run":
#            print("creating run with machine: " + arguments[1] + "\nfrom configuration: " + arguments[2] +
#                  ("\nMaximum number of steps: " + arguments[3] if 3 < len(arguments) else ""))
            #FRIDGE logfile
            environment[arguments[3]] = fun_run(environment[arguments[1]], environment[arguments[2]], *arguments[4:])
            #FRIDGE Hanlde keyError
        elif arguments[0] == "draw_ubt":
            fun_ubt(environment[arguments[1]], environment[arguments[2]], *arguments[3:])
        elif arguments[0] == "toAGC_machine":
            destination = arguments[2] if len(arguments) > 2 else (arguments[1] + ".agc")
            environment[destination] = fun_to_AGC_machine(environment[arguments[1]], destination, arguments[1])
        elif arguments[0] == "toAGC_config":
            destination = arguments[2] if len(arguments) > 2 else (arguments[1] + ".agc")
            environment[destination] = fun_to_AGC_configuration(environment[arguments[1]], destination, *arguments[3:])
        elif arguments[0] == "toAGC_run":
            destination = arguments[3] if len(arguments) > 3 else ("AGCrun_" + arguments[1] + "_" + arguments[1] + ".agc")
            environment[destination] = fun_to_AGC_run(environment[arguments[1]], environment[arguments[2]], destination, *arguments[4:])
        elif arguments[0] == "toAGC_ubt":
            destination = arguments[3] if len(arguments) > 3 else ("AGCrun_" + arguments[1] + "_" + arguments[1] + ".agc")
            environment[destination] = fun_to_AGC_ubt(environment[arguments[1]], environment[arguments[2]], destination, *arguments[4:])
        
        line = file.readline()

#Fridge make this deletion opyional
for n in tmp_list:
    remove(n)