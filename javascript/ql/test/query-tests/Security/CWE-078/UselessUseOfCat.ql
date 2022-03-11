import javascript
import semmle.javascript.security.UselessUseOfCat

query string readFile(UselessCat cat) { result = PrettyPrintCatCall::createReadFileCall(cat) }

query CommandExecution syncCommand() { result.isSync() }

query DataFlow::Node options(CommandExecution sys) { result = sys.getOptionsArg() }
