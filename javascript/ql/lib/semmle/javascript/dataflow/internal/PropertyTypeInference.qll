/**
 * INTERNAL: Do not use directly; use `semmle.javascript.dataflow.TypeInference` instead.
 *
 * Provides classes implementing type inference for properties.
 */

private import javascript
import semmle.javascript.dataflow.AbstractProperties
private import AbstractPropertiesImpl
private import AbstractValuesImpl

/**
 * An analyzed property read, either explicitly (`x.p` or `x[e]`) or
 * implicitly.
 */
abstract class AnalyzedPropertyRead extends DataFlow::AnalyzedNode {
  /**
   * Holds if this property read may read property `propName` of a concrete value represented
   * by `base`.
   */
  pragma[nomagic]
  abstract predicate reads(AbstractValue base, string propName);

  override AbstractValue getAValue() {
    result = this.getASourceProperty().getAValue() or
    result = DataFlow::AnalyzedNode.super.getAValue()
  }

  override AbstractValue getALocalValue() {
    result = this.getASourceProperty().getALocalValue() or
    result = DataFlow::AnalyzedNode.super.getALocalValue()
  }

  /**
   * Gets an abstract property representing one of the concrete properties that
   * this read may refer to.
   */
  pragma[noinline]
  private AbstractProperty getASourceProperty() {
    exists(AbstractValue base, string prop | this.reads(base, prop) |
      result = MkAbstractProperty(base, prop)
    )
  }

  override predicate isIncomplete(DataFlow::Incompleteness cause) {
    super.isIncomplete(cause)
    or
    exists(AbstractValue base | this.reads(base, _) | base.isIndefinite(cause))
  }
}

/**
 * Flow analysis for non-numeric property read accesses.
 */
private class AnalyzedNonNumericPropertyRead extends AnalyzedPropertyRead {
  DataFlow::PropRead self;
  DataFlow::AnalyzedNode baseNode;
  string propName;

  AnalyzedNonNumericPropertyRead() {
    this = self and
    self.accesses(baseNode, propName) and
    isNonNumericPropertyName(propName)
  }

  override predicate reads(AbstractValue base, string prop) {
    base = baseNode.getALocalValue() and
    prop = propName
  }
}

/**
 * Holds if `prop` is a property name that does not look like an array index.
 */
private predicate isNonNumericPropertyName(string prop) {
  exists(PropAccess pacc |
    prop = pacc.getPropertyName() and
    not exists(prop.toInt())
  )
}

/**
 * Holds if properties named `prop` should be tracked.
 */
pragma[noinline]
private predicate isTrackedPropertyName(string prop) { exists(MkAbstractProperty(_, prop)) }

/**
 * An analyzed property write, including exports (which are
 * modeled as assignments to `module.exports`).
 */
abstract class AnalyzedPropertyWrite extends DataFlow::Node {
  /**
   * Holds if this property write assigns `source` to property `propName` of one of the
   * concrete objects represented by `baseVal`.
   *
   * Note that not all property writes have an explicit `source` node; use predicate
   * `writesValue` below to cover these cases.
   */
  predicate writes(AbstractValue baseVal, string propName, DataFlow::AnalyzedNode source) { none() }

  /**
   * Holds if this property write assigns `val` to property `propName` of one of the
   * concrete objects represented by `baseVal`.
   */
  predicate writesValue(AbstractValue baseVal, string propName, AbstractValue val) {
    exists(AnalyzedNode source |
      this.writes(baseVal, propName, source) and
      val = source.getALocalValue()
    )
  }

  /**
   * Holds if the flow information for the base node of this property write is incomplete
   * due to `reason`.
   */
  predicate baseIsIncomplete(DataFlow::Incompleteness reason) { none() }
}

/**
 * Flow analysis for property writes.
 */
private class AnalyzedExplicitPropertyWrite extends AnalyzedPropertyWrite instanceof DataFlow::PropWrite
{
  override predicate writes(AbstractValue base, string prop, DataFlow::AnalyzedNode source) {
    explicitPropertyWrite(this, base, prop, source)
  }

  override predicate baseIsIncomplete(DataFlow::Incompleteness reason) {
    super.getBase().isIncomplete(reason)
  }
}

pragma[noopt]
private predicate explicitPropertyWrite(
  DataFlow::PropWrite pw, AbstractValue base, string prop, DataFlow::Node source
) {
  exists(DataFlow::AnalyzedNode baseNode |
    pw.writes(baseNode, prop, source) and
    isTrackedPropertyName(prop) and
    base = baseNode.getALocalValue() and
    shouldTrackProperties(base)
  )
}

/**
 * Flow analysis for `arguments.callee`. We assume it is never redefined,
 * which is unsound in practice, but pragmatically useful.
 */
private class AnalyzedArgumentsCallee extends AnalyzedNonNumericPropertyRead {
  AnalyzedArgumentsCallee() { propName = "callee" }

  override AbstractValue getALocalValue() {
    exists(AbstractArguments baseVal | this.reads(baseVal, _) |
      result = TAbstractFunction(baseVal.getFunction())
    )
    or
    hasNonArgumentsBase(self) and result = super.getALocalValue()
  }
}

/**
 * Holds if `pr` is of the form `e.callee` where `e` could evaluate to some
 * value that is not an arguments object.
 */
private predicate hasNonArgumentsBase(DataFlow::PropRead pr) {
  pr.getPropertyName() = "callee" and
  exists(AbstractValue baseVal |
    baseVal = pr.getBase().analyze().getALocalValue() and
    not baseVal instanceof AbstractArguments
  )
}
