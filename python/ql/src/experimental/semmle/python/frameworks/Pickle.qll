/**
 * Provides classes modeling security-relevant aspects of the `pickle` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

private module Pickle {
  private string pickleModuleName() { result in ["pickle", "cPickle", "dill"] }

  /** Gets a reference to the `pickle` module. */
  DataFlow::Node pickle(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule(pickleModuleName())
    or
    exists(DataFlow::TypeTracker t2 | result = pickle(t2).track(t2, t))
  }

  /** Gets a reference to the `pickle` module. */
  DataFlow::Node pickle() { result = pickle(DataFlow::TypeTracker::end()) }

  module pickle {
    /** Gets a reference to the `pickle.loads` function. */
    DataFlow::Node loads(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember(pickleModuleName(), "loads")
      or
      t.startInAttr("loads") and
      result = pickle()
      or
      exists(DataFlow::TypeTracker t2 | result = pickle::loads(t2).track(t2, t))
    }

    /** Gets a reference to the `pickle.loads` function. */
    DataFlow::Node loads() { result = pickle::loads(DataFlow::TypeTracker::end()) }
  }
}

/**
 * A call to `pickle.loads`
 * See https://docs.python.org/3/library/pickle.html#pickle.loads
 */
private class PickleDeserialization extends DeserializationSink::Range {
  PickleDeserialization() {
    this.asCfgNode().(CallNode).getFunction() = Pickle::pickle::loads().asCfgNode()
  }

  override DataFlow::Node getData() { result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0) }
}
