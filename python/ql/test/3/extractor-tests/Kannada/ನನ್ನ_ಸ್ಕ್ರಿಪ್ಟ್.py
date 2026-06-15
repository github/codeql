# -*- coding: utf-8 -*-
import sys
from dbgimporter import import_and_enable_debugger
import_and_enable_debugger()
def ಏನಾದರೂ_ಮಾಡು():
    print('ಏನೋ ಮಾಡಿದೆ'.encode(sys.stdout.encoding, errors='replace'))


ಏನಾದರೂ_ಮಾಡು()
