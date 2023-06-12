import java
import semmle.code.java.dataflow.DataFlow

abstract class CLIFlowSource extends DataFlow::Node { }

Field childFiled(RefType rt) {
  not result.getType() instanceof PrimitiveType and
  not result.getType() instanceof BoxedType and
  (
    result.getDeclaringType() = rt or
    result.getDeclaringType() = childFiled(result.getDeclaringType()).getType()
  )
}

module CommonsCLI {
  class TypeCommandLine extends RefType {
    TypeCommandLine() {
      this.getAStrictAncestor*().hasQualifiedName("org.apache.commons.cli", "CommandLine")
    }
  }

  class TypeOption extends RefType {
    TypeOption() { this.getAStrictAncestor*().hasQualifiedName("org.apache.commons.cli", "Option") }
  }

  class OptionValue extends CLIFlowSource {
    OptionValue() {
      exists(MethodAccess ma |
        ma.getCallee().getDeclaringType() instanceof TypeOption and
        ma.getCallee().hasName(["getValue", "getValues", "getValuesList"]) and
        this.asExpr() = ma
      )
    }
  }

  class CommandLine extends CLIFlowSource {
    CommandLine() {
      exists(MethodAccess ma |
        ma.getCallee().getDeclaringType() instanceof TypeCommandLine and
        ma.getCallee()
            .hasName(["getArgs", "getArgList", "getOptionValue", "getOptionValues", "getArgs"]) and
        this.asExpr() = ma
      )
    }
  }
}

module Args4j {
  class TypeCmdLineParser extends RefType {
    TypeCmdLineParser() {
      // classes of ArgumentParser interface like `SubParser`
      this.getAStrictAncestor*().hasQualifiedName("org.kohsuke.args4j", "CmdLineParser")
    }
  }

  class CommandLine extends CLIFlowSource {
    CommandLine() {
      exists(Call c, ClassInstanceExpr cie, Field f |
        c.getCallee().getDeclaringType() instanceof TypeCmdLineParser and
        DataFlow::localExprFlow(cie, c.getArgument(0)) and
        f.getDeclaringType() = cie.getType() and
        (
          this.asExpr() = f.getAnAccess()
          or
          this.asExpr() = childFiled(f.getType()).getAnAccess()
        )
      )
    }
  }
}

module Jcommander {
  class TypeBuilder extends RefType {
    TypeBuilder() {
      // classes of ArgumentParser interface like `SubParser`
      this.getAStrictAncestor*().hasQualifiedName("com.beust.jcommander", "JCommander$Builder")
    }
  }

  class CommandLine extends CLIFlowSource {
    CommandLine() {
      exists(Call c, ClassInstanceExpr cie, Field f |
        c.getCallee().getDeclaringType() instanceof TypeBuilder and
        DataFlow::localExprFlow(cie, c.getArgument(0)) and
        f.getDeclaringType() = cie.getType() and
        (
          this.asExpr() = f.getAnAccess()
          or
          this.asExpr() = childFiled(f.getType()).getAnAccess()
        )
      )
    }
  }
}

module Picocli {
  class TypeCommandLine extends RefType {
    TypeCommandLine() {
      // classes of ArgumentParser interface like `SubParser`
      this.getAStrictAncestor*().hasQualifiedName("picocli", "CommandLine")
    }
  }

  class GetCallResult extends CLIFlowSource {
    GetCallResult() {
      exists(MethodAccess ma |
        ma.getCallee().getDeclaringType() instanceof TypeCommandLine and
        ma.getCallee().hasName("getExecutionResult") and
        this.asExpr() = ma
      )
    }
  }

  class Execute extends CLIFlowSource {
    Execute() {
      exists(MethodAccess ma, ClassInstanceExpr cie, Field f |
        ma.getCallee().getDeclaringType() instanceof TypeCommandLine and
        ma.getCallee().hasName("populateCommand") and
        DataFlow::localExprFlow(cie, ma.getArgument(0)) and
        f.getDeclaringType() = cie.getType() and
        (
          this.asExpr() = f.getAnAccess()
          or
          this.asExpr() = childFiled(f.getType()).getAnAccess()
        )
      )
    }
  }

  class CommandLine extends CLIFlowSource {
    CommandLine() {
      exists(Call c, ClassInstanceExpr cie, Field f |
        c.getCallee().getDeclaringType() instanceof TypeCommandLine and
        DataFlow::localExprFlow(cie, c.getArgument(0)) and
        f.getDeclaringType() = cie.getType() and
        (
          this.asExpr() = f.getAnAccess()
          or
          this.asExpr() = childFiled(f.getType()).getAnAccess()
        )
      )
    }
  }
}

module ArgParse4j {
  class TypeArgumentParser extends RefType {
    TypeArgumentParser() {
      // classes of ArgumentParser interface like `SubParser`
      this.getAStrictAncestor*()
          .hasQualifiedName("net.sourceforge.argparse4j.inf", "ArgumentParser")
    }
  }

  class TypeNamespace extends RefType {
    TypeNamespace() {
      this.getAStrictAncestor*().hasQualifiedName("net.sourceforge.argparse4j.inf", "Namespace")
    }
  }

  class ParseArgsReturnValue extends CLIFlowSource {
    ParseArgsReturnValue() {
      exists(MethodAccess ma |
        ma.getReceiverType() instanceof TypeNamespace and
        ma.getCallee().hasName(["getString", "getList", "toString", "getByte", "get", "getAttrs"]) and
        this.asExpr() = ma
      )
    }
  }

  class ParseArgsSecondArg extends CLIFlowSource {
    ParseArgsSecondArg() {
      exists(MethodAccess ma, ClassInstanceExpr cie, Field f |
        ma.getReceiverType() instanceof TypeArgumentParser and
        ma.getCallee().hasName(["parseArgs"]) and
        ma.getNumArgument() = 2 and
        DataFlow::localExprFlow(cie, ma.getArgument(1)) and
        f.getDeclaringType() = cie.getType() and
        (
          this.asExpr() = f.getAnAccess()
          or
          this.asExpr() = childFiled(f.getType()).getAnAccess()
        )
      )
    }
  }
}
