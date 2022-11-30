from create_database_utils import *

import platform

if platform.system() == 'Darwin':
    import subprocess

    sdk = subprocess.check_output(['xcrun', '-show-sdk-path']).strip()
    frontend = subprocess.check_output(['xcrun', '-find', 'swift-frontend']).strip()
else:
    sdk = ''
    frontend = 'swift-frontend'

run_codeql_database_create([
    f'{frontend} -frontend -c A.swift {sdk}',
    f'{frontend} -frontend -c B.swift -o B.o {sdk}',
    f'{frontend} -frontend -c -primary-file C.swift {sdk}',
    f'{frontend} -frontend -c -primary-file D.swift -o D.o {sdk}',
    f'{frontend} -frontend -c -primary-file E.swift Esup.swift -o E.o {sdk}',
], lang='swift')
