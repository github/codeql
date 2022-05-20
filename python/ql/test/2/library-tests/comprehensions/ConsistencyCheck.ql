/**
 * Check that all Comprehensions have one toString(), one getLocation() and at least one flow node.
 */

import python

select count(Comprehension c |
    count(c.toString()) != 1 or count(c.getLocation()) != 1 or not exists(c.getAFlowNode())
  )
