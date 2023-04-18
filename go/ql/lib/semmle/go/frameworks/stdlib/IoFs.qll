/**
 * Provides classes modeling security-relevant aspects of the 'io/fs' package.
 */

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
      exists(DataFlow::CallNode call, DataFlow::FunctionNode f |
        call.getTarget().hasQualifiedName(packagePath(), "WalkDir") and
        f.getASuccessor*() = call.getArgument(2)
      |
        pred = call.getArgument(0) and
        succ = f.getParameter([0, 1])
      )
    }
  }
}
