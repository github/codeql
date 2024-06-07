/**
 * @name Escaped
 * @description Test for escaped characters
 */

import python
import semmle.python.regex

from RegExp r, int start, int end
where r.character(start, end) and r.getLocation().getFile().getBaseName() = "test.py"
select r.getText(), start, end
