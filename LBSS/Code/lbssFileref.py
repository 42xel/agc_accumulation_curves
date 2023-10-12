#a file defining a class to reference a file from the main environnement

class Fileref(object):
    """a class to reference a file from the main environnement
    """
    def __init__(self, filename, check=True):
        """Checks whether a file with name filename exists and fill filename attribute accordingly
        The check can be ignored (eg if you just created the file)
        """
        if check == True:
            file = open(filename)
            file.close()
        self.filename = filename
    def __str__ (self):
        with open(self.filename) as file:
            return file.read()
    def __repr__ (self):
        return "Fileref('{}')".format(self.filename)
    
class AGCFileref(Fileref):
    """a class to reference an AGC file from the main environnement
    """
    def __init__(self, filename, check=True):
        """Checks filename and filename + '.agc'"""
        try:
            Fileref.__init__(self, filename, check)
        except FileNotFoundError as err:
            try:
                Fileref.__init__(self, filename + ".agc", check)
            except FileNotFoundError:
                raise err
    def __repr__ (self):
        return "AGCFileref('{}')".format(self.filename)
    
class AGCMachineFileref(AGCFileref):
    """a class to reference an AGC file containing  machine from the main environnement
    """
    def __init__(self, filename, machinename, size, MaxCTE, MaxMove, check=True):
        """Checks filename and filename + '.agc'"""
        self.machinename = machinename
        self.size = size
        self.MaxCTE = MaxCTE
        self.MaxMove = MaxMove
        AGCFileref.__init__(self, filename, check)
    def __repr__ (self):
        return "AGCMachineFileref('{}', '{}')".format(self.filename, self.machinename)
    
class AGCConfigFileref(AGCFileref):
    """a class to reference an AGC file containing  machine from the main environnement
    """
    def __init__(self, filename, MaxValue, check=True):
        """Checks filename and filename + '.agc'"""
        self.MaxValue = MaxValue
        AGCFileref.__init__(self, filename, check)
    def __repr__ (self):
        return "AGCConfigFileref('{}', '{}')".format(self.filename)