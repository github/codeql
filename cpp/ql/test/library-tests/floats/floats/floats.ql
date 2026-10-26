import cpp

string displayExpr(Expr e) {
  if e instanceof UnaryMinusExpr
  then result = "-" + displayExpr(e.(UnaryMinusExpr).getOperand())
  else result = e.toString()
}

string displayPortableExpr(Expr e) {
  exists(string displayed | displayed = displayExpr(e) |
    if displayed.length() < 5
    then result = displayed
    else
      // If the calculated value is long, then it's probably got
      // lots of precision, and the least significant digits may
      // vary depending on the machine. So just show the original
      // source value, as well as an indication that that's what
      // we're doing.
      result = "src: " + e.getValueText()
  )
}

from Variable v
select v, displayPortableExpr(v.getInitializer().getExpr())
