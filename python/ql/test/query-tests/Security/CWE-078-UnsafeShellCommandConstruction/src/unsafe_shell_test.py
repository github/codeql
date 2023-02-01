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
