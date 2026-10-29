import re
#Regular expression that includes a dollar, but not at the end.
matcher = re.compile(r"\.\(\w+$\)")

def find_it(filename):
    if matcher.match(filename):
        print("Found it!")

#Regular expression anchored to end of input.
fixed_matcher = re.compile(r"\.\(\w+\)$")