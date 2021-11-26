/**
 * @kind graph
 */

import csharp
import Common
import semmle.code.csharp.controlflow.internal.ControlFlowGraphImplShared::TestOutput

private class MyRelevantNode extends RelevantNode, SourceControlFlowNode { }
