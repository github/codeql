/*
 * For internal use only.
 *
 * Maps ML-powered queries to their `EndpointType` for clearer labelling while evaluating ML model during training.
 */

import experimental.adaptivethreatmodeling.SqlTaintedATM as SqlTaintedAtm
import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
import experimental.adaptivethreatmodeling.RequestForgeryATM as RequestForgeryAtm
import experimental.adaptivethreatmodeling.AdaptiveThreatModeling

from string queryName, AtmConfig c, EndpointType e
where
  (
    queryName = "SqlTainted" and
    c instanceof SqlTaintedAtm::SqlTaintedAtmConfig
    or
    queryName = "TaintedPath" and
    c instanceof TaintedPathAtm::TaintedPathAtmConfig
    or
    queryName = "RequestForgery" and
    c instanceof RequestForgeryAtm::RequestForgeryAtmConfig
  ) and
  e = c.getASinkEndpointType()
select queryName, e.getEncoding() as label
