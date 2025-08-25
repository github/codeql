import sys
from semmle import util
from .py_extractor import PythonExtractor

class ModulePrinter(object):

    name = "module printer"

    def __init__(self, options, trap_folder, src_archive, renamer, logger):
        self.logger = logger
        self.py_extractor = PythonExtractor(options, trap_folder, src_archive, logger)

    def process(self, unit):
        imports = ()
        if isinstance(unit, util.BuiltinModuleExtractable):
            name = unit.name
            self.logger.info("Found builtin module '%s'", name)
        elif isinstance(unit, util.FileExtractable):
            self.logger.info("Found file '%s'", unit.path)
            _, imports = self.py_extractor._get_module_and_imports(unit)
        elif isinstance(unit, util.FolderExtractable):
            self.logger.info("Found folder '%s'", unit.path)
        else:
            self.logger.error("Unexpected object: %s", unit)
        return imports

    def close(self):
        pass

    def write_global_data(self):
        pass
