
from semmle import util
from semmle.extractors.base import BaseExtractor

HALF_MB = 1 << 19

class FileExtractor(BaseExtractor):
    '''Extractor for extracting arbitrary 'text' files.'''

    name = "file extractor"

    def process(self, unit):
        if not isinstance(unit, util.FileExtractable):
            return NotImplemented
        if util.isdir(unit.path):
            return NotImplemented
        with open(unit.path, "rb") as fd:
            data = fd.read()
        source = data.decode("latin-1")
        if len(source) > HALF_MB:
            self.logger.info("Skipping overly large file: '%s'", unit.path)
            return ()
        file_tag = util.get_source_file_tag(unit.path)
        writer = util.TrapWriter()
        writer.write_tuple("file_contents", "gS", file_tag, source)
        writer.write_file(unit.path)
        output = writer.get_compressed()
        self.trap_folder.write_trap("file", unit.path, output)
        self.src_archive.write(unit.path, data)
        return ()

    def close(self):
        pass
