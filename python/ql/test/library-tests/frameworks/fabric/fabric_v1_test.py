"""tests for the 'fabric' package (v1.x)

See http://docs.fabfile.org/en/1.14/tutorial.html
"""

from fabric.api import run, local, sudo

local("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
run("cmd1; cmd2")  # $getCommand="cmd1; cmd2"
sudo("cmd1; cmd2")  # $getCommand="cmd1; cmd2"

local(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
run(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
sudo(command="cmd1; cmd2")  # $getCommand="cmd1; cmd2"
