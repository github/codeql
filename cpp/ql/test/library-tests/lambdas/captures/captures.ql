import cpp

from LambdaCapture lc, string mode, int index
where
  exists(LambdaExpression le | le.getCapture(index) = lc) and
  if lc.isImplicit() then mode = "implicit" else mode = "explicit"
select lc, mode, index, concat(lc.getField().toString(), ", "),
  concat(lc.getInitializer().toString(), ", ")
