/*
 * For internal use only.
 *
 * Maps ML-powered queries to their `EndpointType` for clearer labelling while evaluating ML model during training.
 */

import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM
import experimental.adaptivethreatmodeling.StoredXssATM as StoredXssATM
import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomATM
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string queryName, ATMConfig c, int label
where
  (
    queryName = "Unknown" and
    label = 0
    or
    queryName = "NotASink" and
    label = 0
    or
    queryName = "LikelyNotASink" and
    label = 0
    or
    queryName = "XssSink" and
    c instanceof XssATM::DomBasedXssATMConfig and
    label = c.getASinkEndpointType().getEncoding()
    or
    queryName = "StoredXssSink" and
    c instanceof StoredXssATM::StoredXssATMConfig and
    label = c.getASinkEndpointType().getEncoding()
    or
    queryName = "XssThroughDomSink" and
    c instanceof XssThroughDomATM::XssThroughDOMATMConfig and
    label = c.getASinkEndpointType().getEncoding()
    or
    queryName = "SqlInjectionSink" and
    c instanceof SqlInjectionATM::SqlInjectionATMConfig and
    label = c.getASinkEndpointType().getEncoding()
    or
    queryName = "NosqlInjectionSink" and
    c instanceof NosqlInjectionATM::NosqlInjectionATMConfig and
    label = c.getASinkEndpointType().getEncoding()
    or
    queryName = "TaintedPathSink" and
    c instanceof TaintedPathATM::TaintedPathATMConfig and
    label = c.getASinkEndpointType().getEncoding()
  )
select queryName, label order by label
