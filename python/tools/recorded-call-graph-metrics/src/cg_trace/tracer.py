import dataclasses
import logging
import os
import sys
from types import FrameType
from typing import Optional

from cg_trace.bytecode_reconstructor import BytecodeExpr, expr_from_frame

LOGGER = logging.getLogger(__name__)


# copy-paste For interactive ipython sessions
# import IPython; sys.stdout = sys.__stdout__; IPython.embed(); sys.exit()


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
class Call:
    """A call
    """

    filename: str
    linenum: int
    inst_index: int
    bytecode_expr: BytecodeExpr

    def __str__(self):
        d = dataclasses.asdict(self)
        del d["bytecode_expr"]
        normal_fields = ", ".join(f"{k}={v!r}" for k, v in d.items())

        return f"{type(self).__name__}({normal_fields}, bytecode_expr≈{repr(str(self.bytecode_expr))})"

    @classmethod
    def from_frame(cls, frame: FrameType):
        code = frame.f_code

        bytecode_expr = expr_from_frame(frame)

        return cls(
            filename=canonic_filename(code.co_filename),
            linenum=frame.f_lineno,
            inst_index=frame.f_lasti,
            bytecode_expr=bytecode_expr,
        )


def better_compare_for_dataclass(cls):
    """When dataclass is used with `order=True`, the comparison methods is only implemented for
    objects of the same class. This decorator extends the functionality to compare class
    name if used against other objects.
    """
    for op in [
        "__lt__",
        "__le__",
        "__gt__",
        "__ge__",
    ]:
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
        return cls(
            module=func.__module__,
            qualname=func.__qualname__,
            is_builtin=type(func) == BUILTIN_FUNCTION_OR_METHOD,
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
    def from_frame(cls, frame: FrameType):
        code = frame.f_code
        return cls(
            filename=canonic_filename(code.co_filename),
            linenum=frame.f_lineno,
            funcname=code.co_name,
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
            sys.setprofile(self.profilefunc)
            exec(code, globals, locals)
            return "completed"
        except SystemExit:
            return "completed (SystemExit)"
        except Exception:
            sys.setprofile(None)
            LOGGER.info("Exception occurred while running program:", exc_info=True)
            return "exception occurred"
        finally:
            sys.setprofile(None)

    def profilefunc(self, frame: FrameType, event: str, arg):
        # ignore everything until the first call, since that is `exec` from the `run`
        # method above
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

        LOGGER.debug(f"profilefunc {event=}")
        if event == "call":
            assert frame.f_back is not None
            # in call, the `frame` argument is new the frame for entering the callee
            call = Call.from_frame(frame.f_back)
            callee = PythonCallee.from_frame(frame)

        if event == "c_call":
            # in c_call, the `frame` argument is frame where the call happens, and the
            # `arg` argument is the C function object.
            call = Call.from_frame(frame)
            callee = ExternalCallee.from_arg(arg)

        LOGGER.debug(f"{call} --> {callee}")
        self.recorded_calls.add((call, callee))
