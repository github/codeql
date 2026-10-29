import cpp

string paramsString(Function f) {
  result =
    concat(int i |
      exists(f.getParameter(i))
    |
      f.getParameter(i) + "(" + f.getParameter(i).getType() + ")", ", " order by i
    )
}

from BlockExpr e, Function f, string params
where
  f = e.getFunction() and
  params = paramsString(f)
select e, e.getType() as te, te.explain(), e.getFunction(), f.getType() as tf, tf.explain(), params
