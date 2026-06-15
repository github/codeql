import java

from Parameter p
where p.getCallable().fromSource()
select p, p.getType().toString(), p.getType().(ParameterizedType).getATypeArgument().toString()
