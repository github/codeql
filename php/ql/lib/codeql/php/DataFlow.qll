/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses for PHP.
 */

import codeql.Locations

/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) data flow analyses.
 */
module DataFlow {
  private import codeql.php.dataflow.internal.DataFlowImplSpecific
  private import codeql.dataflow.DataFlow
  import DataFlowMake<Location, PhpDataFlow>
  import Public
}
