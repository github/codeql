/**
 * @name Useless upcast
 * @description Upcasting a derived type to its base type is usually unnecessary.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/useless-upcast
 * @tags maintainability
 *       language-features
 *       external/cwe/cwe-561
 */

import java

predicate usefulUpcast(CastExpr e) {
  // Upcasts that may be performed to affect resolution of methods or constructors.
  exists(Call c, int i, Callable target |
    c.getArgument(i) = e and
    target = c.getCallee() and
    // An upcast to the type of the corresponding parameter.
    e.getType() = target.getParameterType(i)
  |
    // There is an overloaded method/constructor in the class that we might be trying to avoid.
    exists(Callable other |
      other.getName() = target.getName() and
      other.getSourceDeclaration() != target.getSourceDeclaration()
    |
      c.(MethodAccess).getReceiverType().(RefType).inherits(other.(Method)) or
      other = target.(Constructor).getDeclaringType().getAConstructor()
    )
  )
  or
  // Upcasts of a varargs argument.
  exists(Call c, int iArg, int iParam | c.getArgument(iArg) = e |
    c.getCallee().getParameter(iParam).isVarargs() and iArg >= iParam
  )
  or
  // Upcasts that are performed on an operand of a ternary expression.
  exists(ConditionalExpr ce | e = ce.getTrueExpr() or e = ce.getFalseExpr())
  or
  // Upcasts to raw types.
  e.getType() instanceof RawType
  or
  e.getType().(Array).getElementType() instanceof RawType
  or
  // Upcasts that are performed to affect field, private method, or static method resolution.
  exists(FieldAccess fa | e = fa.getQualifier() |
    not e.getExpr().getType().(RefType).inherits(fa.getField())
  )
  or
  exists(MethodAccess ma, Method m |
    e = ma.getQualifier() and
    m = ma.getMethod() and
    (m.isStatic() or m.isPrivate())
  |
    not e.getExpr().getType().(RefType).inherits(m)
  )
}

from Expr e, RefType src, RefType dest
where
  exists(CastExpr cse | cse = e |
    exists(cse.getLocation()) and
    src = cse.getExpr().getType() and
    dest = cse.getType()
  ) and
  dest = src.getASupertype+() and
  not usefulUpcast(e)
select e, "There is no need to upcast from $@ to $@ - the conversion can be done implicitly.", src,
  src.getName(), dest, dest.getName()
