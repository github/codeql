import logging
import os
import sys
from io import StringIO

from cg_trace import cmdline, tracer
from cg_trace.exporter import CSVExporter, XMLExporter


def record_calls(code, globals):
    real_stdout = sys.stdout
    real_stderr = sys.stderr
    captured_stdout = StringIO()
    captured_stderr = StringIO()

    sys.stdout = captured_stdout
    sys.stderr = captured_stderr

    cgt = tracer.CallGraphTracer()
    cgt.run(code, globals, globals)
    sys.stdout = real_stdout
    sys.stderr = real_stderr

    return sorted(cgt.recorded_calls), captured_stdout, captured_stderr


def main(args=None) -> int:
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

    if args is None:
        # first element in argv is program name
        args = sys.argv[1:]

    opts = cmdline.parse(args)

    # These details of setting up the program to be run is very much inspired by `trace`
    # from the standard library
    sys.argv = [opts.progname, *opts.arguments]
    sys.path[0] = os.path.dirname(opts.progname)

    with open(opts.progname) as fp:
        code = compile(fp.read(), opts.progname, "exec")

    # try to emulate __main__ namespace as much as possible
    globs = {
        "__file__": opts.progname,
        "__name__": "__main__",
        "__package__": None,
        "__cached__": None,
    }

    recorded_calls, captured_stdout, captured_stderr = record_calls(code, globs)

    if opts.csv:
        CSVExporter.export(recorded_calls, opts.csv)
    elif opts.xml:
        XMLExporter.export(recorded_calls, opts.xml)
    else:
        print("Recorded calls:")
        for (call, callee) in recorded_calls:
            print(f"{call} --> {callee}")

    print("--- captured stdout ---")
    print(captured_stdout.getvalue(), end="")
    print("--- captured stderr ---")
    print(captured_stderr.getvalue(), end="")

    return 0
