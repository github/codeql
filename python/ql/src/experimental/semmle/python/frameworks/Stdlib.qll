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
  /** Gets a reference to the `os` module. */
  DataFlow::Node os(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("os")
    or
    exists(DataFlow::TypeTracker t2 | result = os(t2).track(t2, t))
  }

  /** Gets a reference to the `os` module. */
  DataFlow::Node os() { result = os(DataFlow::TypeTracker::end()) }

  /** Provides models for the `os` module. */
  module os {
    /** Gets a reference to the `os.system` function. */
    DataFlow::Node system(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember("os", "system")
      or
      t.startInAttr("system") and
      result = os()
      or
      exists(DataFlow::TypeTracker t2 | result = os::system(t2).track(t2, t))
    }

    /** Gets a reference to the `os.system` function. */
    DataFlow::Node system() { result = os::system(DataFlow::TypeTracker::end()) }

    /** Gets a reference to the `os.popen` function. */
    DataFlow::Node popen(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember("os", "popen")
      or
      t.startInAttr("popen") and
      result = os()
      or
      exists(DataFlow::TypeTracker t2 | result = os::popen(t2).track(t2, t))
    }

    /** Gets a reference to the `os.popen` function. */
    DataFlow::Node popen() { result = os::popen(DataFlow::TypeTracker::end()) }

    /** Gets a reference to the `os.path` module. */
    private DataFlow::Node path(DataFlow::TypeTracker t) {
      t.start() and
      (
        result = DataFlow::importMember("os", "path")
        or
        result = DataFlow::importModule("os.path")
      )
      or
      t.startInAttr("path") and
      result = os()
      or
      exists(DataFlow::TypeTracker t2 | result = path(t2).track(t2, t))
    }

    /** Gets a reference to the `os.path` module. */
    DataFlow::Node path() { result = path(DataFlow::TypeTracker::end()) }

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

      /** Gets a reference to the `os.join` module. */
      DataFlow::Node join() { result = join(DataFlow::TypeTracker::end()) }
    }
  }

  /**
   * A call to `os.system`.
   * See https://docs.python.org/3/library/os.html#os.system
   */
  private class OsSystemCall extends SystemCommandExecution::Range {
    OsSystemCall() { this.asCfgNode().(CallNode).getFunction() = os::system().asCfgNode() }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0)
    }
  }

  /**
   * A call to `os.popen`
   * See https://docs.python.org/3/library/os.html#os.popen
   */
  private class OsPopenCall extends SystemCommandExecution::Range {
    OsPopenCall() { this.asCfgNode().(CallNode).getFunction() = os::popen().asCfgNode() }

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
}
