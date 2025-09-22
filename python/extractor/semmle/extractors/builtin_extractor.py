import sys
from semmle import util
from semmle.python.passes.objects import ObjectPass
from semmle.extractors.base import BaseExtractor

# A sentinel object representing a built-in that should be skipped.
# Unlike returning `NotImplemented`, this prevents other extractors from
# attempting to extract the same file/module and/or reporting an extraction error.
SkippedBuiltin = object()

class BuiltinExtractor(BaseExtractor):
    '''Extractor that can extract built-in Python modules, such as the `sys` module.'''

    name = "built-in extractor"

    def process(self, unit):
        # Modules in the standard library (e.g. `os`)
        if not self.options.extract_stdlib and \
            isinstance(unit, util.FileExtractable) and \
            unit.path.startswith(util.STDLIB_PATH):
                return SkippedBuiltin
        if not isinstance(unit, util.BuiltinModuleExtractable):
            return NotImplemented
        name = unit.name
        # If a Shared Object file fails to import, we want to prevent the `ImportError` from
        # propagating further up. Instead, we simply behave as if the module is not extractable.
        try:
            module = __import__(name)
        except ImportError as e:
            if e.path.endswith(".so"):
                return NotImplemented
            else:
                raise e
        writer = util.TrapWriter()
        ObjectPass().extract_builtin(module, writer)
        output = writer.get_compressed()
        self.trap_folder.write_trap("builtin", name, output)
        return ()

    def close(self):
        pass
