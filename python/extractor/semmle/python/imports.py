import sys
from semmle.python import ast

from collections import namedtuple

from semmle.util import VERSION, get_analysis_major_version
from semmle.cache import Cache
from semmle.logging import INFO

#Maintain distinct version strings for distinct versions of Python
IMPORTS_KEY = 'import%s_%x%x' % (VERSION, sys.version_info[0], sys.version_info[1])

import pickle

__all__ = [ 'CachingModuleImporter', 'ModuleImporter', 'importer_from_options' ]

ImportStar = namedtuple('ImportStar', 'level module')
ImportExpr = namedtuple('ImportExpr', 'level module')
ImportMember = namedtuple('ImportMember', 'level module name')

def safe_string(txt):
    try:
        if isinstance(txt, bytes):
            try:
                return txt.decode(sys.getfilesystemencoding(), errors="replace")
            except Exception:
                return txt.decode("latin-1")
        else:
            return str(txt)
    except Exception:
        return u"?"

class SemmleImportError(Exception):

    def __init__(self, module_name, *reasons):
        reason_txt = u"".join(safe_string(reason) for reason in reasons)
        module_name = safe_string(module_name)
        if reason_txt:
            message = u"Import of %s failed: %s.\n" % (module_name, reason_txt)
        else:
            message = u"Import of %s failed.\n" % module_name
        Exception.__init__(self, message)

    def write(self, out=sys.stdout):
        out.write(self.args[0])


class CachingModuleImporter(object):

    def __init__(self, cachedir, finder, logger):
        self.worker = ModuleImporter(finder, logger)
        if cachedir is None:
            raise IOError("No cache directory")
        self.cache = Cache.for_directory(cachedir, logger)
        self.logger = logger

    def get_imports(self, module, loaded_module):
        import_nodes = self.get_import_nodes(loaded_module)
        return self.worker.parse_imports(module, import_nodes)

    def get_import_nodes(self, loaded_module):
        key = loaded_module.get_hash_key(IMPORTS_KEY)
        if key is None:
            return self.worker.get_import_nodes(loaded_module)
        imports = self.cache.get(key)
        #Unpickle the data
        if imports is not None:
            try:
                imports = pickle.loads(imports)
            except Exception:
                self.logger.debug("Failed to unpickle imports for %s", loaded_module.path)
                imports = None
        if imports is None:
            imports = self.worker.get_import_nodes(loaded_module)
            try:
                data = pickle.dumps(imports)
                self.cache.set(key, data)
            except Exception as ex:
                # Shouldn't really fail, but carry on anyway
                self.logger.debug("Failed to save pickled imports to cache for %s: %s", loaded_module.path, ex)
        else:
            self.logger.debug("Cached imports file found for %s", loaded_module.path)
        return imports

class ModuleImporter(object):
    'Discovers and records which modules import which other modules'

    def __init__(self, finder, logger):

        self.finder = finder
        self.logger = logger
        self.failures = {}

    def get_imports(self, module, loaded_module):
        import_nodes = self.get_import_nodes(loaded_module)
        return self.parse_imports(module, import_nodes)

    def get_import_nodes(self, loaded_module):
        'Return list of AST nodes representing imports'
        try:
            self.logger.debug("Looking for imports in %s", loaded_module.path)
            return imports_from_ast(loaded_module.py_ast)
        except Exception as ex:
            if isinstance(ex, SyntaxError):
                # Example: `Syntax Error (line 123) in /home/.../file.py`
                self.logger.warning("%s in %s", ex, loaded_module.path)
                # no need to show traceback, it's not an internal bug
            else:
                self.logger.warning("Failed to analyse imports of %s : %s", loaded_module.path, ex)
                self.logger.traceback(INFO)
            return []

    def _relative_import(self, module, level, mod_name, report_failure = True):
        for i in range(level):
            parent = module.package
            if parent is None:
                relative_name = level * u'.' + mod_name
                if relative_name not in self.failures:
                    if report_failure:
                        self.logger.warning("Failed to find %s, no parent package of %s", relative_name, module)
                    self.failures[relative_name] = str(module)
                return None
            module = parent
        res = module
        if mod_name:
            res = res.get_sub_module(mod_name)
        if res is None and report_failure:
            relative_name = level * '.' + mod_name
            if relative_name not in self.failures:
                self.logger.warning("Failed to find %s, %s has no module %s", relative_name, module, mod_name)
            self.failures[relative_name] = str(module)
        return res

    def _absolute_import(self, module, mod_name):
        try:
            mod = self.finder.find(mod_name)
        except SemmleImportError as ex:
            if mod_name not in self.failures:
                self.logger.warning("%s", ex)
            self.failures[mod_name] = str(module)
            return None
        return mod

    def parse_imports(self, module, import_nodes):
        imports = set()
        #If an imported module is a package, then yield its __init__ module as well
        for imported in self._parse_imports_no_init(module, import_nodes):
            if imported not in imports:
                imports.add(imported)
                assert imported is not None
                yield imported
            if not imported.is_package():
                continue
            init = imported.get_sub_module(u"__init__")
            if init is not None and init not in imports:
                yield init

    def _parse_imports_no_init(self, module, import_nodes):
        assert not module.is_package()
        for node in import_nodes:
            if node.module is None:
                top = ''
                parts = []
            else:
                parts = node.module.split('.')
                top, parts = parts[0], parts[1:]
            if node.level <= 0:
                if get_analysis_major_version() < 3:
                    #Attempt relative import with level 1
                    imported = self._relative_import(module, 1, top, False)
                    if imported is None:
                        imported = self._absolute_import(module, top)
                else:
                    imported = self._absolute_import(module, top)
            else:
                imported = self._relative_import(module, node.level, top)
            if imported is None:
                self.logger.debug("Unable to resolve import: %s", top)
                continue
            yield imported
            for p in parts:
                inner = imported.get_sub_module(p)
                if inner is None:
                    self.logger.debug("Unable to resolve import: %s", p)
                    break
                imported = inner
                yield imported
            if isinstance(node, ImportStar):
                self.logger.debug("Importing all sub modules of %s", imported)
                #If import module is a package then yield all sub_modules.
                for mod in imported.all_sub_modules():
                    yield mod
            elif isinstance(node, ImportMember):
                mod = imported.get_sub_module(node.name)
                if mod is not None:
                    self.logger.debug("Unable to resolve import: %s", node.name)
                    yield mod

def imports_from_ast(the_ast):
    def walk(node, in_function, in_name_main):
        if isinstance(node, ast.Module):
            for import_node in walk(node.body, in_function, in_name_main):
                yield import_node
        elif isinstance(node, ast.ImportFrom):
            yield ImportStar(node.module.level, node.module.name)
        elif isinstance(node, ast.Import):
            for alias in node.names:
                imp = alias.value
                if isinstance(imp, ast.ImportExpr):
                    yield ImportExpr(imp.level, imp.name)
                else:
                    assert isinstance(imp, ast.ImportMember)
                    yield ImportMember(imp.module.level, imp.module.name, imp.name)
        elif isinstance(node, ast.FunctionExpr):
            for _, child in ast.iter_fields(node.inner_scope):
                for import_node in walk(child, True, in_name_main):
                    yield import_node
        elif  isinstance(node, ast.Call):
            # Might be a decorator
            for import_node in walk(node.positional_args, in_function, in_name_main):
                yield import_node
        elif isinstance(node, list):
            for n in node:
                for import_node in walk(n, in_function, in_name_main):
                    yield import_node
        elif isinstance(node, ast.stmt):
            name_eq_main = is_name_eq_main(node)
            for _, child in ast.iter_fields(node):
                for import_node in walk(child, in_function, name_eq_main or in_name_main):
                    yield import_node
    return list(walk(the_ast, False, False))

def name_from_expr(expr):
    if isinstance(expr, ast.Name):
        return expr.id
    if isinstance(expr, ast.Attribute):
        return name_from_expr(expr.value) + "." + expr.attr
    raise ValueError("%s is not a name" % expr)

def is_name_eq_main(node):
    if not isinstance(node, ast.If):
        return False
    try:
        lhs = node.test.left
        rhs = node.test.comparators[0]
        return rhs.s == "__main__" and lhs.id == "__name__"
    except Exception:
        return False

def importer_from_options(options, finder, logger):
    try:
        importer = CachingModuleImporter(options.trap_cache, finder, logger)
    except Exception as ex:
        if options.trap_cache is not None:
            logger.warn("Failed to create caching importer: %s", ex)
        importer = ModuleImporter(finder, logger)
    return importer
