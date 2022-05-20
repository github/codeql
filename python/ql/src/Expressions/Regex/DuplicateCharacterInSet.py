import re
matcher = re.compile(r"[password|pwd]")

def find_password(data):
    if matcher.match(data):
        print("Found password!")
