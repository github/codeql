import os
import subprocess

def unsafe_shell_one(name): # $ Source
    os.system("ping " + name) # $ Alert result=BAD

    # f-strings
    os.system(f"ping {name}") # $ Alert result=BAD

    # array.join
    os.system("ping " + " ".join(name)) # $ Alert result=BAD

    # array.join, with a list
    os.system("ping " + " ".join([name])) # $ Alert result=BAD

    # format, using .format
    os.system("ping {}".format(name)) # $ Alert result=BAD

    # format, using %
    os.system("ping %s" % name) # $ Alert result=BAD

    os.system(name) # OK - seems intentional.

import fabric

def facbric_stuff (name): # $ Source
    fabric.api.run("ping " + name, shell=False) # OK

    fabric.api.run("ping " + name, shell=True) # $ Alert result=BAD

    def indirect(flag):
        fabric.api.run("ping " + name, shell=flag) # OK

    indirect(False)

def subprocess_flag (name): # $ Source
    subprocess.run("ping " + name, shell=False) # OK - and nonsensical

    subprocess.run("ping " + name, shell=True) # $ Alert result=BAD

    def indirect(flag, x):
        subprocess.run("ping " + x, shell=flag) # $ Alert result=BAD

    indirect(True, name)

    subprocess.Popen("ping " + name, shell=unknownValue) # OK - shell assumed to be False

def explicit_shell_interpreter(name): # $ Source
    subprocess.run(["sh", "-c", "ping " + name]) # $ Alert result=BAD
    # With `shell=True`, only the first sequence element is the outer shell's command.
    subprocess.run(["sh", "-c", "ping " + name], shell=True)

    if unknownValue:
        os.execl("/bin/sh", "sh", "-c", "ping " + name) # $ Alert result=BAD
        os.spawnl(os.P_WAIT, "/bin/sh", "sh", "-c", "ping " + name) # $ Alert result=BAD
        os.posix_spawn("/bin/sh", ["sh", "-c", "ping " + name], {}) # $ Alert result=BAD

def intentional(command):
    os.system("fish -ic " + command) # $ result=OK - intentional

def legacy_shell_helper(name):
    subprocess.getstatusoutput(["sh", "-c", "ping " + name])

import shlex
def unsafe_shell_sanitized(name):
    os.system("ping " + shlex.quote(name)) # $ result=OK - sanitized
