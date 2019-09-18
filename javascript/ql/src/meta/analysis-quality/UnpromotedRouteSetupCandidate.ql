/**
 * @name Unpromoted route setup candidate
 * @description If a call that looks like a route setup is not detected as such, this may indicate incomplete library modeling.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id js/unpromoted-route-setup-candidate
 * @tags analysis-quality
 */

import javascript
import CandidateTracking

from HTTP::RouteSetupCandidate setup
where
  not setup.asExpr() instanceof HTTP::RouteSetup and
  exists(HTTP::RouteHandlerCandidate rh |
    track(rh, DataFlow::TypeTracker::end()).flowsTo(setup.getARouteHandlerArg())
  )
select setup,
  "A `RouteSetupCandidate` that did not get promoted to `RouteSetup`, and it is using at least one `RouteHandlerCandidate`."
