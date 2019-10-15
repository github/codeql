import os as o
import subprocess as subp

# Vulnerable to wildcard injection
o.system("/bin/tar xvzf *")
o.system('/bin/chown *')
o.popen2('/bin/chmod *')
subp.Popen('/bin/chown *', shell=True)

# Not vulnerable to wildcard injection
subp.Popen('/bin/rsync *')
subp.Popen("/bin/chmod *")
subp.Popen(['/bin/chown', '*'])
subp.Popen(["/bin/chmod", sys.argv[1], "*"],
                 stdin=subprocess.PIPE, stdout=subprocess.PIPE)
o.spawnvp(os.P_WAIT, 'tar', ['tar', 'xvzf', '*'])
