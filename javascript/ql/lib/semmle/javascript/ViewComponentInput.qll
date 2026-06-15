/**
 * Provides a classes and predicates for contributing to the `view-component-input` threat model.
 */

private import javascript

/**
 * An input to a view component, such as React props.
 */
abstract class ViewComponentInput extends DataFlow::Node {
  /** Gets a string that describes the type of this threat-model source. */
  abstract string getSourceType();
}

private class ViewComponentInputAsThreatModelSource extends ThreatModelSource::Range instanceof ViewComponentInput
{
  ViewComponentInputAsThreatModelSource() {
    not this.asExpr().getTypeBinding().isSanitizingPrimitiveType()
  }

  final override string getThreatModel() { result = "view-component-input" }

  final override string getSourceType() { result = ViewComponentInput.super.getSourceType() }
}
