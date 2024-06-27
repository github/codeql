import sys
import os
import subprocess
import re
import ast
import tempfile

from buildtools import unify_requirements
from buildtools.version import executable
from buildtools.version import WIN
from buildtools.helper import print_exception_indented

def call(args, cwd=None):
    print("Calling " + " ".join(args))
    sys.stdout.flush()
    sys.stderr.flush()
    subprocess.check_call(args, cwd=cwd)

class Venv(object):

    def __init__(self, path, version):
        self.environ = {}
        self.path = path
        exe_ext = [ "Scripts", "python.exe" ] if WIN else [ "bin", "python" ]
        self.venv_executable = os.path.join(self.path, *exe_ext)
        self._lib = None
        self.pip_upgraded = False
        self.empty_folder = tempfile.mkdtemp(prefix="empty", dir=os.environ["LGTM_WORKSPACE"])
        self.version = version

    def create(self):
        if self.version < 3:
            venv = ["-m", "virtualenv", "--never-download"]
        else:
            venv = ["-m", "venv"]
        call(executable(self.version) + venv + [self.path], cwd=self.empty_folder)

    def upgrade_pip(self):
        'Make sure that pip has been upgraded to latest version'
        if self.pip_upgraded:
            return
        self.pip([ "install", "--upgrade", "pip"])
        self.pip_upgraded = True

    def pip(self, args):
        call([self.venv_executable, "-m", "pip"] + args, cwd=self.empty_folder)

    @property
    def lib(self):
        if self._lib is None:
            try:
                tools = os.path.join(os.environ['SEMMLE_DIST'], "tools")
                get_venv_lib = os.path.join(tools, "get_venv_lib.py")
                if os.path.exists(self.venv_executable):
                    python_executable = [self.venv_executable]
                else:
                    python_executable = executable(self.version)
                args = python_executable + [get_venv_lib]
                print("Calling " + " ".join(args))
                sys.stdout.flush()
                sys.stderr.flush()
                self._lib = subprocess.check_output(args)
                if sys.version_info >= (3,):
                    self._lib = str(self._lib, sys.getfilesystemencoding())
                self._lib = self._lib.rstrip("\r\n")
            except:
                lib_ext = ["Lib"] if WIN else [ "lib" ]
                self._lib = os.path.join(self.path, *lib_ext)
                print('Error trying to run get_venv_lib (this is Python {})'.format(sys.version[:5]))
                print_exception_indented()
        return self._lib

def venv_path():
    return os.path.join(os.environ["LGTM_WORKSPACE"], "venv")

def system_packages(version):
    output = subprocess.check_output(executable(version) + [ "-c", "import sys; print(sys.path)"])
    if sys.version_info >= (3,):
        output = str(output, sys.getfilesystemencoding())
    paths = ast.literal_eval(output.strip())
    return [ path for path in paths if ("dist-packages" in path or "site-packages" in path) ]

REQUIREMENTS_TAG = "LGTM_PYTHON_SETUP_REQUIREMENTS"
EXCLUDE_REQUIREMENTS_TAG = "LGTM_PYTHON_SETUP_EXCLUDE_REQUIREMENTS"

def main(version, root, requirement_files):
    # We import `auto_install` here, as it has a dependency on the `packaging`
    # module. For the CodeQL CLI (where we do not install any packages) we never
    # run the `main` function, and so there is no need to always import this
    # dependency.
    from buildtools import auto_install
    print("version, root, requirement_files", version, root, requirement_files)
    venv = Venv(venv_path(), version)
    venv.create()
    if REQUIREMENTS_TAG in os.environ:
        if not auto_install.install(os.environ[REQUIREMENTS_TAG], venv):
            sys.exit(1)
    requirements_from_setup = os.path.join(os.environ["LGTM_WORKSPACE"], "setup_requirements.txt")
    args = [ venv.venv_executable, os.path.join(os.environ["SEMMLE_DIST"], "tools", "convert_setup.py"), root, requirements_from_setup] + system_packages(version)
    print("Calling " + " ".join(args))
    sys.stdout.flush()
    sys.stderr.flush()
    #We don't care if this fails, we only care if `requirements_from_setup` was created.
    subprocess.call(args)
    if os.path.exists(requirements_from_setup):
        requirement_files = [ requirements_from_setup ] + requirement_files[1:]
    print("Requirement files: " + str(requirement_files))
    requirements = unify_requirements.gather(requirement_files)
    if EXCLUDE_REQUIREMENTS_TAG in os.environ:
        excludes = os.environ[EXCLUDE_REQUIREMENTS_TAG].splitlines()
        print("Excluding ", excludes)
        regex = re.compile("|".join(exclude + r'\b' for exclude in excludes))
        requirements = [ req for req in requirements if not regex.match(req) ]
    err = 0 if auto_install.install(requirements, venv) else 1
    sys.exit(err)

def get_library(version):
    return Venv(venv_path(), version).lib

if __name__ == "__main__":
    version, root, requirement_files = sys.argv[1], sys.argv[2], sys.argv[3:]
    version = int(version)
    main(version, root, requirement_files)
