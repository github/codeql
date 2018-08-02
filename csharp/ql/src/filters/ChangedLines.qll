import csharp
import external.ExternalArtifact

pragma[noopt]
predicate changedLine(File f, int line) {
  exists(ExternalMetric metric, Location l |
    exists(string s | s = "changedLines.ql" and metric.getQueryPath() = s) and
    l = metric.getLocation() and
    f = l.getFile() and
    line = l.getStartLine()
  )
}
