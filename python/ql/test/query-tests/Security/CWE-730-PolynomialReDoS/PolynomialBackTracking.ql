import python
import semmle.python.security.performance.SuperlinearBackTracking

from PolynomialBackTrackingTerm t
select t.getRegex(), t, t.getReason()
