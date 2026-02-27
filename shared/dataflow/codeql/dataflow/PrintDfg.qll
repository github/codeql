/**
 * Provides a module for implementing the `View DFG` query based on inputs to the data flow library.
 */
overlay[local?]
module;

private import codeql.util.Location
private import codeql.dataflow.DataFlow as DF
private import codeql.dataflow.TaintTracking as TT

module MakePrintDfg<
  LocationSig Location, DF::InputSig<Location> DataFlowLang,
  TT::InputSig<Location, DataFlowLang> TaintTrackingLang>
{
  private import DataFlowLang
  private import codeql.util.PrintGraph as Pp

  final private class FinalNode = Node;

  private module PrintGraphInput implements Pp::InputSig<Location> {
    class Callable = DataFlowLang::DataFlowCallable;

    class Node extends FinalNode {
      string getOrderDisambiguation() { result = DataFlowLang::nodeGetOrderDisambiguation(this) }

      Callable getEnclosingCallable() { result = DataFlowLang::nodeGetEnclosingCallable(this) }
    }

    predicate edge(Node node1, string label, Node node2) {
      simpleLocalFlowStep(node1, node2, _) and label = "value"
      or
      jumpStep(node1, node2) and label = "jump"
      or
      TaintTrackingLang::defaultAdditionalTaintStep(node1, node2, _) and label = "taint"
      or
      exists(ContentSet c |
        readStep(node1, c, node2) and label = "read[" + c.toString() + "]"
        or
        storeStep(node1, c, node2) and label = "store[" + c.toString() + "]"
      )
      or
      node1 = node2.(PostUpdateNode).getPreUpdateNode() and label = "post-update"
    }
  }

  import Pp::PrintGraph<Location, PrintGraphInput>
}
