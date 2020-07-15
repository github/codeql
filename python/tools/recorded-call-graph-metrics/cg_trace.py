#!/usr/bin/env python3

"""Call Graph tracing.

Execute a python program and for each call being made, record the call and callee. This
allows us to compare call graph resolution from static analysis with actual data -- that
is, can we statically determine the target of each actual call correctly.

If there is 100% code coverage from the Python execution, it would also be possible to
look at the precision of the call graph resolutions -- that is, do we expect a function to
be able to be called in a place where it is not? Currently not something we're looking at.
"""

# read: https://eli.thegreenplace.net/2012/03/23/python-internals-how-callables-work/

# TODO: Know that a call to a C-function was made. See
# https://docs.python.org/3/library/bdb.html#bdb.Bdb.trace_dispatch. Maybe use `lxml` as
# test

# For inspiration, look at these projects:
# - https://github.com/joerick/pyinstrument (capture call-stack every <n> ms for profiling)
# - https://github.com/gak/pycallgraph (display call-graph with graphviz after python execution)

import argparse
import bdb
from io import StringIO
import sys
import os
import dis
import dataclasses
import csv
import xml.etree.ElementTree as etree

# Copy-Paste and uncomment for interactive ipython sessions
# import IPython; IPython.embed(); sys.exit()


_canonic_filename_cache = dict()
def canonic_filename(filename):
    """Return canonical form of filename. (same as Bdb.canonic)

    For real filenames, the canonical form is a case-normalized (on
    case insensitive filesystems) absolute path.  'Filenames' with
    angle brackets, such as "<stdin>", generated in interactive
    mode, are returned unchanged.
    """
    if filename == "<" + filename[1:-1] + ">":
        return filename
    canonic = _canonic_filename_cache.get(filename)
    if not canonic:
        canonic = os.path.abspath(filename)
        canonic = os.path.normcase(canonic)
        _canonic_filename_cache[filename] = canonic
    return canonic


@dataclasses.dataclass(frozen=True, eq=True, order=True)
class Call():
    """A call
    """
    filename: str
    linenum: int
    inst_index: int

    @classmethod
    def from_frame(cls, frame):
        code = frame.f_code

        # Uncomment to see the bytecode
        # b = dis.Bytecode(frame.f_code, current_offset=frame.f_lasti)
        # print(b.dis(), file=sys.__stderr__)

        return cls(
            filename = canonic_filename(code.co_filename),
            linenum = frame.f_lineno,
            inst_index = frame.f_lasti,
        )


@dataclasses.dataclass(frozen=True, eq=True, order=True)
class Callee():
    """A callee (Function/Lambda/???)

    should (hopefully) be uniquely identified by its name and location (filename+line
    number)
    """
    filename: str
    linenum: int
    funcname: str

    @classmethod
    def from_frame(cls, frame):
        code = frame.f_code
        return cls(
            funcname = code.co_name,
            filename = canonic_filename(code.co_filename),
            linenum = frame.f_lineno,
        )


class CallGraphTracer(bdb.Bdb):
    """Tracer that records calls being made

    It would seem obvious that this should have extended `trace` library
    (https://docs.python.org/3/library/trace.html), but that part is not extensible --
    however, the basic debugger (bdb) is, and provides maybe a bit more help than just
    using `sys.settrace` directly.
    """

    recorded_calls: set

    def __init__(self):
        self.recorded_calls = set()
        super().__init__()

    def user_call(self, frame, argument_list):
        call = Call.from_frame(frame.f_back)
        callee = Callee.from_frame(frame)

        # _print(f'{call}  -> {callee}')
        self.recorded_calls.add((call, callee))


################################################################################
# Export
################################################################################


class Exporter:

    @staticmethod
    def export(recorded_calls, outfile_path):
        raise NotImplementedError()

    @staticmethod
    def dataclass_to_dict(obj):
        d = dataclasses.asdict(obj)
        prefix = obj.__class__.__name__.lower()
        return {f"{prefix}_{key}": val for (key, val) in d.items()}


class CSVExporter(Exporter):

    @staticmethod
    def export(recorded_calls, outfile_path):
        with open(outfile_path, 'w', newline='') as csv_file:
            writer = None
            for (call, callee) in sorted(recorded_calls):
                data = {
                    **Exporter.dataclass_to_dict(call),
                    **Exporter.dataclass_to_dict(callee)
                }

                if writer is None:
                    writer = csv.DictWriter(csv_file, fieldnames=data.keys())
                    writer.writeheader()

                writer.writerow(data)


        print(f'output written to {outfile_path}')

        # embed(); sys.exit()


class XMLExporter(Exporter):

    @staticmethod
    def export(recorded_calls, outfile_path):

        root = etree.Element('root')

        for (call, callee) in sorted(recorded_calls):
            data = {
                **Exporter.dataclass_to_dict(call),
                **Exporter.dataclass_to_dict(callee)
            }

            rc = etree.SubElement(root, 'recorded_call')
            # this xml library only supports serializing attributes that have string values
            rc.attrib = {k: str(v) for k, v in data.items()}

        tree = etree.ElementTree(root)
        tree.write(outfile_path, encoding='utf-8')


################################################################################
# __main__
################################################################################


if __name__ == "__main__":


    parser = argparse.ArgumentParser()


    parser.add_argument('--csv')
    parser.add_argument('--xml')

    parser.add_argument('progname', help='file to run as main program')
    parser.add_argument('arguments', nargs=argparse.REMAINDER,
            help='arguments to the program')

    opts = parser.parse_args()

    # These details of setting up the program to be run is very much inspired by `trace`
    # from the standard library
    sys.argv = [opts.progname, *opts.arguments]
    sys.path[0] = os.path.dirname(opts.progname)

    with open(opts.progname) as fp:
        code = compile(fp.read(), opts.progname, 'exec')

    # try to emulate __main__ namespace as much as possible
    globs = {
        '__file__': opts.progname,
        '__name__': '__main__',
        '__package__': None,
        '__cached__': None,
    }

    real_stdout = sys.stdout
    real_stderr = sys.stderr
    captured_stdout = StringIO()

    sys.stdout = captured_stdout
    cgt = CallGraphTracer()
    cgt.run(code, globs, globs)
    sys.stdout = real_stdout

    if opts.csv:
        CSVExporter.export(cgt.recorded_calls, opts.csv)
    elif opts.xml:
        XMLExporter.export(cgt.recorded_calls, opts.xml)
    else:
        for (call, callee) in sorted(cgt.recorded_calls):
            print(f'{call}  -> {callee}')

    print('--- captured stdout ---')
    print(captured_stdout.getvalue(), end='')
