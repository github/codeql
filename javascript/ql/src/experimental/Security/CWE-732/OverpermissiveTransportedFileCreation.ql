import ModableFileCreation

class OverpermissiveTransportedFileCreation extends DataFlow::Configuration {
  OverpermissiveTransportedFileCreation() { this = "OverpermissiveTransportedFileCreation" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof LiteralSpecifier and
    specifierOverpermissive(node.asExpr(), getOverpermissiveFileMask())
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableFileCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  OverpermissiveTransportedFileCreation transport,
  DataFlow::Node source,
  DataFlow::Node sink
where transport.hasFlow(source, sink)
select sink, "message"
