/**
 * @name Leaking sensitive Android file
 * @description Getting file intent from user input without path validation could leak arbitrary
 *              Android configuration file and sensitive user data.
 * @kind path-problem
 * @id java/sensitive-android-file-leak
 * @tags security
 *       external/cwe/cwe-200
 */

import java
import AndroidFileIntentSink
import AndroidFileIntentSource
import DataFlow2::PathGraph
import semmle.code.java.dataflow.TaintTracking2

private class StartsWithSanitizer extends DataFlow2::BarrierGuard {
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

class AndroidFileLeakConfig extends TaintTracking2::Configuration {
  AndroidFileLeakConfig() { this = "AndroidFileLeakConfig" }

  /** Holds if it is an access to file intent result. */
  override predicate isSource(DataFlow2::Node src) {
    exists(
      AndroidActivityResultInput ai, AndroidFileIntentInput fi, IfStmt ifs, VarAccess intentVar // if (requestCode == REQUEST_CODE__SELECT_CONTENT_FROM_APPS)
    |
      ifs.getCondition().getAChildExpr().getAChildExpr().(CompileTimeConstantExpr).getIntValue() =
        fi.getRequestCode() and
      ifs.getCondition().getAChildExpr().getAChildExpr() = ai.getRequestCodeVar() and
      intentVar.getType() instanceof TypeIntent and
      intentVar.(Argument).getAnEnclosingStmt() = ifs.getThen() and
      src.asExpr() = intentVar
    )
  }

  /** Holds if it is a sink of file access in Android. */
  override predicate isSink(DataFlow2::Node sink) { sink instanceof AndroidFileSink }

  override predicate isAdditionalTaintStep(DataFlow2::Node prev, DataFlow2::Node succ) {
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
      DataFlow2::localExprFlow(ce, csma.getArgument(0)) and // context.startService(intent);
      prev.asExpr() = csma.getArgument(0) and
      succ.asParameter() = ssm.getParameter(0) // public int onStartCommand(Intent intent, int flags, int startId) {...} in FileUploader
    )
  }

  override predicate isSanitizerGuard(DataFlow2::BarrierGuard guard) {
    guard instanceof StartsWithSanitizer
  }
}

from DataFlow2::PathNode source, DataFlow2::PathNode sink, AndroidFileLeakConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Leaking arbitrary Android file from $@.", source.getNode(),
  "this user input"
