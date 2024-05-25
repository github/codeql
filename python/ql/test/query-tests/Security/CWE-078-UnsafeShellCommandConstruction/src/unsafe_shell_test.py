import os
import subprocess

def unsafe_shell_one(name):
    os.system("ping " + name) # $result=BAD

    # f-strings
    os.system(f"ping {name}") # $result=BAD

    # array.join
    os.system("ping " + " ".join(name)) # $result=BAD

    # array.join, with a list
    os.system("ping " + " ".join([name])) # $result=BAD

    # format, using .format
    os.system("ping {}".format(name)) # $result=BAD

    # format, using %
    os.system("ping %s" % name) # $result=BAD

    os.system(name) # OK - seems intentional.

import fabric

def facbric_stuff (name): 
    fabric.api.run("ping " + name, shell=False) # OK

    fabric.api.run("ping " + name, shell=True) # $result=BAD

    def indirect(flag): 
        fabric.api.run("ping " + name, shell=flag) # OK

    indirect(False)

def subprocess_flag (name): 
    subprocess.run("ping " + name, shell=False) # OK - and nonsensical

    subprocess.run("ping " + name, shell=True) # $result=BAD

    def indirect(flag, x): 
        subprocess.run("ping " + x, shell=flag) # $result=BAD

    indirect(True, name)

    subprocess.Popen("ping " + name, shell=unknownValue) # OK - shell assumed to be False

def intentional(command): 
    os.system("fish -ic " + command) # $result=OK - intentional

import shlex
def unsafe_shell_sanitized(name): 
    os.system("ping " + shlex.quote(name)) # $result=OK - sanitized