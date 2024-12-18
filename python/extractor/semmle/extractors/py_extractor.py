import os.path

from semmle import util
from semmle.python import extractor, finder, imports
import re
from semmle.extractors.base import BaseExtractor
from semmle.logging import Logger

class PythonExtractor(BaseExtractor):
    '''Extractor that can extract Python source code.'''

    name = "Python extractor"

    def __init__(self, options, trap_folder, src_archive, logger: Logger, diagnostics_writer):
        super(PythonExtractor, self).__init__(options, trap_folder, src_archive, logger)
        self.module_extractor = extractor.Extractor.from_options(options, trap_folder, src_archive, logger, diagnostics_writer)
        self.finder = finder.Finder.from_options_and_env(options, logger)
        self.importer = imports.importer_from_options(options, self.finder, logger)

    def _get_module_and_imports(self, unit):
        if not isinstance(unit, util.FileExtractable):
            return None, ()
        #Convert unit to module.
        module = self.finder.from_extractable(unit)
        if module is None:
            return None, ()
        py_module = module.load(self.logger)
        if py_module is None:
            return None, ()
        imports = set(mod.get_extractable() for mod in self.importer.get_imports(module, py_module))
        for imp in imports:
            self.logger.trace("%s imports %s", module, imp)
        package = module.package
        while package:
            ex = package.get_extractable()
            if ex is None:
                break
            self.logger.debug("Requiring package %s", ex)
            imports.add(ex)
            package = package.package
        return py_module, imports

    def process(self, unit):
        py_module, imports = self._get_module_and_imports(unit)
        if py_module is None:
            return NotImplemented
        self.module_extractor.process_source_module(py_module)
        return imports

    def close(self):
        self.module_extractor.close()

    def write_interpreter_data(self, options):
        self.module_extractor.write_interpreter_data(options)

LEGAL_NAME = re.compile(r"[^\W0-9]\w+$")

class PackageExtractor(object):
    '''Extractor that can extract folders as Python packages.'''

    name = "package extractor"

    def __init__(self, options, trap_folder, src_archive, logger):
        self.trap_folder = trap_folder
        self.src_archive = src_archive
        self.logger = logger
        self.respect_init = options.respect_init

    def process(self, unit):
        if not isinstance(unit, util.FolderExtractable):
            return NotImplemented
        _, name = os.path.split(unit.path)
        init_path = os.path.join(unit.path, "__init__.py")
        if (self.respect_init and not os.path.exists(init_path)) or not LEGAL_NAME.match(name):
            self.logger.debug("Ignoring non-package folder %s", unit.path)
            return ()
        writer = util.TrapWriter()
        trap_name = u'py-package:' + unit.path
        vpath = self.src_archive.get_virtual_path(unit.path)
        folder_tag = writer.write_folder(vpath)
        writer.write_tuple(u'py_Modules', 'g', trap_name)
        writer.write_tuple(u'py_module_path', 'gg', trap_name, folder_tag)
        #Add fake CFG entry node to represent the PackageObject.
        entry_node = object()
        entry_id = trap_name + ":entry-point"
        entry_tag = writer.get_labelled_id(entry_node, entry_id)
        writer.write_tuple(u'py_flow_bb_node', 'rgrd', entry_tag, trap_name, entry_tag, 0)
        writer.write_tuple(u'py_scope_flow', 'rgd', entry_tag, trap_name, -1)
        #Add dummy location
        loc = object()
        loc_id = trap_name + ":location"
        loc_tag = writer.get_labelled_id(loc, loc_id)
        writer.write_tuple(u'locations_ast', 'rgdddd', loc_tag, trap_name, 0, 0, 0, 0)
        output = writer.get_compressed()
        self.trap_folder.write_trap('$package', unit.path, output)
        if os.path.exists(init_path):
            return util.FileExtractable(init_path),
        else:
            return ()

    def close(self):
        pass
