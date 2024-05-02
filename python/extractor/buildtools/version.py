import sys
import os
import subprocess
import tokenize
import re

from buildtools.helper import print_exception_indented


TROVE = re.compile(r"Programming Language\s+::\s+Python\s+::\s+(\d)")

if sys.version_info > (3,):
    import collections.abc as collections
    file_open = tokenize.open
else:
    import collections
    file_open = open

WIN = sys.platform == "win32"

if WIN and "CODEQL_EXTRACTOR_PYTHON_OPTION_PYTHON_EXECUTABLE_NAME" not in os.environ:
    # installing `py` launcher is optional when installing Python on windows, so it's
    # possible that the user did not install it, see
    # https://github.com/github/codeql-cli-binaries/issues/125#issuecomment-1157429430
    # so we check whether it has been installed, and we check only if the "python_executable_name"
    # extractor option has not been specified. Newer versions have a `--list` option,
    # but that has only been mentioned in the docs since 3.9, so to not risk it not
    # working on potential older versions, we'll just use `py --version` which forwards
    # the `--version` argument to the default python executable.

    try:
        subprocess.check_call(["py", "--version"])
    except (subprocess.CalledProcessError, Exception):
        sys.stderr.write("The `py` launcher is required for CodeQL to work on Windows.")
        sys.stderr.write("Please include it when installing Python for Windows.")
        sys.stderr.write("see https://docs.python.org/3/using/windows.html#python-launcher-for-windows")
        sys.stderr.flush()
        sys.exit(4) # 4 was a unique exit code at the time of writing

AVAILABLE_VERSIONS = []

def set_available_versions():
    """Sets the global `AVAILABLE_VERSIONS` to a list of available (major) Python versions."""
    global AVAILABLE_VERSIONS
    if AVAILABLE_VERSIONS:
        return # already set
    for version in [3, 2]:
        try:
            subprocess.check_call(" ".join(executable_name(version) + ["-c", "pass"]), shell=True)
            AVAILABLE_VERSIONS.append(version)
        except Exception:
            pass # If not available, we simply don't add it to the list
    if not AVAILABLE_VERSIONS:
        # If neither 'python3' nor 'python2' is available, we'll just try 'python' and hope for the best
        AVAILABLE_VERSIONS = ['']

def executable(version):
    """Returns the executable to use for the given Python version."""
    global AVAILABLE_VERSIONS
    set_available_versions()
    if version not in AVAILABLE_VERSIONS:
        available_version = AVAILABLE_VERSIONS[0]
        print("Wanted to run Python %s, but it is not available. Using Python %s instead" % (version, available_version))
        version = available_version
    return executable_name(version)


def executable_name(version):
    if WIN:
        return ["py", "-%s" % version]
    else:
        return ["python%s" % version]

PREFERRED_PYTHON_VERSION = None

def extractor_executable():
    '''
    Returns the executable to use for the extractor.
    If a Python executable name is specified using the extractor option, returns that name.
    In the absence of a user-specified executable name, returns the executable name for
    Python 3 if it is available, and Python 2 if not.
    '''
    executable_name = os.environ.get("CODEQL_EXTRACTOR_PYTHON_OPTION_PYTHON_EXECUTABLE_NAME", None)
    if executable_name is not None:
        print("Using Python executable name provided via the python_executable_name extractor option: {}"
            .format(executable_name)
        )
        return [executable_name]
    # Call machine_version() to ensure we've set PREFERRED_PYTHON_VERSION
    if PREFERRED_PYTHON_VERSION is None:
        machine_version()
    return executable(PREFERRED_PYTHON_VERSION)

def machine_version():
    """If only Python 2 or Python 3 is installed, will return that version"""
    global PREFERRED_PYTHON_VERSION
    print("Trying to guess Python version based on installed versions")
    if sys.version_info > (3,):
        this, other = 3, 2
    else:
        this, other = 2, 3
    try:
        exe = executable(other)
        # We need `shell=True` here in order for the test framework to function correctly. For
        # whatever reason, the `PATH` variable is ignored if `shell=False`.
        # Also, this in turn forces us to give the whole command as a string, rather than a list.
        # Otherwise, the effect is that the Python interpreter is invoked _as a REPL_, rather than
        # with the given piece of code.
        subprocess.check_call(" ".join(exe + [ "-c", "pass" ]), shell=True)
        print("This script is running Python {}, but Python {} is also available (as '{}')"
            .format(this, other, ' '.join(exe))
        )
        # If both versions are available, our preferred version is Python 3
        PREFERRED_PYTHON_VERSION = 3
        return None
    except Exception:
        print("Only Python {} installed -- will use that version".format(this))
        PREFERRED_PYTHON_VERSION = this
        return this

def trove_version(root):
    print("Trying to guess Python version based on Trove classifiers in setup.py")
    try:
        full_path = os.path.join(root, "setup.py")
        if not os.path.exists(full_path):
            print("Did not find setup.py (expected it to be at {})".format(full_path))
            return None

        versions = set()
        with file_open(full_path) as fd:
            contents = fd.read()
        for match in TROVE.finditer(contents):
            versions.add(int(match.group(1)))

        if 2 in versions and 3 in versions:
            print("Found Trove classifiers for both Python 2 and Python 3 in setup.py -- will use Python 3")
            return 3
        elif len(versions) == 1:
            result = versions.pop()
            print("Found Trove classifier for Python {} in setup.py -- will use that version".format(result))
            return result
        else:
            print("Found no Trove classifiers for Python in setup.py")
    except Exception:
        print("Skipping due to exception:")
        print_exception_indented()
    return None

def wrap_with_list(x):
    if isinstance(x, collections.Iterable) and not isinstance(x, str):
        return x
    else:
        return [x]

def travis_version(root):
    print("Trying to guess Python version based on travis file")
    try:
        full_paths = [os.path.join(root, filename) for filename in [".travis.yml", "travis.yml"]]
        travis_file_paths = [path for path in full_paths if os.path.exists(path)]
        if not travis_file_paths:
            print("Did not find any travis files (expected them at either {})".format(full_paths))
            return None

        try:
            import yaml
        except ImportError:
            print("Found a travis file, but yaml library not available")
            return None

        with open(travis_file_paths[0]) as travis_file:
            travis_yaml = yaml.safe_load(travis_file)
        if "python" in travis_yaml:
            versions = wrap_with_list(travis_yaml["python"])
        else:
            versions = []

        # 'matrix' is an alias for 'jobs' now (https://github.com/travis-ci/docs-travis-ci-com/issues/1500)
        # If both are defined, only the last defined will be used.
        if "matrix" in travis_yaml and "jobs" in travis_yaml:
            print("Ignoring 'matrix' and 'jobs' in Travis file, since they are both defined (only one of them should be).")
        else:
            matrix = travis_yaml.get("matrix") or travis_yaml.get("jobs") or dict()
            includes = matrix.get("include") or []
            for include in includes:
                if "python" in include:
                    versions.extend(wrap_with_list(include["python"]))

        found = set()
        for version in versions:
            # Yaml may convert version strings to numbers, convert them back.
            version = str(version)
            if version.startswith("2"):
                found.add(2)
            if version.startswith("3"):
                found.add(3)

        if len(found) == 1:
            result = found.pop()
            print("Only found Python {} in travis file -- will use that version".format(result))
            return result
        elif len(found) == 2:
            print("Found both Python 2 and Python 3 being used in travis file -- ignoring")
        else:
            print("Found no Python being used in travis file")
    except Exception:
        print("Skipping due to exception:")
        print_exception_indented()
    return None

VERSION_TAG = "LGTM_PYTHON_SETUP_VERSION"

def best_version(root, default):
    if VERSION_TAG in os.environ:
        try:
            return int(os.environ[VERSION_TAG])
        except ValueError:
            raise SyntaxError("Illegal value for " + VERSION_TAG)
    print("Will try to guess Python version, as it was not specified in `lgtm.yml`")
    version = trove_version(root) or travis_version(root) or machine_version()
    if version is None:
        version = default
        print("Could not guess Python version, will use default: Python {}".format(version))
    return version
