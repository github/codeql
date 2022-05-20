
import sys

def bump_version(version):
    try:
        parts = map(int, version.split('.'))
    except ValueError:
        fail('Current version is not numeric')
    parts[-1] += 1
    return '.'.join(map(str, parts))


def fail(message):
    print(message)
    sys.exit(1)

# To get the FP result reported in ODASA-6418, 
#bump_version must be called (directly or transitively) from the module scope
bump_version()
str.join
"".join
