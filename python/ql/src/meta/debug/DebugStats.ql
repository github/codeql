import python

from string msg, int cnt, int sort
where
  sort = 0 and
  msg = "Lines of code in DB" and
  cnt = sum(Module m | | m.getMetrics().getNumberOfLinesOfCode())
  or
  sort = 1 and
  msg = "Lines of code in repo" and
  cnt =
    sum(Module m | exists(m.getFile().getRelativePath()) | m.getMetrics().getNumberOfLinesOfCode())
  or
  sort = 2 and
  msg = "Files" and
  cnt = count(File f)
  or
  sort = 10 and msg = "----------" and cnt = 0
  or
  sort = 11 and
  msg = "Modules" and
  cnt = count(Module m)
  or
  sort = 12 and
  msg = "Classes" and
  cnt = count(Class c)
  or
  sort = 13 and
  msg = "Functions" and
  cnt = count(Function f)
  or
  sort = 14 and
  msg = "async functions" and
  cnt = count(Function f | f.isAsync())
  or
  sort = 15 and
  msg = "*args params" and
  cnt = count(Function f | f.hasVarArg())
  or
  sort = 16 and
  msg = "**kwargs params" and
  cnt = count(Function f | f.hasKwArg())
  or
  sort = 20 and msg = "----------" and cnt = 0
  or
  sort = 21 and
  msg = "call" and
  cnt = count(Call c)
  or
  sort = 22 and
  msg = "for loop" and
  cnt = count(For f)
  or
  sort = 23 and
  msg = "comprehension" and
  cnt = count(Comp c)
  or
  sort = 24 and
  msg = "attribute" and
  cnt = count(Attribute a)
  or
  sort = 25 and
  msg = "assignment" and
  cnt = count(Assign a)
  or
  sort = 26 and
  msg = "await" and
  cnt = count(Await a)
  or
  sort = 27 and
  msg = "yield" and
  cnt = count(Yield y)
  or
  sort = 28 and
  msg = "with" and
  cnt = count(With w)
  or
  sort = 29 and
  msg = "raise" and
  cnt = count(Raise r)
  or
  sort = 30 and
  msg = "return" and
  cnt = count(Return r)
  or
  sort = 31 and
  msg = "match" and
  cnt = count(MatchStmt m)
  or
  sort = 32 and
  msg = "from ... import ..." and
  cnt = count(Import i | i.isFromImport())
  or
  sort = 33 and
  msg = "import ..." and
  cnt = count(Import i | not i.isFromImport())
  or
  sort = 34 and
  msg = "import *" and
  cnt = count(ImportStar i)
select sort, msg, cnt order by sort
