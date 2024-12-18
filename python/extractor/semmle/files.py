import os.path
import sys

from semmle.util import base64digest, makedirs

_WINDOWS = os.name == "nt"

LONG_PATH_PREFIX = "\\\\?\\"

def make_renamer(renamer):
    if os.name == "nt":
        if renamer is None:
            return lambda path : path.replace('\\', '/')
        else:
            return lambda path : renamer(path).replace('\\', '/')
    else:
        if renamer is None:
            return lambda path : path
        else:
            return renamer


class NullArchive(object):
    '''A fake source archive object for use when there is no
    source archive folder. For example, by qltest.'''

    def __init__(self, renamer=None):
        self.renamer = make_renamer(renamer)

    def write(self, path, source, encoding=None):
        pass

    def get_virtual_path(self, real_path):
        '''Gets the virtual (potentially renamed) path for the given real path'''
        return self.renamer(real_path)

class RenamingFolder(object):
    '''A folder that can rename its contents according to the given renamer
    (usually derived from a project layout file).'''

    def __init__(self, folder, renamer, logger):
        assert folder is not None
        self.folder = folder
        self.renamer = make_renamer(renamer)
        self.logger = logger

    def get_virtual_path(self, real_path):
        '''Gets the virtual (potentially renamed) path for the given real path'''
        return self.renamer(real_path)

    def get_storage_path(self, *subpath):
        '''Gets the path for storing an item at.
        Creates the necessary sub folders and
        handles long paths on Windows.'''
        #Remove empty path elements
        subpath = [ p for p in subpath if p ]
        suffix = os.sep.join(subpath)
        suffix = suffix.replace(':', '_')
        if suffix[0] in '/\\':
            result = self.folder + suffix
        else:
            result = self.folder + os.sep + suffix
        if _WINDOWS and len(result) > 240:
            result = LONG_PATH_PREFIX + result
        folder = os.path.dirname(result)
        if not os.path.exists(folder):
            makedirs(folder)
        return result

class TrapFolder(RenamingFolder):

    def _trap_path(self, namespace, path, extension='.trap.gz'):
        vpath = self.get_virtual_path(path)
        parts = vpath.split('/')
        basename = parts[-1]
        hashcode = base64digest(vpath + namespace)
        filename = basename + '.' + hashcode + extension
        return self.get_storage_path(filename)

    def write_trap(self, namespace, path, data, extension='.trap.gz'):
        '''Write the trap file for `path` in `namespace` using the given file extension (defaults to .trap.gz)'''
        outpath = self._trap_path(namespace, path, extension)
        with open(outpath, "wb") as out:
            out.write(data)

class SourceArchive(RenamingFolder):

    def write(self, path, bytes_source):
        '''Write the `source` to `path` in this source archive folder.'''
        vpath = self.get_virtual_path(path)
        if vpath != path:
            self.logger.debug("Renaming '%s' to '%s'", path, vpath)
        self.logger.debug("Writing source to '%s'", vpath)
        subpath = vpath.split('/')
        outpath = self.get_storage_path(*subpath)
        with open(outpath, "wb") as out:
            out.write(bytes_source)
