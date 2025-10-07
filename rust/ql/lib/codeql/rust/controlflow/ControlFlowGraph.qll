/** Provides classes representing the control flow graph. */

private import internal.ControlFlowGraphImpl
private import internal.Scope as Scope
import codeql.controlflow.SuccessorType

final class CfgScope = Scope::CfgScope;

final class CfgNode = Node;
