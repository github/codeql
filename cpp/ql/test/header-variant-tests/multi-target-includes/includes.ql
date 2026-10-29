import cpp

from Include i, string d
where if i instanceof IncludeNext then d = "IncludeNext" else d = "Include"
select i, d, i.getIncludedFile().getAbsolutePath(), count(i.getIncludedFile())
