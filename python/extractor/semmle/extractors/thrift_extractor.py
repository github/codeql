

import os.path
import semmle.thrift
import semmle.util
from semmle.extractors.base import BaseExtractor

class ThriftExtractor(BaseExtractor):
    '''Extractor that can extract Apache thrift IDL files.'''

    name = "thrift extractor"

    def __init__(self, options, trap_folder, src_archive, logger):
        super(ThriftExtractor, self).__init__(options, trap_folder, src_archive, logger)
        self.thrift_extractor = semmle.thrift.Extractor(trap_folder, src_archive)

    def process(self, unit):
        if not isinstance(unit, semmle.util.FileExtractable):
            return NotImplemented
        if semmle.util.isdir(unit.path):
            return NotImplemented
        if not unit.path.endswith(".thrift"):
            return NotImplemented
        self.thrift_extractor.extract_file(unit.path)
        return ()

    def close(self):
        pass
