/**
 * Provides an implementation for constructing control-flow graphs (CFGs) from
 * abstract syntax trees (ASTs), using the shared library from `codeql.controlflow.Cfg`.
 */

private import powershell
private import codeql.controlflow.Cfg as CfgShared
private import semmle.code.powershell.controlflow.ControlFlowGraph
private import Completion

private module CfgInput implements CfgShared::InputSig<Location> {
  private import ControlFlowGraphImpl as Impl
  private import Completion as Comp
  private import Splitting as Splitting
  private import semmle.code.powershell.Cfg as Cfg

  class Completion = Comp::Completion;

  predicate completionIsNormal(Completion c) { c instanceof Comp::NormalCompletion }

  predicate completionIsSimple(Completion c) { c instanceof Comp::SimpleCompletion }

  predicate completionIsValidFor(Completion c, Ast e) { c.isValidFor(e) }

  class AstNode = Ast;

  class CfgScope = Cfg::CfgScope;

  CfgScope getCfgScope(Ast n) { result = Impl::getCfgScope(n) }

  predicate scopeFirst(CfgScope scope, Ast first) { scope.(Impl::CfgScope).entry(first) }

  predicate scopeLast(CfgScope scope, Ast last, Completion c) {
    scope.(Impl::CfgScope).exit(last, c)
  }

  class SplitKindBase = Splitting::TSplitKind;

  class Split = Splitting::Split;

  class SuccessorType = Cfg::SuccessorType;

  SuccessorType getAMatchingSuccessorType(Completion c) { result = c.getAMatchingSuccessorType() }

  predicate successorTypeIsSimple(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::NormalSuccessor
  }

  predicate successorTypeIsCondition(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::ConditionalSuccessor
  }

  predicate isAbnormalExitType(SuccessorType t) {
    t instanceof Cfg::SuccessorTypes::RaiseSuccessor or
    t instanceof Cfg::SuccessorTypes::ExitSuccessor
  }
}

private import CfgInput
import CfgShared::Make<Location, CfgInput>

class CfgScope extends Scope {
  predicate entry(Ast first) { first(this, first) }

  predicate exit(Ast last, Completion c) { last(this, last, c) }
}

/** Holds if `first` is first executed when entering `scope`. */
pragma[nomagic]
predicate succEntry(CfgScope scope, Ast first) { scope.entry(first) }

/** Holds if `last` with completion `c` can exit `scope`. */
pragma[nomagic]
predicate succExit(CfgScope scope, Ast last, Completion c) { scope.exit(last, c) }

/** Defines the CFG by dispatch on the various AST types. */
module Trees {
  // TODO
}

private import Scope

cached
private CfgScope getCfgScopeImpl(Ast n) { result = scopeOf(n) }

/** Gets the CFG scope of node `n`. */
pragma[inline]
CfgScope getCfgScope(Ast n) {
  exists(Ast n0 |
    pragma[only_bind_into](n0) = n and
    pragma[only_bind_into](result) = getCfgScopeImpl(n0)
  )
}

cached
private module Cached {
  cached
  newtype TSuccessorType =
    TSuccessorSuccessor() or
    TBooleanSuccessor(boolean b) { b in [false, true] } or
    TReturnSuccessor() or
    TBreakSuccessor() or
    TRaiseSuccessor() or
    TExitSuccessor()
}

import Cached
