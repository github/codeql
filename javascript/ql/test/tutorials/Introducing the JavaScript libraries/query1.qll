import javascript

query predicate test_query1(string res0, int res1) {
  exists(Folder d |
    res0 = d.getRelativePath() and
    res1 = count(File f | f = d.getAFile() and f.getExtension() = "js" | f)
  )
}
