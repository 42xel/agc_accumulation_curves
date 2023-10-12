#The initial configuration parser.

from fractions import Fraction
from math import floor

class ContinuedFraction(list):
    """a class to handle finite continued fractions"""
    #The point is to help convert float into the simplest fraction yielding them.
    #It's a lazy yet lengthy hack to not write a proper interpreter for configurations
    #it's bad and should be removed once proper interpreter for configurations is done.
    def __init__(self, x = [0]):
        if isinstance(x, list):
            for e in x:
                self.append(e)
        elif not isinstance(x, float):
            self.append (floor(x))
            x = x - floor(x)
            while x != 0:
                x = 1/x
                self.append(floor(x))
                x = x - floor(x)
        else :
            #if x is float
            x0 = x
            self.append (floor(x))
            x = x - floor(x)
            while x != 0:
                cf = ContinuedFraction(self)
                f = cf.toFraction()
                if (f.numerator/f.denominator == x0):
                    return
                
                #not necessary I think
                cf = ContinuedFraction(self)
                cf.append(1+cf.pop())
                f = cf.toFraction()
                if (f.numerator/f.denominator == x0):
                    self.append(1+self.pop())
                    return
                
                x = 1/x
                self.append(floor(x))
                
                x = x - floor(x)
            
    def toFraction(self):
        if len(self) == 1:
            return Fraction(self[0])
        else:
            b = self.pop ()
            a = self.pop ()
            self.append(a + 1 / Fraction(b))
            return self.toFraction()
        
    def __repr__(self):
        c = self.copy()
        while len(c) > 1:
            b = c.pop ()
            a = c.pop ()
            c.append(str(a) + "+ 1 /(" + str(b) + ")")
        return c[0]

def toFraction(x):
    if isinstance(x, float):
        return ContinuedFraction(x).toFraction()
    else: 
        return Fraction(x)#also works for strings if anything
    
        
        

class Tape(object):
    #a class to manipulate biinfinite tape.
    def __init__(self, pos = [], neg = [], center = 0):
        #todo
        #arg may be a list or a dictionary, and may only contain integers, floats and string parsable by fraction
        #todo, raise warning if float are used
        
        self.__positiveIndexes = [toFraction(i) for i in pos]
        #nonnegative atually
        self.__negativeIndexes = [toFraction(i) for i in neg]
        self.center = center
    
    def __getitem__(self, index):
        if isinstance(index, int):
            #returns the relevant value, or 0 if none found
            #self[ie]
            if index < 0:
                return self.__negativeIndexes[-1 - index] if -1 - index < len(self.__negativeIndexes) else 0
            else:
                return self.__positiveIndexes[index] if index < len(self.__positiveIndexes) else 0
                
        elif type(index) == slice:
            if index.step == 0:
                raise ValueError("slice step cannot be zero")
            start = index.start if (index.start != None) else  self.start()
            stop = index.stop if (index.stop != None) else  self.stop()
            step = index.step if (index.step != None) else  1
            return [self[i] for i in range(start, stop, step)]
        else:
            raise TypeError("Tape indexes must be integers or slice")
            
    def __setitem__(self, index, value):
        #set a value in the tape, adding the necessary 0s in the gap. Tape is not trimmed even if possible. see/use trim method for that.
        value = toFraction(value)
        
        if isinstance(index, int):
            l, index = (self.__negativeIndexes, -1 - index) if index < 0 else (self.__positiveIndexes, index)
            l.extend([0] * (index - len(l) + 1))
            l[index] = value
        elif type(index) == slice:
            if index.step == 0:
                raise ValueError("slice step cannot be zero")
            start = index.start if (index.start != None) else  self.start()
            stop = index.stop if (index.stop != None) else  self.stop()
            step = index.step if (index.step != None) else  1
            for i in range(start, stop, step):
                self[i] = value.pop(0)
        else:
            raise TypeError("Tape indexes must be integers or slice")
#            
    def __len__(self):
        return len(self.__positiveIndexes) + len(self.__negativeIndexes)
#
    def start(self):
        """ the inclusive start of a tape"""
        return -len(self.__negativeIndexes)
    def stop(self):
        """ the exclusive end of a tape"""
        return len(self.__positiveIndexes)
#
    def __str__(self):
        t = [str(i) for i in self[self.start():self.center]]
        t.append('>' + str(self.read()) + '<')
        t += [str(i) for i in self[self.center + 1: self.stop()]]
        t = ["...", '0', '0'] + t + ['0', '0', "..."]
        return "[" + ', '.join(t) + ']' + " focus (>" + str(self.read()) + "<) at " + str(self.center)

    def __repr__(self):
        return "Tape(" + ", ".join([repr(self.__positiveIndexes), repr(self.__negativeIndexes), str(self.center)]) +')'
        
                     
    def __iter__(self, item):
        for i in range(self.start(), self.stop()):
            yield self[i]
            
    def pairs (self, item):
        for i in range(self.start(), self.stop()):
            yield i,self[i]

    def __contains__(self, item):
        for i in self:
            if i == item:
                return True
        return False
        
    def trim(self):
        for l in [self.__negativeIndexes, self.__positiveIndexes]:
            if 0 < len(l):
                v = l.pop()
                while v == 0 and 0 < len(l):
                    v = l.pop()
                if v != 0:
                    l.append(v)
                    
    def read(self):
        return self[self.center]
    
    def write(self, item):
        self[self.center] = item
        
    def move(self, delta):
        self.center += delta
        
    def moveTo(self, p):
        self.center = p
           
    def copy(self):
        return Tape(self.__positiveIndexes, self.__negativeIndexes, self.center)
        #todo test
            

def fun_create_configuration(configuration_def):
    #todo add starting node
    #todo add head position
    tape = Tape()
    local = {'x' : tape, 'a' : 0}
    exec(configuration_def, {'Fraction':Fraction, 'ONE':Fraction(1)}, local)
    if type(local['x']) != Tape:
        #if tape is entered as an array
        local['x'] = Tape(local['x'])
    if 'p' in local:
        local['x'].moveTo(local['p'])
    
    return local