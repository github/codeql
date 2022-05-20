import python
import Lexical.CommentedOutCode

from CommentBlock block, int line, boolean code
where
  block.hasLocationInfo(_, line, _, _, _) and
  if block instanceof CommentedOutCodeBlock then code = true else code = false
select line, block.length(), code
