from semmle.logging import Logger


class BaseExtractor(object):
    '''Base class for extractors.'''

    def __init__(self, options, trap_folder, src_archive, logger: Logger):
        self.options = options
        self.trap_folder = trap_folder
        self.src_archive = src_archive
        self.logger = logger

    def process(self, unit):
        raise NotImplementedError()
