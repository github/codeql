import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string queryName, ATMConfig c, EndpointType e
where
  (
    queryName = "SqlInjectionATM.ql" and
    c instanceof SqlInjectionATM::SqlInjectionATMConfig
    or
    queryName = "NosqlInjectionATM.ql" and
    c instanceof NosqlInjectionATM::NosqlInjectionATMConfig
    or
    queryName = "TaintedPathInjectionATM.ql" and
    c instanceof TaintedPathATM::TaintedPathATMConfig
    or
    queryName = "XssATM.ql" and c instanceof XssATM::DomBasedXssATMConfig
  ) and
  e = c.getASinkEndpointType()
select queryName, e.getEncoding() as endpointTypeEncoded
