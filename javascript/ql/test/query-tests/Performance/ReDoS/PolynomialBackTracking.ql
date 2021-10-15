import semmle.javascript.security.performance.SuperlinearBackTracking

from PolynomialBackTrackingTerm t
select t, t.getReason()
