/*
 * For internal use only.
 *
 * Maps ML-powered queries to their `EndpointType` for clearer labelling while evaluating ML model during training.
 */

import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
import experimental.adaptivethreatmodeling.XssATM as XssAtm
import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomAtm
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string queryName, AtmConfig c, EndpointType e
where
  (
    queryName = "SqlInjection" and
    c instanceof SqlInjectionAtm::SqlInjectionAtmConfig
    or
    queryName = "NosqlInjection" and
    c instanceof NosqlInjectionAtm::NosqlInjectionAtmConfig
    or
    queryName = "TaintedPath" and
    c instanceof TaintedPathAtm::TaintedPathAtmConfig
    or
    queryName = "Xss" and c instanceof XssAtm::DomBasedXssAtmConfig
    or
    queryName = "XssThroughDom" and c instanceof XssThroughDomAtm::XssThroughDomAtmConfig
  ) and
  e = c.getASinkEndpointType()
select queryName, e.getEncoding() as label
