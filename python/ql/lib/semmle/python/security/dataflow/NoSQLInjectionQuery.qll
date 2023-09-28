/**
 * Provides a taint-tracking configuration for detecting NoSQL injection vulnerabilities
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts
private import NoSQLInjectionCustomizations::NoSqlInjection as C

/**
 * A taint-tracking configuration for detecting NoSQL injection vulnerabilities.
 */
module NoSqlInjectionConfig implements DataFlow::StateConfigSig {
  class FlowState = C::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof C::StringSource and
    state instanceof C::StringInput
    or
    source instanceof C::InterpretedStringSource and
    state instanceof C::InterpretedStringInput
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof C::StringSink and
    (
      state instanceof C::StringInput
      or
      // since InterpretedStrings can include strings,
      // e.g. JSON objects can encode strings.
      state instanceof C::InterpretedStringInput
    )
    or
    sink instanceof C::InterpretedStringSink and
    state instanceof C::InterpretedStringInput
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    // Block `StringInput` paths here, since they change state to `InterpretedStringInput`
    exists(C::StringInterpretation c | node = c.getOutput()) and
    state instanceof C::StringInput
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    exists(C::StringInterpretation c |
      nodeFrom = c.getAnInput() and
      nodeTo = c.getOutput()
    ) and
    stateFrom instanceof C::StringInput and
    stateTo instanceof C::InterpretedStringInput
  }

  predicate isBarrier(DataFlow::Node node) {
    node = any(NoSqlSanitizer noSqlSanitizer).getAnInput()
  }
}

module NoSqlInjectionFlow = TaintTracking::GlobalWithState<NoSqlInjectionConfig>;
