/**
 * @kind problem
 */

import javascript
import experimental.PoI.PoI::PoI

class Config extends StandardPoIConfigurations::ServerPoIConfiguration {
  Config() { this = "Config" }
}

query predicate problems = alertQuery/6;