import python
import Lexical.CommentedOutCode

from CommentedOutCodeBlock c, int bl, int el
where c.hasLocationInfo(_, bl, _, el, _) and not c.maybeExampleCode()
select bl, el, c.toString()
