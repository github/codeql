import python

// looking at `module_export` predicate in DataFlowPrivate, the core of the problem is
// that in alias_problem.py, the direct import of `foo` does not flow to a normal exit of
// the module. Instead there is a second variable foo coming from `from .other import*` that
// goes to the normal exit of the module.
from Module m, EssaVariable v, string useToNormalExit
where
  m = v.getScope().getEnclosingModule() and
  not m.getName() in ["pkg.use", "pkg.foo_def"] and
  v.getName() = "foo" and
  if v.getAUse() = m.getANormalExit()
  then useToNormalExit = "use to normal exit"
  else useToNormalExit = "no use to normal exit"
select m, v, useToNormalExit
