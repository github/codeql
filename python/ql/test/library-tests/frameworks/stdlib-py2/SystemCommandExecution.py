########################################
import os

os.popen2("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
os.popen3("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
os.popen4("cmd1; cmd2")  # $getCommand="cmd1; cmd2"


os.popen2(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
os.popen3(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
os.popen4(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"

# os.popen does not support keyword arguments, so this is a TypeError
os.popen(cmd="cmd1; cmd2")

########################################
import platform

platform.popen("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
platform.popen(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"

########################################
# popen2 was deprecated in Python 2.6, but still available in Python 2.7
import popen2

popen2.popen2("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.popen3("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.popen4("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.Popen3("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.Popen4("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

popen2.popen2(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.popen3(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.popen4(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.Popen3(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
popen2.Popen4(cmd="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
