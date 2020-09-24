/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

private module Stdlib {
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
  private DataFlow::Node os_attr(string attr_name, DataFlow::TypeTracker t) {
    attr_name in ["system", "popen",
          // exec
          "execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe",
          // spawn
          "spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp", "spawnvpe",
          "posix_spawn", "posix_spawnp"] and
    (
      t.start() and
      result = DataFlow::importMember("os", attr_name)
      or
      t.startInAttr(attr_name) and
      result = os()
      or
      exists(DataFlow::TypeTracker t2 | result = os_attr(attr_name, t2).track(t2, t))
    )
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `os` module.
   * WARNING: Only holds for a few predefined attributes.
   *
   * For example, using `"system"` will get all uses of `os.system`.
   */
  private DataFlow::Node os_attr(string attr_name) {
    result = os_attr(attr_name, DataFlow::TypeTracker::end())
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
      this.asCfgNode().(CallNode).getFunction() =
        os_attr(["execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe"])
            .asCfgNode()
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
      this.asCfgNode().(CallNode).getFunction() =
        os_attr(["spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp",
              "spawnvpe"]).asCfgNode()
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
}
