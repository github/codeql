import ruby

from File f, string relative
where if exists(f.getRelativePath()) then relative = "relative" else relative = ""
select f, relative
