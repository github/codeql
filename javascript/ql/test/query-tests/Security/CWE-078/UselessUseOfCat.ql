import javascript
import semmle.javascript.security.UselessUseOfCat

from LineComment comment, string msg
where
  comment.getFile().getAbsolutePath().regexpMatch(".*/uselesscat.js") and
  (
    comment.getText().regexpMatch(".*NOT OK.*") and
    not any(UselessCat cat).asExpr().getLocation().getStartLine() =
      comment.getLocation().getStartLine() and
    msg = "False negative"
    or
    comment.getText().regexpMatch(".* OK.*") and
    not comment.getText().regexpMatch(".*NOT OK.*") and
    any(UselessCat cat).asExpr().getLocation().getStartLine() = comment.getLocation().getStartLine() and
    msg = "False positive"
  )
select msg, comment

query string readFile(UselessCat cat) { result = PrettyPrintCatCall::createReadFileCall(cat) }

query SystemCommandExecution syncCommand() { result.isSync() }

query DataFlow::Node options(SystemCommandExecution sys) { result = sys.getOptionsArg() }
