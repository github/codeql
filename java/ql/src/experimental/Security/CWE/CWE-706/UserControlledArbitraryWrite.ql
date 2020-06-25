/**
 * @name User-controlled content written on user-controlled path expression.
 * @description Writing user-controlled data to an user-controlled paths can allow an attacker to write arbitrary files.
 * @kind path-problem
 * @problem.severity error
 * @precision medium
 * @id java/tainted-file-write
 * @tags security
 *       external/cwe/cwe-706
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.security.XSS
import DataFlow2::PathGraph
import PathsCommon

/** The class `org.json.JSONObject`. */
class TypeJsonObject extends Class {
  TypeJsonObject() { this.hasQualifiedName("org.json", "JSONObject") }
}

/** The class `org.json.JSONArray`. */
class TypeJsonArray extends Class {
  TypeJsonArray() { this.hasQualifiedName("org.json", "JSONArray") }
}

/** The class `ai.susi.server.ServiceResponse`. */
class TypeServiceResponse extends Class {
  TypeServiceResponse() { this.hasQualifiedName("ai.susi.server", "ServiceResponse") }
}

class ServiceResponseSink extends DataFlow::ExprNode {
  ServiceResponseSink() {
    exists(ConstructorCall call |
      call.getConstructedType() instanceof TypeServiceResponse and
      this.getExpr() = call.getAnArgument()
    )
    or
    exists(MethodAccess call |
      call.getType() instanceof TypeServiceResponse and
      this.getExpr() = call.getAnArgument()
    )
  }
}

predicate deletesFile(DataFlow::ExprNode node) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFile and
    call.getMethod().getName().matches("delete%") and
    node.getExpr() = call.getQualifier()
  )
}

predicate deletesPath(DataFlow::ExprNode node) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFiles and
    call.getMethod().getName().matches("delete%") and
    node.getExpr() = call.getArgument(0)
  )
}

predicate renamesFile(DataFlow::ExprNode node) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFile and
    call.getMethod().getName().matches("renameTo%") and
    (
      node.getExpr() = call.getQualifier()
      or
      node.getExpr() = call.getArgument(0)
    )
  )
}

predicate renamesPath(DataFlow::ExprNode node) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFiles and
    call.getMethod().getName().matches("move%") and
    (
      node.getExpr() = call.getArgument(0)
      or
      node.getExpr() = call.getArgument(1)
    )
  )
}

class SensitiveFileOperationSink extends DataFlow::ExprNode {
  SensitiveFileOperationSink() {
    deletesFile(this)
    or
    deletesPath(this)
    or
    renamesFile(this)
    or
    renamesPath(this)
  }
}

/** Holds if `node1` is used in the creation of `node2` and not guarded. */
predicate usedInPathCreation(DataFlow::Node node1, DataFlow::Node node2) {
  exists(Expr e | e = node1.asExpr() |
    e = node2.asExpr().(PathCreation).getInput() and not guarded(e)
  )
}

predicate putsValueIntoJsonObject(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeJsonObject and
    call.getMethod().getName() = ["put", "putOnce", "putOpt"] and
    call.getQualifier() = node2.asExpr() and
    call.getArgument(1) = node1.asExpr()
  )
}

predicate putsValueIntoJsonArray(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeJsonArray and
    call.getMethod().getName() = "put" and
    call.getQualifier() = node2.asExpr() and
    (
      call.getArgument(1) = node1.asExpr() and call.getNumArgument() = 2
      or
      call.getArgument(0) = node1.asExpr() and call.getNumArgument() = 1
    )
  )
}

class ContainsDotDotSanitizer extends DataFlow::BarrierGuard {
  ContainsDotDotSanitizer() {
    this.(MethodAccess).getMethod().hasName("contains") and
    this.(MethodAccess).getAnArgument().(StringLiteral).getValue() = ".."
  }

  override predicate checks(Expr e, boolean branch) {
    e = this.(MethodAccess).getQualifier() and branch = false
  }
}

class TaintedPathConfig extends TaintTracking::Configuration {
  TaintedPathConfig() { this = "TaintedPathConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof TaintedPathSink }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Type t | t = node.getType() | t instanceof BoxedType or t instanceof PrimitiveType)
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof ContainsDotDotSanitizer
    // TODO add guards from zipslip.ql
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    usedInPathCreation(node1, node2)
  }
}

private class TaintedPathSink extends DataFlow::Node {
  Expr path;
  Expr taintedInput;

  TaintedPathSink() {
    exists(Expr e, PathCreation p | e = asExpr() |
      e = p.getInput() and not guarded(e) and path = p and taintedInput = e
    )
  }

  Expr getTaintedFile() { result = path }

  Expr getTaintedFileInput() { result = taintedInput }
}

class InformationLeakConfig extends TaintTracking2::Configuration {
  InformationLeakConfig() { this = "InformationLeakConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof TaintedPathSink
    //exists(TaintedPathSink s | s.getTaintedFile() = source.asExpr())
    //source instanceof TaintedPathSink
    //any() //source.asExpr().getType() instanceof TypePath //any()//source instanceof RemoteFlowSource
  } //source.asExpr().getFile().getBaseName().matches("GetSkillJsonService.java")}//any()}//source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof RemoteFlowSink
    or
    //sink instanceof ServiceResponseSink or
    sink instanceof XssSink //or
    // sink instanceof SensitiveFileOperationSink
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof NumericType or node.getType() instanceof BooleanType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    usedInPathCreation(node1, node2)
    /*
     * or
     *         putsValueIntoJsonObject(node1, node2)
     *         or
     *         putsValueIntoJsonArray(node1, node2)
     */

  }
}

from
  DataFlow::PathNode remoteSource, DataFlow::PathNode taintedFile, DataFlow2::PathNode taintedFile2,
  DataFlow2::PathNode infoLeak, InformationLeakConfig infoLeakConf,
  TaintedPathConfig taintedPathConf //, PathCreation p
where
  taintedPathConf.hasFlowPath(remoteSource, taintedFile) and
  taintedFile.getNode() = taintedFile2.getNode() and
  infoLeakConf.hasFlowPath(taintedFile2, infoLeak)
select infoLeak.getNode(), taintedFile2, infoLeak,
  "Potential disclosure of arbitrary file due to $@ derived from $@.",
  taintedFile2.getNode().(TaintedPathSink).getTaintedFileInput(), "user-provided value",
  remoteSource.getNode(), "a remote source"
