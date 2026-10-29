from . import util
import os.path
import sys
from time import time
import collections

__all__ = [ 'get_profiler' ]

class NoProfiler(object):
    '''Dummy profiler'''

    def __init__(self):
        pass

    def __enter__(self):
        return self

    def __exit__(self, *args):
        pass

class StatProfiler(object):
    ''' statprof based statistical profiler'''

    def __init__(self, outpath):
        self.outpath = outpath

    def __enter__(self):
        statprof.start()
        return self

    def __exit__(self, *args):
        statprof.stop()
        with open(self.outpath, "w") as fd:
            statprof.display(fd)


def get_profiler(options, id, logger):
    '''Returns a profile based on options and version. `id` is used to
    label the output file.'''
    global statprof
    if options.profile_out:
        if sys.version_info >= (3,0):
            logger.warning("Cannot create profiler: statprof is Python2 only.")
        else:
            try:
                import statprof
                util.makedirs(options.profile_out)
                outpath = os.path.join(options.profile_out, "profile-%s.txt" % id)
                logger.info("Writing profile information to %s", outpath)
                return StatProfiler(outpath)
            except ImportError:
                logger.warning("Cannot create profiler: no statprof module.")
            except Exception as ex:
                logger.warning("Cannot create profiler: %s", ex)
    return NoProfiler()

class MillisecondTimer(object):

    def __init__(self):
        self.elapsed = 0.0

    def __enter__(self):
        self.start = time()
        return self

    def __exit__(self, *_):
        self.elapsed += (time() - self.start)*1000


timers = collections.defaultdict(MillisecondTimer)
