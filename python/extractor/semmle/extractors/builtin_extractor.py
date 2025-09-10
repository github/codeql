import sys
import os
from pathlib import Path
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
            _is_subpath(unit.path, util.STDLIB_PATH):
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

def _is_subpath(path, prefix):
    # Prefer filesystem-canonical comparison when possible
    try:
        p = Path(path).resolve()
        q = Path(prefix).resolve()
        return p == q or q in p.parents
    except OSError:
        # Fallback for non-existent paths: normalize and compare strings
        p_str = os.path.normcase(os.path.normpath(os.path.abspath(path)))
        q_str = os.path.normcase(os.path.normpath(os.path.abspath(prefix)))
        # Ensure prefix is a directory boundary
        if not q_str.endswith(os.path.sep):
            q_str = q_str + os.path.sep
        return p_str == q_str.rstrip(os.path.sep) or p_str.startswith(q_str)
