import swift
import codeql.controlflow.Cfg
import codeql.util.Unit
private import Completion as C
private import ControlFlowGraphImpl as Impl
private import ControlFlowGraphImplSpecific as Specific
private import Scope
private import codeql.swift.controlflow.ControlFlowGraph as Cfg
private import Splitting as Splitting

module CfgInput implements InputSig<Location> {
  class AstNode = Specific::ControlFlowElement;

  class Completion = C::Completion;

  predicate completionIsNormal = C::completionIsNormal/1;

  predicate completionIsSimple = C::completionIsSimple/1;

  predicate completionIsValidFor = C::completionIsValidFor/2;

  /** An AST node with an associated control-flow graph. */
  class CfgScope extends Locatable instanceof Impl::CfgScope::Range_ { }

  CfgScope getCfgScope(AstNode n) { result = scopeOfAst(n.asAstNode()) }

  class SplitKindBase = Splitting::TSplitKind;

  class Split = Splitting::Split;

  class SuccessorType = Cfg::SuccessorType;

  /** Gets a successor type that matches completion `c`. */
  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  /**
   * Hold if `c` represents simple (normal) evaluation of a statement or an
   * expression.
   */
  predicate successorTypeIsSimple(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::NormalSuccessor
  }

  /** Holds if `t` is an abnormal exit type out of a CFG scope. */
  predicate isAbnormalExitType(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::ExceptionSuccessor
  }
  
  /** Hold if `t` represents a conditional successor type. */
  predicate successorTypeIsCondition(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::BooleanSuccessor or
    t instanceof Cfg::SuccessorTypes::BreakSuccessor or
    t instanceof Cfg::SuccessorTypes::ContinueSuccessor or
    t instanceof Cfg::SuccessorTypes::MatchingSuccessor or
    t instanceof Cfg::SuccessorTypes::EmptinessSuccessor
  }

  /** Holds if `first` is first executed when entering `scope`. */
  predicate scopeFirst(CfgScope scope, AstNode first) {
    scope.(Impl::CfgScope::Range_).entry(first)
  }

  /** Holds if `scope` is exited when `last` finishes with completion `c`. */
  predicate scopeLast(CfgScope scope, AstNode last, Completion c) {
    scope.(Impl::CfgScope::Range_).exit(last, c)
  }
}

module CfgImpl = Make<Location, CfgInput>;