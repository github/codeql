from create_database_utils import *

path = b'\xd2abcd.cs'

with open(path, 'w') as file:
  file.write('class X { }\n')

run_codeql_database_create([], lang="csharp", extra_args=["--extractor-option=buildless=true", "--extractor-option=cil=false"])
