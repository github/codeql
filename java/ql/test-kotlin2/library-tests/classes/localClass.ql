import java

from LocalTypeDeclStmt s
where not s.getLocalType() instanceof AnonymousClass
select s, s.getLocalType(), s.getEnclosingCallable(), s.getLocalType().getEnclosingType()
