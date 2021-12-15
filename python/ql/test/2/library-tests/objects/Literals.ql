/* Test that there are no literals that do not have a corresponding object. */
import python

string repr(Expr e) {
  result = e.(Num).getN() or
  result = e.(Bytes).getS() or
  result = e.(Unicode).getS()
}

from ImmutableLiteral l
where not exists(l.getLiteralObject())
select l.getLocation().getStartLine(), repr(l)
