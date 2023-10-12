from tkinter import*
root = Tk()
root.title('Aurelien MAS')

WIDTH = 1044  # width of the display window, in pixel
HEIGHT = 800  # height
canvas = Canvas(root, width = WIDTH, height = HEIGHT, bg = 'white')

def create_line(x1, y1, x2, y2):
        """prints a line on canvas, from (x1, y1) to (x2, y2), these points being given in
        the usual mathematical cartesian system, rather than the one usually used for screen
        (so that +y axis corresponds to +time in the printed signal diagram)"""
        canvas.create_line(x1, HEIGHT - y1, x2, HEIGHT - y2)

class Parameters (object):
    """The parameters of the signal machine\
        pm1, p0, p1 encodes the function value at -1, 0 and 1\
        """
    def __init__(self, pm1, p0, p1):
        self.pm1 = pm1
        self.p0 = p0
        self.p1 = p1
    def copy(self):
        return Parameters(self.pm1, self.p0, self.p1)

def machine(depth, u, p, di):
        """choses a step depending of the parameter a and c and xm
        px is the value of the parabola at x (m1 stands for minus one)"""
        
        a = (p.p1 + p.pm1 - 2 * p.p0) / 2
        a /= 2 #previous line is old a, this is new a.
        
        w = 1/2
        if di == -1:#left
            p.p1 = 2 * p.p0
            p.p0 = p.pm1 + p.p0 - 4*w*a
            p.pm1 = 2 * p.pm1
        elif di == +1:#right
            p.pm1 = 2 * p.p0
            p.p0 = p.p0 + p.p1 - 4*w*a
            p.p1 = 2 * p.p1
        #up, nothing to do
        
        p.pm1 -= 1
        p.p0 -= 1
        p.p1 -= 1

            
        m = 0
        
        if a > 0:
            m = min(2 * p.p0 - p.p1, 2 * p.p0 - p.pm1) # not the min but a minoration of it
        else:
            m = min(p.pm1, p.p1)
                
        if m >= 2:
                return "up", depth, u, p
        else:
                return "split", depth - 1, u/2, p

def frec (u, p, di, depth, x0, y0):
        """recursively draws the diagram of the machine\
        parameters at the previous intersection\
        x0, y0 initial coordinate. Used to draw the diagram\
        di provides information as to the side we come from and the last step we took (used by the machine)\
        scale : factor related to the size of the encoded information and the distance to the borders (delimiting verical signals). It's exactly the width of the target segment. Used to draw the diagram\
        depth : number of remaining iterations."""
        #create_line(x0 - 1, y0, x0 + 2, y0)
        x1, y1 = x0 + di * u * SCALE / 2, y0 + u * SCALE/2
        create_line(x0, y0, x1, y1)
        if depth == 0:
                return
        r, depth, u, p = machine(depth, u, p, di)
        if r == "up":
                frec (u, p, 0, depth, x1, y1)
        elif r == "split":
                frec (u, p.copy(), -1, depth, x1, y1)
                frec (u, p, +1, depth, x1, y1)

#stuffs to initialize frec. Not supposed to be touched much.
S0 = 1
STEP0 = 0.75
DIR0 = 0
#+1 means to the right, -1 to the left

X0 = WIDTH/2
Y0 = 10
SCALE = (HEIGHT - 20)/2 #the horizontal width
DEPTH = 10
U = 1

def f(p):
        "draws the diagram of the machine with parameters a and b"
        frec (U, p, DIR0, DEPTH, X0, Y0)
        #create_line(X0 - U * SCALE/2, Y0 + SCALE * s/2, X0 + U * SCALE/2, Y0 + SCALE * t/2)


#PM1 = g(-1), P0 = g(0), P1 = g(1), where g is the function to draw, here a parabola.
#domaine de validité :
        #must all be greater than 2 
PM1 = 2
P0 = 3
P1 = 2

p= Parameters (PM1, P0, P1)
f(p)

canvas.pack()
root.mainloop()
