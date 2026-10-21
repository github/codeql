/**
 * Provides classes for recognizing control flow graph inconsistencies.
 */

private import rust
private import codeql.rust.controlflow.internal.ControlFlowGraphImpl as CfgImpl
private import codeql.rust.controlflow.internal.CfgNodes::Consistency as CfgNodes
private import codeql.rust.Diagnostics
import CfgImpl::ControlFlow::Consistency

pragma[nomagic]
private predicate successfullyExtractedFile(File f) {
  not exists(ExtractionWarning warning | warning.getLocation().getFile() = f)
}

query predicate missingCfgChild(
  CfgImpl::ControlFlowNode parent, string pred, int i, AstNode child
) {
  CfgNodes::missingCfgChild(parent, pred, i, child) and
  successfullyExtractedFile(child.getLocation().getFile())
}

/**
 * Gets counts of control flow graph inconsistencies of each type.
 */
int getCfgInconsistencyCounts(string type) {
  CfgImpl::ControlFlow::Consistency::consistencyOverview(type, result)
  or
  type = "Missing CFG child" and
  result =
    count(CfgImpl::ControlFlowNode parent, string pred, int child |
      missingCfgChild(parent, pred, child, _)
    )
}
