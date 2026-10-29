import csharp

private string hasCompilation(Assembly a) {
  if exists(a.getCompilation()) then result = "has compilation" else result = "no compilation"
}

from Assembly a
select a.getFullName(), hasCompilation(a)
