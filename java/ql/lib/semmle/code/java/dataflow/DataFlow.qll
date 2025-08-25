/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */
overlay[local?]
module;

import java

module DataFlow {
  private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
  private import codeql.dataflow.DataFlow
  import DataFlowMake<Location, JavaDataFlow>
  import Public
}
