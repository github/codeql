import csharp

from Version version
where version = ["1.2.3.4", "2.3.24", "1.2", "xxx", "1.x", "1", "", "1234.56"]
select version, version.getMajor(), version.getMajorRevision(), version.getMinor(),
  version.getMinorRevision()
