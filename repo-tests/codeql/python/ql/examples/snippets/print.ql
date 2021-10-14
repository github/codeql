/**
 * @id py/examples/print
 * @name Find prints
 * @description Find print statements or calls to the builtin function 'print'
 * @tags print
 */

import python

from AstNode print
where
  /* Python 2 without `from __future__ import print_function` */
  print instanceof Print
  or
  /* Python 3 or with `from __future__ import print_function` */
  print.(Call).getFunc().pointsTo(Value::named("print"))
select print
