import rust

from File f, string fromSource, string hasSemantics, string isSkippedByCompilation
where
  exists(f.getRelativePath()) and
  (if f.fromSource() then fromSource = "fromSource: yes" else fromSource = "fromSource: no") and
  (
    if f.(ExtractedFile).hasSemantics()
    then hasSemantics = "hasSemantics: yes"
    else hasSemantics = "hasSemantics: no"
  ) and
  if f.(ExtractedFile).isSkippedByCompilation()
  then isSkippedByCompilation = "isSkippedByCompilation: yes"
  else isSkippedByCompilation = "isSkippedByCompilation: no"
select f, fromSource, hasSemantics, isSkippedByCompilation
