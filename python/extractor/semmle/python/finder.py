'''
Classes and functions for converting module names into paths and Extractables.
Implements standard Python import semantics, and is designed to be extensible
to handle additional features like stub and template files.
'''

import sys
import imp
import os.path
from semmle.util import FileExtractable, FolderExtractable, BuiltinModuleExtractable, PY_EXTENSIONS, get_analysis_major_version
from semmle.python.modules import PythonSourceModule, is_script

class Module(object):
    '''A module. Modules are approximations
    to Python module objects and are used for
    analyzing imports.'''

    IS_PACKAGE = False
    path = None
    respect_init = True

    def __init__(self, name, package):
        self.name = name
        self.package = package

    def get_sub_module(self, name):
        '''gets the (immediate) sub-module with the given name'''
        raise NotImplementedError()

    def all_sub_modules(self):
        '''returns an iterable of all the sub-modules of this module'''
        raise NotImplementedError()

    def get_extractable(self):
        '''gets the Extractable for this module'''
        raise NotImplementedError()

    def find(self, name):
        '''Returns the named sub-module of this module if this module
        is a package, otherwise returns `None`'''
        if '.' in name:
            top, rest = name.split(".", 1)
            pkg = self.get_sub_module(top)
            return pkg.find(rest) if pkg else None
        else:
            return self.get_sub_module(name)

    def is_package(self):
        return self.IS_PACKAGE

class PyModule(Module):
    ' A Python source code module'

    def __init__(self, name, package, path):
        Module.__init__(self, name, package)
        assert isinstance(path, str)
        self.path = path

    def get_sub_module(self, name):
        return None

    def all_sub_modules(self):
        return ()

    def get_extractable(self):
        return FileExtractable(self.path)

    def load(self, logger=None):
        return PythonSourceModule(self.name, self.path, logger=logger)

    def __str__(self):
        return "Python module at %s" % self.path

class BuiltinModule(Module):
    ' A built-in module'

    def __init__(self, name, package):
        Module.__init__(self, name, package)

    def get_sub_module(self, name):
        return None

    def all_sub_modules(self):
        return ()

    def get_extractable(self):
        return BuiltinModuleExtractable(self.name)

    def __str__(self):
        return "Builtin module %s" % self.name

class FilePackage(Module):
    ' A normal package. That is a folder with an __init__.py'

    IS_PACKAGE = True

    def __init__(self, name, package, path, respect_init=True):
        Module.__init__(self, name, package)
        assert isinstance(path, str), type(path)
        self.path = path
        self.respect_init = respect_init

    def get_sub_module(self, name):
        modname = self.name + "." + name if self.name else None
        basepath = os.path.join(self.path, name)
        return _from_base(modname, basepath, self, self.respect_init)

    def all_sub_modules(self):
        return _from_folder(self.name, self.path, self, self.respect_init)

    def load(self):
        return None

    def get_extractable(self):
        return FolderExtractable(self.path)

    def __str__(self):
        return "Package at %s" % self.path

class PthPackage(Module):
    "A built-in package object generated from a '.pth' file"

    IS_PACKAGE = True

    def __init__(self, name, package, search_path):
        Module.__init__(self, name, package)
        self.search_path = search_path

    def get_sub_module(self, name):
        mname = self.name + "." + name
        for path in self.search_path:
            mod = _from_base(mname, os.path.join(path, name), self)
            if mod is not None:
                return mod
        return None

    def all_sub_modules(self):
        for path in self.search_path:
            for mod in _from_folder(self.name, path, self):
                yield mod

    def load(self):
        return None

    def __str__(self):
        return "Builtin package (.pth) %s %s" % (self.name, self.search_path)

    def get_extractable(self):
        return None

#Helper functions

def _from_base(name, basepath, pkg, respect_init=True):
    if os.path.isdir(basepath):
        if os.path.exists(os.path.join(basepath, "__init__.py")) or not respect_init:
            return FilePackage(name, pkg, basepath, respect_init)
        else:
            return None
    for ext in PY_EXTENSIONS:
        filepath = basepath + ext
        if os.path.isfile(filepath):
            return PyModule(name, pkg, filepath)
    return None

def _from_folder(name, path, pkg, respect_init=True):
    for file in os.listdir(path):
        fullpath = os.path.join(path, file)
        if os.path.isdir(fullpath):
            if os.path.exists(os.path.join(fullpath, "__init__.py")) or not respect_init:
                yield FilePackage(name + "." + file if name else None, pkg, fullpath, respect_init)
        base, ext = os.path.splitext(file)
        if ext not in PY_EXTENSIONS:
            continue
        if os.path.isfile(fullpath):
            yield PyModule(name + "." + base if name else None, pkg, fullpath)

class AbstractFinder(object):

    def find(self, mod_name):
        '''Find an extractable object given a module name'''
        if '.' in mod_name:
            top, rest = mod_name.split(".", 1)
            pkg = self.find_top(top)
            return pkg.find(rest) if pkg else None
        else:
            return self.find_top(mod_name)

    def find_top(self, name):
        '''Find module or package object given a simple (dot-less) name'''
        raise NotImplementedError()

    def name_from_path(self, path, extensions):
        '''Find module or package object given a path'''
        raise NotImplementedError()

class PyFinder(AbstractFinder):

    __slots__ = [ 'path', 'respect_init', 'logger' ]

    def __init__(self, path, respect_init, logger):
        assert isinstance(path, str), path
        self.path = os.path.abspath(path)
        self.respect_init = respect_init
        self.logger = logger

    def find_top(self, mod_name):
        basepath = os.path.join(self.path, mod_name)
        return _from_base(mod_name, basepath, None, self.respect_init)

    def name_from_path(self, path, extensions):
        rel_path = _relative_subpath(path, self.path)
        if rel_path is None:
            return None
        base, ext = os.path.splitext(rel_path)
        if ext and ext not in extensions:
            return None
        return ".".join(base.split(os.path.sep))

def _relative_subpath(subpath, root):
    'Returns the relative path if `subpath` is within `root` or `None` otherwise'
    try:
        relpath = os.path.relpath(subpath, root)
    except ValueError:
        #No relative path possible
        return None
    if relpath.startswith(os.pardir):
        #Not in root:
        return None
    return relpath

class BuiltinFinder(AbstractFinder):
    '''Finder for builtin modules that are already present in the VM
    or can be guaranteed to load successfully'''

    def __init__(self, logger):
        self.modules = {}
        for name, module in sys.modules.items():
            self.modules[name] = module
        try:
            self.dynload_path = os.path.dirname(imp.find_module("_json")[1])
        except Exception:
            if os.name != "nt":
                logger.warning("Failed to find dynload path")
            self.dynload_path = None

    def builtin_module(self, name):
        if "." in name:
            pname, name = name.rsplit(".", 1)
            return BuiltinModule(name, self.builtin_module(pname))
        return BuiltinModule(name, None)

    def find(self, mod_name):
        mod = super(BuiltinFinder, self).find(mod_name)
        if mod is not None:
            return mod
        #Use `imp` module to find module
        try:
            _, filepath, mod_t = imp.find_module(mod_name)
        except ImportError:
            return None
        #Accept builtin dynamically loaded modules like _ctypes or _json
        if filepath and os.path.dirname(filepath) == self.dynload_path:
            return BuiltinModule(mod_name, None)
        return None

    def find_top(self, mod_name):
        if mod_name in self.modules:
            mod = self.modules[mod_name]
            if hasattr(mod, "__file__"):
                return None
            if hasattr(mod, "__path__"):
                return PthPackage(mod_name, None, mod.__path__)
            return BuiltinModule(mod_name, None)
        if mod_name in sys.builtin_module_names:
            return BuiltinModule(mod_name, None)
        return None

    def name_from_path(self, path, extensions):
        return None

#Stub file handling

class StubFinder(PyFinder):

    def __init__(self, logger):
        try:
            tools = os.environ['ODASA_TOOLS']
        except KeyError:
            tools = sys.path[1]
            logger.debug("StubFinder: can't find ODASA_TOOLS, using '%s' instead", tools)
        path = os.path.join(tools, "data", "python", "stubs")
        super(StubFinder, self).__init__(path, True, logger)


def _finders_for_path(path, respect_init, logger):
    finders = [ StubFinder(logger) ]
    for p in path:
        if p:
            finders.append(PyFinder(p, respect_init, logger))
    finders.append(BuiltinFinder(logger))
    return finders


def finders_from_options_and_env(options, logger):
    '''Return a list of finders from the given command line options'''
    if options.path:
        path = options.path + options.sys_path
    else:
        path = options.sys_path
    path = [os.path.abspath(p) for p in path]
    if options.exclude:
        exclude = set(options.exclude)
        trimmed_path = []
        for p in path:
            for x in exclude:
                if p.startswith(x):
                    break
            else:
                trimmed_path.append(p)
        path = trimmed_path
    logger.debug("Finder path: %s", path)
    logger.debug("sys path: %s", sys.path)
    return _finders_for_path(path, options.respect_init, logger)


class Finder(object):

    def __init__(self, finders, options, logger):
        self.finders = finders
        self.path_map = {}
        self.logger = logger
        self.respect_init = options.respect_init

    def find(self, mod_name):
        for finder in self.finders:
            mod = finder.find(mod_name)
            if mod is not None:
                return mod
        self.logger.debug("Cannot find module '%s'", mod_name)
        return None

    @staticmethod
    def from_options_and_env(options, logger):
        return Finder(finders_from_options_and_env(options, logger), options, logger)

    def from_extractable(self, unit):
        if isinstance(unit, FolderExtractable) or isinstance(unit, FileExtractable):
            return self.from_path(unit.path)
        return None

    def from_path(self, path, extensions=PY_EXTENSIONS):
        if path in self.path_map:
            return self.path_map[path]
        if not path or path == "/":
            return None
        is_python_2 = (get_analysis_major_version() == 2)
        if os.path.isdir(path) and not os.path.exists(os.path.join(path, "__init__.py")) and (self.respect_init or not is_python_2):
            return None
        pkg = self.from_path(os.path.dirname(path))
        mod = None
        if os.path.isdir(path):
            mod = FilePackage(None, pkg, path)
        if os.path.isfile(path):
            base, ext = os.path.splitext(path)
            if ext in extensions:
                mod = PyModule(None, pkg, path)
            if is_script(path):
                mod = PyModule(None, None, path)
        self.path_map[path] = mod
        return mod

    def name_from_path(self, path, extensions=PY_EXTENSIONS):
        for finder in self.finders:
            name = finder.name_from_path(path, extensions)
            if name is not None:
                return name
        return None
