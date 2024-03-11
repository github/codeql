import sys
import os
import inspect
import pkgutil
from semmle.python import ast

from semmle.python.passes.exports import ExportsPass
from semmle.python.passes.lexical import LexicalPass
from semmle.python.passes.flow import FlowPass
from semmle.python.passes.ast_pass import ASTPass
from semmle.python.passes.objects import ObjectPass
from semmle.util import VERSION, uuid, get_analysis_version, get_analysis_major_version
from semmle.util import makedirs, get_source_file_tag, TrapWriter, base64digest
from semmle.cache import Cache
from semmle.logging import WARN, syntax_error_message, Logger
from semmle.profiling import timers

UTRAP_KEY = 'utrap%s' % VERSION

__all__ = [ 'Extractor', 'CachingExtractor' ]

FLAG_SAVE_TYPES = float, complex, bool, int, bytes, str

class Extractor(object):
    '''The extractor controls the execution of the all the
    specialised passes'''

    def __init__(self, trap_folder, src_archive, options, logger: Logger, diagnostics_writer):
        assert trap_folder
        self.trap_folder = trap_folder
        self.src_archive = src_archive
        self.object_pass = ObjectPass()
        self.passes = [
            ASTPass(),
            ExportsPass(),
            FlowPass(options.split, options.prune, options.unroll, logger)
        ]
        self.lexical = LexicalPass()
        self.files = {}
        self.options = options
        self.handle_syntax_errors = not options.no_syntax_errors
        self.logger = logger
        self.diagnostics_writer = diagnostics_writer

    def _handle_syntax_error(self, module, ex):
        # Write out diagnostics for the syntax error.
        error = syntax_error_message(ex, module)
        self.diagnostics_writer.write(error)

        # Emit trap for the syntax error
        self.logger.debug("Emitting trap for syntax error in %s", module.path)
        writer = TrapWriter()
        module_id = writer.get_node_id(module)
        # Report syntax error as an alert.
        # Ensure line and col are ints (not None).
        line = ex.lineno if ex.lineno else 0
        if line > len(module.lines):
            line = len(module.lines)
            col = len(module.lines[-1])-1
        else:
            col = ex.offset if ex.offset else 0
        loc_id = writer.get_unique_id()
        writer.write_tuple(u'locations_ast', 'rrdddd',
                    loc_id, module_id, 0, 0, 0, 0)
        syntax_id = u'syntax%d:%d' % (line, col)
        writer.write_tuple(u'locations_ast', 'nrdddd',
            syntax_id, module_id, line, col+1, line, col+1)
        writer.write_tuple(u'py_syntax_error_versioned', 'nss', syntax_id, ex.msg, get_analysis_major_version())
        trap = writer.get_compressed()
        self.trap_folder.write_trap("syntax-error", module.path, trap)
        #Create an AST equivalent to an empty file, so that the other passes produce consistent output.
        return ast.Module([])

    def _extract_trap_file(self, ast, comments, path):
        writer = TrapWriter()
        file_tag = get_source_file_tag(self.src_archive.get_virtual_path(path))
        writer.write_tuple(u'py_Modules', 'g', ast.trap_name)
        writer.write_tuple(u'py_module_path', 'gg', ast.trap_name, file_tag)
        try:
            for ex in self.passes:
                with timers[ex.name]:
                    if isinstance(ex, FlowPass):
                        ex.set_filename(path)
                    ex.extract(ast, writer)
            with timers['lexical']:
                self.lexical.extract(ast, comments, writer)
            with timers['object']:
                self.object_pass.extract(ast, path, writer)
        except Exception as ex:
            self.logger.error("Exception extracting module %s: %s", path, ex)
            self.logger.traceback(WARN)
            return None
        return writer.get_compressed()

    def process_source_module(self, module):
        '''Process a Python source module. Checks that module has valid syntax,
        then passes passes ast, source, etc to `process_module`
        '''
        try:
            #Ensure that module does not have invalid syntax before extracting it.
            ast = module.ast
        except SyntaxError as ex:
            self.logger.debug("handle syntax errors is %s", self.handle_syntax_errors)
            if self.handle_syntax_errors:
                ast = self._handle_syntax_error(module, ex)
            else:
                return None
        ast.name = module.name
        ast.kind = module.kind
        ast.trap_name = module.trap_name
        return self.process_module(ast, module.trap_name, module.bytes_source,
                                   module.path, module.comments)

    def process_module(self, ast, module_tag, bytes_source, path, comments):
        'Process a module, generating the trap file for that module'
        self.logger.debug(u"Populating trap file for %s", path)
        ast.trap_name = module_tag
        trap = self._extract_trap_file(ast, comments, path)
        if trap is None:
            return None
        with timers['trap']:
            self.trap_folder.write_trap("python", path, trap)
        try:
            with timers['archive']:
                self.copy_source(bytes_source, module_tag, path)
        except Exception:
            import traceback
            traceback.print_exc()
        return trap

    def copy_source(self, bytes_source, module_tag, path):
        if bytes_source is None:
            return
        self.files[module_tag] = self.src_archive.get_virtual_path(path)
        self.src_archive.write(path, bytes_source)

    def write_interpreter_data(self, options):
        '''Write interpreter data, such as version numbers and flags.'''

        def write_flag(name, value):
            writer.write_tuple(u'py_flags_versioned', 'uus', name, value, get_analysis_major_version())

        def write_flags(obj, prefix):
            pre = prefix + u"."
            for name, value in inspect.getmembers(obj):
                if name[0] == "_":
                    continue
                if type(value) in FLAG_SAVE_TYPES:
                    write_flag(pre + name, str(value))

        writer = TrapWriter()
        for index, name in enumerate((u'major', u'minor', u'micro', u'releaselevel', u'serial')):
            writer.write_tuple(u'py_flags_versioned', 'sss', u'extractor_python_version.' + name, str(sys.version_info[index]), get_analysis_major_version())
        write_flags(sys.flags, u'flags')
        write_flags(sys.float_info, u'float')
        write_flags(self.options, u'options')
        write_flag(u'sys.prefix', sys.prefix)
        path = os.pathsep.join(os.path.abspath(p) for p in options.sys_path)
        write_flag(u'sys.path', path)
        if options.path is None:
            path = ''
        else:
            path = os.pathsep.join(self.src_archive.get_virtual_path(p) for p in options.path)
        if options.language_version:
            write_flag(u'language.version', options.language_version[-1])
        else:
            write_flag(u'language.version', get_analysis_version())
        write_flag(u'extractor.path', path)
        write_flag(u'sys.platform', sys.platform)
        write_flag(u'os.sep', os.sep)
        write_flag(u'os.pathsep', os.pathsep)
        write_flag(u'extractor.version', VERSION)
        if options.context_cost is not None:
            write_flag(u'context.cost', options.context_cost)
        self.trap_folder.write_trap("flags", "$flags", writer.get_compressed())
        if get_analysis_major_version() == 2:
            # Copy the pre-extracted builtins trap
            builtins_trap_data = pkgutil.get_data('semmle.data', 'interpreter2.trap')
            self.trap_folder.write_trap("interpreter", '$interpreter2', builtins_trap_data, extension=".trap")
        else:
            writer = TrapWriter()
            self.object_pass.write_special_objects(writer)
            self.trap_folder.write_trap("interpreter", '$interpreter3', writer.get_compressed())
        # Copy stdlib trap
        if get_analysis_major_version() == 2:
            stdlib_trap_name = '$stdlib_27.trap'
        else:
            stdlib_trap_name = '$stdlib_33.trap'
        stdlib_trap_data = pkgutil.get_data('semmle.data', stdlib_trap_name)
        self.trap_folder.write_trap("stdlib", stdlib_trap_name[:-5], stdlib_trap_data, extension=".trap")

    @staticmethod
    def from_options(options, trap_dir, archive, logger: Logger, diagnostics_writer):
        '''Convenience method to create extractor from options'''
        try:
            trap_copy_dir = options.trap_cache
            caching_extractor = CachingExtractor(trap_copy_dir, options, logger)
        except Exception as ex:
            if options.verbose and trap_copy_dir is not None:
                print ("Failed to create caching extractor: " + str(ex))
            caching_extractor = None
        worker = Extractor(trap_dir, archive, options, logger, diagnostics_writer)
        if caching_extractor:
            caching_extractor.set_worker(worker)
            return caching_extractor
        else:
            return worker

    def stop(self):
        pass

    def close(self):
        'close() must be called, or some information will be not be written'
        #Add name tag to file name, so that multiple extractors do not overwrite each other
        if self.files:
            trapwriter = TrapWriter()
            for _, filepath in self.files.items():
                trapwriter.write_file(filepath)
            self.trap_folder.write_trap('folders', uuid('python') + '/$files', trapwriter.get_compressed())
            self.files = set()
        for name, timer in sorted(timers.items()):
            self.logger.debug("Total time for pass '%s': %0.0fms", name, timer.elapsed)


def hash_combine(x, y):
    return base64digest(x + u":" + y)


class CachingExtractor(object):
    '''The caching extractor has a two stage initialization process.
       After creating the extractor (which will check that the cachedir is valid)
       set_worker(worker) must be called before the CachingExtractor is valid'''

    def __init__(self, cachedir, options, logger: Logger):
        if cachedir is None:
            raise IOError("No cache directory")
        makedirs(cachedir)
        self.worker = None
        self.cache = Cache.for_directory(cachedir, options.verbose)
        self.logger = logger
        self.split = options.split

    def set_worker(self, worker):
        self.worker = worker

    def get_cache_key(self, module):
        key = hash_combine(module.path, module.source)
        if not self.split:
            #Use different key, as not splitting will modify the trap file.
            key = hash_combine(UTRAP_KEY, key)
        return hash_combine(key, module.source)

    def process_source_module(self, module):
        '''Process a Python source module. First look up trap file in cache.
        In no cached trap file is found, then delegate to normal extractor.
        '''
        if self.worker is None:
            raise Exception("worker is not set")
        key = self.get_cache_key(module)
        trap = self.cache.get(key)
        if trap is None:
            trap = self.worker.process_source_module(module)
            if trap is not None:
                self.cache.set(key, trap)
        else:
            self.logger.debug(u"Found cached trap file for %s", module.path)
            self.worker.trap_folder.write_trap("python", module.path, trap)
            try:
                self.worker.copy_source(module.bytes_source, module.trap_name, module.path)
            except Exception:
                self.logger.traceback(WARN)
        return trap

    def process_module(self, ast, module_tag, source_code, path, comments):
        self.worker.process_module(ast, module_tag, source_code, path, comments)

    def close(self):
        self.worker.close()

    def write_interpreter_data(self, sys_path):
        self.worker.write_interpreter_data(sys_path)

    def stop(self):
        self.worker.stop()
