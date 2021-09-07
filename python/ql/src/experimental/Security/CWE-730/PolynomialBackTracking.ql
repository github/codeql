import python
import semmle.python.security.performance.SuperlinearBackTracking

from PolynomialBackTrackingTerm t
where t.getLocation().getFile().getBaseName() = "KnownCVEs.py"
select t.getRegex(), t, t.getReason()
