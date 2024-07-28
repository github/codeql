/**
 * @name Use of externally-controlled input to select classes or code ('unsafe reflection')
 * @description Use external input with reflection function to select the class or code to
 *              be used, which brings serious security risks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-reflection
 * @tags security
 *       experimental
 *       external/cwe/cwe-470
 */

import java
import DataFlow
import UnsafeReflectionLib
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.controlflow.Guards
import UnsafeReflectionFlow::PathGraph

private predicate containsSanitizer(Guard g, Expr e, boolean branch) {
  g.(MethodCall).getMethod().hasName("contains") and
  e = g.(MethodCall).getArgument(0) and
  branch = true
}

private predicate equalsSanitizer(Guard g, Expr e, boolean branch) {
  g.(MethodCall).getMethod().hasName("equals") and
  e = [g.(MethodCall).getArgument(0), g.(MethodCall).getQualifier()] and
  branch = true
}

module UnsafeReflectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeReflectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // Argument -> return of Class.forName, ClassLoader.loadClass
    exists(ReflectiveClassIdentifierMethodCall rcimac |
      rcimac.getArgument(0) = pred.asExpr() and rcimac = succ.asExpr()
    )
    or
    // Qualifier -> return of Class.getDeclaredConstructors/Methods and similar
    exists(MethodCall ma |
      (
        ma instanceof ReflectiveGetConstructorsCall or
        ma instanceof ReflectiveGetMethodsCall
      ) and
      ma.getQualifier() = pred.asExpr() and
      ma = succ.asExpr()
    )
    or
    // Qualifier -> return of Object.getClass
    exists(MethodCall ma |
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

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::BarrierGuard<containsSanitizer/3>::getABarrierNode() or
    node = DataFlow::BarrierGuard<equalsSanitizer/3>::getABarrierNode()
  }
}

module UnsafeReflectionFlow = TaintTracking::Global<UnsafeReflectionConfig>;

private Expr getAMethodArgument(MethodCall reflectiveCall) {
  result = reflectiveCall.(NewInstance).getAnArgument()
  or
  result = reflectiveCall.(MethodInvokeCall).getAnArgument()
}

from
  UnsafeReflectionFlow::PathNode source, UnsafeReflectionFlow::PathNode sink,
  MethodCall reflectiveCall
where
  UnsafeReflectionFlow::flowPath(source, sink) and
  sink.getNode().asExpr() = reflectiveCall.getQualifier() and
  UnsafeReflectionFlow::flowToExpr(getAMethodArgument(reflectiveCall))
select sink.getNode(), source, sink, "Unsafe reflection of $@.", source.getNode(), "user input"
