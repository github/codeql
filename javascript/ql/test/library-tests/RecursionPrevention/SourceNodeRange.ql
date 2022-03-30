/**
 * Test that fails to compile if the domain of `SourceNode::Range` depends on `SourceNode` (recursively).
 *
 * This tests adds a negative dependency `SourceNode --!--> SourceNode::Range`
 * so that the undesired edge `SourceNode::Range --> SourceNode` completes a negative cycle.
 */

import javascript

class BadSourceNodeRange extends DataFlow::SourceNode::Internal::RecursionGuard {
  BadSourceNodeRange() { not this instanceof DataFlow::SourceNode::Range }
}

select "Success"
