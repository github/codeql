/**
 * @name ActiveRecord association queried in loop
 * @description Querying an ActiveRecord association in a loop can be slow if the results are not preloaded.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id rb/active-record-association-queried-in-loop
 * @tags performance
 */

// TODO: is a DB query executed as soon as the assocation is called, or when a field on the associated object is used?
//       Concretely, does `.owner.id` cause owner to be loaded? The ID should already be known without perfoming a DB query.
//
import ruby
import codeql.ruby.ApiGraphs
import codeql.ruby.ast.Constant
import codeql.ruby.ast.Variable
import codeql.ruby.controlflow.ControlFlowGraph
import codeql.ruby.frameworks.ActiveRecord
import codeql.ruby.frameworks.core.Kernel
import codeql.util.Boolean

/**
 * A call that preloads associations of a given collection.
 *
 * This differs from `includes` which modifies a query being built by the query builder
 * interface. We need to reason about aliasing for destructuve preloading calls.
 */
abstract class AssociationPreloadingCall extends DataFlow::CallNode {
  abstract DataFlow::Node getCollection();

  abstract DataFlow::Node getInclusionArg();

  DataFlow::LocalSourceNode getCollectionSource() {
    result = this.getCollection().getALocalSource()
    or
    exists(DataFlow::CallNode call |
      call.getMethodName() = "compact" and
      call = this.getCollectionSource() and
      result = call.getReceiver().getALocalSource()
      or
      call = DataFlow::getConstant("Array").getAMethodCall("wrap") and
      call = this.getCollectionSource() and
      result = call.getArgument(0).getALocalSource()
      or
      call.getMethodName() = "tap" and
      call.getBlock().asCallable().getParameter(0) = this.getCollectionSource() and
      result = call.getReceiver().getALocalSource()
    )
  }

  DataFlow::LocalSourceNode getCollectionAlias() {
    result = this.getCollectionSource()
    or
    exists(DataFlow::LocalSourceNode base, string name |
      this.getCollectionSource() = base.getAnAttributeRead(name) and
      result = base.getAnAttributeRead(name)
    )
    or
    exists(CfgScope scope, string name |
      this.getCollectionSource() = instanceVarAccess(scope, name) and
      result = instanceVarAccess(scope, name)
    )
  }

  DataFlow::LocalSourceNode getInclusionConstant() {
    result = this.getInclusionArg().getALocalSource() and
    (
      result instanceof DataFlow::ArrayLiteralNode
      or
      result instanceof DataFlow::HashLiteralNode
      or
      exists(result.getConstantValue().getSymbol())
    )
  }
}

pragma[nomagic]
private DataFlow::Node instanceVarAccess(CfgScope scope, string name) {
  exists(InstanceVariableReadAccess access |
    access.getCfgScope() = scope and
    access.getVariable().getName() = name and
    result.asExpr().getExpr() = access
  )
}

class PreloaderCall extends AssociationPreloadingCall {
  PreloaderCall() {
    this =
      API::getTopLevelMember("ActiveRecord")
          .getMember("Associations")
          .getMember("Preloader")
          .getAMethodCall("new")
  }

  override DataFlow::Node getCollection() { result = this.getKeywordArgument("records") }

  override DataFlow::Node getInclusionArg() { result = this.getKeywordArgument("associations") }
}

class AssociationPreloadingMethod extends DataFlow::MethodNode {
  private AssociationPreloadingCall call;
  private DataFlow::ParameterNode collection;

  AssociationPreloadingMethod() {
    call.getEnclosingMethod() = this and
    collection = call.getCollectionSource()
  }

  DataFlow::ParameterNode getCollection() { result = collection }

  DataFlow::ParameterNode getInclusionParameter() {
    result = call.getInclusionArg().getALocalSource()
  }

  DataFlow::LocalSourceNode getInclusionConstant() { result = call.getInclusionConstant() }
}

predicate argumentPassing(
  DataFlow::CallNode call, DataFlow::Node argument, DataFlow::MethodNode method,
  DataFlow::ParameterNode parameter
) {
  call.getATarget() = method and
  (
    exists(int i |
      call.getPositionalArgument(i) = argument and
      method.getParameter(i) = parameter
    )
    or
    exists(string name |
      call.getKeywordArgument(name) = argument and
      method.getKeywordParameter(name) = parameter
    )
  )
}

class IndirectAssociationPreloadingCall extends AssociationPreloadingCall {
  private AssociationPreloadingMethod method;
  private DataFlow::Node collection;

  IndirectAssociationPreloadingCall() {
    argumentPassing(this, collection, method, method.getCollection())
  }

  override DataFlow::Node getCollection() { result = collection }

  override DataFlow::Node getInclusionArg() {
    argumentPassing(this, result, method, method.getInclusionParameter())
  }

  override DataFlow::LocalSourceNode getInclusionConstant() {
    result = super.getInclusionConstant()
    or
    result = method.getInclusionConstant()
  }
}

private import codeql.ruby.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/** Name of an Array method that enumerats an array and passes its element to a block. */
private string enumerationName() {
  result in [
      "all?",
      "any?",
      "collect!",
      "collect",
      "count",
      "delete_if",
      "each_index",
      "each",
      "flat_map",
      "keep_if",
      "map!",
      "map",
      "none?",
      "one?",
      "reject!",
      "reject",
      "reverse_each",
      "select!",
      "select",
      "sort_by!",
      "sort_by",
      "uniq",
    ]
}

predicate arrayStep(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlowPrivate::readStep(node1, any(DataFlow::ContentSet cs | cs.isAnyElement()), node2) and
  node1
      .(DataFlowPrivate::NodeImpl)
      .getEnclosingCallable()
      .asLibraryCallable()
      .matches("%" + enumerationName() + "%")
}

/**
 * Tracks flow as follows:
 * - Starting at an ActiveRecord class
 * - Stepping through any number of query builder calls, such as `where`
 * - Stepping into an `each` call, or a similar call that enumerates the resulting elements
 * - Ending at a call to an ActiveRecord association that might result in a database query
 *
 * The flow is blocked if we encounter a call that preloads associations, such as `includes`.
 * Currently we don't check which associations are preloaded.
 *
 * The flow begins as far back as possible to ensure we can detect the presence of such calls.
 * If the flow had started at the `each` call for example, we would be unable to detect a preceding
 * `includes` call without losing call context.
 */
module ActiveRecordConfig implements DataFlow::StateConfigSig {
  private newtype TFlowState =
    /** An object that implements the QueryInterface. */
    TQueryBuilder() or
    /** An array of ActiveRecord objects obtained from a query. */
    TArray() or
    /** An individual ActiveRecord object obtained by enumerating results from a query. */
    TElement()

  class FlowState extends TFlowState {
    string toString() {
      this = TQueryBuilder() and result = "TQueryBuilder"
      or
      this = TArray() and result = "TArray"
      or
      this = TElement() and result = "TElement"
    }
  }

  additional predicate sourceDef(DataFlow::ClassNode cls, DataFlow::Node node) {
    cls = any(ActiveRecordModelClass c).getClassNode() and
    node = cls.getAnImmediateReference().(DataFlow::ConstantAccessNode) and
    not cls.getQualifiedName() = "ActiveRecord::Base"
  }

  predicate isSource(DataFlow::Node node, FlowState state) {
    sourceDef(_, node) and
    state = TQueryBuilder()
  }

  additional predicate sinkDef(ActiveRecordAssociationMethodCall call, DataFlow::Node node) {
    call.getReceiver() = node and
    not call.getAssociation().getKeywordArgument("strict_loading").getConstantValue().getBoolean() =
      true
  }

  predicate isSink(DataFlow::Node node, FlowState state) {
    sinkDef(_, node) and
    state = TElement()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    arrayStep(node1, node2) and
    (state1 = TQueryBuilder() or state1 = TArray()) and
    state2 = TElement()
    or
    exists(DataFlow::CallNode call |
      node1 = call.getReceiver() and
      node2 = call
    |
      call.getMethodName() = ["to_a"] and
      (state1 = TQueryBuilder() or state1 = TArray()) and
      state2 = TArray()
      or
      call.getMethodName() = ["uniq", "compact", "uniq!", "compact!"] and
      state1 = TArray() and
      state2 = TArray()
      or
      call.getMethodName() = queryBuilderMethodName() and
      // Block flow through a few methods:
      //  - none: produces no output
      //  - select: modelled more precisely below
      //  - includes, preload, eager_load: preloads some associations
      //  - strict_loading: replaces N+1 queries problem with a runtime error
      //
      // We don't yet check if the correct associations are preloaded.
      not call.getMethodName() =
        ["none", "select", "includes", "preload", "eager_load", "strict_loading"] and
      state1 = TQueryBuilder() and
      state2 = TQueryBuilder()
      or
      call.getMethodName() = "select" and
      (
        state1 = TQueryBuilder() and
        (if exists(call.getBlock()) then state2 = TArray() else state2 = TQueryBuilder())
        or
        state1 = TArray() and
        state2 = TArray()
      )
    )
    or
    exists(DataFlow::CallNode call |
      call.getMethodName() = "find_each" and
      node1 = call.getReceiver() and
      node2 = call.getBlock().asCallable().getParameter(0) and
      state1 = TQueryBuilder() and
      state2 = TElement()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node.getLocation().getFile().getBaseName().matches("%_test.rb")
    or
    // Block flow through anything that might be preloaded. We don't currently check if the correct associations
    // are preloaded.
    exists(AssociationPreloadingCall call | node = call.getCollectionAlias())
  }
}

/**
 * Name of a method on ActiveRecord::QueryMethods which returns another ActiveRecord::QueryMethods object.
 */
private string queryBuilderMethodName() {
  result =
    [
      "and", "annotate", "create_with", "distinct", "eager_load", "excluding", "extending",
      "extract_associated", "from", "having", "in_order_of", "includes", "invert_where", "joins",
      "left_joins", "left_outer_joins", "limit", "none", "offset", "optimizer_hints", "or", "order",
      "preload", "readonly", "references", "regroup", "reorder", "reselect", "reverse_order",
      "rewhere", "strict_loading", "uniq!", "unscope", "joins", "where", "with", "with_recursive"
    ]
}

module ActiveRecordFlow = DataFlow::GlobalWithState<ActiveRecordConfig>;

import ActiveRecordFlow::PathGraph

from
  ActiveRecordFlow::PathNode source, ActiveRecordFlow::PathNode sink,
  ActiveRecordAssociationMethodCall sinkCall
where
  ActiveRecordFlow::flowPath(source, sink) and
  ActiveRecordConfig::sinkDef(sinkCall, sink.getNode())
select sinkCall, source, sink,
  "The :" + sinkCall.getMethodName() +
    " association is being queried in a loop, consider eagerly loading it with includes(:" +
    sinkCall.getMethodName() + ") to avoid N+1 queries."
