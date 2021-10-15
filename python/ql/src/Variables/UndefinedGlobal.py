import math

angle = 0.01

sin(angle)       # NameError: name 'sin' is not defined (function imported from 'math')

math.sin(angle)  # 'sin' function now correctly defined

math.tan(angel)  # NameError: name 'angel' not defined (typographic error)

math.tan(angle)  # Global variable now correctly defined

