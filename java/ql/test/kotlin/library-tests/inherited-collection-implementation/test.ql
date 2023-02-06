import java

from MethodAccess ma
where ma.getEnclosingCallable().fromSource()
select ma
