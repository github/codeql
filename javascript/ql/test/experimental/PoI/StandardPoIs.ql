/**
 * @kind problem
 */

import javascript
import experimental.PoI.PoI::PoI

class Config extends PoIConfiguration {
  Config() { this = "Config" }

  override predicate enabled(PoI poi) { poi instanceof StandardPoIs::UnpromotedRouteHandlerPoI }
}

query predicate problems = alertQuery/6;