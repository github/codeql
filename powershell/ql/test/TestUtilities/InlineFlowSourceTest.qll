/**
 * Inline flow source tests for Powershell.
 */

import powershell
private import codeql.util.test.InlineExpectationsTest
private import internal.InlineExpectationsTestImpl
private import semmle.code.powershell.dataflow.flowsources.FlowSources
import Make<Impl>

module InlineFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "type" }

  bindingset[s]
  private string quote(string s) {
    if s.matches("% %") then result = "\"" + s + "\"" else result = s
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SourceNode sourceNode |
      sourceNode.getLocation() = location and
      tag = "type" and
      quote(sourceNode.getSourceType()) = value and
      element = sourceNode.toString()
    )
  }
}

import MakeTest<InlineFlowSourceTest>
