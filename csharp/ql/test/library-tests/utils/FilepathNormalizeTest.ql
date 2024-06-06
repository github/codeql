import codeql.util.FilePath

class FilepathTest extends NormalizableFilepath {
  FilepathTest() {
    this =
      [
        "a/b/c", "a/b/../c", "a/..", "/a/b/../c", "a/b/c/../../../../d/e/../f", "", "/",
        "./a/b/c/../d", "a/b//////c/./d/../e//d//", "/a/b/c/../../d/"
      ]
  }
}

from FilepathTest s
select s, s.getNormalizedPath()
