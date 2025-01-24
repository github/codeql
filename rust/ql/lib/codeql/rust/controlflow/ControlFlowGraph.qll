/** Provides classes representing the control flow graph. */

private import internal.ControlFlowGraphImpl
private import internal.SuccessorType
private import internal.Scope as Scope

final class CfgScope = Scope::CfgScope;

final class SuccessorType = SuccessorTypeImpl;

final class NormalSuccessor = NormalSuccessorImpl;

final class ConditionalSuccessor = ConditionalSuccessorImpl;

final class BooleanSuccessor = BooleanSuccessorImpl;

final class MatchSuccessor = MatchSuccessorImpl;

final class BreakSuccessor = BreakSuccessorImpl;

final class ContinueSuccessor = ContinueSuccessorImpl;

final class ReturnSuccessor = ReturnSuccessorImpl;

final class CfgNode = Node;
