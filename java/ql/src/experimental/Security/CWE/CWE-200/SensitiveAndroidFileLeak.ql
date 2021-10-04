/**
 * @name Leaking sensitive Android file
 * @description Getting file intent from user input without path validation could leak arbitrary
 *              Android configuration file and sensitive user data.
 * @kind path-problem
 * @id java/sensitive-android-file-leak
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import semmle.code.java.controlflow.Guards
import AndroidFileIntentSink
import AndroidFileIntentSource
import DataFlow::PathGraph

private class StartsWithSanitizer extends DataFlow::BarrierGuard {
  StartsWithSanitizer() { this.(MethodAccess).getMethod().hasName("startsWith") }

  override predicate checks(Expr e, boolean branch) {
    e =
      [
        this.(MethodAccess).getQualifier(),
        this.(MethodAccess).getQualifier().(MethodAccess).getQualifier()
      ] and
    branch = false
  }
}

class AndroidFileLeakConfig extends TaintTracking::Configuration {
  AndroidFileLeakConfig() { this = "AndroidFileLeakConfig" }

  /**
   * Holds if `src` is a read of some Intent-typed method argument guarded by a check like
   * `requestCode == REQUEST_CODE__SELECT_CONTENT_FROM_APPS`, where `requestCode` is the first
   * argument to `Activity.onActivityResult`.
   */
  override predicate isSource(DataFlow::Node src) {
    exists(
      AndroidActivityResultInput ai, AndroidFileIntentInput fi, ConditionBlock cb,
      VarAccess intentVar
    |
      cb.getCondition().getAChildExpr().(CompileTimeConstantExpr).getIntValue() =
        fi.getRequestCode() and
      cb.getCondition().getAChildExpr() = ai.getRequestCodeVar() and
      intentVar.getType() instanceof TypeIntent and
      cb.getBasicBlock() = intentVar.(Argument).getAnEnclosingStmt() and
      src.asExpr() = intentVar
    )
  }

  /** Holds if it is a sink of file access in Android. */
  override predicate isSink(DataFlow::Node sink) { sink instanceof AndroidFileSink }

  override predicate isAdditionalTaintStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(MethodAccess aema, AsyncTaskRunInBackgroundMethod arm |
      // fileAsyncTask.execute(params) will invoke doInBackground(params) of FileAsyncTask
      aema.getQualifier().getType() = arm.getDeclaringType() and
      aema.getMethod() instanceof ExecuteAsyncTaskMethod and
      prev.asExpr() = aema.getArgument(aema.getMethod().(ExecuteAsyncTaskMethod).getParamIndex()) and
      succ.asParameter() = arm.getParameter(0)
    )
    or
    exists(MethodAccess csma, ServiceOnStartCommandMethod ssm, ClassInstanceExpr ce |
      csma.getMethod() instanceof ContextStartServiceMethod and
      ce.getConstructedType() instanceof TypeIntent and // Intent intent = new Intent(context, FileUploader.class);
      ce.getArgument(1).(TypeLiteral).getReferencedType() = ssm.getDeclaringType() and
      DataFlow::localExprFlow(ce, csma.getArgument(0)) and // context.startService(intent);
      prev.asExpr() = csma.getArgument(0) and
      succ.asParameter() = ssm.getParameter(0) // public int onStartCommand(Intent intent, int flags, int startId) {...} in FileUploader
    )
  }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof StartsWithSanitizer
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, AndroidFileLeakConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Leaking arbitrary Android file from $@.", source.getNode(),
  "this user input"
