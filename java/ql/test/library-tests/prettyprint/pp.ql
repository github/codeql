import semmle.code.java.PrettyPrintAst

from ClassOrInterface cori, string s, int line
where pp(cori, s, line) and cori.fromSource()
select cori, line, s order by line
