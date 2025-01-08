/**
 * Provides a classes and predicates for contributing to the `view-component-input` threat model.
 */

private import javascript

/**
 * An input to a view component, such as React props.
 */
abstract class ViewComponentInput extends ThreatModelSource::Range {
  final override string getThreatModel() { result = "view-component-input" }
}
