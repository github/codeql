from .builtin_extractor import BuiltinExtractor
from .py_extractor import PythonExtractor
from .py_extractor import PackageExtractor
from .file_extractor import FileExtractor
from .thrift_extractor import ThriftExtractor
from semmle.files import TrapFolder, SourceArchive, NullArchive
from semmle.profiling import MillisecondTimer
from semmle.logging import DEBUG, Logger

class SuperExtractor(object):
    '''Extractor that can extract any 'extractable'.
    Delegates to the relevant extractor.'''

    def __init__(self, options, trap_dir, archive, renamer, logger: Logger, diagnostics_writer):
        trap_folder = TrapFolder(trap_dir, renamer, logger)
        if archive is None:
            src_archive = NullArchive(renamer)
        else:
            src_archive = SourceArchive(archive, renamer, logger)
        bltn_extractor = BuiltinExtractor(options, trap_folder, src_archive, logger)
        package_extractor = PackageExtractor(options, trap_folder, src_archive, logger)
        gen_extractor = FileExtractor(options, trap_folder, src_archive, logger)
        thrift_extractor = ThriftExtractor(options, trap_folder, src_archive, logger)
        self.py_extractor = PythonExtractor(options, trap_folder, src_archive, logger, diagnostics_writer)
        self.extractors = [ bltn_extractor, thrift_extractor, self.py_extractor, package_extractor, gen_extractor]
        if logger.level >= DEBUG:
            self.extractors = [ TimingExtractor(extractor, logger) for extractor in self.extractors ]
        self.logger = logger
        self.options = options

    def process(self, unit):
        for extractor in self.extractors:
            self.logger.debug("Trying %s on %s",extractor.name, unit)
            res = extractor.process(unit)
            if res is not NotImplemented:
                self.logger.debug("%s extracted by the %s.", unit, extractor.name)
                break
        else:
            self.logger.error("Could not extract %s", unit)
            res = ()
        return res

    def add_extractor(self, extractor):
        #Insert after built-in extractor
        self.extractors.insert(1, extractor)

    def close(self):
        for ex in self.extractors:
            ex.close()

    def write_global_data(self):
        self.py_extractor.write_interpreter_data(self.options)


class TimingExtractor(object):

    def __init__(self, extractor, logger):
        self.timer = MillisecondTimer()
        self.extractor = extractor
        self.logger = logger
        self.name = self.extractor.name

    def process(self, unit):
        with self.timer:
            return self.extractor.process(unit)

    def close(self):
        self.logger.debug(self.name + " time %0.1fs", self.timer.elapsed/1000)
        self.extractor.close()
