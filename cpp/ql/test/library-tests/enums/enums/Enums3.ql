import cpp

from Enum e, boolean isScoped
where if e instanceof ScopedEnum then isScoped = true else isScoped = false
select e, isScoped

