/**
 * Test that fails to compile if the domain of `SourceNode` depends on `SourceNode.flowsTo` (recursively).
 *
 * This tests adds a negative dependency `flowsTo --!--> SourceNode`
 * so that the undesired edge `SourceNode --> flowsTo` completes a negative cycle.
 */

import javascript

class BadSourceNode extends DataFlow::SourceNode {
  BadSourceNode() { this.(DataFlow::PropRead).getPropertyName() = "foo" }

  override predicate flowsTo(DataFlow::Node node) { not node instanceof DataFlow::SourceNode }
}

select "Success"
