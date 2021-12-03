import cpp

predicate paramsString(Function f, int n, string res) {
  if n = -1
  then res = ""
  else
    exists(string sep |
      (if n = 0 then sep = "" else sep = ", ") and
      exists(string prefixRes |
        paramsString(f, n - 1, prefixRes) and
        res = prefixRes + sep + f.getParameter(n) + "(" + f.getParameter(n).getType() + ")"
      )
    )
}

from BlockExpr e, Function f, string params
where
  f = e.getFunction() and
  paramsString(f, f.getNumberOfParameters() - 1, params)
select e, e.getType() as te, te.explain(), e.getFunction(), f.getType() as tf, tf.explain(), params
