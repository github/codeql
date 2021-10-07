/**
 * @name Leaking sensitive Android file
 * @description Using a path specified in an Android Intent without validation could leak arbitrary
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
   * Holds if `src` is a read of some Intent-typed variable guarded by a check like
   * `requestCode == someCode`, where `requestCode` is the first
   * argument to `Activity.onActivityResult` and `someCode` is
   * any request code used in a call to `startActivityForResult(intent, someCode)`.
   */
  override predicate isSource(DataFlow::Node src) {
    exists(
      OnActivityForResultMethod oafr, ConditionBlock cb, CompileTimeConstantExpr cc,
      VarAccess intentVar
    |
      cb.getCondition().(EQExpr).hasOperands(oafr.getParameter(0).getAnAccess(), cc) and
      cc.getIntValue() = any(AndroidFileIntentInput fi).getRequestCode() and
      intentVar.getType() instanceof TypeIntent and
      cb.controls(intentVar.getBasicBlock(), true) and
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
      // An intent passed to startService will later be passed to the onStartCommand event of the corresponding service
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
