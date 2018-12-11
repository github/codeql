/**
 * @name Escaped
 * @description Test for escaped characters
 */

 
import python
import semmle.python.regex

from Regex r, int start, int end
where r.character(start, end)
select r.getText(), start, end


