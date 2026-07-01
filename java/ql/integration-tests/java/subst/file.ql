import java

from File f, string relative
where
  not f.getURL().matches("file:///modules/%") and
  not f.getURL().matches("file:///!unknown-binary-location/kotlin/%") and
  not f.getURL().matches("%/ql/java/kotlin-extractor/%") and
  if exists(f.getRelativePath()) then relative = "relative" else relative = ""
select f, relative
