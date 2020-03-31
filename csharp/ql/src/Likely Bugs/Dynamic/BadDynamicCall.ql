/**
 * @name Bad dynamic call
 * @description The type of the target of a dynamic invocation expression must have a method or operator with the appropriate signature, or an exception will be thrown.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/invalid-dynamic-call
 * @tags reliability
 *       correctness
 *       logic
 *       external/cwe/cwe-628
 */

import csharp
import semmle.code.csharp.dispatch.Dispatch

abstract class BadDynamicCall extends DynamicExpr {
  abstract predicate isBad(Variable v, ValueOrRefType pt, Expr pts, string message, string target);

  abstract AssignableRead getARelevantVariableAccess(int i);

  Type possibleBadTypeForRelevantSource(Variable v, int i, Expr source) {
    exists(Type t | t = possibleTypeForRelevantSource(v, i, source) |
      // If the source can have the type of an interface or an abstract class,
      // then all possible sub types are, in principle, possible
      t instanceof Interface and result.isImplicitlyConvertibleTo(t)
      or
      t.(Class).isAbstract() and result.isImplicitlyConvertibleTo(t)
      or
      result = t
    ) and
    not result instanceof Interface and
    not result.(Class).isAbstract() and
    not result instanceof NullType and
    not result instanceof DynamicType
  }

  private Type possibleTypeForRelevantSource(Variable v, int i, Expr source) {
    exists(AssignableRead read, Ssa::Definition ssaDef, Ssa::ExplicitDefinition ultimateSsaDef |
      read = getARelevantVariableAccess(i) and
      v = read.getTarget() and
      result = source.getType() and
      read = ssaDef.getARead() and
      ultimateSsaDef = ssaDef.getAnUltimateDefinition()
    |
      ultimateSsaDef.getADefinition() =
        any(AssignableDefinition def | source = def.getSource().stripImplicitCasts())
      or
      ultimateSsaDef.getADefinition() =
        any(AssignableDefinitions::ImplicitParameterDefinition p |
          source = p.getParameter().getAnAssignedValue().stripImplicitCasts()
        )
    )
  }
}

class BadDynamicMethodCall extends BadDynamicCall, DynamicMethodCall {
  override AssignableRead getARelevantVariableAccess(int i) { result = getQualifier() and i = -1 }

  override predicate isBad(Variable v, ValueOrRefType pt, Expr pts, string message, string target) {
    pt = possibleBadTypeForRelevantSource(v, -1, pts) and
    not exists(Method m | m = getARuntimeTarget() |
      pt.isImplicitlyConvertibleTo(m.getDeclaringType())
    ) and
    message =
      "The $@ of this dynamic method invocation can obtain (from $@) type $@, which does not have a method '"
        + getLateBoundTargetName() + "' with the appropriate signature." and
    target = "target"
  }
}

class BadDynamicOperatorCall extends BadDynamicCall, DynamicOperatorCall {
  override AssignableRead getARelevantVariableAccess(int i) { result = getRuntimeArgument(i) }

  override predicate isBad(Variable v, ValueOrRefType pt, Expr pts, string message, string target) {
    exists(int i |
      pt = possibleBadTypeForRelevantSource(v, i, pts) and
      not pt.containsTypeParameters() and
      not exists(Operator o, Type paramType | paramType = getADynamicParameterType(o, i) |
        pt.isImplicitlyConvertibleTo(paramType)
        or
        // If either the argument type or the parameter type contains type parameters,
        // then assume they may match
        paramType.containsTypeParameters()
      ) and
      exists(string number |
        number = "first" and i = 0
        or
        number = "second" and i = 1
      |
        target = number + " argument"
      )
    ) and
    message =
      "The $@ of this dynamic operator can obtain (from $@) type $@, which does not match an operator '"
        + getLateBoundTargetName() + "' with the appropriate signature."
  }

  private Type getADynamicParameterType(Operator o, int i) {
    o = getARuntimeTarget() and
    result = o.getParameter(i).getType()
  }
}

from BadDynamicCall call, Variable v, ValueOrRefType pt, Expr pts, string message, string target
where call.isBad(v, pt, pts, message, target)
select call, message, v, target, pts, "here", pt, pt.getName()
