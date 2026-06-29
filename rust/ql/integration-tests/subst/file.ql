import rust

from File f, string relative
where
  not f.getURL().matches("%/semmle-code/semmle-code/%") and
  if exists(f.getRelativePath()) then relative = "relative" else relative = ""
select f, relative
