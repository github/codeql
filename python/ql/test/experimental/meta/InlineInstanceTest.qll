/**
 * Defines an InlineExpectationsTest for class instances, that is,
 * for any API::Node that is an instance of a class (e.g. `Flask`).
 */

import python
import semmle.python.ApiGraphs
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

signature API::Node getInstanceSig();

module MakeInlineInstanceTest<getInstanceSig/0 getInstance> {
  private module InlineInstanceTest implements TestSig {
    string getARelevantTag() { result = "instance" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(location.getFile().getRelativePath()) and
      exists(API::Node instance | instance = getInstance() |
        location = instance.getLocation() and
        element = prettyNode(instance.asSource()) and
        value = "" and
        tag = "instance"
      )
    }
  }

  import MakeTest<InlineInstanceTest>
}
