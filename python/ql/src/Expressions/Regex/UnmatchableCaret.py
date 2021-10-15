import re
#Regular expression includes a caret, but not at the start.
matcher = re.compile(r"\[^.]*\.css")

def find_css(filename):
    if matcher.match(filename):
        print("Found it!")
        
#Regular expression for a css file name
fixed_matcher_css = re.compile(r"[^.]*\.css")

