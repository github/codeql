/* Test that there are no literals that do not have a corresponding object. */
import python
private import LegacyPointsTo

string repr(Expr e) {
  result = e.(Num).getN() or
  result = e.(Bytes).getS() or
  result = e.(Unicode).getS()
}

from ImmutableLiteral l
where not exists(getLiteralObject(l))
select l.getLocation().getStartLine(), repr(l)
