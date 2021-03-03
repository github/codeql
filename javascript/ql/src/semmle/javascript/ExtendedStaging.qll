/**
 * INTERNAL: Do not use.
 *
 * The purpose of this file is to reduce the number of stages computed by the runtime,
 * thereby speeding up the evaluation without affecting any results.
 *
 * Computing less stages can improve performance as each stages is less likely to recompute non-cached predicates.
 *
 * A number of stages are grouped into an extended stage.
 * An extended stage contains a number of substages - corrosponding to to how the stages would be grouped if this file didn't exist.
 * Each extended stage is identified by a `cached module` in the `ExtendedStaging` module.
 *
 * The number of stages are reduced by using how the compiler groups predicates into stages.
 * The compiler will group mutually recursive cached predicates, or cached predicates within the same `cached module`, into the same stage.
 * This file uses the latter by creating a `cached module` with two predicates for each extended stage.
 * The first predicate is referenced from all the `cached` predicates we want in the same extended stage,
 * and the second predicate has references to all the `cached` predicates we want in the same extended stage.
 *
 * With these two predicates in a `cached module` we ensure that all substages will be in a single stage at runtime.
 *
 * Grouping stages into extended stages can cause unnecessary computation, as a concrete query might not depend on
 * all the substages in an extended stage.
 * Care should therefore be taken not to group stages into an extended stage, if it is likely that a query only depend
 * on some but not all the stages in the extended stage.
 */

import javascript
private import internal.StmtContainers
private import semmle.javascript.dataflow.internal.PreCallGraphStep
private import semmle.javascript.dataflow.internal.FlowSteps

/**
 * Contains a `cached module` for each extended stage.
 * Each `cached module` ensures that predicates that are supposed to be in the same stage, are in the same stage.
 *
 * Each `cached module` contain two predicates:
 * The first, `ref`, always holds, and is referenced from `cached` predicates in each of the substages.
 * The second, `backref`, contains references to `cached` predicate from each substage.
 * The `backref` predicate starts with `1 = 1 or` to ensure that the predicate will be optimized down to a constant by the optimizer.
 */
module ExtendedStaging {
  /**
   * The `ast` extended stage.
   * Consists of 7 substages (as of writing this).
   *
   * substage 1:
   *   AST::ASTNode::getParent
   * substage 2:
   *   JSDoc::Documentable::getDocumentation
   * substage 3:
   *   StmtContainers::getStmtContainer
   * substage 4:
   *   AST::StmtContainer::getEnclosingContainer
   * substage 5:
   *   AST::ASTNode::getTopLevel
   * substage 6:
   *   AST::isAmbientTopLevel
   * substage 7:
   *   Expr::Expr::getStringValue // maybe doesn't belong here?
   * substage 8:
   *   AST::ASTNode::isAmbientInternal
   */
  cached
  module Ast {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Ast stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      exists(any(ASTNode a).getTopLevel())
      or
      exists(any(ASTNode a).getParent())
      or
      exists(any(StmtContainer c).getEnclosingContainer())
      or
      exists(any(Documentable d).getDocumentation())
      or
      exists(any(NodeInStmtContainer n).getContainer())
      or
      exists(any(Expr e).getStringValue())
      or
      any(ASTNode node).isAmbient()
    }
  }

  /**
   * The `basicblocks` extended stage.
   * Consists of 2 substages (as of writing this).
   *
   * substage 1:
   *   BasicBlocks::Internal::bbLength#ff
   *   BasicBlocks::Internal::useAt#ffff
   *   BasicBlocks::Internal::defAt#ffff
   *   BasicBlocks::Internal::reachableBB#f
   *   BasicBlocks::Internal::bbIndex#fff
   * substage 2:
   *   BasicBlocks::bbIDominates#ff
   */
  cached
  module BasicBlocks {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the BasicBlocks stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      any(ReachableBasicBlock bb).dominates(_)
      or
      exists(any(BasicBlock bb).getNode(_))
    }
  }

  /**
   * The `dataflow` extended stage.
   * Consists of 6 substages (as of writing this).
   *
   * substage 1:
   *   SSA::Internal
   * substage 2:
   *   All the constructors in DataFlowNode.qll
   * substage 3:
   *   AMD::AmdModule
   * substage 4:
   *   DataFlow::DataFlow::localFlowStep
   * substage 5:
   *   Sources::Cached::isSyntacticMethodCall
   *   NodeJS::isRequire
   *   Sources::Cached::dynamicPropRef
   *   Sources::Cached::hasLocalSource
   *   Sources::Cached::invocation
   *   Sources::Cached::namedPropRef
   *   Sources::SourceNode::Range
   * substage 6:
   *   Expr::getCatchParameterFromStmt // maybe doesn't belong here?
   */
  cached
  module DataFlowStage {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the DataFlow stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      exists(AmdModule a)
      or
      DataFlow::localFlowStep(_, _)
      or
      exists(any(DataFlow::SourceNode s).getAPropertyReference("foo"))
      or
      exists(any(Expr e).getExceptionTarget())
      or
      exists(DataFlow::ssaDefinitionNode(_))
    }
  }

  /**
   * The `imports` extended stage.
   * Consists of 2 substages (as of writing this).
   *
   * substage 1:
   *   Modules::Import::getImportedModule
   * substage 2:
   *   Nodes::moduleImport
   *
   * Implemented as a cached module as there is a negative dependency between the predicates.
   *
   * It would have been preferable to include these predicates in the dataflow or typetracking stage.
   * But that trips the BDD limit.
   */
  cached
  module Imports {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Imports stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backrefs() {
      1 = 1
      or
      exists(any(Import i).getImportedModule())
      or
      exists(DataFlow::moduleImport(_))
    }
  }

  /**
   * The `typetracking` extended stage.
   * Consists of 2 substages (as of writing this).
   *
   * substage 1:
   *   PreCallGraphStep::PreCallGraphStep::loadStep
   * substage 2:
   *   PreCallGraphStep::PreCallGraphStep::loadStoreStep
   *   PreCallGraphStep::PreCallGraphStep::storeStep
   *   PreCallGraphStep::PreCallGraphStep::step
   *   FlowSteps::CachedSteps
   *   CallGraphs::CallGraph
   *   Nodes::ClassNode::getAClassReference
   *   JSDoc::JSDocNamedTypeExpr::resolvedName
   *   TypeTracking::TypeTracker::append
   *   StepSummary::StepSummary::step
   *   Modules::Module::getAnExportedValue
   *   DataFlow::DataFlow::Node::getImmediatePredecessor
   *   VariableTypeInference::clobberedProp
   *   TypeInference::AnalyzedNode::getAValue
   *   GlobalAccessPaths::AccessPath::fromReference
   *   GlobalAccessPaths::AccessPath::fromRhs
   */
  cached
  module TypeTracking {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the TypeTracking stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      PreCallGraphStep::loadStep(_, _, _)
      or
      basicLoadStep(_, _, _)
    }
  }

  /**
   * The `flowsteps` extended stage.
   * Consists of 2 substages (as of writing this).
   *
   * substage 1:
   *   Configuration::AdditionalFlowStep::loadStoreStep
   *   Configuration::AdditionalFlowStep::step
   *   Configuration::AdditionalFlowStep::storeStep
   *   Configuration::AdditionalFlowStep::loadStep
   * substage 2:
   *   GlobalAccessPaths::AccessPath::DominatingPaths::hasDominatingWrite
   */
  cached
  module FlowSteps {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the FlowSteps stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      AccessPath::DominatingPaths::hasDominatingWrite(_)
      or
      any(DataFlow::AdditionalFlowStep s).step(_, _)
    }
  }

  /**
   * The `taint` extended stage.
   * Consists of 2 substages (as of writing this).
   *
   * substage 1:
   *   TaintTracking::TaintTracking::AdditionalTaintStep::step
   * substage 2:
   *   RemoteFlowSources::RemoteFlowSource
   */
  cached
  module Taint {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the Taint stage.
     */
    cached
    predicate ref() { 1 = 1 }

    /**
     * DONT USE!
     * Contains references to each predicate that use the above `ref` predicate.
     */
    cached
    predicate backref() {
      1 = 1
      or
      any(TaintTracking::AdditionalTaintStep step).step(_, _)
      or
      exists(RemoteFlowSource r)
    }
  }
}
