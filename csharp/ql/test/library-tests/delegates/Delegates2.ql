/**
 * @name Test for delegates
 */

import csharp

from DelegateType d
where
  d.hasQualifiedName("Delegates.FooDelegate") and
  d.getReturnType() instanceof DoubleType and
  d.getParameter(0).hasName("param") and
  d.getParameter(0).isRef() and
  d.getParameter(0).getType() instanceof StringType and
  d.getParameter(1).getName() = "condition" and
  d.getParameter(1).isOut() and
  d.getParameter(1).getType() instanceof BoolType and
  d.getParameter(2).hasName("args") and
  d.getParameter(2).isParams() and
  d.getParameter(2).getType().(ArrayType).getElementType() instanceof StringType
select d, d.getAParameter().getType().toString()
