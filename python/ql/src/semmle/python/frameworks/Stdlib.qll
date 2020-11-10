/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts

/** Provides models for the Python standard library. */
private module Stdlib {
  // ---------------------------------------------------------------------------
  // os
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `os` module. */
  private DataFlow::Node os(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("os")
    or
    exists(DataFlow::TypeTracker t2 | result = os(t2).track(t2, t))
  }

  /** Gets a reference to the `os` module. */
  DataFlow::Node os() { result = os(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `os` module.
   * WARNING: Only holds for a few predefined attributes.
   *
   * For example, using `attr_name = "system"` will get all uses of `os.system`.
   */
  private DataFlow::Node os_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in [
        "system", "popen", "popen2", "popen3", "popen4",
        // exec
        "execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe",
        // spawn
        "spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp", "spawnvpe",
        "posix_spawn", "posix_spawnp",
        // modules
        "path"
      ] and
    (
      t.start() and
      result = DataFlow::importNode("os." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importNode("os")
    )
    or
    // Due to bad performance when using normal setup with `os_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        os_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate os_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(os_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `os` module.
   * WARNING: Only holds for a few predefined attributes.
   *
   * For example, using `"system"` will get all uses of `os.system`.
   */
  private DataFlow::Node os_attr(string attr_name) {
    result = os_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `os` module. */
  module os {
    /** Gets a reference to the `os.path` module. */
    DataFlow::Node path() { result = os_attr("path") }

    /** Provides models for the `os.path` module */
    module path {
      /**
       * Gets a reference to the attribute `attr_name` of the `os.path` module.
       * WARNING: Only holds for a few predefined attributes.
       *
       * For example, using `attr_name = "join"` will get all uses of `os.path.join`.
       */
      private DataFlow::Node path_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["join", "normpath"] and
        (
          t.start() and
          result = DataFlow::importNode("os.path." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = os::path()
        )
        or
        // Due to bad performance when using normal setup with `path_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            path_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate path_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(path_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `os.path` module.
       * WARNING: Only holds for a few predefined attributes.
       *
       * For example, using `attr_name = "join"` will get all uses of `os.path.join`.
       */
      DataFlow::Node path_attr(string attr_name) {
        result = path_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /** Gets a reference to the `os.path.join` function. */
      DataFlow::Node join() { result = path_attr("join") }
    }
  }

  /**
   * A call to `os.path.normpath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.normpath
   */
  private class OsPathNormpathCall extends Path::PathNormalization::Range, DataFlow::CfgNode {
    override CallNode node;

    OsPathNormpathCall() { node.getFunction() = os::path::path_attr("normpath").asCfgNode() }

    DataFlow::Node getPathArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("path")]
    }
  }

  /** An additional taint step for calls to `os.path.normpath` */
  private class OsPathNormpathCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(OsPathNormpathCall call |
        nodeTo = call and
        nodeFrom = call.getPathArg()
      )
    }
  }

  /**
   * A call to `os.system`.
   * See https://docs.python.org/3/library/os.html#os.system
   */
  private class OsSystemCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsSystemCall() { node.getFunction() = os_attr("system").asCfgNode() }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(0) }
  }

  /**
   * A call to any of the `os.popen*` functions
   * See https://docs.python.org/3/library/os.html#os.popen
   *
   * Note that in Python 2, there are also `popen2`, `popen3`, and `popen4` functions.
   * Although deprecated since version 2.6, they still work in 2.7.
   * See https://docs.python.org/2.7/library/os.html#os.popen2
   */
  private class OsPopenCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;
    string name;

    OsPopenCall() {
      name in ["popen", "popen2", "popen3", "popen4"] and
      node.getFunction() = os_attr(name).asCfgNode()
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = node.getArg(0)
      or
      not name = "popen" and
      result.asCfgNode() = node.getArgByName("cmd")
    }
  }

  /**
   * A call to any of the `os.exec*` functions
   * See https://docs.python.org/3.8/library/os.html#os.execl
   */
  private class OsExecCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsExecCall() {
      exists(string name |
        name in ["execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe"] and
        node.getFunction() = os_attr(name).asCfgNode()
      )
    }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(0) }
  }

  /**
   * A call to any of the `os.spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.spawnl
   */
  private class OsSpawnCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsSpawnCall() {
      exists(string name |
        name in [
            "spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp", "spawnvpe"
          ] and
        node.getFunction() = os_attr(name).asCfgNode()
      )
    }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(1) }
  }

  /**
   * A call to any of the `os.posix_spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.posix_spawn
   */
  private class OsPosixSpawnCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsPosixSpawnCall() { node.getFunction() = os_attr(["posix_spawn", "posix_spawnp"]).asCfgNode() }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(0) }
  }

  /** An additional taint step for calls to `os.path.join` */
  private class OsPathJoinCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(CallNode call |
        nodeTo.asCfgNode() = call and
        call.getFunction() = os::path::join().asCfgNode() and
        call.getAnArg() = nodeFrom.asCfgNode()
      )
      // TODO: Handle pathlib (like we do for os.path.join)
    }
  }

  // ---------------------------------------------------------------------------
  // subprocess
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `subprocess` module. */
  private DataFlow::Node subprocess(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("subprocess")
    or
    exists(DataFlow::TypeTracker t2 | result = subprocess(t2).track(t2, t))
  }

  /** Gets a reference to the `subprocess` module. */
  DataFlow::Node subprocess() { result = subprocess(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `subprocess` module.
   * WARNING: Only holds for a few predefined attributes.
   *
   * For example, using `attr_name = "Popen"` will get all uses of `subprocess.Popen`.
   */
  private DataFlow::Node subprocess_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["Popen", "call", "check_call", "check_output", "run"] and
    (
      t.start() and
      result = DataFlow::importNode("subprocess." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = subprocess()
    )
    or
    // Due to bad performance when using normal setup with `subprocess_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        subprocess_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate subprocess_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(subprocess_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `subprocess` module.
   * WARNING: Only holds for a few predefined attributes.
   *
   * For example, using `attr_name = "Popen"` will get all uses of `subprocess.Popen`.
   */
  private DataFlow::Node subprocess_attr(string attr_name) {
    result = subprocess_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /**
   * A call to `subprocess.Popen` or helper functions (call, check_call, check_output, run)
   * See https://docs.python.org/3.8/library/subprocess.html#subprocess.Popen
   */
  private class SubprocessPopenCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    SubprocessPopenCall() {
      exists(string name |
        name in ["Popen", "call", "check_call", "check_output", "run"] and
        node.getFunction() = subprocess_attr(name).asCfgNode()
      )
    }

    /** Gets the ControlFlowNode for the `args` argument, if any. */
    private ControlFlowNode get_args_arg() { result in [node.getArg(0), node.getArgByName("args")] }

    /** Gets the ControlFlowNode for the `shell` argument, if any. */
    private ControlFlowNode get_shell_arg() {
      result in [node.getArg(8), node.getArgByName("shell")]
    }

    private boolean get_shell_arg_value() {
      not exists(this.get_shell_arg()) and
      result = false
      or
      exists(ControlFlowNode shell_arg | shell_arg = this.get_shell_arg() |
        result = shell_arg.getNode().(ImmutableLiteral).booleanValue()
        or
        // TODO: Track the "shell" argument to determine possible values
        not shell_arg.getNode() instanceof ImmutableLiteral and
        (
          result = true
          or
          result = false
        )
      )
    }

    /** Gets the ControlFlowNode for the `executable` argument, if any. */
    private ControlFlowNode get_executable_arg() {
      result in [node.getArg(2), node.getArgByName("executable")]
    }

    override DataFlow::Node getCommand() {
      // TODO: Track arguments ("args" and "shell")
      // TODO: Handle using `args=["sh", "-c", <user-input>]`
      result.asCfgNode() = this.get_executable_arg()
      or
      exists(ControlFlowNode arg_args, boolean shell |
        arg_args = get_args_arg() and
        shell = get_shell_arg_value()
      |
        // When "executable" argument is set, and "shell" argument is `False`, the
        // "args" argument will only be used to set the program name and arguments to
        // the program, so we should not consider any of them as command execution.
        not (
          exists(this.get_executable_arg()) and
          shell = false
        ) and
        (
          // When the "args" argument is an iterable, first element is the command to
          // run, so if we're able to, we only mark the first element as the command
          // (and not the arguments to the command).
          //
          result.asCfgNode() = arg_args.(SequenceNode).getElement(0)
          or
          // Either the "args" argument is not a sequence (which is valid) or we where
          // just not able to figure it out. Simply mark the "args" argument as the
          // command.
          //
          not arg_args instanceof SequenceNode and
          result.asCfgNode() = arg_args
        )
      )
    }
  }

  // ---------------------------------------------------------------------------
  // marshal
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `marshal` module. */
  private DataFlow::Node marshal(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("marshal")
    or
    exists(DataFlow::TypeTracker t2 | result = marshal(t2).track(t2, t))
  }

  /** Gets a reference to the `marshal` module. */
  DataFlow::Node marshal() { result = marshal(DataFlow::TypeTracker::end()) }

  /** Provides models for the `marshal` module. */
  module marshal {
    /** Gets a reference to the `marshal.loads` function. */
    private DataFlow::Node loads(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importNode("marshal.loads")
      or
      t.startInAttr("loads") and
      result = marshal()
      or
      exists(DataFlow::TypeTracker t2 | result = loads(t2).track(t2, t))
    }

    /** Gets a reference to the `marshal.loads` function. */
    DataFlow::Node loads() { result = loads(DataFlow::TypeTracker::end()) }
  }

  /**
   * A call to `marshal.loads`
   * See https://docs.python.org/3/library/marshal.html#marshal.loads
   */
  private class MarshalLoadsCall extends Decoding::Range, DataFlow::CfgNode {
    override CallNode node;

    MarshalLoadsCall() { node.getFunction() = marshal::loads().asCfgNode() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "marshal" }
  }

  // ---------------------------------------------------------------------------
  // pickle
  // ---------------------------------------------------------------------------
  private string pickleModuleName() { result in ["pickle", "cPickle", "_pickle"] }

  /** Gets a reference to the `pickle` module. */
  private DataFlow::Node pickle(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode(pickleModuleName())
    or
    exists(DataFlow::TypeTracker t2 | result = pickle(t2).track(t2, t))
  }

  /** Gets a reference to the `pickle` module. */
  DataFlow::Node pickle() { result = pickle(DataFlow::TypeTracker::end()) }

  /** Provides models for the `pickle` module. */
  module pickle {
    /** Gets a reference to the `pickle.loads` function. */
    private DataFlow::Node loads(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importNode(pickleModuleName() + ".loads")
      or
      t.startInAttr("loads") and
      result = pickle()
      or
      exists(DataFlow::TypeTracker t2 | result = loads(t2).track(t2, t))
    }

    /** Gets a reference to the `pickle.loads` function. */
    DataFlow::Node loads() { result = loads(DataFlow::TypeTracker::end()) }
  }

  /**
   * A call to `pickle.loads`
   * See https://docs.python.org/3/library/pickle.html#pickle.loads
   */
  private class PickleLoadsCall extends Decoding::Range, DataFlow::CfgNode {
    override CallNode node;

    PickleLoadsCall() { node.getFunction() = pickle::loads().asCfgNode() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }

  // ---------------------------------------------------------------------------
  // popen2
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `popen2` module (only available in Python 2). */
  private DataFlow::Node popen2(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("popen2")
    or
    exists(DataFlow::TypeTracker t2 | result = popen2(t2).track(t2, t))
  }

  /** Gets a reference to the `popen2` module (only available in Python 2). */
  DataFlow::Node popen2() { result = popen2(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `popen2` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node popen2_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in [
        "popen2", "popen3", "popen4",
        // classes
        "Popen3", "Popen4"
      ] and
    (
      t.start() and
      result = DataFlow::importNode("popen2." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importNode("popen2")
    )
    or
    // Due to bad performance when using normal setup with `popen2_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        popen2_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate popen2_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(popen2_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `popen2` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node popen2_attr(string attr_name) {
    result = popen2_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /**
   * A call to any of the `popen.popen*` functions, or instantiation of a `popen.Popen*` class.
   * See https://docs.python.org/2.7/library/popen2.html
   */
  private class Popen2PopenCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    Popen2PopenCall() {
      exists(string name |
        name in ["popen2", "popen3", "popen4", "Popen3", "Popen4"] and
        node.getFunction() = popen2_attr(name).asCfgNode()
      )
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("cmd")]
    }
  }

  // ---------------------------------------------------------------------------
  // platform
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `platform` module. */
  private DataFlow::Node platform(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("platform")
    or
    exists(DataFlow::TypeTracker t2 | result = platform(t2).track(t2, t))
  }

  /** Gets a reference to the `platform` module. */
  DataFlow::Node platform() { result = platform(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `platform` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node platform_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["popen"] and
    (
      t.start() and
      result = DataFlow::importNode("platform." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importNode("platform")
    )
    or
    // Due to bad performance when using normal setup with `platform_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        platform_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate platform_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(platform_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `platform` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node platform_attr(string attr_name) {
    result = platform_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /**
   * A call to the `platform.popen` function.
   * See https://docs.python.org/2.7/library/platform.html#platform.popen
   */
  private class PlatformPopenCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    PlatformPopenCall() { node.getFunction() = platform_attr("popen").asCfgNode() }

    override DataFlow::Node getCommand() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("cmd")]
    }
  }

  // ---------------------------------------------------------------------------
  // builtins
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `builtins` module (called `__builtin__` in Python 2). */
  private DataFlow::Node builtins(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode(["builtins", "__builtin__"])
    or
    exists(DataFlow::TypeTracker t2 | result = builtins(t2).track(t2, t))
  }

  /** Gets a reference to the `builtins` module. */
  DataFlow::Node builtins() { result = builtins(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `builtins` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node builtins_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["exec", "eval", "compile"] and
    (
      t.start() and
      result = DataFlow::importNode(["builtins", "__builtin__"] + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importNode(["builtins", "__builtin__"])
      or
      // special handling of builtins, that are in scope without any imports
      // TODO: Take care of overrides, either `def eval: ...`, `eval = ...`, or `builtins.eval = ...`
      t.start() and
      exists(NameNode ref | result.asCfgNode() = ref |
        ref.isGlobal() and
        ref.getId() = attr_name and
        ref.isLoad()
      )
    )
    or
    // Due to bad performance when using normal setup with `builtins_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        builtins_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate builtins_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(builtins_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `builtins` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node builtins_attr(string attr_name) {
    result = builtins_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /**
   * A call to the builtin `exec` function.
   * See https://docs.python.org/3/library/functions.html#exec
   */
  private class BuiltinsExecCall extends CodeExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    BuiltinsExecCall() { node.getFunction() = builtins_attr("exec").asCfgNode() }

    override DataFlow::Node getCode() { result.asCfgNode() = node.getArg(0) }
  }

  /**
   * A call to the builtin `eval` function.
   * See https://docs.python.org/3/library/functions.html#eval
   */
  private class BuiltinsEvalCall extends CodeExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    BuiltinsEvalCall() { node.getFunction() = builtins_attr("eval").asCfgNode() }

    override DataFlow::Node getCode() { result.asCfgNode() = node.getArg(0) }
  }

  /** An additional taint step for calls to the builtin function `compile` */
  private class BuiltinsCompileCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(CallNode call |
        nodeTo.asCfgNode() = call and
        call.getFunction() = builtins_attr("compile").asCfgNode() and
        nodeFrom.asCfgNode() in [call.getArg(0), call.getArgByName("source")]
      )
    }
  }
}

/**
 * An exec statement (only Python 2).
 * Se ehttps://docs.python.org/2/reference/simple_stmts.html#the-exec-statement.
 */
private class ExecStatement extends CodeExecution::Range {
  ExecStatement() {
    // since there are no DataFlow::Nodes for a Statement, we can't do anything like
    // `this = any(Exec exec)`
    this.asExpr() = any(Exec exec).getBody()
  }

  override DataFlow::Node getCode() { result = this }
}

/**
 * A call to the builtin `open` function.
 * See https://docs.python.org/3/library/functions.html#open
 */
private class OpenCall extends FileSystemAccess::Range, DataFlow::CfgNode {
  override CallNode node;

  OpenCall() { node.getFunction().(NameNode).getId() = "open" }

  override DataFlow::Node getAPathArgument() {
    result.asCfgNode() in [node.getArg(0), node.getArgByName("file")]
  }
}

// ---------------------------------------------------------------------------
// base64
// ---------------------------------------------------------------------------
/** Gets a reference to the `base64` module. */
private DataFlow::Node base64(DataFlow::TypeTracker t) {
  t.start() and
  result = DataFlow::importNode("base64")
  or
  exists(DataFlow::TypeTracker t2 | result = base64(t2).track(t2, t))
}

/** Gets a reference to the `base64` module. */
DataFlow::Node base64() { result = base64(DataFlow::TypeTracker::end()) }

/**
 * Gets a reference to the attribute `attr_name` of the `base64` module.
 * WARNING: Only holds for a few predefined attributes.
 */
private DataFlow::Node base64_attr(DataFlow::TypeTracker t, string attr_name) {
  attr_name in [
      "b64encode", "b64decode", "standard_b64encode", "standard_b64decode", "urlsafe_b64encode",
      "urlsafe_b64decode", "b32encode", "b32decode", "b16encode", "b16decode", "encodestring",
      "decodestring", "a85encode", "a85decode", "b85encode", "b85decode", "encodebytes",
      "decodebytes"
    ] and
  (
    t.start() and
    result = DataFlow::importNode("base64" + "." + attr_name)
    or
    t.startInAttr(attr_name) and
    result = base64()
  )
  or
  // Due to bad performance when using normal setup with `base64_attr(t2, attr_name).track(t2, t)`
  // we have inlined that code and forced a join
  exists(DataFlow::TypeTracker t2 |
    exists(DataFlow::StepSummary summary |
      base64_attr_first_join(t2, attr_name, result, summary) and
      t = t2.append(summary)
    )
  )
}

pragma[nomagic]
private predicate base64_attr_first_join(
  DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
) {
  DataFlow::StepSummary::step(base64_attr(t2, attr_name), res, summary)
}

/**
 * Gets a reference to the attribute `attr_name` of the `base64` module.
 * WARNING: Only holds for a few predefined attributes.
 */
private DataFlow::Node base64_attr(string attr_name) {
  result = base64_attr(DataFlow::TypeTracker::end(), attr_name)
}

/** A call to any of the encode functions in the `base64` module. */
private class Base64EncodeCall extends Encoding::Range, DataFlow::CfgNode {
  override CallNode node;

  Base64EncodeCall() {
    exists(string name |
      name in [
          "b64encode", "standard_b64encode", "urlsafe_b64encode", "b32encode", "b16encode",
          "encodestring", "a85encode", "b85encode", "encodebytes"
        ] and
      node.getFunction() = base64_attr(name).asCfgNode()
    )
  }

  override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

  override DataFlow::Node getOutput() { result = this }

  override string getFormat() {
    exists(string name | node.getFunction() = base64_attr(name).asCfgNode() |
      name in [
          "b64encode", "standard_b64encode", "urlsafe_b64encode", "encodestring", "encodebytes"
        ] and
      result = "Base64"
      or
      name = "b32encode" and result = "Base32"
      or
      name = "b16encode" and result = "Base16"
      or
      name = "a85encode" and result = "Ascii85"
      or
      name = "b85encode" and result = "Base85"
    )
  }
}

/** A call to any of the decode functions in the `base64` module. */
private class Base64DecodeCall extends Decoding::Range, DataFlow::CfgNode {
  override CallNode node;

  Base64DecodeCall() {
    exists(string name |
      name in [
          "b64decode", "standard_b64decode", "urlsafe_b64decode", "b32decode", "b16decode",
          "decodestring", "a85decode", "b85decode", "decodebytes"
        ] and
      node.getFunction() = base64_attr(name).asCfgNode()
    )
  }

  override predicate mayExecuteInput() { none() }

  override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

  override DataFlow::Node getOutput() { result = this }

  override string getFormat() {
    exists(string name | node.getFunction() = base64_attr(name).asCfgNode() |
      name in [
          "b64decode", "standard_b64decode", "urlsafe_b64decode", "decodestring", "decodebytes"
        ] and
      result = "Base64"
      or
      name = "b32decode" and result = "Base32"
      or
      name = "b16decode" and result = "Base16"
      or
      name = "a85decode" and result = "Ascii85"
      or
      name = "b85decode" and result = "Base85"
    )
  }
}

// ---------------------------------------------------------------------------
// OTHER
// ---------------------------------------------------------------------------
/**
 * A call to the `startswith` method on a string.
 * See https://docs.python.org/3.9/library/stdtypes.html#str.startswith
 */
private class StartswithCall extends Path::SafeAccessCheck::Range {
  StartswithCall() { this.(CallNode).getFunction().(AttrNode).getName() = "startswith" }

  override predicate checks(ControlFlowNode node, boolean branch) {
    node = this.(CallNode).getFunction().(AttrNode).getObject() and
    branch = true
  }
}
