import javascript
import semmle.javascript.security.UselessUseOfCat

query string readFile(UselessCat cat) { result = PrettyPrintCatCall::createReadFileCall(cat) }

query SystemCommandExecution syncCommand() { result.isSync() }

query DataFlow::Node options(SystemCommandExecution sys) { result = sys.getOptionsArg() }
