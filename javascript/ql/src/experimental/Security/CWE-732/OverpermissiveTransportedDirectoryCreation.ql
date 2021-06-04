import ModableDirectoryCreation

/**
 * A data flow configuration for directory creation with a mode
 * transported through expressions and variables.
 *
 * For example:
 * ```js
 * function getMode() {
 *   const mode = 0o700
 *   return mode
 * }
 * fs.mkdir('/tmp/dir', getMode())
 * ```
 */
class OverpermissiveTransportedDirectoryCreation extends DataFlow::Configuration {
  OverpermissiveTransportedDirectoryCreation() {
    this = "OverpermissiveTransportedDirectoryCreation"
  }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof LiteralSpecifier and
    specifierOverpermissive(node.asExpr(), getOverpermissiveDirectoryMask())
  }

  override predicate isSink(DataFlow::Node node) {
    exists(ModableDirectoryCreation creation | creation.getSpecifier() = node.asExpr())
  }
}

from
  OverpermissiveTransportedDirectoryCreation transport,
  DataFlow::Node source,
  DataFlow::Node sink
where transport.hasFlow(source, sink)
select sink, "message"
