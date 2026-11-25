import java

from File f, string relative
where
  not f.getURL().startsWith("file:///modules/") and
  not f.getURL().startsWith("file:///!unknown-binary-location/kotlin/") and
  not f.getURL().contains("/ql/java/kotlin-extractor/") and
  if exists(f.getRelativePath()) then relative = "relative" else relative = ""
select f, relative
