import java

from Method m
where m.getName() = "memberOnlySeenByKotlin"
select m, m.getDeclaringType().getName()
