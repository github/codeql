import cpp

string getValueCategoryString(Expr expr) {
  if expr.isLValueCategory()
  then result = "lval"
  else
    if expr.isXValueCategory()
    then result = "xval"
    else
      if expr.hasLValueToRValueConversion()
      then result = "prval(load)"
      else result = "prval"
}

from Cast cast
select cast, cast.getSemanticConversionString(), getValueCategoryString(cast),
  cast.getType().toString(), cast.getExpr().getType().toString()
