import sys
import os

from buildtools import version

DEFAULT_VERSION = 3

def get_relative_root(root_identifiers):
    if any([os.path.exists(identifier) for identifier in root_identifiers]):
        print("Source root appears to be the real root.")
        return "."

    found = set()
    for directory in next(os.walk("."))[1]:
        if any([os.path.exists(os.path.join(directory, identifier)) for identifier in root_identifiers]):
            found.add(directory)
    if not found:
        print("No directories containing root identifiers were found. Returning working directory as root.")
        return "."
    if len(found) > 1:
        print("Multiple possible root directories found. Returning working directory as root.")
        return "."

    root = found.pop()
    print("'%s' appears to be the root." % root)
    return root

def get_root(*root_identifiers):
    return os.path.abspath(get_relative_root(root_identifiers))

REQUIREMENTS_TAG = "LGTM_PYTHON_SETUP_REQUIREMENTS_FILES"

def find_requirements(dir):
    if REQUIREMENTS_TAG in os.environ:
        val = os.environ[REQUIREMENTS_TAG]
        if val == "false":
            return []
        paths = [ os.path.join(dir, line.strip()) for line in val.splitlines() ]
        for p in paths:
            if not os.path.exists(p):
                raise IOError(p + " not found")
        return paths
    candidates = ["requirements.txt", "test-requirements.txt"]
    return [ path if os.path.exists(path) else "" for path in [ os.path.join(dir, file) for file in  candidates] ]

def discover(default_version=DEFAULT_VERSION):
    """Discover things about the Python checkout and return a version, root, requirement-files triple."""
    root = get_root("requirements.txt", "setup.py")
    v = version.best_version(root, default_version)
    # Unify the requirements or just get path to requirements...
    requirement_files = find_requirements(root)
    return v, root, requirement_files

def get_version(default_version=DEFAULT_VERSION):
    root = get_root("requirements.txt", "setup.py")
    return version.best_version(root, default_version)

def main():
    if len(sys.argv) > 1:
        print(discover(int(sys.argv[1])))
    else:
        print(discover())

if __name__ == "__main__":
    main()
