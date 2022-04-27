/*
 * For internal use only.
 *
 * Maps ML-powered queries to their `EndpointType` for clearer labelling while evaluating ML model during training.
 */

import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string queryName, AtmConfig c, EndpointType e
where
  (
    queryName = "SqlInjection" and
    c instanceof SqlInjectionATM::SqlInjectionAtmConfig
    or
    queryName = "NosqlInjection" and
    c instanceof NosqlInjectionATM::NosqlInjectionAtmConfig
    or
    queryName = "TaintedPathInjection" and
    c instanceof TaintedPathATM::TaintedPathAtmConfig
    or
    queryName = "Xss" and c instanceof XssATM::DomBasedXssAtmConfig
  ) and
  e = c.getASinkEndpointType()
select queryName, e.getEncoding() as label
