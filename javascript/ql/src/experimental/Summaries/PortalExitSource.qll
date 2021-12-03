import javascript
import semmle.javascript.dataflow.Portals

/**
 * A remote exit node of a portal, viewed as an additional source node for any flow
 * configuration currently in scope.
 */
class PortalExitSource extends DataFlow::AdditionalSource {
  Portal p;

  PortalExitSource() { this = p.getAnExitNode(true) }

  override predicate isSourceFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) { any() }

  /** Gets the portal of which this is an exit node. */
  Portal getPortal() { result = p }
}
