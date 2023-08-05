import go
import semmle.go.dataflow.Properties
import semmle.go.security.FlowSources

abstract class CmdLineFlowSource extends DataFlow::Node { }

/**
 * https://cli.urfave.org/v2/examples/flags/
 */
class UrfaveCmdLineSourceFlags extends CmdLineFlowSource {
  UrfaveCmdLineSourceFlags() {
    exists(DataFlow::Function f |
      f.hasQualifiedName(["github.com/urfave/cli/v2.Context", "github.com/urfave/cli.Context"],
        ["String", "StringSlice", "Generic", "Value", "Path"])
    |
      this = f.getACall().getResult(0)
    )
  }
}

/**
 * https://pkg.go.dev/github.com/urfave/cli
 *
 * https://pkg.go.dev/github.com/urfave/cli/v2
 *
 * ```go
 * // e.g. cCtx.Args().Get(0) in following
 *app := &cli.App{
 *        Action: func(cCtx *cli.Context) error {
 *            fmt.Printf("Hello %q", cCtx.Args().Get(0))
 *            return nil
 *        },
 *    }
 * ```
 */
class UrfaveCmdLineSourceArguments extends CmdLineFlowSource {
  UrfaveCmdLineSourceArguments() {
    // https://pkg.go.dev/gopkg.in/urfave/cli.v1
    // Args()[i] just for v1
    exists(DataFlow::Function f | f.hasQualifiedName("github.com/urfave/cli.Context", "Args") |
      f.getACall().asExpr().getParent().(IndexExpr) = this.asExpr()
    )
    or
    // Args().Get/First/Tail
    exists(DataFlow::Function f |
      f.hasQualifiedName(["github.com/urfave/cli/v2.Args", "github.com/urfave/cli.Args"],
        ["Get", "First", "Tail", "Slice"])
    |
      this = f.getACall()
    )
  }
}

/**
 * https://pkg.go.dev/github.com/spf13/cobra
 *
 * ```go
 * // example
 * var cmdTimes = &cobra.Command{
 *    Use:   "times [# times] [string to echo]"
 *    Run: func(cmd *cobra.Command, args []string) {
 *        fmt.Println("Echo: " + strings.Join(args, " "))
 *    },
 *  }
 * }
 * ```
 */
class CobraCmdLineSource extends CmdLineFlowSource {
  CobraCmdLineSource() {
    // following is to restrictive as we must have a function with a constant signiture but
    // we can `Run: someFunc(some params)` and then someFunc has the method that we want inside itself
    exists(DataFlow::Parameter p, DataFlow::StructLit f, int indexOfRunField |
      this.asParameter() = p and
      // checking type of a Struct literal
      f.getType().hasQualifiedName("github.com/spf13/cobra", "Command")
    |
      p.getFunction() = f.getValue(indexOfRunField) and
      // this is possible to use unsafe sinks in other that "Run" field, all of them have a same function signiture
      // Args field has PositionalArgs type which is same as Run function signiture
      f.getKey(indexOfRunField).toString() =
        [
          "Run", "RunE", "PreRun", "PreRunE", "PostRun", "PostRunE", "PersistentPreRun",
          "PersistentPreRunE", "PersistentPostRun", "PersistentPostRunE", "Args"
        ] and
      f.getValue(indexOfRunField).getAChild().(FuncTypeExpr).getNumParameter() = 2 and
      f.getValue(indexOfRunField).getAChild().(FuncTypeExpr).getParameterDecl(1).getType() =
        any(SliceType s) and
      // checking type of first function parameter of `Run` filed
      f.getValue(indexOfRunField)
          .getAChildExpr()
          .(FuncTypeExpr)
          .getParameterDecl(0)
          .getAChildExpr()
          .(StarExpr)
          .getAChildExpr()
          .getType()
          .hasQualifiedName("github.com/spf13/cobra", "Command")
    )
    or
    // I don't see much problems with following because if we have some function that
    //has two parameters, with checking the types of them we can assume that second
    //parameter is our CliFlowSource Node.
    exists(DataFlow::Parameter p, DataFlow::FuncTypeExpr fte | p = this.asParameter() |
      this.asParameter() = p and
      p.getFunction() = fte.getParent() and
      fte.getNumParameter() = 2 and
      fte.getParameterDecl(1).getType() = any(SliceType s) and
      // checking type of first function parameter of `Run` filed
      fte.getParameterDecl(0)
          .getAChildExpr()
          .(StarExpr)
          .getAChildExpr()
          .getType()
          .hasQualifiedName("github.com/spf13/cobra", "Command")
    )
  }
}

class CmdLineSourceFlags extends CmdLineFlowSource {
  CmdLineSourceFlags() {
    // bind function arguments to variable and set the variable as cli source flow node
    exists(DataFlow::CallNode call, DataFlow::DeclaredVariable v |
      (
        v.getARead().asExpr() = call.getArgument(0).asExpr() or
        v.getARead().asExpr() = call.getArgument(0).asExpr().getAChild().(ReferenceExpr)
      ) and
      call.getTarget().hasQualifiedName(["flag", "flag.FlagSet"], ["StringVar", "TextVar"]) and
      (
        this = v.getARead()
        or
        this.asExpr() = v.getAReference()
      )
    )
    or
    exists(DataFlow::CallNode call |
      call.getTarget().hasQualifiedName(["flag", "flag.FlagSet"], "String") and
      this = call
    )
  }
}

class CobraCmdLineSourceFlags extends CmdLineFlowSource {
  CobraCmdLineSourceFlags() {
    // bind function arguments to variable and set the variable as cli source flow node
    exists(DataFlow::CallNode call, DataFlow::DeclaredVariable v |
      (
        v.getARead().asExpr() = call.getArgument(0).asExpr() or
        v.getARead().asExpr() = call.getArgument(0).asExpr().getAChild().(ReferenceExpr)
      ) and
      call.getTarget()
          .hasQualifiedName("github.com/spf13/pflag.FlagSet",
            [
              "StringVar", "StringVarP", "BytesBase64Var", "BytesBase64VarP", "BytesHexVar",
              "BytesHexVarP", "StringArrayVar", "StringArrayVarP", "StringSliceVar",
              "StringSliceVarP", "StringToStringVar", "StringToStringVarP"
            ]) and
      (
        this = v.getARead()
        or
        this.asExpr() = v.getAReference()
      )
    )
    or
    // set function return value as cli source flow node
    exists(DataFlow::CallNode call |
      call.getTarget()
          .hasQualifiedName("github.com/spf13/pflag.FlagSet",
            [
              "String", "BytesBase64", "BytesBase64P", "BytesHex", "BytesHexP", "StringArray",
              "StringArrayP", "StringSlice", "StringSliceP", "StringToString", "StringToStringP",
              "Arg", "Args", "GetString", "GetStringArray", "GetStrigSlice", "GetStringToString",
              "GetBytesHex", "GetBytesBase64", "GetBytesBase64"
            ]) and
      this = call
    )
    // TODO: there is a  `func (f *FlagSet) Lookup(name string) *Flag` which seems that need spf13/viper QL model to work
  }
}

private class OsCmdLineSource extends CmdLineFlowSource {
  OsCmdLineSource() { this = any(Variable c | c.hasQualifiedName("os", "Args")).getARead() }
}
