/**
 * Provides classes for working with sinks and taint propagators
 * from the `github.com/spf13/afero` package.
 */

import go

/**
 * Provide File system access sinks of [afero](https://github.com/spf13/afero) framework
 */
module Afero {
  /**
   * Gets all versions of `github.com/spf13/afero`
   */
  string aferoPackage() { result = package("github.com/spf13/afero", "") }

  /**
   * DEPRECATED: Use `FileSystemAccess::Range` instead.
   *
   * The File system access sinks of [afero](https://github.com/spf13/afero) framework methods
   */
  deprecated class AferoSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    AferoSystemAccess() {
      exists(Method m |
        m.hasQualifiedName(aferoPackage(), "HttpFs",
          ["Create", "Open", "OpenFile", "Remove", "RemoveAll"]) and
        this = m.getACall()
        or
        m.hasQualifiedName(aferoPackage(), "RegexpFs",
          ["Create", "Open", "OpenFile", "Remove", "RemoveAll", "Mkdir", "MkdirAll"]) and
        this = m.getACall()
        or
        m.hasQualifiedName(aferoPackage(), "ReadOnlyFs",
          ["Create", "Open", "OpenFile", "ReadDir", "ReadlinkIfPossible", "Mkdir", "MkdirAll"]) and
        this = m.getACall()
        or
        m.hasQualifiedName(aferoPackage(), "OsFs",
          [
            "Create", "Open", "OpenFile", "ReadlinkIfPossible", "Remove", "RemoveAll", "Mkdir",
            "MkdirAll"
          ]) and
        this = m.getACall()
        or
        m.hasQualifiedName(aferoPackage(), "MemMapFs",
          ["Create", "Open", "OpenFile", "Remove", "RemoveAll", "Mkdir", "MkdirAll"]) and
        this = m.getACall()
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
  }

  /**
   * The File system access sinks of [afero](https://github.com/spf13/afero) framework utility functions
   *
   * Afero Type is basically is an wrapper around utility functions which make them like a method, look at [here](https://github.com/spf13/afero/blob/cf95922e71986c0116204b6eeb3b345a01ffd842/ioutil.go#L61)
   *
   * The Types that are not vulnerable: `afero.BasePathFs` and `afero.IOFS`
   */
  class AferoUtilityFunctionSystemAccess extends FileSystemAccess::Range, DataFlow::CallNode {
    int pathArg;

    AferoUtilityFunctionSystemAccess() {
      // utility functions
      exists(Function f |
        f.hasQualifiedName(aferoPackage(),
          ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"]) and
        this = pragma[only_bind_out](f.getACall()) and
        pathArg = 1 and
        not aferoSanitizer(this.getArgument(0))
      )
      or
      exists(Method m |
        m.hasQualifiedName(aferoPackage(), "Afero",
          ["WriteReader", "SafeWriteReader", "WriteFile", "ReadFile", "ReadDir"]) and
        this = pragma[only_bind_out](m.getACall()) and
        pathArg = 0 and
        not aferoSanitizer(this.getReceiver())
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(pathArg) }
  }

  /**
   * Holds if the Afero utility function has a first argument of a safe type like `NewBasePathFs`.
   *
   * e.g.
   * ```
   * basePathFs := afero.NewBasePathFs(osFS, "tmp")
   * afero.ReadFile(basePathFs, filepath)
   * ```
   */
  predicate aferoSanitizer(DataFlow::Node n) {
    exists(Function f |
      f.hasQualifiedName(aferoPackage(), ["NewBasePathFs", "NewIOFS"]) and
      TaintTracking::localTaint(f.getACall(), n)
    )
  }

  /**
   * Holds if there is a dataflow node from n1 to n2 when initializing the Afero instance
   *
   * A helper for `aferoSanitizer` for when the Afero instance is initialized with one of the safe FS types like IOFS
   *
   * e.g.`n2 := &afero.Afero{Fs: afero.NewBasePathFs(osFS, "./")}` n1 is `afero.NewBasePathFs(osFS, "./")`
   */
  class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
      exists(StructLit st | st.getType().hasQualifiedName(aferoPackage(), "Afero") |
        n1.asExpr() = st.getAnElement().(KeyValueExpr).getAChildExpr() and
        n2.asExpr() = st
      )
    }
  }
}
