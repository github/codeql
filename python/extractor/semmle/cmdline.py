from optparse import OptionParser, OptionGroup, HelpFormatter
import shlex
import sys
import os
import re

from semmle import logging
from semmle.util import VERSION


def make_parser():
    '''Parse command_line, returning options, arguments'''
    parser = OptionParser(add_help_option=False, version='%s' % VERSION)

    import_options = OptionGroup(parser, "Import following options",
        description="Note that -a -n -g and -t are included for backwards compatibility. They are ignored")
    import_options.add_option("--max-import-depth", dest="max_import_depth",
                      help="The maximum depth of imports to follow before halting.",
                      default=None)
    import_options.add_option("-p", "--path", dest="path", default=[], action="append",
                      help="Search path for python modules.")
    import_options.get_option("-p").long_help = (
        "This is the path that the extractor uses when searching for imports. This path is searched before sys.path. "+
        "If the search path (sys.path) during program execution includes any paths that are not in 'sys.path' during extraction, " +
        "then those paths need to be included using this flag.")
    import_options.add_option("-x", "--excludepath", dest="exclude", default=[], action="append",
                      help="Exclude from search path for importing modules.")
    import_options.get_option("-x").long_help = (
        "Excludes this path and all its sub-paths when searching for imports. " +
        "Useful for excluding sub folders of paths specified with the '-p' option, or for excluding items in the 'sys.path' list.")
    import_options.add_option("-a", "--all-imports", dest="all",
                      help="Ignored", default=False, action="store_true")
    import_options.add_option("-n", "--no-imports", dest="none",
                      help="Ignored", default=False, action="store_true")
    import_options.add_option("-g", "--guess-imports", dest="guess",
                          help="Ignored", default=False, action="store_true")
    import_options.add_option("-t", "--top-imports", dest="top",
                      help="Ignored", default=False, action="store_true")
    parser.add_option_group(import_options)

    module_options = OptionGroup(parser, "Options to determine which modules are to be extracted",
        description="When specifying a list of values, individual values should be separated by the OS path separator for paths, and by commas for names.")
    module_options.add_option("-m", "--main", dest="main",
                      help="A list of files which can be run as the main (or application) script.",
                      default=[], action="append")
    module_options.get_option("-m").long_help = (
        "Files included in the database as 'main' modules will have the name '__main__' rather than a name derived from the path. " +
        "It is perfectly legal to have several '__main__' modules in the database.")
    module_options.add_option("-r", "--recurse-package", dest="recursive", default=[], action="append",
                      help="DEPRECATED. Analyze all modules in this comma-separated list of packages (recursively).")
    module_options.add_option("-y", "--exclude-package", dest="exclude_package", default=[], action="append",
                      help="IGNORED.")
    module_options.add_option("-Y", "--exclude-file", dest="exclude_file", default=[], action="append",
                      help="Exclude file from recursive search of files. Will not affect recursive search by package.")
    module_options.add_option("--filter", dest="path_filter", default=[], action="append",
                      help="""Filter to apply to files from recursive search of files. Will not affect recursive search by package.
                      Filters are of the form [include|exclude]:GLOB_PATTERN""")
    module_options.add_option("--exclude-pattern", dest="exclude_pattern",
                      help = """Exclude any modules matching this regular expression.""",
                      default=None)
    module_options.add_option("--respect-init", dest="respect_init",
                      help="Respect the presence of '__init__.py' files when considering whether a folder is "
                        "a package. Defaults to True for Python 2 and False for Python 3. "
                        "Legal values are 'True' or 'False' (case-insensitive).",
                      default = None)
    module_options.add_option("-F", "--files", dest="files", default=[], action="append",
                      help = """Treat the paths in this list as source files for modules. Compute the module name from given paths.""")
    module_options.add_option("-R", "--recurse-files", dest="recurse_files", default=[], action="append",
                      help = """Treat the paths in this list as paths for packages, then recurse. Compute the package name from given paths.""")
    parser.add_option_group(module_options)

    config_options = OptionGroup(parser, "Configuration options")
    config_options.add_option("-f","--file", dest="file", default=None,
                      help="File to read options from")
    config_options.add_option("-c", "--trap-cache", dest="trap_cache",
                      help="Directory in which to cache trap files.",
                      default=None)
    config_options.add_option("-z", "--max-procs", dest="max_procs", default=None,
                      help="Maximum number of processes, legal options are "
                      "'all', 'half'(the default) or any positive integer.")
    config_options.add_option("-j", "--introspect-c", dest="introspect_c",
                      help="Option is ignored (retained for backwards compatibility)",
                      default=False, action="store_true")
    config_options.add_option("--ignore-missing-modules", dest="ignore_missing_modules", default=False, action="store_true",
                      help = """Ignore any module specified on the command line that cannot be found. Defaults to false.""")
    config_options.add_option("-u", "--no-symlinks", dest="no_symlinks",
                      help="Do not follow sym-links when normalizing paths",
                      default=False, action="store_true")
    config_options.add_option("-e", "--renamer", dest="renamer",
                      help="""Module containing get_renamer() function which returns
                              a renaming function to be used when normalizing paths.""",
                      default=None)
    config_options.add_option("-o", "--outdir", dest="outdir",
                      help="Output directory for writing trap files.")
    config_options.add_option("--omit-syntax-errors", dest="no_syntax_errors",
                      help="Do not emit trap files or copy source for those files containing syntax errors",
                      default=False, action="store_true")
    config_options.get_option("-o").long_help = " Only useful when running the extractor independently of Semmle's toolchain."
    config_options.add_option("--max-context-cost", dest="context_cost", default=None,
                      help="""Specify the maximum cost of contexts in the points-to analysis.
                      WARNING: Setting this option may cause the analysis to consume a lot more time and memory than normal""")
    config_options.add_option("--colorize", dest="colorize", default=False, action="store_true",
                      help = """Colorize the logging output.""")

    config_options.add_option("--dont-extract-stdlib", dest="extract_stdlib", action="store_false",
        help="This flag is deprecated; not extracting the standard library is now the default.")
    config_options.add_option("--extract-stdlib", dest="extract_stdlib", default=False, action="store_true",
        help="Extract the standard library.")

    parser.add_option_group(config_options)

    debug_options = OptionGroup(parser, "Debug and information options")
    debug_options.add_option("-h", "--help", default=False, action="store_true",
                      help="show this help message and exit. Combine with -v for more details.")
    debug_options.add_option("-v", "--verbose", dest="verbose", help="Verbose output",
                      default=0, action="count")
    debug_options.add_option("--verbosity", dest="verbosity", help="Verbosity of output",
                      default=None)
    debug_options.add_option("--quiet", dest="quiet", help="Quiet output, only report errors or worse.",
                      default=0, action="count")
    debug_options.add_option("-q", "--trace-only", dest="trace_only",
                      help="Trace only, printing modules found. Do not create trap files.",
                      default=False, action="store_true")
    debug_options.add_option("--profile-out", dest="profile_out", default=None,
                      help="Write profiling information to the given file.")
    parser.add_option_group(debug_options)

    lang_options = OptionGroup(parser, "Options for handling sub-languages and extensions")

    # This is a temporary feature until we have full, transparent support for combined 2/3 analysis.
    # Slated to be removed before 1.12 so it should not be documented.
    lang_options.add_option("-l", "--lang", dest="language_version", default=[], action="append",
                              help="Override automatic language version detection and use specified versions(s)")

    parser.add_option_group(lang_options)

    advanced_options = OptionGroup(parser, "Advanced options: For running the extractor in unusual environments.")
    advanced_options.add_option("--dont-split-graph", dest="split", default=True, action="store_false",
                      help = """Do not perform splitting on the flow graph, this will result in increased performance,
                      but at the cost of decreased accuracy in the resulting database. Defaults to false.""")
    advanced_options.add_option("--dont-unroll-graph", dest="unroll", action="store_false",
                      help = """DEPRECATED. Do not use.
                      Do not perform selective loop unrolling on the flow graph. This will result in increased performance,
                      but at the cost of decreased accuracy in the resulting database. Defaults to true.""")
    advanced_options.add_option("--unroll-graph", dest="unroll", default=False, action="store_true",
                      help = """Perform selective loop unrolling on the flow graph. This may result in increased accuracy,
                      but at the cost of decreased performance in the resulting database. Defaults to false.""")

    parser.add_option_group(advanced_options)
    return parser

def strip_trailing_slash(path):
    '''Remove trailing slash from path for consistency'''
    while path.endswith(os.sep) and path != os.sep:
        path = path[:-1]
    return path

def parse(command_line):
    parser = make_parser()
    options, args = parser.parse_args(command_line)
    while options.file:
        with open(options.file) as opt_file:
            file_opts = shlex.split(opt_file.read())
        extra_options, extra_args = parser.parse_args(file_opts)
        options.file = None
        #The optparse.Values class does not provide a public method for updating.
        #This only works if all the defaults are a false value (which they are)
        for attr in dir(options):
            if attr in extra_options.__dict__:
                dval = extra_options.__dict__[attr]
                if dval:
                    setattr(options, attr, dval)
        args.extend(extra_args)
    del options.file
    if options.help:
        if options.verbose:
            for opt in parser._get_all_options():
                if hasattr(opt, "long_help"):
                    if opt.long_help.endswith("."):
                        opt.help += " " + opt.long_help
                    else:
                        opt.help += ". " + opt.long_help
        parser.print_help()
        if options.verbose:
            print(EXTRA_HELP)
        sys.exit(0)
    if options.respect_init is None:
        # In this case we cannot use `util.get_analysis_major_version` because it will only be
        # populated _after_ we've parsed the options.
        options.respect_init = any(version.startswith('2') for version in options.language_version)
    else:
        options.respect_init = options.respect_init.lower() == "true"
    options.main = split_and_flatten(options.main, os.pathsep)
    options.exclude = split_and_flatten(options.exclude, os.pathsep)
    options.recursive = split_and_flatten(options.recursive, ",")
    options.exclude_package = split_and_flatten(options.exclude_package, ",")
    options.files = split_and_flatten(options.files, os.pathsep)
    options.recurse_files = split_and_flatten(options.recurse_files, os.pathsep)
    options.path = split_and_flatten(options.path, os.pathsep)
    options.path = [strip_trailing_slash(item) for item in options.path]
    for name in options.recursive:
        verify_module_name(name)
    for name in options.exclude_package:
        verify_module_name(name)
    for name in args:
        verify_module_name(name)
    if options.verbosity is not None:
        try:
            options.verbosity = int(options.verbosity)
        except ValueError:
            print (options.verbosity + " is not a valid verbosity level.")
            sys.exit(1)
    else:
        options.verbosity = logging.WARN # default logging level
        options.verbosity -= options.quiet
        options.verbosity += options.verbose
    if options.verbosity > logging.TRACE:
        options.verbosity = logging.TRACE
    if options.verbosity < logging.OFF:
        options.verbosity = logging.OFF
    if options.max_import_depth is None:
        max_import_depth = float('inf')
    else:
        max_import_depth = int(options.max_import_depth)
    if max_import_depth < 0:
        max_import_depth = float('inf')
    options.max_import_depth = max_import_depth

    if 'CODEQL_EXTRACTOR_PYTHON_DONT_EXTRACT_STDLIB' in os.environ:
        options.extract_stdlib = False
        print ("WARNING: CODEQL_EXTRACTOR_PYTHON_DONT_EXTRACT_STDLIB is deprecated; the default is now to not extract the standard library.")

    if 'CODEQL_EXTRACTOR_PYTHON_EXTRACT_STDLIB' in os.environ:
        options.extract_stdlib = True

    options.prune = True

    if options.extract_stdlib:
        print ("WARNING: The analysis will extract the standard library. This behavior is deprecated and will be removed in a future release. We expect it to be gone in CLI version 2.20.0.")
    else:
        print ("INFO: The Python extractor has recently stopped extracting the standard library by default. If you encounter problems, please let us know by submitting an issue to https://github.com/github/codeql. It is possible to re-enable extraction of the standard library by setting the environment variable CODEQL_EXTRACTOR_PYTHON_EXTRACT_STDLIB.")

    return options, args

def split_and_flatten(options_list, div):
    result = []
    for item in options_list:
        result.extend(item.split(div))
    return result

def is_legal_module_name(name):
    for identifier in name.split("."):
        if not identifier.isidentifier():
            return False
    return True

def verify_module_name(name):
    if not is_legal_module_name(name):
        sys.exit("'%s' is not a legal module name" % name)

EXTRA_HELP = '''
When combining explicitly listed modules, or any options to include modules, with any option to exclude modules, the exclude options act as filters on the included modules.
Therefore if any module is both excluded and included by a command line option, then it will not be included in the database.
Note that exclusion of a module does not necessarily exclude the modules that are imported by that module.

For example, if module 'a' imports module 'b' and module 'c' also imports module 'b' and the extractor is called with "-y c a",
then 'c' will be excluded but 'b' will be included as it is imported by 'a'.

Exit codes:
    0. OK, finished normally
    1. Failed to extract one or more files.
    2. Interrupted (by ctrl-C or a signal)
    3. Other error.
'''

def output_dir_from_options_and_env(options):
    trap_dir = options.outdir
    if trap_dir is None:
        if 'CODEQL_EXTRACTOR_PYTHON_TRAP_DIR' in os.environ:
            trap_dir = os.environ['CODEQL_EXTRACTOR_PYTHON_TRAP_DIR']
        elif 'TRAP_FOLDER' in os.environ:
            trap_dir = os.environ['TRAP_FOLDER']
        else:
            raise IOError(
                "Cannot find trap folder. CODEQL_EXTRACTOR_PYTHON_TRAP_DIR is not set.")
    if not os.path.exists(trap_dir):
        os.makedirs(trap_dir)
    return trap_dir


class MarkdownFormatter (HelpFormatter):
    """Format help with underlined section headers.
    """

    def __init__(self,
                 indent_increment=0,
                 max_help_position=40,
                 width=1000,
                 short_first=0):
        HelpFormatter.__init__ (
            self, indent_increment, max_help_position, width, short_first)
        self.needs_table_heading = False

    def format_usage(self, usage):
        return "%s  %s\n" % (self.format_heading(_("Usage")), usage)

    def format_heading(self, heading):
        self.needs_table_heading = True
        return '%s %s\n' % ('#' * (self.level +3), heading)

    def format_description(self, description):
        return description + "\n"

    def format_option(self, option):
        if self.needs_table_heading:
            self.needs_table_heading = False
            header = "Flags | Description\n------|---------\n"
        else:
            header = ''
        opts = self.option_strings[option]
        return header + opts + " | " + option.help.replace("\n", " ") + "\n"

def _is_help_line(lines, index, pos):
    if index + 1 >= len(lines):
        return False
    if len(lines[index]) <= pos:
        return False
    if lines[index].startswith("#"):
        return False
    return True

def _format_parser_options():
    parser = make_parser()
    formatter = MarkdownFormatter()
    return parser.format_help(formatter)


if __name__ == "__main__":
    print(_format_parser_options())
