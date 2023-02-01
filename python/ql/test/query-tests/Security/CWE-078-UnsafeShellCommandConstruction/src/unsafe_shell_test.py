import os
import subprocess

def unsafe_shell_one(name):
    os.system("ping " + name) # $result=BAD

    # f-strings
    os.system(f"ping {name}") # $result=BAD
