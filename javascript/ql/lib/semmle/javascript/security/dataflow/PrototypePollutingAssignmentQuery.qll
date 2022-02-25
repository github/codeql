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
private import semmle.javascript.filters.ClassifyFiles as ClassifyFiles

// Materialize flow labels
private class ConcreteObjectPrototype extends ObjectPrototype {
  ConcreteObjectPrototype() { this = this }
}

/** A taint-tracking configuration for reasoning about prototype-polluting assignments. */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PrototypePollutingAssignment" }

  override predicate isSource(DataFlow::Node node) { node instanceof Source }

  override predicate isSink(DataFlow::Node node, DataFlow::FlowLabel lbl) {
    node.(Sink).getAFlowLabel() = lbl
  }

  override predicate isSanitizer(DataFlow::Node node) {
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
        replace.isGlobal()
        or
        // Non-global replace with a non-empty string can also prevent __proto__ by
        // inserting a chunk of text that doesn't fit anywhere in __proto__
        not replace.getRawReplacement().getStringValue() = ""
      )
    )
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node pred, DataFlow::Node succ, DataFlow::FlowLabel inlbl, DataFlow::FlowLabel outlbl
  ) {
    // Step from x -> obj[x] while switching to the ObjectPrototype label
    // (If `x` can have the value `__proto__` then the result can be Object.prototype)
    exists(DynamicPropRead read |
      pred = read.getPropertyNameNode() and
      succ = read and
      inlbl.isTaint() and
      outlbl instanceof ObjectPrototype and
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
      pred = proj.getASelector() and
      succ = proj and
      inlbl.isTaint() and
      outlbl instanceof ObjectPrototype
    )
    or
    DataFlow::localFieldStep(pred, succ) and inlbl = outlbl
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
    guard instanceof IncludesCheck
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
private class PropertyPresenceCheck extends TaintTracking::LabeledSanitizerGuardNode,
  DataFlow::ValueNode {
  override PropAccess astNode;

  PropertyPresenceCheck() {
    astNode = any(ConditionGuardNode c).getTest() and // restrict size of charpred
    not isPropertyPresentOnObjectPrototype(astNode.getPropertyName())
  }

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    e = astNode.getBase() and
    outcome = true and
    label instanceof ObjectPrototype
  }
}

/** A check of form `"prop" in e` where `prop` is not present on `Object.prototype`. */
private class InExprCheck extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::ValueNode {
  override InExpr astNode;

  InExprCheck() {
    not isPropertyPresentOnObjectPrototype(astNode.getLeftOperand().getStringValue())
  }

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    e = astNode.getRightOperand() and
    outcome = true and
    label instanceof ObjectPrototype
  }
}

/** A check of form `e instanceof X`, which is always false for `Object.prototype`. */
private class InstanceofCheck extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::ValueNode {
  override InstanceofExpr astNode;

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    e = astNode.getLeftOperand() and
    outcome = true and
    label instanceof ObjectPrototype
  }
}

/** A check of form `typeof e === "string"`. */
private class TypeofCheck extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::ValueNode {
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

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    polarity = outcome and
    e = operand and
    label instanceof ObjectPrototype
  }
}

/** A guard that checks whether `x` is a number. */
class NumberGuard extends TaintTracking::SanitizerGuardNode instanceof DataFlow::CallNode {
  Expr x;
  boolean polarity;

  NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

  override predicate sanitizes(boolean outcome, Expr e) { e = x and outcome = polarity }
}

/** A call to `Array.isArray`, which is false for `Object.prototype`. */
private class IsArrayCheck extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::CallNode {
  IsArrayCheck() { this = DataFlow::globalVarRef("Array").getAMemberCall("isArray") }

  override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
    e = this.getArgument(0).asExpr() and
    outcome = true and
    label instanceof ObjectPrototype
  }
}

/**
 * Sanitizer guard of form `x !== "__proto__"`.
 */
private class EqualityCheck extends TaintTracking::SanitizerGuardNode, DataFlow::ValueNode {
  override EqualityTest astNode;

  EqualityCheck() { astNode.getAnOperand().getStringValue() = "__proto__" }

  override predicate sanitizes(boolean outcome, Expr e) {
    e = astNode.getAnOperand() and
    outcome = astNode.getPolarity().booleanNot()
  }
}

/**
 * Sanitizer guard of the form `x.includes("__proto__")`.
 */
private class IncludesCheck extends TaintTracking::LabeledSanitizerGuardNode, InclusionTest {
  IncludesCheck() { this.getContainedNode().mayHaveStringValue("__proto__") }

  override predicate sanitizes(boolean outcome, Expr e) {
    e = this.getContainerNode().asExpr() and
    outcome = this.getPolarity().booleanNot()
  }
}
