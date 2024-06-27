import java

from Method m, string kind, Type t
where
  m.fromSource() and
  (
    kind = "param" and t = m.getAParamType()
    or
    kind = "return" and t = m.getReturnType()
  )
// 't.(ParameterizedType).getATypeArgument().(Wildcard).getUpperBound().getType()' is pulling the 'T' out of 'List<? extends T>'
select m, m.getSignature(), kind, t.toString(),
  [t, t.(ParameterizedType).getATypeArgument().(Wildcard).getUpperBound().getType()]
      .(TypeVariable)
      .getGenericCallable()
      .getSignature()
