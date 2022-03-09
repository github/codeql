import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionATM
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathATM
import experimental.adaptivethreatmodeling.XssATM as XssATM
import experimental.adaptivethreatmodeling.StoredXssATM as StoredXssATM
import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomATM
import experimental.adaptivethreatmodeling.CodeInjectionATM as CodeInjectionATM
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string queryName, ATMConfig c, EndpointType e
where
  (
    queryName = "Unknown" and
    endpointTypeEncoded = 0
    or
    queryName = "NotASink" and
    endpointTypeEncoded = 0
    or
    queryName = "Xss" and
    c instanceof XssATM::DomBasedXssATMConfig and
    endpointTypeEncoded = c.getASinkEndpointType().getEncoding()
    or
    queryName = "StoredXss" and
    c instanceof StoredXssATM::StoredXssATMConfig and
    endpointTypeEncoded = c.getASinkEndpointType().getEncoding()
    or
    queryName = "XssThroughDom" and
    c instanceof XssThroughDomATM::XssThroughDOMATMConfig and
    endpointTypeEncoded = c.getASinkEndpointType().getEncoding()
    or
    queryName = "SqlInjection" and
    c instanceof SqlInjectionATM::SqlInjectionATMConfig and
    endpointTypeEncoded = c.getASinkEndpointType().getEncoding()
    or
    queryName = "NosqlInjection" and
    c instanceof NosqlInjectionATM::NosqlInjectionATMConfig and
    endpointTypeEncoded = c.getASinkEndpointType().getEncoding()
    or
    queryName = "TaintedPath" and
    c instanceof TaintedPathATM::TaintedPathATMConfig and
    endpointTypeEncoded = c.getASinkEndpointType().getEncoding()
    or
    queryName = "CodeInjection" and
    c instanceof CodeInjectionATM::CodeInjectionATMConfig and
    endpointTypeEncoded = c.getASinkEndpointType().getEncoding()
  )
select queryName, endpointTypeEncoded order by encodingTypeEncoded
