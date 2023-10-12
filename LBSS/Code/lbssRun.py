#The interpreter

#use:
# python3 lbss.py test.lbss
# with some run function in test.lbss. to output on a log file rather than just print in the command prompt:
# python3 lbss.py test.lbss > test.log

from fractions import Fraction
#To read and manipulate rational numbers.
#import re
#for rational expressions
from lbssMachine import createID
from lbssMachine import ensureID
#to know the default ID createID()

class Run:
    def __init__(self, machine, configuration, accumulator = Fraction(0), initialNodeID = createID(), maxsteps = -1):
        self.machine = machine
        self.tape = configuration
        self.steps = 0
        self.maxsteps = Fraction(maxsteps)
        self.current = initialNodeID
        self.accu = accumulator
        self.hist = ""
    
    def __iter__(self):
        current = self.machine[self.current]
        while current.value.type not in ["end", "delay", "split"] and self.steps != self.maxsteps:
            self.steps += 1
            
            current = self.machine[self.current]
            if current.value.type == "computation":
                if current.value.token == "=0":
                    r = 0
                else:
                    lhs = self.accu if current.value.recipient == "a" else self.tape.read()
                    rhs = {"u": 1, "a": self.accu, "h": self.tape.read()}[current.value.operand]
                    rhs *= current.value.constant
                    if current.value.token == "+=":
                        r = lhs + rhs
                    elif current.value.token == "-=":
                        r = lhs - rhs
                if current.value.recipient == "a":
                    self.accu = r
                else:
                    self.tape.write(r)
                    
                self.current = current.nextID[0]
                yield current
                
            elif current.value.type == "move":
                self.tape.move(current.value.move)
                self.current = current.nextID[0]
                yield current
                
            elif current.value.type == "branch":
                if self.accu < 0:
                    self.current = current.nextID[0]
                elif self.accu == 0:
                    self.current = current.nextID[1]
                else:
                    self.current = current.nextID[2]
                yield current
        
        if current.value.type in ["end", "delay", "split"]:
            yield current
#            pass
        
        
    def print (self, *objects, sep=' ', end='\n'):
        self.hist += sep.join(str(i) for i in objects) + end
        
    def __str__(self):
        return self.hist
 
    def copy (self):
        return Run(self.machine, self.tape.copy(), self.accu, self.current, self.maxsteps - self.steps)
    
def fun_run(machine, config, initialNode = createID(), maxsteps = -1):
    accumulator = Fraction(0) if 'a' not in config else config['a']
    configuration = config['x']
    initialNode = ensureID(initialNode)
#    oldprint("maxsteps: ", maxsteps)
    
    run = Run(machine, configuration, accumulator, initialNode, maxsteps)
    print = run.print
    print("Initial configuration:", configuration, sep = "\n", end = "\n\n")
    for node in run:
        print(node, end = "")
        if node.value.type == "computation":
            print(node.value.recipient, "->", run.accu if node.value.recipient == 'a' else configuration.read())
        elif node.value.type == "move":
            print("\n\t", str(configuration), "\ta -> ", run.accu, sep="")
        elif node.value.type == "branch":
            print("a -> ", run.accu, end = " ")
            if run.accu < 0:
                print("< 0")
            elif 0 < run.accu:
                print("> 0")
            else:
                print("= 0")
        elif node.value.type == "end":
            print("terminating node: ", node.id)
    configuration.trim()
    print("\nFinal configuration:", configuration, "\ta -> ", run.accu, sep = "\n", end = "\n\n")
    
    return run