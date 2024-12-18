
'''The traverser is the front-end of the Python extractor. It walks the file system yielding
a sequence of modules to be queued up and processed by the back-end.'''

import re
import os.path

from semmle.path_filters import filter_from_pattern
from semmle.util import Extractable, PY_EXTENSIONS, isdir, islink, listdir
from semmle.python import finder, modules
from semmle.worker import ExtractorFailure

try:
    FileNotFoundError
except NameError:
    FileNotFoundError = IOError

__all__ = [ 'Traverser' ]

class Traverser(object):
    '''Default iterable of extractables for the Python extractor,
    as specified by the command line options and environment variables.
    '''

    def __init__(self, options, modulenames, logger):
        self.paths = set()
        if options.files:
            py_files = options.files
            for p in py_files:
                if not os.path.exists(p) and not options.ignore_missing_modules:
                    raise FileNotFoundError("'%s' does not exist." % p)
                self.paths.add(p)
        self.exclude_paths = set([ os.path.abspath(f) for f in options.exclude_file ])
        self.exclude = exclude_filter_from_options(options)
        self.filter = filter_from_options_and_environment(options)
        self.recurse_files = options.recurse_files
        self.recurse_packages = options.recursive
        self.modulenames = modulenames
        self.finder = finder.Finder.from_options_and_env(options, logger)
        self.logger = logger
        self.ignore_missing_modules = options.ignore_missing_modules

    def __iter__(self):
        '''Return an iterator over all the specified files'''
        for name in self.modulenames:
            if not self.exclude(name):
                mod = self.finder.find(name)
                if mod is None:
                    self.logger.error("No module named '%s'.", name)
                    raise ExtractorFailure()
                yield mod.get_extractable()
        for path in self.paths:
            yield Extractable.from_path(path)
        for path in self.recurse_files:
            for modpath in self._treewalk(path):
                yield Extractable.from_path(modpath)
        for name in self.recurse_packages:
            mod = self.finder.find(name)
            if mod is None:
                if self.ignore_missing_modules:
                    continue
                self.logger.error("Package '%s' does not exist.", name)
                raise ExtractorFailure()
            path = mod.path
            if path is None:
                self.logger.error("Package '%s' does not have a path.", name)
                raise ExtractorFailure()
            for modpath in self._treewalk(path):
                yield Extractable.from_path(modpath)

    def _treewalk(self, path):
        '''Recursively walk the directory tree, skipping sym-links and
        hidden files and directories.'''
        #Note that if a path is both explicitly specified *and* specifically excluded,
        #then the inclusion takes priority

        path = os.path.abspath(path)
        self.logger.debug("Traversing %s", path)
        filenames = listdir(path)
        for filename in filenames:
            fullpath = os.path.join(path, filename)
            if islink(fullpath):
                self.logger.debug("Ignoring %s (symlink)", fullpath)
                continue
            if isdir(fullpath):
                if fullpath in self.exclude_paths or is_hidden(fullpath):
                    if is_hidden(fullpath):
                        self.logger.debug("Ignoring %s (hidden)", fullpath)
                    else:
                        self.logger.debug("Ignoring %s (excluded)", fullpath)
                else:
                    empty = True
                    for item in self._treewalk(fullpath):
                        yield item
                        empty = False
                    if not empty:
                        yield fullpath
            elif self.filter(fullpath):
                yield fullpath
            else:
                self.logger.debug("Ignoring %s (filter)", fullpath)


if os.name== 'nt':
    import ctypes

    def is_hidden(path):
        #Magical windows code
        try:
            attrs = ctypes.windll.kernel32.GetFileAttributesW(str(path))
            if attrs == -1:
                return False
            if attrs&2:
                return True
        except Exception:
            #Not sure what to log here, probably best to carry on.
            pass
        return os.path.basename(path).startswith(".")

else:

    def is_hidden(path):
        return os.path.basename(path).startswith(".")


def exclude_filter_from_options(options):
    if options.exclude_package:
        choices = '|'.join(mod.replace('.', r'\.') for mod in options.exclude_package)
        pattern = r'(?:%s)(?:\..+)?' % choices
        if options.exclude_pattern:
            pattern = '^((?:%s)|(?:%s))$' % (pattern, options.exclude_pattern)
        else:
            pattern = '^%s$' % pattern
    elif options.exclude_pattern:
        pattern = '^(?:%s)$' % options.exclude_pattern
    else:
        def no_filter(name):
            return False
        return no_filter
    matcher = re.compile(pattern)
    def exclude_filter(name):
        return name is not None and bool(matcher.match(name))
    return exclude_filter

def base_filter(path):
    _, ext = os.path.splitext(path)
    return ext in PY_EXTENSIONS or not ext and modules.is_script(path)

def filter_from_options_and_environment(options):
    the_filter = base_filter
    filter_prefix = ""
    src_path = os.environ.get("LGTM_SRC", None)
    if src_path is not None:
        filter_prefix = os.path.join(src_path, "")
    for line in options.path_filter:
        the_filter = filter_from_pattern(line, the_filter, filter_prefix)
    return the_filter
