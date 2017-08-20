#coding:utf-8

class signal:
    def __init__(self,signalName, cycleLong, signalType, defaultValue):
        self.cycleLong = cycleLong
        self.signalType = signalType
        self.defaultValue = defaultValue
        self.signalName = signalName
        '''
        0     --------------------
        1    /                    \
        2   x        str           x==============
        3    \                    /               
        4     --------------------            
        '''
        self.outputStr = [ "" for i in range(5)]

        self.currentType = self.defaultValue

        if not signalType in ['BUS', 'SIGNAL']:
            raise Exception("Error : signal type is 'BUS' or 'SIGNAL' ")
        if signalType == 'BUS':
            self.__initBUS()
        else:
            if defaultValue == 'H':
                self.__initSignalHight()
            elif defaultValue == 'L':
                self.__initSignalLower()
            else:
                self.__initSignalNCare()

    # ======================== init function ============================

    def __initBUS(self):
        self.outputStr[0] += self.outputStr[0] + '=='
        self.outputStr[1] += self.outputStr[1] + '  '
        self.outputStr[2] += self.outputStr[2] + '  '
        self.outputStr[3] += self.outputStr[3] + '  '
        self.outputStr[4] += self.outputStr[4] + '=='

    def __initSignalHight(self):
        self.outputStr[0] += self.outputStr[0] + '--'
        self.outputStr[1] += self.outputStr[1] + '  '
        self.outputStr[2] += self.outputStr[2] + '  '
        self.outputStr[3] += self.outputStr[3] + '  '
        self.outputStr[4] += self.outputStr[4] + '  '

    def __initSignalLower(self):
        self.outputStr[0] += self.outputStr[0] + '  '
        self.outputStr[1] += self.outputStr[1] + '  '
        self.outputStr[2] += self.outputStr[2] + '  '
        self.outputStr[3] += self.outputStr[3] + '  '
        self.outputStr[4] += self.outputStr[4] + '--'

    def __initSignalNCare(self):
        self.outputStr[0] += self.outputStr[0] + '--'
        self.outputStr[1] += self.outputStr[1] + '  '
        self.outputStr[2] += self.outputStr[2] + '  '
        self.outputStr[3] += self.outputStr[3] + '  '
        self.outputStr[4] += self.outputStr[4] + '--'

    # ======================== init function ============================
    
    # ======================== change function ============================

    def __BUSToChange(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '*   *'
        self.outputStr[1] += ' \ / '
        self.outputStr[2] += '  x  '
        self.outputStr[3] += ' / \ '
        self.outputStr[4] += '*   *'
        self.outputStr[0] += '=' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '=' * cycleLong

    def __BUSToNChange(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '====='
        self.outputStr[1] += '     '
        self.outputStr[2] += '     '
        self.outputStr[3] += '     '
        self.outputStr[4] += '====='
        self.outputStr[0] += '=' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '=' * cycleLong

    def __SignalHighToLower(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '*    '
        self.outputStr[1] += ' \   '
        self.outputStr[2] += '  \  '
        self.outputStr[3] += '   \ '
        self.outputStr[4] += '    *'
        self.outputStr[0] += ' ' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '-' * cycleLong

    def __SignalHighToHigh(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '-----'
        self.outputStr[1] += '     '
        self.outputStr[2] += '     '
        self.outputStr[3] += '     '
        self.outputStr[4] += '     '
        self.outputStr[0] += '-' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += ' ' * cycleLong

    def __SignalLowerToLower(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '     '
        self.outputStr[1] += '     '
        self.outputStr[2] += '     '
        self.outputStr[3] += '     '
        self.outputStr[4] += '-----'
        self.outputStr[0] += ' ' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '-' * cycleLong

    def __SignalLowerToHigh(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '    *'
        self.outputStr[1] += '   / '
        self.outputStr[2] += '  /  '
        self.outputStr[3] += ' /   '
        self.outputStr[4] += '*    '
        self.outputStr[0] += '-' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += ' ' * cycleLong

    def __SignalNCareToNcare(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '-----'
        self.outputStr[1] += '     '
        self.outputStr[2] += '     '
        self.outputStr[3] += '     '
        self.outputStr[4] += '-----'
        self.outputStr[0] += '-' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '-' * cycleLong

    def __SignalNCareToHigh(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '----*'
        self.outputStr[1] += '   / '
        self.outputStr[2] += '  /  '
        self.outputStr[3] += ' /   '
        self.outputStr[4] += '*    '
        self.outputStr[0] += '-' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += ' ' * cycleLong

    def __SignalNCareToLower(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '*    '
        self.outputStr[1] += ' \   '
        self.outputStr[2] += '  \  '
        self.outputStr[3] += '   \ '
        self.outputStr[4] += '----*'
        self.outputStr[0] += ' ' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '-' * cycleLong

    def __SignalHighToNCare(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '*----'
        self.outputStr[1] += ' \   '
        self.outputStr[2] += '  \  '
        self.outputStr[3] += '   \ '
        self.outputStr[4] += '    *'
        self.outputStr[0] += '-' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '-' * cycleLong
    
    def __SignalLowerToNCare(self, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        self.outputStr[0] += '    *'
        self.outputStr[1] += '   / '
        self.outputStr[2] += '  /  '
        self.outputStr[3] += ' /   '
        self.outputStr[4] += '*----'
        self.outputStr[0] += '-' * cycleLong
        self.outputStr[1] += ' ' * cycleLong
        self.outputStr[2] += showStr + ' ' * (cycleLong - len(showStr)) 
        self.outputStr[3] += ' ' * cycleLong
        self.outputStr[4] += '-' * cycleLong

    # ======================== change function ============================

    def addToChange(self, changeToType, showStr = None, cycleLong = None):
        cycleLong = cycleLong if cycleLong else self.cycleLong
        showStr = showStr if showStr else ''
        if self.signalType == "BUS":
            if changeToType == 'C':
                self.__BUSToChange(showStr,cycleLong)
            else:
                self.__BUSToNChange(showStr,cycleLong)
        else:
            if self.currentType == 'H':
                if changeToType == 'H':
                    self.__SignalHighToHigh(showStr,cycleLong)
                elif changeToType == 'L':
                    self.__SignalHighToLower(showStr,cycleLong)
                elif changeToType == 'N':
                    self.__SignalHighToNCare(showStr,cycleLong)
                else:
                    raise Exception("Error : change type BUS:'' Signal:'H','L','N'")
            elif self.currentType == 'L':
                if changeToType == 'H':
                    self.__SignalLowerToHigh(showStr,cycleLong)
                elif changeToType == 'L':
                    self.__SignalLowerToLower(showStr,cycleLong)
                elif changeToType == 'N':
                    self.__SignalLowerToNCare(showStr,cycleLong)
                else:
                    raise Exception("Error : change type BUS:'' Signal:'H','L','N'")
            elif self.currentType == 'N':
                if changeToType == 'H':
                    self.__SignalNCareToHigh(showStr,cycleLong)
                elif changeToType == 'L':
                    self.__SignalNCareToLower(showStr,cycleLong)
                elif changeToType == 'N':
                    self.__SignalNCareToNcare(showStr,cycleLong)
                else:
                    raise Exception("Error : change type BUS:'' Signal:'H','L','N'")
        self.currentType = changeToType

    def showSignal(self,nameLong=None):
        nameLong = nameLong if nameLong else self.cycleLong
        for n in range(5):
            if n == 2:
                print(self.signalName+' '*(nameLong-len(self.signalName))+self.outputStr[n])
            else:
                print(' '*nameLong+self.outputStr[n])

# test 
if __name__ == '__main__':
    b = signal('bus',10,"BUS","x")
    b.addToChange("C","aaa")
    b.addToChange("C","xxx")
    b.addToChange("","xxx")
    b.showSignal()
    s = signal('clk',10,"SIGNAL","N")
    s.addToChange("L","lll")
    s.addToChange("L","lll")
    s.addToChange("N","nnn")
    s.addToChange("H","hh")
    s.showSignal()
