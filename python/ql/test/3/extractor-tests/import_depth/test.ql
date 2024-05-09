import python

from ModuleObject m
/* Exclude the builtins module as it has a different name under 2 and 3. */
where not m = theBuiltinModuleObject()
select m.toString()
