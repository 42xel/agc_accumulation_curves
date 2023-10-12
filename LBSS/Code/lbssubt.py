from tkinter import*

from fractions import Fraction
#To read and manipulate rational numbers.
#for rational expressions
from lbssMachine import createID
from lbssMachine import ensureID
from lbssRun import fun_run
from lbssRun import Run

WIDTH = 1044  # width of the display window, in pixel
HEIGHT = 800  # height

#stuffs to initialize frec. Not supposed to be touched much.
#S0 = 1
#STEP0 = 0.75
#DIR0 = 0
#+1 means to the right, -1 to the left 0 means up

X0 = WIDTH/2
Y0 = 10
SCALE = (WIDTH - 20)/4
DEPTH = 7
#the default ubtree depth.

#X0 - U * SCALE/2, Y0 + SCALE * s/2, X0 + U * SCALE/2, Y0 + SCALE * t/2

class Segment:
    def __init__ (self, x0, y0, x1, y1):
        self.x0 = x0
        self.y0 = y0
        self.x1 = x1
        self.y1 = y1
    
class Position:
    """a
    """
    def __init__ (self, x = X0, y = Y0, scale = SCALE):
        self.x = x
        self.y = y
        self.scale = scale
        
    def delay(self):
        """Draws line and compute the the position.
        """
        y1 = self.y + self.scale
        s = Segment(self.x, self.y, self.x, y1)
        self.y = y1
        return self, s
    
    def split(self):
        """Draws lines and compute the the positions.
        """
        xl, xr = self.x - self.scale / 2, self.x + self.scale / 2
        y1 = self.y + self.scale / 2
        sl = Segment(self.x, self.y, xl, y1)
        sr = Segment(self.x, self.y, xr, y1)
        self.x, self.y = xl, y1
        self.scale = self.scale / 2
        return self, sl, Position(xr, y1, self.scale), sr
    


def fun_ubt(machine, config, depth = DEPTH, initialNode = createID()):
    accumulator = Fraction(0) if 'a' not in config else config['a']
    configuration = config['x']
    depth = int(depth)
    initialNode = ensureID(initialNode)
    root = Tk()
    root.title('LBSS UBT')#todo improve
    
    canvas = Canvas(root, width = WIDTH, height = HEIGHT, bg = 'white')
    def create_line(s):
        """prints a line on canvas, from (x1, y1) to (x2, y2), these points being given in
        the usual mathematical cartesian system, rather than the one usually used for screen
        (so that +y axis corresponds to +time in the printed signal diagram)"""
        canvas.create_line(s.x0, HEIGHT - s.y0, s.x1, HEIGHT - s.y1)

    def frec (run, depth, p):
            """recursively draws the diagram of the machine\
            x0, y0 initial coordinate. Used to draw the diagram\
            """
            #todo: finish description
            if depth == 0:
                return
            for node in run:
                #print(node)
                pass
            
            current = run.machine[run.current]
            
            if current.value.type == "delay":
                p, s = p.delay()
                create_line(s)
                run.current = current.nextID[0]
                frec (run, depth, p)
                
            elif current.value.type == "split":
                pl, sl, pr, sr = p.split()
                create_line(sl)
                create_line(sr)
                rightRun = run.copy()
                run.current = current.nextID[0]
                rightRun.current = current.nextID[1]
                frec (run, depth - 1, pl)
                frec (rightRun, depth - 1, pr) 

    frec(Run(machine, configuration, accumulator, initialNode), depth, Position())
    
    canvas.pack()
    root.mainloop()

