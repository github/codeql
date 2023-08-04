import cpp

predicate interesting(Element e) {
  e instanceof LambdaCapture or
  e instanceof LambdaExpression or
  e = any(LambdaExpression le).getLambdaFunction() or
  e = any(LambdaExpression le).getInitializer() or
  e instanceof Closure
}

from Element e
where interesting(e.getEnclosingElement*())
select e
