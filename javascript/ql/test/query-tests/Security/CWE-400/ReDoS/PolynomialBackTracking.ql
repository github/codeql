import semmle.javascript.security.regexp.SuperlinearBackTracking

from PolynomialBackTrackingTerm t
select t, t.getReason()
