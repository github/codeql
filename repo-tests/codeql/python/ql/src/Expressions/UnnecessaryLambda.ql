/**
 * @name Unnecessary lambda
 * @description A lambda is used that calls through to a function without modifying any parameters
 * @kind problem
 * @tags maintainability
 *       useless-code
 * @problem.severity recommendation
 * @sub-severity high
 * @precision high
 * @id py/unnecessary-lambda
 */

import python

/* f consists of a single return statement, whose value is a call. The arguments of the call are exactly the parameters of f */
predicate simple_wrapper(Lambda l, Expr wrapped) {
  exists(Function f, Call c | f = l.getInnerScope() and c = l.getExpression() |
    wrapped = c.getFunc() and
    count(f.getAnArg()) = count(c.getAnArg()) and
    forall(int arg | exists(f.getArg(arg)) | f.getArgName(arg) = c.getArg(arg).(Name).getId()) and
    /* Either no **kwargs or they must match */
    (
      not exists(f.getKwarg()) and not exists(c.getKwargs())
      or
      f.getKwarg().(Name).getId() = c.getKwargs().(Name).getId()
    ) and
    /* Either no *args or they must match */
    (
      not exists(f.getVararg()) and not exists(c.getStarargs())
      or
      f.getVararg().(Name).getId() = c.getStarargs().(Name).getId()
    ) and
    /* No named parameters in call */
    not exists(c.getAKeyword())
  ) and
  // f is not necessarily a drop-in replacement for the lambda if there are default argument values
  not exists(l.getArgs().getADefault())
}

/* The expression called will refer to the same object if evaluated when the lambda is created or when the lambda is executed. */
predicate unnecessary_lambda(Lambda l, Expr e) {
  simple_wrapper(l, e) and
  (
    /* plain class */
    exists(ClassValue c | e.pointsTo(c))
    or
    /* plain function */
    exists(FunctionValue f | e.pointsTo(f))
    or
    /* bound-method of enclosing instance */
    exists(ClassValue cls, Attribute a | cls.getScope() = l.getScope().getScope() and a = e |
      a.getObject().(Name).getId() = "self" and
      cls.hasAttribute(a.getName())
    )
  )
}

from Lambda l, Expr e
where unnecessary_lambda(l, e)
select l,
  "This 'lambda' is just a simple wrapper around a callable object. Use that object directly."
