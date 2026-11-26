import csharp

from File f, string relative
where
  not f.getURL().startsWith("file://C:/Program Files/") and
  if exists(f.getRelativePath()) then relative = "relative" else relative = ""
select f, relative
