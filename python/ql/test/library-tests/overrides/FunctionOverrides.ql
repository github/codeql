import python

from PythonFunctionValue f, string overriding, string overridden
where
  (if f.isOverridingMethod() then overriding = "overriding" else overriding = "not overriding") and
  (if f.isOverriddenMethod() then overridden = "overridden" else overridden = "not overridden")
select f, overriding, overridden
