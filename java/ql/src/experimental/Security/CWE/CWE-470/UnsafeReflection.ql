/**
 * @name Use of externally-controlled input to select classes or code ('unsafe reflection')
 * @description Use external input with reflection function to select the class or code to
 *              be used, which brings serious security risks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-reflection
 * @tags security
 *       external/cwe/cwe-470
 */

import java
import DataFlow
import UnsafeReflectionLib
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.controlflow.Guards
import DataFlow::PathGraph

private predicate containsSanitizer(Guard g, Expr e, boolean branch) {
  g.(MethodAccess).getMethod().hasName("contains") and
  e = g.(MethodAccess).getArgument(0) and
  branch = true
}

private predicate equalsSanitizer(Guard g, Expr e, boolean branch) {
  g.(MethodAccess).getMethod().hasName("equals") and
  e = [g.(MethodAccess).getArgument(0), g.(MethodAccess).getQualifier()] and
  branch = true
}

class UnsafeReflectionConfig extends TaintTracking::Configuration {
  UnsafeReflectionConfig() { this = "UnsafeReflectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeReflectionSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Argument -> return of Class.forName, ClassLoader.loadClass
    exists(ReflectiveClassIdentifierMethodAccess rcimac |
      rcimac.getArgument(0) = pred.asExpr() and rcimac = succ.asExpr()
    )
    or
    // Qualifier -> return of Class.getDeclaredConstructors/Methods and similar
    exists(MethodAccess ma |
      (
        ma instanceof ReflectiveConstructorsAccess or
        ma instanceof ReflectiveMethodsAccess
      ) and
      ma.getQualifier() = pred.asExpr() and
      ma = succ.asExpr()
    )
    or
    // Qualifier -> return of Object.getClass
    exists(MethodAccess ma |
      ma.getMethod().hasName("getClass") and
      ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "Object") and
      ma.getQualifier() = pred.asExpr() and
      ma = succ.asExpr()
    )
    or
    // Argument -> return of methods that look like Class.forName
    looksLikeResolveClassStep(pred, succ)
    or
    // Argument -> return of methods that look like `Object getInstance(Class c)`
    looksLikeInstantiateClassStep(pred, succ)
    or
    // Qualifier -> return of Constructor.newInstance, Class.newInstance
    exists(NewInstance ni |
      ni.getQualifier() = pred.asExpr() and
      ni = succ.asExpr()
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<containsSanitizer/3>::getABarrierNode() or
    node = DataFlow::BarrierGuard<equalsSanitizer/3>::getABarrierNode()
  }
}

private Expr getAMethodArgument(MethodAccess reflectiveCall) {
  result = reflectiveCall.(NewInstance).getAnArgument()
  or
  result = reflectiveCall.(MethodInvokeCall).getAnArgument()
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, UnsafeReflectionConfig conf,
  MethodAccess reflectiveCall
where
  conf.hasFlowPath(source, sink) and
  sink.getNode().asExpr() = reflectiveCall.getQualifier() and
  conf.hasFlowToExpr(getAMethodArgument(reflectiveCall))
select sink.getNode(), source, sink, "Unsafe reflection of $@.", source.getNode(), "user input"
