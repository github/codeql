/**
 * INTERNAL: Do not use.
 *
 * The purpose of this file is to control which cached predicates belong to the same stage.
 *
 * Combining stages can improve performance as we are more likely to reuse shared, non-cached predicates.
 *
 * To make a predicate `p` belong to a stage `A`:
 * - make `p` depend on `A::ref()`, and
 * - make `A::backref()` depend on `p`.
 *
 * Since `A` is a cached module, `ref` and `backref` must be in the same stage, and the dependency
 * chain above thus forces `p` to be in that stage as well.
 *
 * With these two predicates in a `cached module` we ensure that all the cached predicates will be in a single stage at runtime.
 *
 * Grouping stages can cause unnecessary computation, as a concrete query might not depend on
 * all the cached predicates in a stage.
 * Care should therefore be taken not to combine two stages, if it is likely that a query only depend
 * on some but not all the cached predicates in the combined stage.
 */

import javascript
private import StmtContainers
private import semmle.javascript.dataflow.internal.PreCallGraphStep
private import semmle.javascript.dataflow.internal.FlowSteps
private import semmle.javascript.dataflow.internal.AccessPaths
private import semmle.javascript.dataflow.internal.TaintTrackingPrivate as TaintTrackingPrivate

/**
 * Contains a `cached module` for each stage.
 * Each `cached module` ensures that predicates that are supposed to be in the same stage, are in the same stage.
 *
 * Each `cached module` contain two predicates:
 * The first, `ref`, always holds, and is referenced from `cached` predicates.
 * The second, `backref`, contains references to the same `cached` predicates.
 * The `backref` predicate starts with `1 = 1 or` to ensure that the predicate will be optimized down to a constant by the optimizer.
 */
module Stages {
  /**
   * The `ast` stage.
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
      exists(any(AstNode a).getTopLevel())
      or
      exists(any(AstNode a).getParent())
      or
      exists(any(StmtContainer c).getEnclosingContainer())
      or
      exists(any(Documentable d).getDocumentation())
      or
      exists(any(NodeInStmtContainer n).getContainer())
      or
      exists(any(Expr e).getStringValue())
      or
      any(AstNode node).isAmbient()
      or
      exists(any(Identifier e).getName())
      or
      exists(any(ExprOrType e).getUnderlyingValue())
      or
      exists(ConstantExpr e)
      or
      exists(SyntacticConstants::NullConstant n)
    }
  }

  /**
   * The `basicblocks` stage.
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
   * The part of data flow computed before flow summary nodes.
   */
  cached
  module EarlyDataFlowStage {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the early DataFlow stage.
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
      DataFlow::localFlowStep(_, _)
    }
  }

  /**
   * The `dataflow` stage.
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
      exists(any(DataFlow::SourceNode s).getAPropertyReference("foo"))
      or
      exists(any(Expr e).getExceptionTarget())
      or
      exists(DataFlow::ssaDefinitionNode(_))
      or
      exists(any(DataFlow::Node node).getLocation())
      or
      exists(any(DataFlow::Node node).toString())
      or
      exists(any(AccessPath a).getAnInstanceIn(_))
      or
      exists(any(DataFlow::PropRef ref).getBase())
      or
      exists(any(DataFlow::ClassNode cls))
      or
      exists(any(DataFlow::CallNode node).getArgument(_))
      or
      exists(any(DataFlow::CallNode node).getAnArgument())
      or
      exists(any(DataFlow::CallNode node).getLastArgument())
    }
  }

  /**
   * The `imports` stage.
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
      or
      exists(any(ReExportDeclaration d).getReExportedModule())
      or
      exists(any(Module m).getABulkExportedNode())
    }
  }

  /**
   * The `typetracking` stage.
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
      or
      exists(any(DataFlow::TypeTracker t).append(_))
      or
      exists(any(DataFlow::TypeBackTracker t).prepend(_))
      or
      DataFlow::functionForwardingStep(_, _)
      or
      any(DataFlow::Node node).hasUnderlyingType(_)
      or
      any(DataFlow::Node node).hasUnderlyingType(_, _)
      or
      AccessPath::DominatingPaths::hasDominatingWrite(_)
    }
  }

  /**
   * The `flowsteps` stage.
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
      DataFlow::SharedFlowStep::step(_, _)
      or
      exists(any(DataFlow::RegExpCreationNode e).getAReference())
    }
  }

  /**
   * The `APIStage` stage.
   */
  cached
  module ApiStage {
    /**
     * Always holds.
     * Ensures that a predicate is evaluated as part of the APIStage stage.
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
      exists(
        API::moduleImport("foo")
            .getMember("bar")
            .getUnknownMember()
            .getAMember()
            .getAParameter()
            .getPromised()
            .getReturn()
            .getParameter(2)
            .getUnknownMember()
            .getInstance()
            .getReceiver()
            .getForwardingFunction()
            .getPromisedError()
            .getADecoratedClass()
            .getADecoratedMember()
            .getADecoratedParameter()
      )
    }
  }

  /**
   * The `taint` stage.
   */
  cached
  module Taint {
    private import semmle.javascript.PackageExports as Exports

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
      TaintTracking::heapStep(_, _)
      or
      exists(RemoteFlowSource r)
      or
      exists(Exports::getALibraryInputParameter())
      or
      any(RegExpTerm t).isUsedAsRegExp()
      or
      TaintTrackingPrivate::defaultTaintSanitizer(_)
    }
  }
}
