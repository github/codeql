/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */

import csharp

module DataFlow {
  private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
  private import codeql.dataflow.DataFlow
  import DataFlowMake<Location, CsharpDataFlow>
  import Public
}
