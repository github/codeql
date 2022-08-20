import java

string getReferencedCallable(MemberRefExpr e) {
  if exists(e.getReferencedCallable())
  then result = e.getReferencedCallable().getQualifiedName()
  else result = ""
}

from MemberRefExpr e
select e, getReferencedCallable(e), e.getReceiverType()
