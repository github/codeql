import python

from Fstring str, int n, Expr e
where
  e = str.getValue(n) and
  not exists(FormattedValue v | v.getFormatSpec() = str)
select str.getLocation().getStartLine(), str.toString(), n, e.toString()
