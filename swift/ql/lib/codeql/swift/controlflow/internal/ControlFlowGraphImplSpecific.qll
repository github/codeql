/**
 * Provides the `CfgImpl` module that is used to construct the basic successor relation on control
 * flow elements, and the `CfgInput` module that is used to construct `CgfImpl`.
 *
 * See `ControlFlowGraphImpl.qll` for the auxiliary classes and predicates that map AST elements to
 * control flow elements and sequence their children.
 */

private import swift as S
import codeql.controlflow.Cfg
import codeql.util.Unit
private import Completion as C
private import ControlFlowGraphImpl as Impl
import Completion
private import codeql.swift.controlflow.ControlFlowGraph as Cfg
private import Splitting as Splitting
private import Scope
private import codeql.swift.generated.Raw
private import codeql.swift.generated.Synth
import ControlFlowElements
import AstControlFlowTrees

/** The base class for `ControlFlowTree`. */
class ControlFlowTreeBase = ControlFlowElement;

class CfgScope = Cfg::CfgScope;

predicate getCfgScope = Impl::getCfgScope/1;

/** Gets the maximum number of splits allowed for a given node. */
class Location = S::Location;

class Node = Cfg::ControlFlowNode;

module CfgInput implements InputSig<Location> {
  class AstNode = ControlFlowElement;

  class Completion = C::Completion;

  predicate completionIsNormal = C::completionIsNormal/1;

  predicate completionIsSimple = C::completionIsSimple/1;

  predicate completionIsValidFor = C::completionIsValidFor/2;

  /** An AST node with an associated control-flow graph. */
  class CfgScope extends S::Locatable instanceof Impl::CfgScope::Range_ { }

  CfgScope getCfgScope(AstNode n) { result = scopeOfAst(n.asAstNode()) }

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

  private predicate id(Raw::AstNode x, Raw::AstNode y) { x = y }

  private predicate idOfDbAstNode(Raw::AstNode x, int y) = equivalenceRelation(id/2)(x, y)

  // TODO: does not work if fresh ipa entities (`ipa: on:`) turn out to be first of the block
  private predicate idOf(S::AstNode x, int y) { idOfDbAstNode(Synth::convertAstNodeToRaw(x), y) }

  private S::AstNode projectToAst(ControlFlowElement n) {
    result = n.asAstNode()
    or
    isPropertyGetterElement(n, _, result)
    or
    isPropertySetterElement(n, _, result)
    or
    isPropertyObserverElement(n, _, result)
    or
    result = n.(KeyPathElement).getAst()
    or
    result = n.(FuncDeclElement).getAst()
  }

  int idOfAstNode(AstNode node) { idOf(projectToAst(node), result) }

  int idOfCfgScope(CfgScope node) { idOf(node, result) }
}

private module CfgSplittingInput implements SplittingInputSig<Location, CfgInput> {
  private import Splitting as S

  class SplitKindBase = S::TSplitKind;

  class Split = S::Split;
}

private module ConditionalCompletionSplittingInput implements
  ConditionalCompletionSplittingInputSig<Location, CfgInput, CfgSplittingInput>
{
  import Splitting::ConditionalCompletionSplitting::ConditionalCompletionSplittingInput
}

module CfgImpl =
  MakeWithSplitting<Location, CfgInput, CfgSplittingInput, ConditionalCompletionSplittingInput>;
