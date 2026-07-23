import semmle.code.cpp.regex.RegexTreeView

from RegExpTerm t, string file, int sl, int sc, int el, int ec
where t.isRootTerm() and t.hasLocationInfo(file, sl, sc, el, ec)
select t, file, sl, sc, el, ec
