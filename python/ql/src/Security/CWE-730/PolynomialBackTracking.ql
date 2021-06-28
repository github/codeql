import python
import semmle.python.regex.SuperlinearBackTracking

from PolynomialBackTrackingTerm t
where t.getLocation().getFile().getBaseName() = "KnownCVEs.py"
select t.getRegex(), t, t.getReason()
