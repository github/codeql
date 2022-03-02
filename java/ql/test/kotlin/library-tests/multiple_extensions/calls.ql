import java

from MethodAccess ma, Expr qualifier, Argument arg
where ma.getQualifier() = qualifier and
      ma.getAnArgument() = arg
select ma, qualifier, arg
