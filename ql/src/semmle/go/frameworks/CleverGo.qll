/**
 * TODO: Doc about this file.
 */

import go

/**
 * TODO: Doc about this module.
 */
private module CleverGo {
  /** Gets the package path. */
  bindingset[result]
  string packagePath() { result = ["clevergo.tech/clevergo", "github.com/clevergo/clevergo"] }

  /**
   * Provides models of untrusted flow sources.
   */
  private class UntrustedSources extends UntrustedFlowSource::Range {
    UntrustedSources() {
      // Methods on types of package: clevergo.tech/clevergo@v0.5.2
      exists(string methodName, Method mtd, FunctionOutput outp |
        this = outp.getExitNode(mtd.getACall())
      |
        // Receiver: Context
        mtd.hasQualifiedName(packagePath(), "Context", methodName) and
        (
          // Method: func (*Context).BasicAuth() (username string, password string, ok bool)
          methodName = "BasicAuth" and
          outp.isResult([0, 1])
          or
          // Method: func (*Context).Decode(v interface{}) (err error)
          methodName = "Decode" and
          outp.isParameter(0)
          or
          // Method: func (*Context).DefaultQuery(key string, defaultVlue string) string
          methodName = "DefaultQuery" and
          outp.isResult()
          or
          // Method: func (*Context).FormValue(key string) string
          methodName = "FormValue" and
          outp.isResult()
          or
          // Method: func (*Context).GetHeader(name string) string
          methodName = "GetHeader" and
          outp.isResult()
          or
          // Method: func (*Context).PostFormValue(key string) string
          methodName = "PostFormValue" and
          outp.isResult()
          or
          // Method: func (*Context).QueryParam(key string) string
          methodName = "QueryParam" and
          outp.isResult()
          or
          // Method: func (*Context).QueryString() string
          methodName = "QueryString" and
          outp.isResult()
        )
        or
        // Receiver: Params
        mtd.hasQualifiedName(packagePath(), "Params", methodName) and
        (
          // Method: func (Params).String(name string) string
          methodName = "String" and
          outp.isResult()
        )
      )
      or
      // Structs of package: clevergo.tech/clevergo@v0.5.2
      exists(DataFlow::Field fld |
        // Struct: Context
        fld.hasQualifiedName(packagePath(), "Context", "Params")
        or
        // Struct: Param
        fld.hasQualifiedName(packagePath(), "Param", ["Key", "Value"])
      |
        this = fld.getARead()
      )
      or
      // Types of package: clevergo.tech/clevergo@v0.5.2
      exists(DataFlow::ReadNode read, ValueEntity v |
        v.getType().hasQualifiedName(packagePath(), "Params")
      |
        read.reads(v) and
        this = read
      )
    }
  }

  // Models taint-tracking through functions.
  private class TaintTrackingFunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput out;

    TaintTrackingFunctionModels() {
      // Taint-tracking models for package: clevergo.tech/clevergo@v0.5.2
      (
        // signature: func CleanPath(p string) string
        hasQualifiedName(packagePath(), "CleanPath") and
        (
          inp.isParameter(0) and
          out.isResult()
        )
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = out
    }
  }

  // Models taint-tracking through method calls.
  private class TaintTrackingMethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput out;

    TaintTrackingMethodModels() {
      // Taint-tracking models for package: clevergo.tech/clevergo@v0.5.2
      (
        // signature: func (Decoder).Decode(req *net/http.Request, v interface{}) error
        implements(packagePath(), "Decoder", "Decode") and
        (
          inp.isParameter(0) and
          out.isParameter(1)
        )
        or
        // signature: func (Renderer).Render(w io.Writer, name string, data interface{}, c *Context) error
        implements(packagePath(), "Renderer", "Render") and
        (
          inp.isParameter(2) and
          out.isParameter(0)
        )
      )
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = out
    }
  }
}
