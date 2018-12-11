import python
import semmle.python.security.TaintTracking

import python
import semmle.python.security.SensitiveData
import semmle.python.security.Crypto

from TaintedNode n
select n.getTrackedValue(), n.getLocation(), n.getNode().getNode(), n.getContext()
