import csharp

from Method m, Method overrider
where
  m.getAnOverrider() = overrider and
  m.getFile().getStem() = "CovariantReturn"
select m.getQualifiedName(), m.getReturnType().toString(), overrider.getQualifiedName(),
  overrider.getReturnType().toString()
