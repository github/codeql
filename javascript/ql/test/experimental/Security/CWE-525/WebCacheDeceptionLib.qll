import javascript
import StringOps

module WebCacheDeception {
  abstract class Sink extends DataFlow::Node { }

  private class Express extends Sink {
    Express() {
      exists(Import is | is.getImportedModuleNode().getASuccessor().toString() = "express") and
      exists(DataFlow::CallNode m |
        m.getAMethodCall().getArgument(0).getStringValue().matches("%*") and
        this = m.getAMethodCall().getArgument(0)
      )
    }
  }
}
