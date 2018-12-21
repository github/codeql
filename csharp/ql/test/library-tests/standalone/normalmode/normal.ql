import csharp

from SourceFile f, int mode
where
  not f.extractedStandalone() and
  not extractionIsStandalone() and
  file_extraction_mode(f, mode)
select f, mode
