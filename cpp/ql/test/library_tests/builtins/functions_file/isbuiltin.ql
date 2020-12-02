import cpp

from Function f, boolean isBuiltin
where if f instanceof BuiltInFunction then isBuiltin = true else isBuiltin = false
select f, isBuiltin, f.getNumberOfParameters(), f.getType()
