import itertools
import logging
import os
import sys
import time
from datetime import datetime
from io import StringIO

from cg_trace import __version__, cmdline, settings, tracer
from cg_trace.exporter import XMLExporter


def record_calls(code, globals):
    real_stdout = sys.stdout
    real_stderr = sys.stderr
    captured_stdout = StringIO()
    captured_stderr = StringIO()

    sys.stdout = captured_stdout
    sys.stderr = captured_stderr

    cgt = tracer.CallGraphTracer()
    exit_status = cgt.run(code, globals, globals)
    sys.stdout = real_stdout
    sys.stderr = real_stderr

    all_calls_sorted = sorted(
        itertools.chain(cgt.python_calls.values(), cgt.external_calls.values())
    )

    return all_calls_sorted, captured_stdout, captured_stderr, exit_status


def setup_logging(debug):
    # code we run can also set up logging, so we need to set the level directly on our
    # own pacakge
    sh = logging.StreamHandler(stream=sys.stderr)

    pkg_logger = logging.getLogger("cg_trace")
    pkg_logger.addHandler(sh)
    pkg_logger.setLevel(logging.CRITICAL if debug else logging.INFO)


def main(args=None) -> int:

    # from . import bytecode_reconstructor
    # logging.getLogger(bytecode_reconstructor.__name__).setLevel(logging.INFO)

    if args is None:
        # first element in argv is program name
        args = sys.argv[1:]

    opts = cmdline.parse(args)

    settings.DEBUG = opts.debug
    setup_logging(opts.debug)

    # These details of setting up the program to be run is very much inspired by `trace`
    # from the standard library
    if opts.module:
        import runpy

        module_name = opts.progname
        _mod_name, mod_spec, code = runpy._get_module_details(module_name)
        sys.argv = [code.co_filename, *opts.arguments]
        globs = {
            "__name__": "__main__",
            "__file__": code.co_filename,
            "__package__": mod_spec.parent,
            "__loader__": mod_spec.loader,
            "__spec__": mod_spec,
            "__cached__": None,
        }
    else:
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

    start = time.time()
    recorded_calls, captured_stdout, captured_stderr, exit_status = record_calls(
        code, globs
    )
    end = time.time()
    elapsed_formatted = f"{end-start:.2f} seconds"

    if opts.xml:
        XMLExporter.export(
            opts.xml,
            recorded_calls,
            info={
                "cg_trace_version": __version__,
                "args": " ".join(args),
                "exit_status": exit_status,
                "elapsed": elapsed_formatted,
                "utctimestamp": datetime.utcnow().replace(microsecond=0).isoformat(),
            },
        )
    else:
        print(f"--- Recorded calls (in {elapsed_formatted}) ---")
        for (call, callee) in recorded_calls:
            print(f"{call} --> {callee}")

    print("--- captured stdout ---")
    print(captured_stdout.getvalue(), end="")
    print("--- captured stderr ---")
    print(captured_stderr.getvalue(), end="")

    return 0
