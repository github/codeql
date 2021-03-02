import javascript

predicate remoteFlowSourceSpec(Comment c, string path, int line, string sourceType) {
  c.getLocation().hasLocationInfo(path, line, _, _, _) and
  sourceType = c.getText().regexpCapture("\\s*RemoteFlowSource\\s*:\\s*(.+)", 1)
}

predicate remoteFlowSource(RemoteFlowSource rfs, string path, int line, string sourceType) {
  rfs.hasLocationInfo(path, line, _, _, _) and
  sourceType = rfs.getSourceType()
}

query predicate missing(Comment c, string sourceType) {
  exists(string path, int line |
    remoteFlowSourceSpec(c, path, line, sourceType) and
    not remoteFlowSource(_, path, line, sourceType)
  )
}

query predicate spurious(RemoteFlowSource rfs, string sourceType) {
  exists(string path, int line |
    not remoteFlowSourceSpec(_, path, line, sourceType) and
    remoteFlowSource(rfs, path, line, sourceType)
  )
}
