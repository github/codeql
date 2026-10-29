import python

from Import imp, Alias al
where
  al = imp.getAName() and
  imp.getLocation().getFile().getShortName() = "test.py"
select imp.getLocation().getStartLine(), imp.toString(), al.toString(), al.getValue().toString(),
  al.getAsname().toString()
