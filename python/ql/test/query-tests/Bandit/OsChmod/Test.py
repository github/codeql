import os
import stat

keyfile = 'foo'

os.chmod('/etc/passwd', 0o227)
os.chmod('/etc/passwd', 0o7)
os.chmod('/etc/passwd', 0o664)
os.chmod('/etc/passwd', 0o777)
os.chmod('/etc/passwd', 0o770)
os.chmod('/etc/passwd', 0o776)
os.chmod('/etc/passwd', 0o760)
os.chmod('~/.bashrc', 511)
os.chmod('/etc/hosts', 0o777)
os.chmod('/tmp/oh_hai', 0x1ff)
os.chmod('/etc/passwd', stat.S_IRWXU)
os.chmod(key_file, 0o777)
