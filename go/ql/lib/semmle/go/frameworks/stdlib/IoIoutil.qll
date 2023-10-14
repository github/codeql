/**
 * Provides classes modeling security-relevant aspects of the `io/ioutil` package.
 */

import go

/** Provides models of commonly used functions in the `io/ioutil` package. */
module IoIoutil {
  private class IoUtilFileSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    IoUtilFileSystemAccess() {
      exists(string fn | this.getTarget().hasQualifiedName("io/ioutil", fn) |
        fn = ["ReadDir", "ReadFile", "TempDir", "TempFile", "WriteFile"]
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getAnArgument() }
  }
}
