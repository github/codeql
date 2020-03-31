import javascript
import semmle.javascript.dataflow.Portals

/**
 * An escaping entry node of a portal, viewed as an additional sink node for any flow
 * configuration currently in scope.
 */
class PortalEntrySink extends DataFlow::AdditionalSink {
  Portal p;

  PortalEntrySink() { this = p.getAnEntryNode(true) }

  override predicate isSinkFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) { any() }

  /** Gets the portal of which this is an entry node. */
  Portal getPortal() { result = p }
}
