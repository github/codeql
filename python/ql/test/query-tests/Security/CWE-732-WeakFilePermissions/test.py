import os
import stat

file = 'semmle/important_secrets'


os.chmod(file, 0o7) # BAD
os.chmod(file, 0o77) # BAD
os.chmod(file, 0o777) # BAD
os.chmod(file, 0o600) # GOOD
os.chmod(file, 0o550) # BAD
os.chmod(file, stat.S_IRWXU) # GOOD
os.chmod(file, stat.S_IWGRP) # BAD
os.chmod(file, 400) # BAD -- Decimal format.

os.open(file, 'w', 0o704) # BAD
