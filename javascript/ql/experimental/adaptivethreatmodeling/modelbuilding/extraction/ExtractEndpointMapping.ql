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
    queryName = "SqlInjectionATM.ql" and
    c instanceof SqlInjectionAtm::SqlInjectionAtmConfig
    or
    queryName = "NosqlInjectionATM.ql" and
    c instanceof NosqlInjectionAtm::NosqlInjectionAtmConfig
    or
    queryName = "TaintedPathInjectionATM.ql" and
    c instanceof TaintedPathAtm::TaintedPathAtmConfig
    or
    queryName = "XssATM.ql" and c instanceof XssAtm::DomBasedXssAtmConfig
  ) and
  e = c.getASinkEndpointType()
select queryName, e.getEncoding() as endpointTypeEncoded
