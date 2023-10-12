from tkinter import*
root = Tk()
root.title('Aurelien MAS')

WIDTH = 1044  # width of the display window, in pixel
HEIGHT = 800  # height
canvas = Canvas(root, width = WIDTH, height = HEIGHT, bg = 'white')

DEPTH = 10#computation depth

def coord(x1, y1, x2, y2):
    return (x1, HEIGHT - y1, x2, HEIGHT - y2)
    """prints a line on canvas, from (x1, y1) to (x2, y2), these points being given in
    the usual mathematical cartesian system, rather than the one usually used for screen
    (so that +y axis corresponds to +time in the printed signal diagram)"""

class parameters (object):
    """The parameters of the signal machine\
        
        """
    def __init__(self, y, z, d):
        self.y = y
        self.z = z
        self.d = d
    def copy(self):
        return parameters(self.y, self.z, self.d)
    
class convexFunction (object):
    """the convex 2 variable function defining the curve we wish to draw
        """
    def __init__(self, e, m, M):
        self.evaluate = e
        self.minor = m
        self.major = M

class direction (object):
    def __init__(self, split, y, z):
        self.split = split
        self.y = y
        self.z = z
        
SPL00 = direction(True, 0, 0)
SPL01 = direction(True, 0, 1)
SPL10 = direction(True, 1, 0)
SPL11 = direction(True, 1, 1)
EXPL = direction(False, 0, 1)
EXPR = direction(False, 1, 0)


def machine(depth, f, p, di):
        """choses a step depending of the parameter a and c and xm
        """
        
        #parameter update
        if di.split:
            p.d /=2
        if di.y:
            p.y += p.d
        if di.z:
            p.z += p.d
        
        m = f.minor(p)
        M = f.major(p)
        expandL = False
        expandR = False
        split = False
        
        if M >= 0 and m <= 0:
            split = True
        
        if not di.split:
            #add some conditions exploiting convexity to stop computation when not needed
            #f00 = f.evaluate(p.x, p.y)
            #f01 = f.evaluate(p.x, p.y + p.d)
            #f10 = f.evaluate(p.x + p.d, p.y)
            #f11 = f.evaluate(p.x + p.d, p.y +p.d)
            expandL = True
            if di.y:
                expandR = True
        
        return expandL, expandR, split, depth -1, p
    

def drawRec (u, f, p, di, depth, x0, t0, accu):
        """recursively draws the diagram of the machine\
        parameters at the previous intersection\
        x0, y0 initial coordinate. Used to draw the diagram\
        di provides information as to the side we come from and the last step we took (used by the machine)\
        scale : factor related to the size of the encoded information and the distance to the borders (delimiting verical signals). It's exactly the width of the target segment. Used to draw the diagram\
        depth : number of remaining iterations."""
        #create_line(x0 - 1, t0, x0 + 1, t0)
        x1, t1 = x0 + (di.y - di.z) * u * SCALE / 2, t0 + (di.y + di.z) * u * SCALE/2
        canvas.create_line(*coord(x0, t0, x1, t1))#, fill = 'darkgray')
        #canvas.create_line(*coord(x0, t0, x1, t1), dash=(1 + 3 * depth // DEPTH, 1 + DEPTH - depth), fill = 'darkgray')
        if depth == 0:
            accu.append((x0,t0)) #drawn afterward
            return
        eL, eR, s, depth, p = machine(depth, f, p, di)
        if eL:
            drawRec (u, f, p.copy(), EXPL, depth, x1, t1, accu)
        if eR:
            drawRec (u, f, p.copy(), EXPR, depth, x1, t1, accu)
        if s:
            if eR or eL:
                depth = DEPTH
            for iy in [0,1]:
                for iz in [0,1]:
                    drawRec (u/2, f, p.copy(), direction(True, iy, iz), depth, x1, t1, accu)
                    
#stuffs to initialize frec. Not supposed to be touched much.
S0 = 1
STEP0 = 0.75
DIR0 = EXPR
X0 = WIDTH/2
T0 = 10
SCALE = (HEIGHT - 20)/4
U = 1

#definition of function. do touch
#TODO : make easier parameters to fiddle with
A = 1
B = -5
ALPHA = 2
BETA = -5
K = 8

absA = abs(A)
absB = abs(B)
absALPHA = abs(ALPHA)
absBETA = abs(BETA)

def fe(y,z):
    return A * y * y + B * y + ALPHA * z * z + BETA * z + K
def fm(p):
    #return fe(p.y, p.z) - absA * p.d *(2 * p.y + p.d) - p.d * absB - absALPHA * p.d *(2 * p.z + p.d) - p.d * absBETA
    d = p.d/2
    y = p.y + d
    z = p.z + d
    return fe(y, z) - absA * d *(2 * y + d) - d * absB - absALPHA * d *(2 * z + d) - d * absBETA
def fM(p):
    #return 2 * fe(p.y, p.z) - fm(p)
    d = p.d/2
    y = p.y + d
    z = p.z + d
    return 2 * fe(y, z) - fm(p)

f = convexFunction(fe, fm, fM)

def draw(p):
    """draws the diagram of the machine with parameter p
    Option t means draw the underlying tree
    Option c means only draw the last step of computation, the closest to the conics (deeper computation yield finer result; the branch not drawn are terminated before DEPTH iteration, so no accu on them even though they're dense)
    option te or a (but not et) means draw both
    """
    l = []
    drawRec (U, f, p, DIR0, DEPTH, X0, T0, l)
    for k in l:
        x, t = k[0], k[1]
        canvas.create_line(*coord(x, t, x, t+1), fill = 'red')
        #create_line(X0 - U * SCALE/2, Y0 + SCALE * s/2, X0 + U * SCALE/2, Y0 + SCALE * t/2)

#canvas2 = Canvas(root, width = WIDTH, height = HEIGHT, bg = 'white')


p= parameters (0, 0, 1)

draw(p)
#in black is drawn the skeletton. In red are drawn nodes still active at the end of the partial simulation (those around which accu can still happen)

canvas.pack()
root.mainloop()
