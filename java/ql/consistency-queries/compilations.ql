import java

predicate goodCompilation(Compilation c) {
  forex(int i |
        exists(c.getFileCompiled(i)) |
        exists(c.getFileCompiled(i - 1)) or i = 0) and
  forex(int i |
        exists(c.getArgument(i)) |
        exists(c.getArgument(i - 1)) or i = 0) and
  c.extractionStarted() and
  c.normalTermination()
}

from Compilation c
where c.isKotlin()
  and not goodCompilation(c)
select c
