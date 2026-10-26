import pexpect
from pexpect import popen_spawn

cmd = "ls -la"
result = pexpect.run(cmd) # $ getCommand=cmd
result = pexpect.runu(cmd) # $ getCommand=cmd
result = pexpect.spawn(cmd) # $ getCommand=cmd
result = pexpect.spawnu(cmd) # $ getCommand=cmd
result = popen_spawn.PopenSpawn(cmd) # $ getCommand=cmd