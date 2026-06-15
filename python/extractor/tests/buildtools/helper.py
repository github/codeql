import os
import stat
import tempfile
import shutil
import time
import sys
import subprocess
from contextlib import contextmanager
from functools import wraps


# Would have liked to use a decorator, but for Python 2 the functools.wraps is not good enough for
# signature preservation that pytest can figure out what is going on. It would be possible to use
# the decorator package, but that seemed like a bit too much of a hassle.
@contextmanager
def in_fresh_temp_dir():
    old_cwd = os.getcwd()
    with managed_temp_dir('extractor-python-buildtools-test-') as tmp:
        os.chdir(tmp)
        try:
            yield tmp
        finally:
            os.chdir(old_cwd)


@contextmanager
def managed_temp_dir(prefix=None):
    dir = tempfile.mkdtemp(prefix=prefix)
    try:
        yield dir
    finally:
        rmtree_robust(dir)


def rmtree_robust(dir):
    if is_windows():
        # It's important that the path is a Unicode path on Windows, so
        # that the right system calls get used.
        dir = u'' + dir
        if not dir.startswith("\\\\?\\"):
            dir = "\\\\?\\" + os.path.abspath(dir)

    # Emulate Python 3 "nonlocal" keyword
    class state: pass
    state.last_failed_delete = None


    def _rmtree(path):
        """wrapper of shutil.rmtree to handle Python 3.12 rename (onerror => onexc)"""
        if sys.version_info >= (3, 12):
            shutil.rmtree(path, onexc=remove_error)
        else:
            shutil.rmtree(path, onerror=remove_error)

    def remove_error(func, path, excinfo):
        # If we get an error twice in a row for the same path then just give up.
        if state.last_failed_delete == path:
            return
        state.last_failed_delete = path

        # The problem could be one of permissions, so setting path writable
        # might fix it.
        os.chmod(path, stat.S_IWRITE)

        # On Windows, we sometimes get errors about directories not being
        # empty, but immediately afterwards they are empty. Waiting a bit
        # might therefore be sufficient.
        t = 0.1
        while (True):
            try:
                if os.path.isdir(path):
                    _rmtree(path)
                else:
                    os.remove(path)
            except OSError:
                if (t > 1):
                    return # Give up
                time.sleep(t)
                t *= 2
    _rmtree(dir)
    # On Windows, attempting to write immediately after deletion may result in
    # an 'access denied' exception, so wait a bit.
    if is_windows():
        time.sleep(0.5)


def is_windows():
    return os.name == 'nt'


@contextmanager
def copy_repo_dir(repo_dir_in):
    with managed_temp_dir(prefix="extractor-python-buildtools-test-") as tmp:
        repo_dir = os.path.join(tmp, 'repo')
        print('copying', repo_dir_in, 'to', repo_dir)
        shutil.copytree(repo_dir_in, repo_dir, symlinks=True)
        yield repo_dir

################################################################################


DEVNULL = subprocess.DEVNULL
