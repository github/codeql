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
    queryName = "SqlInjectionATM.ql" and
    c instanceof SqlInjectionATM::SqlInjectionAtmConfig
    or
    queryName = "NosqlInjectionATM.ql" and
    c instanceof NosqlInjectionATM::NosqlInjectionAtmConfig
    or
    queryName = "TaintedPathInjectionATM.ql" and
    c instanceof TaintedPathATM::TaintedPathAtmConfig
    or
    queryName = "XssATM.ql" and c instanceof XssATM::DomBasedXssAtmConfig
  ) and
  e = c.getASinkEndpointType()
select queryName, e.getEncoding() as endpointTypeEncoded
