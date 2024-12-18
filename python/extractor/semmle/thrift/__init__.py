import os.path

from .parse import Parser
from .emit import Emitter

class Extractor(object):

    def __init__(self, trap_folder, src_archive=None):
        self.parser = Parser()
        self.emitter = Emitter(trap_folder)
        self.src_archive = src_archive

    def _walk(self, path):
        for dirpath, _, filenames in os.walk(path):
            for filename in filenames:
                if filename.endswith(".thrift"):
                    yield os.path.join(dirpath, filename)

    def extract_files(self, files):
        for file in files:
            self.extract_file(file)

    def extract_folder(self, path):
        for file in self._walk(path):
            self.extract_file(file)

    def extract_file(self, file):
        with open(file, "rb") as fd:
            bytes_source = fd.read()
        src = bytes_source.decode('utf-8')
        tree = self.parser.parse(src)
        self.emitter.emit(file, tree)
        if self.src_archive:
            self.src_archive.write(file, bytes_source)
