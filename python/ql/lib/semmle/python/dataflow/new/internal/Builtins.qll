/** Provides predicates for reasoning about built-ins in Python. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.ImportStar

module Builtins {
  /** Gets the name of a known built-in. */
  string getBuiltinName() {
    // These lists were created by inspecting the `builtins` and `__builtin__` modules in
    // Python 3 and 2 respectively, using the `dir` built-in.
    // Built-in functions and exceptions shared between Python 2 and 3
    result in [
        "abs", "all", "any", "bin", "bool", "bytearray", "callable", "chr", "classmethod",
        "compile", "complex", "delattr", "dict", "dir", "divmod", "enumerate", "eval", "filter",
        "float", "format", "frozenset", "getattr", "globals", "hasattr", "hash", "help", "hex",
        "id", "input", "int", "isinstance", "issubclass", "iter", "len", "list", "locals", "map",
        "max", "memoryview", "min", "next", "object", "oct", "open", "ord", "pow", "print",
        "property", "range", "repr", "reversed", "round", "set", "setattr", "slice", "sorted",
        "staticmethod", "str", "sum", "super", "tuple", "type", "vars", "zip", "__import__",
        // Exceptions
        "ArithmeticError", "AssertionError", "AttributeError", "BaseException", "BufferError",
        "BytesWarning", "DeprecationWarning", "EOFError", "EnvironmentError", "Exception",
        "FloatingPointError", "FutureWarning", "GeneratorExit", "IOError", "ImportError",
        "ImportWarning", "IndentationError", "IndexError", "KeyError", "KeyboardInterrupt",
        "LookupError", "MemoryError", "NameError", "NotImplemented", "NotImplementedError",
        "OSError", "OverflowError", "PendingDeprecationWarning", "ReferenceError", "RuntimeError",
        "RuntimeWarning", "StandardError", "StopIteration", "SyntaxError", "SyntaxWarning",
        "SystemError", "SystemExit", "TabError", "TypeError", "UnboundLocalError",
        "UnicodeDecodeError", "UnicodeEncodeError", "UnicodeError", "UnicodeTranslateError",
        "UnicodeWarning", "UserWarning", "ValueError", "Warning", "ZeroDivisionError",
        // Added for compatibility
        "exec"
      ]
    or
    // Built-in constants shared between Python 2 and 3
    result in ["False", "True", "None", "NotImplemented", "Ellipsis", "__debug__"]
    or
    // Python 3 only
    result in [
        "ascii", "breakpoint", "bytes", "exec",
        // Exceptions
        "BlockingIOError", "BrokenPipeError", "ChildProcessError", "ConnectionAbortedError",
        "ConnectionError", "ConnectionRefusedError", "ConnectionResetError", "FileExistsError",
        "FileNotFoundError", "InterruptedError", "IsADirectoryError", "ModuleNotFoundError",
        "NotADirectoryError", "PermissionError", "ProcessLookupError", "RecursionError",
        "ResourceWarning", "StopAsyncIteration", "TimeoutError"
      ]
    or
    // Python 2 only
    result in [
        "basestring", "cmp", "execfile", "file", "long", "raw_input", "reduce", "reload", "unichr",
        "unicode", "xrange"
      ]
  }

  /**
   * Gets a data flow node that is likely to refer to a built-in with the name `name`.
   *
   * Currently this is an over-approximation, and may not account for things like overwriting a
   * built-in with a different value.
   */
  DataFlow::Node likelyBuiltin(string name) {
    exists(Module m |
      result.asCfgNode() =
        any(NameNode n |
          possible_builtin_accessed_in_module(n, name, m) and
          not possible_builtin_defined_in_module(name, m)
        )
    )
  }

  /**
   * Holds if a global variable called `name` (which is also the name of a built-in) is assigned
   * a value in the module `m`.
   */
  private predicate possible_builtin_defined_in_module(string name, Module m) {
    ImportStar::globalNameDefinedInModule(name, m) and
    name = getBuiltinName()
  }

  /**
   * Holds if `n` is an access of a global variable called `name` (which is also the name of a
   * built-in) inside the module `m`.
   */
  private predicate possible_builtin_accessed_in_module(NameNode n, string name, Module m) {
    n.isGlobal() and
    n.isLoad() and
    name = n.getId() and
    name = getBuiltinName() and
    m = n.getEnclosingModule()
  }
}
