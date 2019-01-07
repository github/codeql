import csharp

from Version version
where
  version = "1.2.3.4" or
  version = "2.3.24" or
  version = "1.2" or
  version = "xxx" or
  version = "1.x" or
  version = "1" or
  version = "" or
  version = "1234.56"
select version, version.getMajor(), version.getMajorRevision(), version.getMinor(),
  version.getMinorRevision()
