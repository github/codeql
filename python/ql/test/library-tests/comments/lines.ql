import python
import Lexical.CommentedOutCode

from CommentedOutCodeLine c, int l
where l = c.getLocation().getStartLine()
select l, c.toString()
