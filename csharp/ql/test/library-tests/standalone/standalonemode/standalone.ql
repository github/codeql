import csharp

from SourceFile f, int mode
where
  f.extractedStandalone() and
  extractionIsStandalone() and
  file_extraction_mode(f, mode)
select f, mode
