/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.TaintTracking
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

/** Provides models for the Python standard library. */
private module Stdlib {
  // ---------------------------------------------------------------------------
  // os
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `os` module. */
  private DataFlow::Node os(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("os")
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
    attr_name in ["system", "popen",
          // exec
          "execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe",
          // spawn
          "spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp", "spawnvpe",
          "posix_spawn", "posix_spawnp",
          // modules
          "path"] and
    (
      t.start() and
      result = DataFlow::importMember("os", attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importModule("os")
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
      /** Gets a reference to the `os.path.join` function. */
      private DataFlow::Node join(DataFlow::TypeTracker t) {
        t.start() and
        result = DataFlow::importMember("os.path", "join")
        or
        t.startInAttr("join") and
        result = os::path()
        or
        exists(DataFlow::TypeTracker t2 | result = join(t2).track(t2, t))
      }

      /** Gets a reference to the `os.path.join` function. */
      DataFlow::Node join() { result = join(DataFlow::TypeTracker::end()) }
    }
  }

  /**
   * A call to `os.system`.
   * See https://docs.python.org/3/library/os.html#os.system
   */
  private class OsSystemCall extends SystemCommandExecution::Range {
    OsSystemCall() { this.asCfgNode().(CallNode).getFunction() = os_attr("system").asCfgNode() }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
    }
  }

  /**
   * A call to `os.popen`
   * See https://docs.python.org/3/library/os.html#os.popen
   */
  private class OsPopenCall extends SystemCommandExecution::Range {
    OsPopenCall() { this.asCfgNode().(CallNode).getFunction() = os_attr("popen").asCfgNode() }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
    }
  }

  /**
   * A call to any of the `os.exec*` functions
   * See https://docs.python.org/3.8/library/os.html#os.execl
   */
  private class OsExecCall extends SystemCommandExecution::Range {
    OsExecCall() {
      exists(string name |
        name in ["execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe"] and
        this.asCfgNode().(CallNode).getFunction() = os_attr(name).asCfgNode()
      )
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
    }
  }

  /**
   * A call to any of the `os.spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.spawnl
   */
  private class OsSpawnCall extends SystemCommandExecution::Range {
    OsSpawnCall() {
      exists(string name |
        name in ["spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp",
              "spawnvpe"] and
        this.asCfgNode().(CallNode).getFunction() = os_attr(name).asCfgNode()
      )
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = this.asCfgNode().(CallNode).getArg(1)
    }
  }

  /**
   * A call to any of the `os.posix_spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.posix_spawn
   */
  private class OsPosixSpawnCall extends SystemCommandExecution::Range {
    OsPosixSpawnCall() {
      this.asCfgNode().(CallNode).getFunction() =
        os_attr(["posix_spawn", "posix_spawnp"]).asCfgNode()
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
    }
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
    result = DataFlow::importModule("subprocess")
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
      result = DataFlow::importMember("subprocess", attr_name)
      or
      t.startInAttr(attr_name) and
      result = DataFlow::importModule("subprocess")
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
  private class SubprocessPopenCall extends SystemCommandExecution::Range {
    CallNode call;

    SubprocessPopenCall() {
      call = this.asCfgNode() and
      exists(string name |
        name in ["Popen", "call", "check_call", "check_output", "run"] and
        call.getFunction() = subprocess_attr(name).asCfgNode()
      )
    }

    /** Gets the ControlFlowNode for the `args` argument, if any. */
    private ControlFlowNode get_args_arg() {
      result = call.getArg(0)
      or
      result = call.getArgByName("args")
    }

    /** Gets the ControlFlowNode for the `shell` argument, if any. */
    private ControlFlowNode get_shell_arg() {
      result = call.getArg(8)
      or
      result = call.getArgByName("shell")
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
      result = call.getArg(2)
      or
      result = call.getArgByName("executable")
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
}
