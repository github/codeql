/**
 * @name find PendingIntent vulners
 * @description Constructing a PendingIntent with implicit Intent and without PendingIntent.FLAG_IMMUTABLE flag could lead to leaking sensitive data or privilege escalation.
 * @kind path-problem
 * @id java/find-PendingIntent-Vulner
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-285
 */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

// import semmle.code.java.Variable
class MAsetIntentDest extends MethodAccess {
  MAsetIntentDest() {
    this.getQualifier().getType() instanceof TypeIntent and
    (
      this.getMethod().getName() = "setClassName" or
      this.getMethod().getName() = "setClass" or
      this.getMethod().getName() = "setPackage" or
      this.getMethod().getName() = "setComponent" or
      this.getMethod().getName() = "makeMainActivity" or
      this.getMethod().getName() = "makeRestartActivityTask"
    )
  }
}

class ImplicitIntentConstructor extends Call {
  ImplicitIntentConstructor() {
    this.(ConstructorCall)
        .getConstructedType()
        .getSourceDeclaration()
        .hasQualifiedName("android.content", "Intent") and
    (
      this.getNumArgument() <= 1
      or
      this.getNumArgument() = 2 and this.getArgument(0).getType() instanceof TypeString
    )
  }
}

private class ImplicitIntentFlowConfig extends TaintTracking::Configuration {
  ImplicitIntentFlowConfig() { this = "ImplicitIntent::ImplicitIntentFlowConfig" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() = any(ImplicitIntentConstructor implictIntent)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getQualifier().getType().toString() = "PendingIntent" and
      (
        ma.getMethod().getName() = "getActivity" or
        ma.getMethod().getName() = "getBroadcast" or
        ma.getMethod().getName() = "getService" or
        ma.getMethod().getName() = "getActivities" or
        ma.getMethod().getName() = "getForegroundService"
      ) and
      sink.asExpr() = ma.getArgument(2)
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asExpr() = any(MAsetIntentDest ma).getQualifier()
  }
}

private class PendingFlagFlowConfig extends TaintTracking::Configuration {
  PendingFlagFlowConfig() { this = "ImplicitIntent::PendingFlagFlowConfig1" }

  override predicate isSource(DataFlow::Node src) {
    exists(Variable_Non_Flag_IMMUTABLE var_non_flg_immute |
      src.asExpr() = var_non_flg_immute.getSource()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getQualifier().getType().toString() = "PendingIntent" and
      (
        ma.getMethod().getName() = "getActivity" or
        ma.getMethod().getName() = "getBroadcast" or
        ma.getMethod().getName() = "getService" or
        ma.getMethod().getName() = "getActivities" or
        ma.getMethod().getName() = "getForegroundService"
      ) and
      sink.asExpr() = ma.getArgument(3)
    )
  }
}

predicate has_sub_flag_immutable(Expr expr) {
  expr.getPrimaryQlClasses() = "OrBitwiseExpr" and
  (
    expr.getAChildExpr().toString() = "PendingIntent.FLAG_IMMUTABLE"
    or
    expr.getAChildExpr().getPrimaryQlClasses() = "IntegerLiteral" and
    expr.getAChildExpr().(IntegerLiteral).getIntValue().bitAnd(67108864) != 0
  )
}

class Variable_Non_Flag_IMMUTABLE extends VariableAssign {
  Variable_Non_Flag_IMMUTABLE() {
    exists(VariableAssign va |
      (
        va.getType() instanceof IntegralType and
        (
          va.getSource().getPrimaryQlClasses() = "IntegerLiteral" and
          va.getSource().(IntegerLiteral).getIntValue().bitAnd(67108864) = 0
          or
          va.getSource().getPrimaryQlClasses() = "VarAccess" and
          va.getSource().toString().indexOf("PendingIntent.") != -1 and
          va.getSource().toString() != "PendingIntent.FLAG_IMMUTABLE"
          or
          va.getSource().getPrimaryQlClasses() = "OrBitwiseExpr" and
          not has_sub_flag_immutable(va.getSource())
        ) and
        this = va
      )
    )
  }
}

predicate ma_arg_is_non_immutable(MethodAccess ma, int arg_idx) {
  ma.getArgument(arg_idx).getPrimaryQlClasses() = "IntegerLiteral" and
  ma.getArgument(arg_idx).(IntegerLiteral).getIntValue().bitAnd(67108864) = 0
  or
  ma.getArgument(arg_idx).getPrimaryQlClasses() = "VarAccess" and
  ma.getArgument(arg_idx).toString().indexOf("PendingIntent.") != -1 and
  ma.getArgument(arg_idx).toString() != "PendingIntent.FLAG_IMMUTABLE"
  or
  ma.getArgument(arg_idx).getPrimaryQlClasses() = "OrBitwiseExpr" and
  not has_sub_flag_immutable(ma.getArgument(arg_idx))
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, DataFlow::PathNode source2,
  DataFlow::PathNode sink2, ImplicitIntentFlowConfig cc, PendingFlagFlowConfig pf
where
  cc.hasFlowPath(source, sink) and
  (
    pf.hasFlowPath(source2, sink2) and
    sink.getNode().asExpr().getParent() = sink2.getNode().asExpr().getParent()
    or
    ma_arg_is_non_immutable(sink.getNode().asExpr().getParent().(MethodAccess), 3)
  )
select sink.getNode(), source, sink, "$@ implicit intent flows to here", source.getNode(),
  sink.getNode().asExpr().getParent().toString()

