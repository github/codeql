import cpp

class CustomTestOptions extends Options {
  override predicate okToIgnoreReturnValue(FunctionCall fc) {
    Options.super.okToIgnoreReturnValue(fc) or
    fc.getTarget().getName() = "myIgnoreReturnValue"
  }
}

from Options opts, Element e, string why
where
  opts.overrideReturnsNull(e) and
  why = "overrideReturnsNull"
  or
  opts.returnsNull(e) and
  why = "returnsNull"
  or
  opts.exits(e) and
  why = "exits"
  or
  opts.exprExits(e) and
  why = "exprExits"
  or
  opts.alwaysCheckReturnValue(e) and
  why = "alwaysCheckReturnValue"
  or
  opts.okToIgnoreReturnValue(e) and
  why = "okToIgnoreReturnValue"
select e, why
