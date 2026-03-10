/**
 * Much of the QL library handling integral values assumes that
 * equivalence of the DB entities implies equivalence of the
 * Python object and vice-versa.
 * In Python 2, 1L == 1, which can cause problems, so we
 * normalise all longs to ints.
 */

import python
private import LegacyPointsTo

from NumericObject n
where
  exists(IntegerLiteral i | getLiteralObject(i) = n |
    i.getEnclosingModule().getFile().getShortName() = "test.py"
  )
select n.toString(), n.repr()
