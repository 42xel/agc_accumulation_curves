#The machine parser

from fractions import Fraction
#To read and manipulate rational numbers.
import re
#for rational expressions

class NodeValue (object):
    """a class for the value of a node
    """
    def __init__(self, kind):
        self.type = kind
        
    def __str__(self):
        return str(vars(self))
#    def __repr__(self):
        #todo do or delete
#        return str(vars(self))

#class PassNodeValue(NodeValue):
#    def __init__(self):
#        NodeValue.__init__(self, "pass")
#    def __str__(self):
#        return "pass; \t"
    
class MoveNodeValue(NodeValue):
    def __init__(self, move = None):
        # "= None" is just to make direction non positional. It's always given when necessary (it is not used to catch error).
        assert move != 0, "Move nodes can't be void"
        NodeValue.__init__(self, "move")
        self.move = move
    def __str__(self):
        return (-self.move) * '<' if self.move < 0 else self.move * '>'
        
class BranchNodeValue(NodeValue):
    def __init__(self):
        NodeValue.__init__(self, "branch")
    def __str__(self):
        return "Branch "
        
class ComputeNodeValue(NodeValue):
    def __init__(self, recipient = None, token = None, constant = 1, operand = None):
        NodeValue.__init__(self, "computation")
        self.recipient = recipient
        self.token = token
        self.constant = constant
        self.operand = operand
    def __str__(self):
        return ' '.join([self.recipient, self.token, (str(self.constant) + " * " + self.operand if self.operand else "")])
    
class EndNodeValue(NodeValue):
    def __init__(self):
        NodeValue.__init__(self, "end")
    def __str__(self):
        return "end"

class DelayNodeValue(NodeValue):
    def __init__(self):
        NodeValue.__init__(self, "delay")
    def __str__(self):
        return "Delay "
        
class SplitNodeValue(NodeValue):
    def __init__(self):
        NodeValue.__init__(self, "split")
    def __str__(self):
        return "Split "

dictValue = {
#        "pass": PassNodeValue,
        "move": MoveNodeValue,
        "branch": BranchNodeValue,
        "computation": ComputeNodeValue,
        "end": EndNodeValue,
        "delay": DelayNodeValue,
        "split": SplitNodeValue
        }
    
    
def createID(label = "", n = 0):
    return label + '_#' + str(n)

def splitID(ID):
    m = re.fullmatch("(\w*)_#(\d*)", ID)
    return (m[1], m[2]) if (m != None) else None

def ensureID(ID):
    """a function that ensure an ID is well formatted:
        If ID is an ID, it is returned,
        else if it is a label, the corresponding ID is returned
        """
    if splitID(ID):
        return ID
    elif re.fullmatch("\w*", ID):
        return createID(ID)
    else:
        raise Exception("can't parse as an initial ID name:" + ID)
        
class Node(object):
    """A class for the node
    """
    def __init__(self, ID, typ = "", nextID = [], **kwargs):
        self.id = ID
        #the unique id of the node in the form "label#x" where label is the last visited label and x the number of lines since
        self.nextID = nextID
        
        if typ != "":
            self.setValue(typ, **kwargs)
            
    def setValue(self, typ, **kwargs):
        assert typ in dictValue, "Invalid NodeValue type"
        self.value = dictValue[typ](**kwargs)
        
    def __str__(self):
        r = self.id + " :\t" + str(self.value)
        r += ', '.join(self.nextID) + '; \t' if self.value.type in ["branch", "split", "delay"] else '; \t'
        return r
#    def __repr__(self):
        #todo repr
#        return str(vars(self))
    
class IDlink:
    def __init__(self, selfname, previous):
        self.self = selfname
        self.prev = previous
        self.size = 0
        self.next = None
     
class NodeCollection (dict):
    """A data structure to reference and acess Node.
        It's simply a dictionary.
        It could evolve, using node identifiers might then warrant making an original class.
        """
    #todo errors/warnings?
    def __init__(self, *args, **kwargs):
        dict.__init__(self, *args, **kwargs)
        self.labelMap = {"": IDlink("", None)}
        #a map of labels to handle broken IDs. Not sure if useful
        self.curLabel = ""
        #the current label
        self.curPos = 0
        #the number of nodes visited since current label
        self.lastID = None
        #the ID of the last recorded Node
        self.lastNaturalFlow = False
        
    def getID(self, label = None, nNodesSince = None):
        label = label if label != None else self.curLabel
        nNodesSince = nNodesSince if nNodesSince != None else self.curPos
        return createID(label, nNodesSince)      
        
    def addNode(self, node, naturalFlow = False):
        newID = self.getID()
        if self.lastNaturalFlow:
            self[self.lastID].nextID = [newID]
        self[newID] = node
        self.lastID = newID
        self.curPos += 1
        self.lastNaturalFlow = naturalFlow
        
    def addLabel(self, lbl):
        assert lbl not in self.labelMap, "Label defined twice (they must be unique)"
        oldLbl = self.curLabel
        self.labelMap[oldLbl].size = self.curPos
        self.labelMap[oldLbl].next = lbl
        brokenID = self.getID()
        self.curLabel = lbl
        self.curPos = 0
        
        if self.lastID in self and self[self.lastID].nextID == [brokenID]:
            self[self.lastID].nextID = [self.getID()]
        #repairs possible links failures
        
        self.labelMap[lbl] = IDlink(lbl, oldLbl)
        
    def __getitem__(self, index):
        try:
            return dict.__getitem__(self, index)
        except KeyError:
        #todo: see why this works for the interpreter but isn't used by the AGC compiler
            print("Warning: could not resolve as a node ID:  " + index + "  , trying with the next label", end = "")
            lbl, n = splitID(index)
            n = int(n)
            li = self.labelMap[lbl]
            n -= li.size
            assert n >= 0 and li.next != None, ". Node ID resolution failed:  " + index
            print(":  " + self.getID(label = li.next, nNodesSince = n))
            return self [self.getID(label = li.next, nNodesSince = n)]
#    def __str__(self):
            #TODO
            
  


#def fun_read_node_type (code):
#    """a function that infers the type of a Node from its code
#    """
#    code = code.strip()
#    if '=' in code:
#        return "computation"
#    elif Node.patternMove.fullmatch(code):
#        return "move"
#    elif code.startswith("Branch"):
#        return "branch"
#    elif code.startswith("Delay"):
#        return "delay
#    elif code.startswith("Split"):
#        return "split"
#    elif Node.patternEnd.fullmatch(code):
#        return "end"
#    else:
#        raise TypeError("cannot infer the type of this node: \t" + code)
#        #TODO Error

 
 

patternMove = re.compile("([<\s]+|[>\s]+)")
#patternComputation1 = re.compile(r"([ah])\s*([+-]=|=\s*0)\s*")
#patternComputation2 = re.compile(r"(.*)\*\s*([uah])")
patternBranch = re.compile(r"Branch\s+(\w+)\s*,\s*(\w+)\s*,\s*(\w+)")
patternEnd = re.compile("end")
patternDelay = re.compile(r"Delay\s+(\w+)")
patternSplit = re.compile(r"Split\s+(\w+)\s*,\s*(\w+)") 
          
patternComputation = re.compile(r"(.*?)([+-]?=)(.*)")
patternComputationR = re.compile(r"(.*?)\*(.*)")
def computeRHS(rhs):
#TODO: raise and catch errors properly
    if "*" in rhs:
        match = patternComputationR.fullmatch(rhs)
        constant = match[1].strip()
        operand = match[2].strip()
        if operand not in ['a', 'h', 'u']:
            assert (constant in ['a', 'h', 'u']), ["invalid operand ", match[2]]
            constant, operand = operand, constant
        constant = Fraction(constant)
    else:
        operand = rhs.strip()
        if operand in ['a', 'h', 'u']:
            constant = 1
        else:
            constant = Fraction(operand)
            operand = "u"
    return constant, operand
        
def fun_create_machine(machine_def):
    """creates a machine from a string of character.
    """
    #First pass, to check double labels and expand computations
    rlineNumber = 1
    pattern = re.compile(r"\s*(.*)([:;])((?<=;)\s*goto\s*(\w*)|)")
    nodes = NodeCollection()
    
    for match in pattern.finditer(machine_def):
        if match[2] == ':':
            lbl = match[1].strip()
            assert re.fullmatch(r'\w*', lbl), [rlineNumber, "Could not resolve as a label (must be a single sequence of alphanumerical characters):\n" + lbl]
            nodes.addLabel(lbl)
            
        else:
            code = match[1].strip()
            ID = nodes.getID()
            
            if '=' in code:
                """computation"""
                matchC = patternComputation.fullmatch(code)
                """recipient"""
                recipient = matchC[1].strip()
                assert (recipient in ['a', 'h']), [rlineNumber, "invalid recipient ", match[1]]
                token = matchC[2]
                constant, operand = computeRHS(matchC[3])
                if token == "=":
                    if constant == 0:
                        #simple reset, already elementary
                        nodes.addNode(Node(ID, typ = "computation", recipient = recipient, token = "=0"), naturalFlow = True)
                    else:
                        if operand == recipient:
                            if constant == 1:
                                rlineNumber = rlineNumber + match[0].count('\n')
                                continue
                                #ignore a=a: and h=h; . Explicit room for raising warning, erros, or handling it differently.
                            else:
                                constant -= 1
                                #h=2*h; : get ready for h += 1 * h;
                        else:
                            nodes.addNode(Node(ID, typ = "computation", recipient = recipient, token = "=0"), naturalFlow = True)
                            ID = nodes.getID()
                            #a = 2 *h; : starts with a=0; get ready for a += 2*h;
                            
                        if constant < 0:
                            constant = -constant
                            token = "-="
                        else:
                            token = "+="
                        nodes.addNode(Node(ID, typ = "computation", recipient = recipient, token = token, constant = constant, operand = operand)
                            , naturalFlow = True)
                else:
                    if constant == 0:
                        #ingore a+= 0
                        rlineNumber = rlineNumber + match[0].count('\n')
                        continue
                    if constant < 0:
                        constant = -constant
                        token = "+=" if token == "-=" else"-="
                    nodes.addNode(Node(ID, typ = "computation", recipient = recipient, token = token, constant = constant, operand = operand)
                        , naturalFlow = True)
                
            elif patternMove.fullmatch(code):
                """move"""
                if code.startswith(">"):
                    nodes.addNode(Node(ID, typ = "move", move = code.count(">")), naturalFlow = True)
                else:
                    nodes.addNode(Node(ID, typ = "move", move = - code.count("<")), naturalFlow = True)
            elif code.startswith("Branch"):
                """branch"""
                matchB = patternBranch.fullmatch(code)
                assert matchB, "Invalid Branch node definition:\n" + code
                nodes.addNode(Node(ID, typ = "branch", nextID = [createID(matchB[1]), createID(matchB[2]), createID(matchB[3])]))
            elif code.startswith("Delay"):
                """delay"""
                matchD = patternDelay.fullmatch(code)
                assert matchD, "Invalid Delay node definition:\n" + code
                nodes.addNode(Node(ID, typ = "delay", nextID = [createID(matchD[1])]))
            elif code.startswith("Split"):
                """split"""
                matchS = patternSplit.fullmatch(code)
                assert matchS, "Invalid Split node definition:\n" + code
                nodes.addNode(Node(ID, typ = "split", nextID = [createID(matchS[1]), createID(matchS[2])]))
            elif patternEnd.fullmatch(code):
                """end"""
                nodes.addNode(Node(ID, typ = "end"))
            else:
                raise TypeError("cannot infer the type of this node: \t" + code)
                #TODO Error
            
            if match[3]:
                #if there is a goto
                assert nodes.lastNaturalFlow, "This node does not supports goto: " + nodes[nodes.lastID]
                nodes[nodes.lastID].nextID = [createID(match[4])]
                nodes.lastNaturalFlow = False
                
        rlineNumber = rlineNumber + match[0].count('\n')
    if nodes.lastNaturalFlow:
        print("Warning: terminal node was missing.")
        nodes.addNode(Node(nodes.getID(), typ = "end"))
    
    #just a sanity check that all the links between nodes are valid
    for _, node in nodes.items():
        for ID in node.nextID:
            try:
                nodes[ID]
            except:
                print("Could not resolve link:\n" + ID + "\nfrom:\n")
                raise
            #todo somehow get line number and use it in error
    
    return nodes
    
    #relative line number
    