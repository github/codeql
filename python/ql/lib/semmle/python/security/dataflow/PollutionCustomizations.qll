/**
 * Provides default sources, sinks and sanitizers for detecting
 * "attribute pollution" vulnerabilities, as well as extension
 * points for adding your own.
 */

private import python
private import semmle.python.Concepts
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.internal.Attributes

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "attribute pollution" vulnerabilities, as well as extension
 * points for adding your own.
 */
module AttributePollution {
  /** A data flow source for "attribute pollution" vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A sink for "attribute pollution" vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /** Gets the object being polluted. */
    abstract DataFlow::Node getObject();
  }

  /** A source of remote user input, considered as a flow source. */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /** A sink for subscripts. */
  class SubscriptSink extends Sink {
    Subscript subscript;

    SubscriptSink() {
      subscript = any(AssignStmt a).getATarget() and
      this.asExpr() = subscript.getIndex()
    }

    override DataFlow::Node getObject() { result.asExpr() = subscript.getObject() }
  }

  /** A sink for setattr. */
  class SetAttrSink extends Sink {
    CallNode setAttrCall;

    SetAttrSink() {
      setAttrCall.getFunction().(NameNode).getId() = "setattr" and
      this.asCfgNode() in [setAttrCall.getArg(1), setAttrCall.getArgByName("name")]
    }

    override DataFlow::Node getObject() { result.asCfgNode() = setAttrCall.getArg(0) }
  }

  /** A flow state signifying remote input before a for loop. */
  class BeforeForIn extends DataFlow::FlowState {
    BeforeForIn() { this = "BeforeFor" }
  }

  /** A flow state signifying remote input after a for loop. */
  class AfterForIn extends DataFlow::FlowState {
    AfterForIn() { this = "AfterFor" }
  }

  /**
   * A taint step that changes the flow state to satisfy the sink.
   * Holds when `nodeFrom` is the iterable in a for loop.
   */
  predicate enumeratedAttributeNameStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    exists(EnumeratedAttributeName e |
      nodeFrom = e.getSourceObject() and
      nodeTo = e
    ) and
    stateFrom instanceof BeforeForIn and
    stateTo instanceof AfterForIn
  }
}
