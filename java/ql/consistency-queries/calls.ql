import java

from MethodAccess ma
where not exists(ma.getQualifier()) and ma.getFile().isKotlinSourceFile()
select ma
