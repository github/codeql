/*
 * For internal use only.
 *
 * Maps ML-powered queries to their `EndpointType` for clearer labelling while evaluating ML model during training.
 */

import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
import experimental.adaptivethreatmodeling.XssATM as XssAtm
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string queryName, AtmConfig c, EndpointType e
where
  (
    queryName = "SqlInjection" and
    c instanceof SqlInjectionAtm::Configuration
    or
    queryName = "NosqlInjection" and
    c instanceof NosqlInjectionAtm::Configuration
    or
    queryName = "TaintedPath" and
    c instanceof TaintedPathAtm::Configuration
    or
    queryName = "Xss" and c instanceof XssAtm::Configuration
  ) and
  e = c.getASinkEndpointType()
select queryName, e.getEncoding() as label
