import java

from LocalVariableDecl v
where not exists(v.getAnAccess()) and exists(v.getFile().getRelativePath())
select v
