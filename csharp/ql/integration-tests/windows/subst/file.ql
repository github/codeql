import csharp

from File f, string relative
where
  not f.getURL().matches("file://C:/Program Files/%") and
  if exists(f.getRelativePath()) then relative = "relative" else relative = ""
select f, relative
