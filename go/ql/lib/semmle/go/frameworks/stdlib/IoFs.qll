/**
 * Provides classes modeling security-relevant aspects of the 'io/fs' package.
 */
overlay[local?]
module;

import go

/**
 * Provides classes modeling security-relevant aspects of the 'io/fs' package.
 */
module IoFs {
  /** Gets the package name `io/fs`. */
  string packagePath() { result = "io/fs" }

  /**
   * Models a step from `fs` to `path` and `d` in
   * `fs.WalkDir(fs, "root", func(path string, d DirEntry, err error) {}`
   */
  private class WalkDirStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      //signature: func WalkDir(fsys FS, root string, fn WalkDirFunc) error
      exists(DataFlow::CallNode call, DataFlow::FunctionNode f, DataFlow::Node n |
        n = f.(DataFlow::FuncLitNode)
        or
        n.asExpr().(FunctionName).getTarget() = f.(DataFlow::GlobalFunctionNode).getFunction()
      |
        call.getTarget().hasQualifiedName(packagePath(), "WalkDir") and
        n.getASuccessor*() = call.getArgument(2) and
        pred = call.getArgument(0) and
        succ = f.getParameter([0, 1])
      )
    }
  }
}
