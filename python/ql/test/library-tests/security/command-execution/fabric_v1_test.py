"""tests for the 'fabric' package (v1.x)

See http://docs.fabfile.org/en/1.14/tutorial.html
"""

from fabric.api import run, local, sudo

local('echo local execution')
run('echo remote execution')
sudo('echo remote execution with sudo')
