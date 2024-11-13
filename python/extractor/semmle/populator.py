import sys
import os
import subprocess
from ast import literal_eval

from semmle import logging
from semmle import traverser
from semmle import cmdline
from semmle import worker
from semmle.util import VERSION, update_analysis_version, get_analysis_major_version
from buildtools.version import executable

'''The populator generates trap files from a Python project.
The populator consists of two parts: a traverser front end which traverses the file
system and multiple worker back ends which extract information from the modules.
'''

#NOTE: The front-end is simply an iterable of "extractables" and it should be easy to
#plug-in new front-ends if needed.

def cleanup_sys_path(path):
    '''Clean up sys.path removing duplicates and
    current working directory, making it safe for analysis.
    '''
    #Remove duplicates
    path = [ p for i, p  in enumerate(path) if i == 0 or p != path[i-1] ]
    #Remove curent working directory
    cwd = os.getcwd()
    if cwd in path:
        path.remove(cwd)
    return path

def get_py2_sys_path(logger, py3_sys_path):
    '''Get the sys.path for Python 2, if it is available. If no Python 2 is available,
    simply return the Python 3 sys.path. Returns a tuple of the sys.path and a boolean indicating
    whether Python 2 is available.'''
    try:
        command = " ".join(executable(2) + ['-c "import sys; print(sys.path)"'])
        # We need `shell=True` here in order for the test framework to function correctly. For
        # whatever reason, the `PATH` variable is ignored if `shell=False`.
        # Also, this in turn forces us to give the whole command as a string, rather than a list.
        # Otherwise, the effect is that the Python interpreter is invoked _as a REPL_, rather than
        # with the given piece of code.
        output = subprocess.check_output(command, shell=True).decode(sys.getfilesystemencoding())
        py2_sys_path = literal_eval(output)
        # Ensure that the first element of the sys.path is the same as the Python 3 sys.path --
        # specifically a reference to our local `tools` directory. This ensures that the `six` stubs
        # are picked up from there. The item we're overwriting here is '', which would be cleaned up
        # later anyway.
        py2_sys_path[0] = py3_sys_path[0]
        return py2_sys_path, True
    except (subprocess.CalledProcessError, ValueError, SyntaxError) as e:
        logger.error("Error while getting Python 2 sys.path:")
        logger.error(e)
        logger.info("No Python 2 found. Using Python 3 sys.path.")
        return py3_sys_path, False

def main(sys_path = sys.path[:]):
    options, args = cmdline.parse(sys.argv[1:])
    logger = logging.Logger(options.verbosity, options.colorize)
    # This is not the prettiest way to do it, but when running tests we want to ensure that the
    # `--lang` flag influences the analysis version (e.g. so that we include the correct stdlib TRAP
    # file). So, we change the values of the appropriate variables (which would otherwise be based
    # on `CODEQL_EXTRACTOR_PYTHON_ANALYSIS_VERSION`), overwriting the previous values.
    if options.language_version:
        last_version = options.language_version[-1]
        update_analysis_version(last_version)

    found_py2 = False
    if get_analysis_major_version() == 2 and options.extract_stdlib:
        # Setup `sys_path` to use the Python 2 standard library
        sys_path, found_py2 = get_py2_sys_path(logger, sys_path)

    # use utf-8 as the character encoding for stdout/stderr to be able to properly
    # log/print things on systems that use bad default encodings (windows).
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')

    sys.setrecursionlimit(2000)
    sys_path = cleanup_sys_path(sys_path)
    options.sys_path = sys_path[1:]

    if sys.version_info.major == 2:
        logger.error("Extraction using Python 2 is not supported.")
        logger.warning("To use the Python extractor, please ensure that Python 3 is available on your system.")
        logger.warning("For more information, see https://codeql.github.com/docs/codeql-overview/system-requirements/#additional-software-requirements")
        logger.warning("and https://codeql.github.com/docs/codeql-overview/supported-languages-and-frameworks/#languages-and-compilers")
        logger.close()
        logging.stop()
        sys.exit(1)
    elif found_py2:
        logger.info("Extraction will use the Python 2 standard library.")
    else:
        logger.info("Extraction will use the Python 3 standard library.")
    logger.info("sys_path is: %s", sys_path)
    try:
        the_traverser = traverser.Traverser(options, args, logger)
    except Exception as ex:
        logger.error("%s", ex)
        logger.close()
        logging.stop()
        sys.exit(1)
    run(options, args, the_traverser, logger)


def run(options, args, the_traverser, logger: logging.Logger):
    logger.info("Python version %s", sys.version.split()[0])
    logger.info("Python extractor version %s", VERSION)
    if 'CODEQL_EXTRACTOR_PYTHON_SOURCE_ARCHIVE_DIR' in os.environ:
        archive = os.environ['CODEQL_EXTRACTOR_PYTHON_SOURCE_ARCHIVE_DIR']
    elif 'SOURCE_ARCHIVE' in os.environ:
        archive = os.environ['SOURCE_ARCHIVE']
    else:
        archive = None
    trap_dir = cmdline.output_dir_from_options_and_env(options)
    try:
        pool = worker.ExtractorPool.from_options(options, trap_dir, archive, logger)
    except ValueError as ve:
        logger.error("%s", ve)
        logger.close()
        sys.exit(1)
    try:
        exitcode = 0
        pool.extract(the_traverser)
    except worker.ExtractorFailure:
        exitcode = 1
    except KeyboardInterrupt:
        exitcode = 2
        logger.info("Keyboard interrupt")
    except BaseException as ex:
        exitcode = 3
        logger.error("Unexpected exception: %s ", ex)
        logger.traceback(logging.WARN)
    finally:
        if exitcode:
            logger.debug("Stopping...")
            pool.stop()
        else:
            logger.debug("Writing interpreter trap")
            pool.close()
        logger.close()
        logging.stop()
        logger.write_message(logging.DEBUG, "Stopped." if exitcode else "Done.")
        if exitcode:
            sys.exit(exitcode)

if __name__ == "__main__":
    main()
