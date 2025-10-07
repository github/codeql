deprecated module;

import java
import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.security.Sanitizers

module ExecCmdFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(CompileTimeConstantExpr).getStringValue() instanceof UnSafeExecutable
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall call |
      call.getMethod() instanceof RuntimeExecMethod and
      sink.asExpr() = call.getArgument(0) and
      sink.asExpr().getType() instanceof Array
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof AssignToNonZeroIndex or
    node instanceof ArrayInitAtNonZeroIndex or
    node instanceof StreamConcatAtNonZeroIndex or
    node instanceof SimpleTypeSanitizer
  }
}

/** Tracks flow of unvalidated user input that is used in Runtime.Exec */
module ExecCmdFlow = TaintTracking::Global<ExecCmdFlowConfig>;

abstract class Source extends DataFlow::Node { }

module ExecUserFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall call |
      call.getMethod() instanceof RuntimeExecMethod and
      sink.asExpr() = call.getArgument(_) and
      sink.asExpr().getType() instanceof Array
    )
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof SimpleTypeSanitizer }
}

/** Tracks flow of unvalidated user input that is used in Runtime.Exec */
module ExecUserFlow = TaintTracking::Global<ExecUserFlowConfig>;

// array[3] = node
class AssignToNonZeroIndex extends DataFlow::Node {
  AssignToNonZeroIndex() {
    exists(AssignExpr assign, ArrayAccess access |
      assign.getDest() = access and
      access.getIndexExpr().(IntegerLiteral).getValue().toInt() != 0 and
      assign.getSource() = this.asExpr()
    )
  }
}

// String[] array = {"a", "b, "c"};
class ArrayInitAtNonZeroIndex extends DataFlow::Node {
  ArrayInitAtNonZeroIndex() {
    exists(ArrayInit init, int index |
      init.getInit(index) = this.asExpr() and
      index != 0
    )
  }
}

// Stream.concat(Arrays.stream(array_1), Arrays.stream(array_2))
class StreamConcatAtNonZeroIndex extends DataFlow::Node {
  StreamConcatAtNonZeroIndex() {
    exists(MethodCall call, int index |
      call.getMethod().hasQualifiedName("java.util.stream", "Stream", "concat") and
      call.getArgument(index) = this.asExpr() and
      index != 0
    )
  }
}

// list of executables that execute their arguments
// TODO: extend with data extensions
class UnSafeExecutable extends string {
  bindingset[this]
  UnSafeExecutable() {
    this.regexpMatch("^(|.*/)([a-z]*sh|javac?|python.*|perl|[Pp]ower[Ss]hell|php|node|deno|bun|ruby|osascript|cmd|Rscript|groovy)(\\.exe)?$") and
    not this = "netsh.exe"
  }
}

predicate callIsTaintedByUserInputAndDangerousCommand(
  ExecUserFlow::PathNode source, ExecUserFlow::PathNode sink, DataFlow::Node sourceCmd,
  DataFlow::Node sinkCmd
) {
  exists(MethodCall call |
    call.getMethod() instanceof RuntimeExecMethod and
    // this is a command-accepting call to exec, e.g. rt.exec(new String[]{"/bin/sh", ...})
    ExecCmdFlow::flow(sourceCmd, sinkCmd) and
    sinkCmd.asExpr() = call.getArgument(0) and
    // it is tainted by untrusted user input
    ExecUserFlow::flowPath(source, sink) and
    sink.getNode().asExpr() = call.getArgument(0)
  )
}
