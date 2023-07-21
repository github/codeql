import os 

def unsafe_setup(name):
    os.system("ping " + name) # $result=OK - this is inside a setyp script, so it's fine.