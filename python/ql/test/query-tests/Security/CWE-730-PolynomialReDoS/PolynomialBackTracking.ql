import python
import semmle.python.security.regexp.SuperlinearBackTracking

from PolynomialBackTrackingTerm t
select t.getRegex(), t, t.getReason()
