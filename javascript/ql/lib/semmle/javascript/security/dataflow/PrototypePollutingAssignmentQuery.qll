/**
 * Provides a taint tracking configuration for reasoning about
 * prototype-polluting assignments.
 *
 * Note, for performance reasons: only import this file if
 * `PrototypePollutingAssignment::Configuration` is needed, otherwise
 * `PrototypePollutingAssignmentCustomizations` should be imported instead.
 */

private import javascript
private import semmle.javascript.DynamicPropertyAccess
private import semmle.javascript.dataflow.InferredTypes
import PrototypePollutingAssignmentCustomizations::PrototypePollutingAssignment
private import PrototypePollutingAssignmentCustomizations::PrototypePollutingAssignment as PrototypePollutingAssignment
private import semmle.javascript.filters.ClassifyFiles as ClassifyFiles

// Materialize flow labels
deprecated private class ConcreteObjectPrototype extends ObjectPrototype {
  ConcreteObjectPrototype() { this = this }
}

/** A taint-tracking configuration for reasoning about prototype-polluting assignments. */
module PrototypePollutingAssignmentConfig implements DataFlow::StateConfigSig {
  class FlowState = PrototypePollutingAssignment::FlowState;

  predicate isSource(DataFlow::Node node, FlowState state) {
    node instanceof Source and state = FlowState::taint()
  }

  predicate isSink(DataFlow::Node node, FlowState state) { node.(Sink).getAFlowState() = state }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof Sanitizer
    or
    // Concatenating with a string will in practice prevent the string `__proto__` from arising.
    exists(StringOps::ConcatenationRoot root | node = root |
      // Exclude the string coercion `"" + node` from this filter.
      not node.(StringOps::ConcatenationNode).isCoercion()
    )
    or
    node instanceof DataFlow::ThisNode
    or
    // Stop at .replace() calls that likely prevent __proto__ from arising
    exists(StringReplaceCall replace |
      node = replace and
      replace.getAReplacedString() = ["_", "p", "r", "o", "t"] and
      // Replacing with "_" is likely to be exploitable
      not replace.getRawReplacement().getStringValue() = "_" and
      (
        replace.maybeGlobal()
        or
        // Non-global replace with a non-empty string can also prevent __proto__ by
        // inserting a chunk of text that doesn't fit anywhere in __proto__
        not replace.getRawReplacement().getStringValue() = ""
      )
    )
    or
    node = DataFlow::MakeBarrierGuard<BarrierGuard>::getABarrierNode()
  }

  predicate isBarrierOut(DataFlow::Node node, FlowState state) {
    // Suppress the value-preserving step src -> dst in `extend(dst, src)`. This is modeled as a value-preserving
    // step because it preserves all properties, but the destination is not actually Object.prototype.
    node = any(ExtendCall call).getASourceOperand() and
    state = FlowState::objectPrototype()
  }

  predicate isBarrierIn(DataFlow::Node node, FlowState state) { isSource(node, state) }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    // Step from x -> obj[x] while switching to the ObjectPrototype label
    // (If `x` can have the value `__proto__` then the result can be Object.prototype)
    exists(DynamicPropRead read |
      node1 = read.getPropertyNameNode() and
      node2 = read and
      state1 = FlowState::taint() and
      state2 = FlowState::objectPrototype() and
      // Exclude cases where the property name came from a property enumeration.
      // If the property name is an own property of the base object, the read won't
      // return Object.prototype.
      not read = any(EnumeratedPropName n).getASourceProp() and
      // Exclude cases where the read has no prototype, or a prototype other than Object.prototype.
      not read = prototypeLessObject().getAPropertyRead() and
      // Exclude cases where this property has just been assigned to
      not read.hasDominatingAssignment()
    )
    or
    // Same as above, but for property projection.
    exists(PropertyProjection proj |
      proj.isSingletonProjection() and
      node1 = proj.getASelector() and
      node2 = proj and
      state1 = FlowState::taint() and
      state2 = FlowState::objectPrototype()
    )
    or
    state1 = FlowState::taint() and
    TaintTracking::defaultTaintStep(node1, node2) and
    state1 = state2
  }

  DataFlow::FlowFeature getAFeature() { result instanceof DataFlow::FeatureHasSourceCallContext }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    state = FlowState::taint() and
    TaintTracking::defaultSanitizer(node)
    or
    // Don't propagate into the receiver, as the method lookups will generally fail on Object.prototype.
    node instanceof DataFlow::ThisNode and
    state = FlowState::objectPrototype()
    or
    node = DataFlow::MakeStateBarrierGuard<FlowState, BarrierGuard>::getABarrierNode(state)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Taint-tracking for reasoning about prototype-polluting assignments. */
module PrototypePollutingAssignmentFlow =
  DataFlow::GlobalWithState<PrototypePollutingAssignmentConfig>;

/**
 * Holds if the given `source, sink` pair should not be reported, as we don't have enough
 * confidence in the alert given that source is a library input.
 */
bindingset[source, sink]
predicate isIgnoredLibraryFlow(ExternalInputSource source, Sink sink) {
  exists(source) and
  // filter away paths that start with library inputs and end with a write to a fixed property.
  exists(DataFlow::PropWrite write | sink = write.getBase() |
    // fixed property name
    exists(write.getPropertyName())
    or
    // non-string property name (likely number)
    exists(Expr prop | prop = write.getPropertyNameExpr() |
      not prop.analyze().getAType() = TTString()
    )
  )
}

/**
 * DEPRECATED. Use the `PrototypePollutingAssignmentFlow` module instead.
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PrototypePollutingAssignment" }

  override predicate isSource(DataFlow::Node node) { node instanceof Source }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    node.(Sink).getAFlowLabel() = lbl
  }

  override predicate isSanitizer(DataFlow::Node node) {
    PrototypePollutingAssignmentConfig::isBarrier(node)
  }

  override predicate isSanitizerOut(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    // Suppress the value-preserving step src -> dst in `extend(dst, src)`. This is modeled as a value-preserving
    // step because it preserves all properties, but the destination is not actually Object.prototype.
    node = any(ExtendCall call).getASourceOperand() and
    lbl instanceof ObjectPrototype
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    PrototypePollutingAssignmentConfig::isAdditionalFlowStep(pred, FlowState::fromFlowLabel(inlbl),
      succ, FlowState::fromFlowLabel(outlbl))
  }

  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    super.hasFlowPath(source, sink) and
    // require that there is a path without unmatched return steps
    DataFlow::hasPathWithoutUnmatchedReturn(source, sink) and
    // filter away paths that start with library inputs and end with a write to a fixed property.
    not exists(ExternalInputSource src, Sink snk, DataFlow::PropWrite write |
      source.getNode() = src and sink.getNode() = snk
    |
      snk = write.getBase() and
      (
        // fixed property name
        exists(write.getPropertyName())
        or
        // non-string property name (likely number)
        exists(Expr prop | prop = write.getPropertyNameExpr() |
          not prop.analyze().getAType() = TTString()
        )
      )
    )
  }

  override predicate isLabeledBarrier(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    super.isLabeledBarrier(node, lbl)
    or
    // Don't propagate into the receiver, as the method lookups will generally fail on Object.prototype.
    node instanceof DataFlow::ThisNode and
    lbl instanceof ObjectPrototype
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof PropertyPresenceCheck or
    guard instanceof InExprCheck or
    guard instanceof InstanceofCheck or
    guard instanceof IsArrayCheck or
    guard instanceof TypeofCheck or
    guard instanceof NumberGuard or
    guard instanceof EqualityCheck or
    guard instanceof IncludesCheck or
    guard instanceof DenyListInclusionGuard
  }
}

/** Gets a data flow node referring to an object created with `Object.create`. */
DataFlow::SourceNode prototypeLessObject() {
  result = prototypeLessObject(DataFlow::TypeTracker::end())
}

private DataFlow::SourceNode prototypeLessObject(DataFlow::TypeTracker t) {
  t.start() and
  // We assume the argument to Object.create is not Object.prototype, since most
  // users wouldn't bother to call Object.create in that case.
  result = DataFlow::globalVarRef("Object").getAMemberCall("create") and
  not result.getFile() instanceof TestFile
  or
  // Allow use of SharedFlowSteps to track a bit further
  exists(DataFlow::Node mid |
    prototypeLessObject(t.continue()).flowsTo(mid) and
    DataFlow::SharedFlowStep::step(mid, result)
  )
  or
  exists(DataFlow::TypeTracker t2 | result = prototypeLessObject(t2).track(t2, t))
}

/**
 * A test file.
 * Objects created in such files are ignored in the `prototypeLessObject` predicate.
 */
private class TestFile extends File {
  TestFile() { ClassifyFiles::isTestFile(this) }
}

/** Holds if `Object.prototype` has a member named `prop`. */
private predicate isPropertyPresentOnObjectPrototype(string prop) {
  exists(ExternalInstanceMemberDecl decl |
    decl.getBaseName() = "Object" and
    decl.getName() = prop
  )
}

/** A check of form `e.prop` where `prop` is not present on `Object.prototype`. */
private class PropertyPresenceCheck extends BarrierGuard, DataFlow::ValueNode {
  override PropAccess astNode;

  PropertyPresenceCheck() {
    astNode = any(ConditionGuardNode c).getTest() and // restrict size of charpred
    not isPropertyPresentOnObjectPrototype(astNode.getPropertyName())
  }

  override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
    e = astNode.getBase() and
    outcome = true and
    state = FlowState::objectPrototype()
  }
}

/** A check of form `"prop" in e` where `prop` is not present on `Object.prototype`. */
private class InExprCheck extends BarrierGuard, DataFlow::ValueNode {
  override InExpr astNode;

  InExprCheck() {
    not isPropertyPresentOnObjectPrototype(astNode.getLeftOperand().getStringValue())
  }

  override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
    e = astNode.getRightOperand() and
    outcome = true and
    state = FlowState::objectPrototype()
  }
}

/** A check of form `e instanceof X`, which is always false for `Object.prototype`. */
private class InstanceofCheck extends BarrierGuard, DataFlow::ValueNode {
  override InstanceofExpr astNode;

  override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
    e = astNode.getLeftOperand() and
    outcome = true and
    state = FlowState::objectPrototype()
  }
}

/** A check of form `typeof e === "string"`. */
private class TypeofCheck extends BarrierGuard, DataFlow::ValueNode {
  override EqualityTest astNode;
  Expr operand;
  boolean polarity;

  TypeofCheck() {
    exists(TypeofTag value | TaintTracking::isTypeofGuard(astNode, operand, value) |
      value = "object" and polarity = astNode.getPolarity().booleanNot()
      or
      value != "object" and polarity = astNode.getPolarity()
    )
  }

  override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
    polarity = outcome and
    e = operand and
    state = FlowState::objectPrototype()
  }
}

/** A guard that checks whether `x` is a number. */
class NumberGuard extends BarrierGuard instanceof DataFlow::CallNode {
  Expr x;
  boolean polarity;

  NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

  override predicate blocksExpr(boolean outcome, Expr e) { e = x and outcome = polarity }
}

/** A call to `Array.isArray`, which is false for `Object.prototype`. */
private class IsArrayCheck extends BarrierGuard, DataFlow::CallNode {
  IsArrayCheck() { this = DataFlow::globalVarRef("Array").getAMemberCall("isArray") }

  override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
    e = this.getArgument(0).asExpr() and
    outcome = true and
    state = FlowState::objectPrototype()
  }
}

/**
 * Sanitizer guard of form `x !== "__proto__"`.
 */
private class EqualityCheck extends BarrierGuard, DataFlow::ValueNode {
  override EqualityTest astNode;

  EqualityCheck() { astNode.getAnOperand().getStringValue() = "__proto__" }

  override predicate blocksExpr(boolean outcome, Expr e) {
    e = astNode.getAnOperand() and
    outcome = astNode.getPolarity().booleanNot()
  }
}

/**
 * Sanitizer guard of the form `x.includes("__proto__")`.
 */
private class IncludesCheck extends BarrierGuard, InclusionTest {
  IncludesCheck() { this.getContainedNode().mayHaveStringValue("__proto__") }

  override predicate blocksExpr(boolean outcome, Expr e) {
    e = this.getContainerNode().asExpr() and
    outcome = this.getPolarity().booleanNot()
  }
}

/**
 * A sanitizer guard that checks tests whether `x` is included in a list like `["__proto__"].includes(x)`.
 */
private class DenyListInclusionGuard extends BarrierGuard, InclusionTest {
  DenyListInclusionGuard() {
    this.getContainerNode()
        .getALocalSource()
        .(DataFlow::ArrayCreationNode)
        .getAnElement()
        .mayHaveStringValue("__proto__")
  }

  override predicate blocksExpr(boolean outcome, Expr e) {
    e = this.getContainedNode().asExpr() and
    outcome = super.getPolarity().booleanNot()
  }
}
