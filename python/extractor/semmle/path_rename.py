import os
import semmle.projectlayout as projectlayout
from semmle.util import SemmleError

__all__ = "renamer_from_options_and_env"

def _realpath(path):
    try:
        return os.path.realpath(path)
    except IOError:
        return os.path.abspath(path)

def renamer_from_options_and_env(options, logger):
    'Returns a renamer function which takes a path and returns the nominal path'
    preserve_symlinks = os.environ.get('SEMMLE_PRESERVE_SYMLINKS', "")
    if options.no_symlinks or preserve_symlinks.lower() == "true":
        pre_rename = os.path.abspath
    else:
        pre_rename = _realpath

    if options.renamer:
        try:
            module = __import__(options.renamer, fromlist=['get_renamer'])
            rename = module.get_renamer()
        except (AttributeError, ImportError):
            raise SemmleError("Cannot get renamer from module " + options.renamer)
    else:
        path_transformer = os.environ.get("SEMMLE_PATH_TRANSFORMER", None)
        if path_transformer:
            logger.info("Using path transformer '%s'", path_transformer)
            rename = projectlayout.get_renamer(path_transformer)
        else:
            rename = lambda path : path

    if os.name == "nt":
        def post_rename(path):
            if path[1] == ':':
                path = path[0].upper() + path[1:]
            return path
    else:
        post_rename = lambda path : path

    renamer = lambda path : post_rename(rename(pre_rename(path)))
    return renamer
