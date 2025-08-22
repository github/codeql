from semmle.util import makedirs
import os
from collections import deque
from functools import total_ordering

'''
Least Recently Written Disk-based Cache

Implements a LRW disk cache for trap files and similar.
This cache relies on the following properties which *must* hold.

Only one value can ever be associated with a key.
Keys should be ascii strings and cannot start with '$' or include any file or path separator characters.
Values should be byte strings (with any contents).

The cache is robust against arbitrary levels of concurrency.

'''


MAX_GENERATIONS = 50
MAX_FILES_PER_GENERATION = 200

def encode_keys(keys):
    'Convert a collection of keys to a byte string'
    return '\n'.join(keys).encode("ascii")

def decode_keys(data):
    'Convert a byte string into a set of keys'
    return set(data.decode("ascii").split('\n'))

@total_ordering
class Generation(object):

    def __init__(self, cachedir, age):
        self.cachedir = os.path.join(cachedir, str(age))
        self.age = age
        if not os.path.exists(self.cachedir):
            makedirs(self.cachedir)
        try:
            with open(os.path.join(self.cachedir, "$keys"), 'rb') as fd:
                self.keys = decode_keys(fd.read())
            self.full = True
        except Exception:
            self.keys = set()
            if os.path.isdir(self.cachedir):
                #Directory exists, but cannot read "$keys", so this is a non-full generation
                self.full = False
            else:
                self.full = True

    def get(self, key):
        if self.full and key not in self.keys:
            return None
        try:
            with open(os.path.join(self.cachedir, key), 'rb') as fd:
                return fd.read()
        except Exception:
            return None

    def set(self, key, value):
        '''Returns true if it should be able to store (key, value) even if in fact it can't.
        This means that this method will return True if the generation is not full.'''
        if self.full:
            return False
        if os.path.exists(os.path.join(self.cachedir, "$keys")):
            self.full = True
            try:
                with open(os.path.join(self.cachedir, "$keys"), 'rb') as fd:
                    self.keys = decode_keys(fd.read())
            except Exception:
                self.keys = set()
            return False
        self._try_atomic_write_file(key, value)
        if len(self._list_files()) >= MAX_FILES_PER_GENERATION:
            self.full = True
            self._write_keys()
        return True

    def _list_files(self):
        try:
            return os.listdir(self.cachedir)
        except Exception:
            #This probably means the directory has been deleted
            return []

    def _write_keys(self):
        keys = self._list_files()
        self._try_atomic_write_file("$keys", encode_keys(keys))
        self.keys = set(keys)

    def _try_atomic_write_file(self, name, contents):
        fullname = os.path.join(self.cachedir, name)
        tmpname = os.path.join(self.cachedir, '$%d%s' % (os.getpid(), name))
        try:
            with open(tmpname, 'wb') as tmp:
                tmp.write(contents)
            os.rename(tmpname, fullname)
        except Exception:
            #Failed for some reason. The folder may have been deleted, or on Windows, the file may already exist.
            #Attempt to tidy up
            if os.path.exists(tmpname):
                try:
                    os.remove(tmpname)
                except Exception:
                    #Give up :(
                    pass

    def clear(self):
        try:
            filenames = os.listdir(self.cachedir)
        except Exception:
            #Can't do anything
            return
        for filename in filenames:
            try:
                os.remove(os.path.join(self.cachedir, filename))
            except Exception:
                # Can't delete. Maybe another process has deleted it or it is open (on Windows)
                pass
        try:
            os.rmdir(self.cachedir)
        except Exception:
            # Can't delete
            pass

    def __lt__(self, other):
        #Smaller numbers are older
        return self.age > other.age

class Cache(object):

    cache_of_caches = {}

    def __init__(self, cachedir, verbose=False):
        self.cachedir = cachedir
        self.verbose = verbose
        self.generations = []
        if not os.path.exists(cachedir):
            makedirs(cachedir)
        generations = []
        for gen in os.listdir(self.cachedir):
            try:
                age = int(gen)
                generations.append(Generation(self.cachedir, age))
            except Exception:
                #gen might not be an int, or it may have been deleted
                pass
        if generations:
            generations.sort()
        else:
            generations = [Generation(self.cachedir, 1)]
        self.generations = deque(generations)
        while len(self.generations) > MAX_GENERATIONS:
            self.generations.pop().clear()

    def set(self, key, value):
        '''Add this (key, value) pair to the cache. keys should not start with '$' or include file or path separators.
        Either adds the (key, value) atomically or does nothing. Partial keys or values are never visible.
        '''
        try:
            while not self.generations[0].set(key, value):
                self.generations.appendleft(Generation(self.cachedir, self.generations[0].age+1))
                if len(self.generations) > MAX_GENERATIONS:
                    self.generations.pop().clear()
        except Exception as ex:
            #Its OK to fail but we must never raise
            if self.verbose:
                try:
                    print ("Exception setting cache key '%s': %s" % (key, ex))
                except Exception:
                    # Just in case
                    pass

    def get(self, key):
        if key is None:
            return None
        try:
            for gen in self.generations:
                res = gen.get(key)
                if res is not None:
                    return res
        except Exception as ex:
            if self.verbose:
                try:
                    print ("Exception getting cache key '%s': %s" % (key, ex))
                except Exception:
                    # Just in case
                    pass
        return None

    @staticmethod
    def for_directory(cachedir, verbose):
        '''Caches are relatively expensive objects, so we cache them.'''
        if (cachedir, verbose) not in Cache.cache_of_caches:
            Cache.cache_of_caches[(cachedir, verbose)] = Cache(cachedir, verbose)
        return Cache.cache_of_caches[(cachedir, verbose)]
