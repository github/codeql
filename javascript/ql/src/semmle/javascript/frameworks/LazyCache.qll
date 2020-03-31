/**
 * Models imports through the NPM `lazy-cache` package.
 */

import javascript

module LazyCache {
  /**
   * A lazy-cache object, usually created through an expression of form `require('lazy-cache')(require)`.
   */
  class LazyCacheObject extends DataFlow::SourceNode {
    LazyCacheObject() {
      // Use `require` directly instead of `moduleImport` to avoid recursion.
      // For the same reason, avoid `Import.getImportedPath`.
      exists(Require req |
        req.getArgument(0).getStringValue() = "lazy-cache" and
        this = req.flow().(DataFlow::SourceNode).getAnInvocation()
      )
    }
  }

  /**
   * An import through `lazy-cache`.
   */
  class LazyCacheImport extends CallExpr, Import {
    LazyCacheObject cache;

    LazyCacheImport() { this = cache.getACall().asExpr() }

    /** Gets the name of the package as it's exposed on the lazy-cache object. */
    string getLocalAlias() {
      result = getArgument(1).getStringValue()
      or
      not exists(getArgument(1)) and
      result = getArgument(0).getStringValue()
    }

    override Module getEnclosingModule() { result = getTopLevel() }

    override PathExpr getImportedPath() { result = getArgument(0) }

    override DataFlow::Node getImportedModuleNode() {
      result = this.flow()
      or
      result = cache.getAPropertyRead(getLocalAlias())
    }
  }

  /** A constant path element appearing in a call to a lazy-cache object. */
  private class LazyCachePathExpr extends PathExprInModule, ConstantString {
    LazyCachePathExpr() { this = any(LazyCacheImport rp).getArgument(0) }

    override string getValue() { result = getStringValue() }
  }
}
