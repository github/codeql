import experimental.meta.InlineTaintTest
import semmle.python.Concepts

module HtmlSpecializationConfig implements DataFlow::ConfigSig {
  predicate isSource = TestTaintTrackingConfig::isSource/1;

  predicate isSink = TestTaintTrackingConfig::isSink/1;

  // TODO: For now, since there is not an `isSanitizingStep` member-predicate part of a
  // `TaintTracking::Configuration`, we use treat the output is a taint-sanitizer. This
  // is slightly imprecise, which you can see in the `m_unsafe + SAFE` test-case in
  // python/ql/test/library-tests/frameworks/markupsafe/taint_test.py
  //
  // However, it is better than `getAnInput()`. Due to use-use flow, that would remove
  // the taint-flow to `SINK()` in `some_escape(tainted); SINK(tainted)`.
  predicate isBarrier(DataFlow::Node node) { node = any(HtmlEscaping esc).getOutput() }
}

import MakeInlineTaintTest<HtmlSpecializationConfig>
