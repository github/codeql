/**
 * Provides utility predicates for working with flow summary specifications.
 */

import javascript

/**
 * Holds if `config` matches `spec`, that is, either `spec` is the name of `config`
 * or `spec` is the empty string and `config` is an arbitrary configuration.
 */
predicate configSpec(DataFlow::Configuration config, string spec) {
  config.toString() = spec
  or
  spec = ""
}

/**
 * Holds if `lbl` matches `spec`, that is, either `spec` is the name of `config`
 * or `spec` is the empty string and `lbl` is the built-in flow label `data`.
 */
predicate sourceFlowLabelSpec(DataFlow::FlowLabel lbl, string spec) {
  lbl.toString() = spec
  or
  spec = "" and
  lbl = DataFlow::FlowLabel::data()
}

/**
 * Holds if `lbl` matches `spec`, that is, either `spec` is the name of `config`
 * or `spec` is the empty string and `lbl` is an arbitrary standard flow label.
 */
predicate sinkFlowLabelSpec(DataFlow::FlowLabel lbl, string spec) {
  lbl.toString() = spec
  or
  spec = "" and
  lbl instanceof DataFlow::StandardFlowLabel
}
