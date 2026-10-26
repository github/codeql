import python
import Lexical.CommentedOutCode

from CommentedOutCodeLine c, int l
where l = c.getLocation().getStartLine() and not c.maybeExampleCode()
select l, c.toString()
