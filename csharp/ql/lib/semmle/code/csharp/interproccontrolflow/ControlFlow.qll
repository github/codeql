import csharp

/**
 * Provides classes for performing global (inter-procedural) control flow analyses.
 */
module ControlFlow {
  private import internal.ControlFlowSpecific
  private import codeql.globalcontrolflow.ControlFlow
  import ControlFlowMake<Location, CSharpControlFlow>
  import Public
}
