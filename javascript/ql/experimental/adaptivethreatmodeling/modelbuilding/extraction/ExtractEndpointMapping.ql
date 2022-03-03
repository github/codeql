import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string query, ATMConfig c, EndpointType e
where
  (
    query = "SqlInjectionATM.ql" and
    c instanceof SqlInjectionATM::SqlInjectionATMConfig
    or
    query = "NosqlInjectionATM.ql" and
    c instanceof NosqlInjectionATM::NosqlInjectionATMConfig
    or
    query = "TaintedPathInjectionATM.ql" and
    c instanceof TaintedPathATM::TaintedPathATMConfig
    or
    query = "XssATM.ql" and c instanceof XssATM::DomBasedXssATMConfig
  ) and
  e = c.getASinkEndpointType()
select query, e.toString() as name, e.getEncoding() as encoding
