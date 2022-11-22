import java

from Method m, Type t
where m.getAParamType() = t and t.toString().matches("%? super ? extends%")
select m, t
