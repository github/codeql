import java

from Method m, TypeVariable param
where
  m.getDeclaringType().getQualifiedName() = "java.util.Map$Entry" and
  param = m.(GenericCallable).getATypeParameter()
select m.toString(), param.toString(), param.getATypeBound().toString()
