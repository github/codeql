/**
 * Provides classes modeling security-relevant aspects of the `marshal` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

private module Marshal {
  /** Gets a reference to the `marshal` module. */
  DataFlow::Node marshal(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importModule("marshal")
    or
    exists(DataFlow::TypeTracker t2 | result = marshal(t2).track(t2, t))
  }

  /** Gets a reference to the `marshal` module. */
  DataFlow::Node marshal() { result = marshal(DataFlow::TypeTracker::end()) }

  module marshal {
    /** Gets a reference to the `marshal.loads` function. */
    DataFlow::Node loads(DataFlow::TypeTracker t) {
      t.start() and
      result = DataFlow::importMember("marshal", "loads")
      or
      t.startInAttr("loads") and
      result = marshal()
      or
      exists(DataFlow::TypeTracker t2 | result = marshal::loads(t2).track(t2, t))
    }

    /** Gets a reference to the `marshal.loads` function. */
    DataFlow::Node loads() { result = marshal::loads(DataFlow::TypeTracker::end()) }
  }
}

/**
 * A call to `marshal.loads`
 * See https://docs.python.org/2/library/marshal.html#marshal.load
 */
private class MarshalDeserialization extends DeserializationSink::Range {
  MarshalDeserialization() {
    this.asCfgNode().(CallNode).getFunction() = Marshal::marshal::loads().asCfgNode()
  }

  override DataFlow::Node getData() { result.asCfgNode() = this.asCfgNode().(CallNode).getArg(0) }
}
