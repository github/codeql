/**
 * @kind graph
 */

import csharp
import Common

private class MyRelevantNode extends SourceControlFlowNode {
  string getOrderDisambiguation() { result = "" }
}

import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
