/**
 * @id py/examples/filename
 * @name File with given name
 * @description Finds files called `spam.py`
 * @tags file
 */

import python

from File f
where f.getShortName() = "spam.py"
select f
