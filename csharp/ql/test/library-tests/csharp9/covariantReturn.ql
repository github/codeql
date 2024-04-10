import csharp

from Method m, Method overrider
where
  m.getAnOverrider() = overrider and
  m.getFile().getStem() = "CovariantReturn"
select m.getFullyQualifiedNameDebug(), m.getReturnType().toString(),
  overrider.getFullyQualifiedNameDebug(), overrider.getReturnType().toString()
