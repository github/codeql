import semmle.go.dependencies.SemVer

from DependencySemVer ver, string normVersion
where
  exists(int major, int minor, int patch |
    major = [0 .. 20] and minor = [0 .. 20] and patch = [0 .. 20]
  |
    normVersion = major + "." + minor + "." + patch
  ) and
  ver.is(normVersion)
select ver, normVersion
