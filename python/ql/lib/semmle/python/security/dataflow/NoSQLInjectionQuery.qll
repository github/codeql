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
    source instanceof C::DictSource and
    state instanceof C::DictInput
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink instanceof C::StringSink and
    (
      state instanceof C::StringInput
      or
      // since dictionaries can encode strings
      state instanceof C::DictInput
    )
    or
    sink instanceof C::DictSink and
    state instanceof C::DictInput
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    // Block `StringInput` paths here, since they change state to `DictInput`
    exists(C::StringToDictConversion c | node = c.getOutput()) and
    state instanceof C::StringInput
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    exists(C::StringToDictConversion c |
      nodeFrom = c.getAnInput() and
      nodeTo = c.getOutput()
    ) and
    stateFrom instanceof C::StringInput and
    stateTo instanceof C::DictInput
  }

  predicate isBarrier(DataFlow::Node node) {
    node = any(NoSqlSanitizer noSqlSanitizer).getAnInput()
  }
}

module NoSqlInjectionFlow = TaintTracking::GlobalWithState<NoSqlInjectionConfig>;
