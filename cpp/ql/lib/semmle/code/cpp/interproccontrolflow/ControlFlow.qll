import cpp

/**
 * Provides classes for performing global (inter-procedural) control flow analyses.
 */
module ControlFlow {
  private import internal.ControlFlowSpecific
  private import shared.ControlFlow
  import ControlFlowMake<Location, CppControlFlow>
  import Public
}
