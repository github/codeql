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
from lxml import etree
from typing import Optional

# copy-paste For interactive ipython sessions
# import IPython; sys.stdout = sys.__stdout__; IPython.embed(); sys.exit()

def debug_print(*args, **kwargs):
    # print(*args, **kwargs, file=sys.__stderr__)
    pass

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
        b = dis.Bytecode(frame.f_code, current_offset=frame.f_lasti)
        debug_print(b.dis())

        return cls(
            filename = canonic_filename(code.co_filename),
            linenum = frame.f_lineno,
            inst_index = frame.f_lasti,
        )


def better_compare_for_dataclass(cls):
    """When dataclass is used with `order=True`, the comparison methods is only implemented for
    objects of the same class. This decorator extends the functionality to compare class
    name if used against other objects.
    """
    for op in ['__lt__', '__le__', '__gt__', '__ge__',]:
        old = getattr(cls, op)
        def new(self, other):
            if type(self) == type(other):
                return old(self, other)
            return getattr(str, op)(self.__class__.__name__, other.__class__.__name__)
        setattr(cls, op, new)
    return cls

@dataclasses.dataclass(frozen=True, eq=True, order=True)
class Callee:
    pass


BUILTIN_FUNCTION_OR_METHOD = type(print)


@better_compare_for_dataclass
@dataclasses.dataclass(frozen=True, eq=True, order=True)
class ExternalCallee(Callee):
    # Some bound methods might not have __module__ attribute: for example,
    # `list().append.__module__ is None`
    module: Optional[str]
    qualname: str
    #
    is_builtin: bool

    @classmethod
    def from_arg(cls, func):
        # if func.__name__ == "append":
            # import IPython; sys.stdout = sys.__stdout__; IPython.embed(); sys.exit()

        return cls(
            module=func.__module__,
            qualname=func.__qualname__,
            is_builtin=type(func) == BUILTIN_FUNCTION_OR_METHOD
        )


@better_compare_for_dataclass
@dataclasses.dataclass(frozen=True, eq=True, order=True)
class PythonCallee(Callee):
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
            filename = canonic_filename(code.co_filename),
            linenum = frame.f_lineno,
            funcname = code.co_name,
        )


class CallGraphTracer:
    """Tracer that records calls being made

    It would seem obvious that this should have extended `trace` library
    (https://docs.python.org/3/library/trace.html), but that part is not extensible.

    You might think that we can just use `sys.settrace`
    (https://docs.python.org/3.8/library/sys.html#sys.settrace) like the basic debugger
    (bdb) does, but that isn't invoked on calls to C code, which we need in general, and
    need for handling builtins specifically.

    Luckily, `sys.setprofile`
    (https://docs.python.org/3.8/library/sys.html#sys.setprofile) provides all that we
    need. You might be scared by reading the following bit of the documentation

    > The function is thread-specific, but there is no way for the profiler to know about
    > context switches between threads, so it does not make sense to use this in the
    > presence of multiple threads.

    but that is to be understood in the context of making a profiler (you can't reliably
    measure function execution time if you don't know about context switches). For our
    use-case, this is not a problem.
    """

    recorded_calls: set

    def __init__(self):
        self.recorded_calls = set()

    def run(self, code, globals, locals):
        self.exec_call_seen = False
        self.ignore_rest = False
        try:
            sys.setprofile(cgt.profilefunc)
            exec(code, globals, locals)
        # TODO: exception handling?
        finally:
            sys.setprofile(None)

    def profilefunc(self, frame, event, arg):
        # ignore everything until the first call, since that is `exec` from the `run` method above
        if not self.exec_call_seen:
            if event == "call":
                self.exec_call_seen = True
            return

        # if we're going out of the exec, we should ignore anything else (for example the
        # call to `sys.setprofile(None)`)
        if event == "c_return":
            if arg == exec and frame.f_code.co_filename == __file__:
                self.ignore_rest = True

        if self.ignore_rest:
            return

        if event not in ["call", "c_call"]:
            return

        debug_print(f"profilefunc {event=}")
        if event == "call":
            # in call, the `frame` argument is new the frame for entering the callee
            call = Call.from_frame(frame.f_back)
            callee = PythonCallee.from_frame(frame)

        if event == "c_call":
            # in c_call, the `frame` argument is frame where the call happens, and the `arg` argument
            # is the C function object.
            call = Call.from_frame(frame)
            callee = ExternalCallee.from_arg(arg)

        debug_print(f'{call} --> {callee}')
        debug_print('\n'*5)
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
            for k, v in data.items():
                # xml library only supports serializing attributes that have string values
                rc.set(k, str(v))

        tree = etree.ElementTree(root)
        tree.write(outfile_path, encoding='utf-8', pretty_print=True)


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
            print(f'{call} --> {callee}')

    print('--- captured stdout ---')
    print(captured_stdout.getvalue(), end='')
