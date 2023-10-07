/**
 * @kind graph
 */

import csharp
import Common
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImpl::TestOutput

private class MyRelevantNode extends RelevantNode, SourceControlFlowNode { }
