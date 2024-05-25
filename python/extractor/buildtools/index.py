import sys
import os
import subprocess
import csv

if sys.version_info < (3,):
    from urlparse import urlparse
    from urllib import url2pathname
else:
    from urllib.parse import urlparse
    from urllib.request import url2pathname

from buildtools import discover
from buildtools import install
from buildtools.version import executable, extractor_executable


INCLUDE_TAG = "LGTM_INDEX_INCLUDE"
EXCLUDE_TAG = "LGTM_INDEX_EXCLUDE"
FILTER_TAG = "LGTM_INDEX_FILTERS"
PATH_TAG = "LGTM_INDEX_IMPORT_PATH"
REPO_FOLDERS_TAG = "LGTM_REPOSITORY_FOLDERS_CSV"
REPO_EXCLUDE_KINDS = "metadata", "external"

# These are the levels that the CodeQL CLI supports, in order of increasing verbosity.
CLI_LOGGING_LEVELS = ['off', 'errors', 'warnings', 'progress', 'progress+', 'progress++', 'progress+++']

# These are the verbosity levels used internally in the extractor. The indices of these levels
# should match up with the corresponding constants in the semmle.logging module.
EXTRACTOR_LOGGING_LEVELS = ['off', 'errors', 'warnings', 'info', 'debug', 'trace']

def trap_cache():
    return os.path.join(os.environ["LGTM_WORKSPACE"], "trap_cache")

def split_into_options(lines, opt):
    opts = []
    for line in lines.split("\n"):
        line = line.strip()
        if line:
            opts.append(opt)
            opts.append(line)
    return opts

def get_include_options():
    if INCLUDE_TAG in os.environ:
        return split_into_options(os.environ[INCLUDE_TAG], "-R")
    else:
        src = os.environ["LGTM_SRC"]
        return [ "-R", src]

def get_exclude_options():
    options = []
    if EXCLUDE_TAG in os.environ:
        options.extend(split_into_options(os.environ[EXCLUDE_TAG], "-Y"))
    if REPO_FOLDERS_TAG not in os.environ:
        return options
    with open(os.environ[REPO_FOLDERS_TAG]) as csv_file:
        csv_reader = csv.reader(csv_file)
        next(csv_reader) # discard header
        for kind, url in csv_reader:
            if kind not in REPO_EXCLUDE_KINDS:
                continue
            try:
                path = url2pathname(urlparse(url).path)
            except:
                print("Unable to parse '" +  url + "' as file url.")
            else:
                options.append("-Y")
                options.append(path)
    return options

def get_filter_options():
    if FILTER_TAG in os.environ:
        return split_into_options(os.environ[FILTER_TAG], "--filter")
    else:
        return []

def get_path_options(version):
    # Before 2.17.1 it was possible to extract installed libraries
    # where this function would return ["-p", "/path/to/library"].
    # However, from 2.17.1 onwards, this is no longer supported.

    return []

def get_stdlib():
    return os.path.dirname(os.__file__)


def exclude_pip_21_3_build_dir_options():
    """
    Handle build/ dir from `pip install .` (new in pip 21.3)

    Starting with pip 21.3, in-tree builds are now the default (see
    https://pip.pypa.io/en/stable/news/#v21-3). This means that pip commands that build
    the package (like `pip install .` or `pip wheel .`), will leave a copy of all the
    package source code in `build/lib/<package-name>/`.

    If that is done before invoking the extractor, we will end up extracting that copy
    as well, which is very bad (especially for points-to performance). So with this
    function we try to find such folders, so they can be excluded from extraction.

    The only reliable sign is that inside the `build` folder, there must be a `lib`
    subfolder, and there must not be any ordinary files.

    When the `wheel` package is installed there will also be a `bdist.linux-x86_64`
    subfolder. Although most people have the `wheel` package installed, it's not
    required, so we don't use that in the logic.
    """

    # As a failsafe, we include logic to disable this functionality based on an
    # environment variable.
    #
    # Like PYTHONUNBUFFERED for Python, we treat any non-empty string as meaning the
    # flag is enabled.
    # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUNBUFFERED
    if os.environ.get("CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_PIP_BUILD_DIR_EXCLUDE"):
        return []

    include_dirs = set(get_include_options()[1::2])

    # For the purpose of exclusion, we normalize paths to their absolute path, just like
    # we do in the actual traverser.
    exclude_dirs = set(os.path.abspath(path) for path in get_exclude_options()[1::2])

    to_exclude = list()

    def walk_dir(dirpath):
        if os.path.abspath(dirpath) in exclude_dirs:
            return

        contents = os.listdir(dirpath)
        paths = [os.path.join(dirpath, c) for c in contents]
        dirs = [path for path in paths if os.path.isdir(path)]
        dirnames = [os.path.basename(path) for path in dirs]

        # Allow Python package such as `mypkg.build.lib`, so if we see an `__init__.py`
        # file in the current dir don't walk the tree further.
        if "__init__.py" in contents:
            return

        # note that we don't require that there by a `setup.py` present beside the
        # `build/` dir, since that is not required to build a package -- see
        # https://pgjones.dev/blog/packaging-without-setup-py-2020
        #
        # Although I didn't observe `pip install .` with a package that uses `poetry` as
        # the build-system leave behind a `build/` directory, that doesn't mean it
        # couldn't happen.
        if os.path.basename(dirpath) == "build" and "lib" in dirnames and dirs == paths:
            to_exclude.append(dirpath)
            return # no need to walk the sub directories

        for dir in dirs:
            # We ignore symlinks, as these can present infinite loops, and any folders
            # they can point to will be handled on their own anyway.
            if not os.path.islink(dir):
                walk_dir(dir)

    for top in include_dirs:
        walk_dir(top)

    options = []

    if to_exclude:
        print(
            "Excluding the following directories from extraction, since they look like "
            "in-tree build directories generated by pip: {}".format(to_exclude)
        )
        print(
            "You can disable this behavior by setting the environment variable "
            "CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_PIP_BUILD_DIR_EXCLUDE=1"
        )
        for dirpath in to_exclude:
            options.append("-Y")  # `-Y` is the same as `--exclude-file`
            options.append(dirpath)

    return options


def exclude_venvs_options():
    """
    If there are virtual environments (venv) present within the directory that is being
    extracted, we don't want to recurse into all of these and extract all the Python
    source code.

    This function tries to find such venvs, and produce the right options to ignore
    them.
    """

    # As a failsafe, we include logic to disable this functionality based on an
    # environment variable.
    #
    # Like PYTHONUNBUFFERED for Python, we treat any non-empty string as meaning the
    # flag is enabled.
    # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUNBUFFERED
    if os.environ.get("CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE"):
        return []

    include_dirs = set(get_include_options()[1::2])

    # For the purpose of exclusion, we normalize paths to their absolute path, just like
    # we do in the actual traverser.
    exclude_dirs = set(os.path.abspath(path) for path in get_exclude_options()[1::2])

    to_exclude = []

    def walk_dir(dirpath):
        if os.path.abspath(dirpath) in exclude_dirs:
            return

        paths = [os.path.join(dirpath, c) for c in os.listdir(dirpath)]
        dirs = [path for path in paths if os.path.isdir(path)]
        dirnames = [os.path.basename(path) for path in dirs]

        # we look for `<venv>/Lib/site-packages` (Windows) or
        # `<venv>/lib/python*/site-packages` (unix) without requiring any other files to
        # be present.
        #
        # Initially we had implemented some more advanced logic to only ignore venvs
        # that had a `pyvenv.cfg` or a suitable activate scripts. But reality turned out
        # to be less reliable, so now we just ignore any venv that has a proper
        # `site-packages` as a subfolder.
        #
        # This logic for detecting a virtual environment was based on the CPython implementation, see:
        # - https://github.com/python/cpython/blob/4575c01b750cd26377e803247c38d65dad15e26a/Lib/venv/__init__.py#L122-L131
        # - https://github.com/python/cpython/blob/4575c01b750cd26377e803247c38d65dad15e26a/Lib/venv/__init__.py#L170
        #
        # Some interesting examples:
        # - windows without `activate`: https://github.com/NTUST/106-team4/tree/7f902fec29f68ca44d4f4385f2d7714c2078c937/finalPage/finalVENV/Scripts
        # - windows with `activate`: https://github.com/Lynchie/KCM/tree/ea9eeed07e0c9eec41f9fc7480ce90390ee09876/VENV/Scripts
        # - without `pyvenv.cfg`: https://github.com/FiacreT/M-moire/tree/4089755191ffc848614247e98bbb641c1933450d/osintplatform/testNeo/venv
        # - without `pyvenv.cfg`: https://github.com/Lynchie/KCM/tree/ea9eeed07e0c9eec41f9fc7480ce90390ee09876/VENV
        # - without `pyvenv.cfg`: https://github.com/mignonjia/NetworkingProject/tree/a89fe12ffbf384095766aadfe6454a4c0062d1e7/crud/venv
        #
        # I'm quite sure I saw some project on LGTM that had neither `pyvenv.cfg` or an activate script, but I could not find the reference again.

        if "Lib" in dirnames:
            has_site_packages_folder = os.path.exists(os.path.join(dirpath, "Lib", "site-packages"))
        elif "lib" in dirnames:
            lib_path = os.path.join(dirpath, "lib")
            python_folders = [dirname for dirname in os.listdir(lib_path) if dirname.startswith("python")]
            has_site_packages_folder = bool(python_folders) and any(
                os.path.exists(os.path.join(dirpath, "lib", python_folder, "site-packages")) for python_folder in python_folders
            )
        else:
            has_site_packages_folder = False

        if has_site_packages_folder:
            to_exclude.append(dirpath)
            return # no need to walk the sub directories

        for dir in dirs:
            # We ignore symlinks, as these can present infinite loops, and any folders
            # they can point to will be handled on their own anyway.
            if not os.path.islink(dir):
                walk_dir(dir)

    for top in include_dirs:
        walk_dir(top)

    options = []

    if to_exclude:
        print(
            "Excluding the following directories from extraction, since they look like "
            "virtual environments: {}".format(to_exclude)
        )
        print(
            "You can disable this behavior by setting the environment variable "
            "CODEQL_EXTRACTOR_PYTHON_DISABLE_AUTOMATIC_VENV_EXCLUDE=1"
        )

        for dirpath in to_exclude:
            options.append("-Y")  # `-Y` is the same as `--exclude-file`
            options.append(dirpath)

    return options

def get_extractor_logging_level(s: str):
    """Returns a integer value corresponding to the logging level specified by the string s, or `None` if s is invalid."""
    try:
        return EXTRACTOR_LOGGING_LEVELS.index(s)
    except ValueError:
        return None

def get_cli_logging_level(s: str):
    """Returns a integer value corresponding to the logging level specified by the string s, or `None` if s is invalid."""
    try:
        return CLI_LOGGING_LEVELS.index(s)
    except ValueError:
        return None

def get_logging_options():
    # First look for the extractor-specific option
    verbosity_level = os.environ.get("CODEQL_EXTRACTOR_PYTHON_OPTION_LOGGING_VERBOSITY", None)
    if verbosity_level is not None:
        level = get_extractor_logging_level(verbosity_level)
        if level is None:
            level = get_cli_logging_level(verbosity_level)
            if level is None:
                # This is unlikely to be reached in practice, as the level should be validated by the CLI.
                raise ValueError(
                    "Invalid verbosity level: {}. Valid values are: {}".format(
                        verbosity_level, ", ".join(set(EXTRACTOR_LOGGING_LEVELS + CLI_LOGGING_LEVELS))
                    )
                )
        return ["--verbosity", str(level)]

    # Then look for the CLI-wide option
    cli_verbosity_level = os.environ.get("CODEQL_VERBOSITY", None)
    if cli_verbosity_level is not None:
        level = get_cli_logging_level(cli_verbosity_level)
        if level is None:
            # This is unlikely to be reached in practice, as the level should be validated by the CLI.
            raise ValueError(
                "Invalid verbosity level: {}. Valid values are: {}".format(
                    cli_verbosity_level, ", ".join(CLI_LOGGING_LEVELS)
                )
            )
        return ["--verbosity", str(level)]

    # Default behaviour: turn on verbose mode:
    return ["-v"]


def extractor_options(version):
    options = []

    options += get_logging_options()

    # use maximum number of processes
    options += ["-z", "all"]

    # cache trap files
    options += ["-c", trap_cache()]

    options += get_path_options(version)
    options += get_include_options()
    options += get_exclude_options()
    options += get_filter_options()
    options += exclude_pip_21_3_build_dir_options()
    options += exclude_venvs_options()

    return options


def site_flag(version):
    #
    # Disabling site with -S (which we do by default) has been observed to cause
    # problems at some customers. We're not entirely sure enabling this by default is
    # going to be 100% ok, so for now we just want to disable this flag if running with
    # it turns out to be a problem (which we check for).
    #
    # see https://docs.python.org/3/library/site.html
    #
    # I don't see any reason for running with -S when invoking the tracer in this
    # scenario. If we were using the executable from a virtual environment after
    # installing PyPI packages, running without -S would allow one of those packages to
    # influence the behavior of the extractor, as was the problem for CVE-2020-5252
    # (described in https://github.com/akoumjian/python-safety-vuln). But since this is
    # not the case, I don't think there is any advantage to running with -S.

    # Although we have an automatic way that should detect when we should not be running
    # with -S, we're not 100% certain that it is not possible to create _other_ strange
    # Python installations where `gzip` could be available, but the rest of the standard
    # library still not being available. Therefore we're going to keep this environment
    # variable, just to make sure there is an easy fall-back in those cases.
    #
    # Like PYTHONUNBUFFERED for Python, we treat any non-empty string as meaning the
    # flag is enabled.
    # https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUNBUFFERED
    if os.environ.get("CODEQL_EXTRACTOR_PYTHON_ENABLE_SITE"):
        return []

    try:
        # In the cases where customers had problems, `gzip` was the first module
        # encountered that could not be loaded, so that's the one we check for. Note
        # that this has nothing to do with it being problematic to add GZIP support to
        # Python :)
        args = executable(version) + ["-S", "-c", "import gzip"]
        subprocess.check_call(args)
        return ["-S"]
    except (subprocess.CalledProcessError, Exception):
        print("Running without -S")
        return []

def get_analysis_version(major_version):
    """Gets the version of Python that we _analyze_ the code as being written for.
    The return value is a string, e.g. "3.11" or "2.7.18". Populating the `major_version`,
    `minor_version` and `micro_version` predicates is done inside the CodeQL libraries.
    """
    # If the version is already specified, simply reuse it.
    if "CODEQL_EXTRACTOR_PYTHON_ANALYSIS_VERSION" in os.environ:
        return os.environ["CODEQL_EXTRACTOR_PYTHON_ANALYSIS_VERSION"]
    elif major_version == 2:
        return "2.7.18" # Last officially supported version
    else:
        return "3.12" # This should always be the latest supported version


def main():
    version = discover.get_version()
    tracer = os.path.join(os.environ["SEMMLE_DIST"], "tools", "python_tracer.py")
    args = extractor_executable() + site_flag(3) + [tracer] + extractor_options(version)
    print("Calling " + " ".join(args))
    sys.stdout.flush()
    sys.stderr.flush()
    env = os.environ.copy()
    env["CODEQL_EXTRACTOR_PYTHON_ANALYSIS_VERSION"] = get_analysis_version(version)
    subprocess.check_call(args, env=env)

if __name__ == "__main__":
     main()
