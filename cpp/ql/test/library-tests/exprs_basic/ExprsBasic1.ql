import cpp

from Function f
select f, count(Literal l | l.getEnclosingFunction() = f),
  count(ArrayToPointerConversion c | c.getEnclosingFunction() = f)
