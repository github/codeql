#!/usr/bin/env python

import os
import shutil
import sys
import zipfile
import optparse
import compileall

from python_tracer import getzipfilename

# TO DO -- Add options to set destination directory and source directory


def find_tools():
    try:
        return os.environ['PYTHON_INSTALLER_OUTPUT']
    except KeyError:
        pass
    try:
        return os.environ['ODASA_TOOLS']
    except KeyError:
        pass
    try:
        return os.path.join(os.environ['SEMMLE_DIST'], 'tools')
    except KeyError:
        pass
    try:
        return os.path.join(os.environ['ODASA_HOME'], 'tools')
    except KeyError:
        pass
    raise Exception('ODASA_TOOLS environment variable is not set')

def find_src():
    if __name__ == '__main__':
        return os.path.dirname(os.path.abspath(sys.argv[0]))
    raise Exception('Cannot find source code')


def build_byte_compiled_zip(src_dir, zippath):
    # TODO(low): Why are we compiling ourselves, when writepy can also do that?
    compileall.compile_dir(os.path.join(src_dir, 'semmle'), force=True, quiet=True)

    zipped = zipfile.PyZipFile(zippath, 'w')

    zipped.writepy(os.path.join(src_dir, '__main__.py'))
    zipped.writepy(os.path.join(src_dir, 'semmle'))
    zipped.writepy(os.path.join(src_dir, 'blib2to3'))
    zipped.writepy(os.path.join(src_dir, 'lark'))
    zipped.writepy(os.path.join(src_dir, 'buildtools'))
    zipped.write(os.path.join(src_dir, 'blib2to3', 'Grammar.txt'), 'blib2to3/Grammar.txt')
    zipped.write(os.path.join(src_dir, 'lark', 'grammars', 'common.lark'), 'lark/grammars/common.lark')

    data_dir = os.path.join(src_dir, 'semmle', 'data')
    for f in os.listdir(data_dir):
        if f.endswith('.trap'):
            zipped.write(os.path.join(data_dir, f), os.path.join('semmle', 'data', f))
    zipped.close()


def build_source_zip(src_dir, zippath):
    zipped = zipfile.PyZipFile(zippath, 'w')

    zipped.write(os.path.join(src_dir, '__main__.py'), '__main__.py')
    zipped.write(os.path.join(src_dir, 'imp.py'), 'imp.py')
    write_source(zipped, src_dir, 'semmle')
    write_source(zipped, src_dir, 'blib2to3', ('.py', '.txt', ''))
    write_source(zipped, src_dir, 'lark', (".py", ".lark", ""))
    write_source(zipped, src_dir, 'buildtools')

    data_dir = os.path.join(src_dir, 'semmle', 'data')
    for f in os.listdir(data_dir):
        if f.endswith('.trap'):
            zipped.write(os.path.join(data_dir, f), os.path.join('semmle', 'data', f))

    zipped.close()

def write_source(zipped, root, name, extensions=[".py"]):
    src = os.path.join(root, name)
    for dirpath, _, filenames in os.walk(src):
        for name in filenames:
            _, ext = os.path.splitext(name)
            if ext not in extensions:
                continue
            path = os.path.join(dirpath, name)
            zipped.write(path, os.path.relpath(path, root))

def main():
    parser = optparse.OptionParser(usage = "usage: %prog [install-dir]")
    _, args = parser.parse_args(sys.argv[1:])
    if len(args) > 1:
        parser.print_usage()
    elif args:
        tools_dir = args[0]
        if not os.path.exists(tools_dir):
            os.makedirs(tools_dir)
    else:
        tools_dir = find_tools()
    src_dir = find_src()

    zippath = os.path.join(src_dir, getzipfilename())

    if sys.version_info > (3,):
        build_source_zip(src_dir, zippath)
    else:
        build_byte_compiled_zip(src_dir, zippath)

    shutil.copy(zippath, tools_dir)

if __name__ == '__main__':
    main()
