import a
import b
import c
import d
import e
import f

# Colours
if platform.system() == 'Windows':
    col_default = 0x07
    col_red = 0x0C
    col_green = 0x0A
else:
    col_default = '\033[0m'
    col_red = '\033[91m'
    col_green = '\033[92m'
col_current = None

def set_text_colour(col):
    global col_current
    if col_current is None or col_current != col:
        if not sys.stdout.isatty():
            pass # not on a terminal (e.g. output is being piped to file)
        elif (platform.system() == 'Windows'):
            # set the text colour using the Win32 API
            handle = ctypes.windll.kernel32.GetStdHandle(-11) # STD_OUTPUT_HANDLE
            ctypes.windll.kernel32.SetConsoleTextAttribute(handle, col)
        else:
            # set the text colour using a character code
            sys.stdout.write(col)
        col_current = col

def report(text, col = col_default):
    set_text_colour(col)
    print(text)
    set_text_colour(col_default)

