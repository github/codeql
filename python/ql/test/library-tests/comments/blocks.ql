/**
 * @name commented_out_code
 * @description Insert description here...
 * @kind table
 * @problem.severity warning
 */

import python
import Lexical.CommentedOutCode

from CommentedOutCodeBlock c, int bl, int el
where c.hasLocationInfo(_, bl, _, el, _)
select bl, el, c.toString()
