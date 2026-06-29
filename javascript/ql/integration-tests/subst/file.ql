import javascript

from File f, string relative
where
  not f.getURL().matches("%/target/intree/%") and
  if exists(f.getRelativePath()) then relative = "relative" else relative = ""
select f, relative
