/**
 * @name Unpromoted route handler candidate
 * @description If a function that looks like a route handler is not detected as such, this may indicate incomplete library modeling.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id js/unpromoted-route-handler-candidate
 * @tags analysis-quality
 */

import javascript
import CandidateTracking

from HTTP::RouteHandlerCandidate rh
where
  not rh instanceof HTTP::RouteHandler and
  not exists(HTTP::RouteSetupCandidate setup |
    track(rh, DataFlow::TypeTracker::end()).flowsTo(setup.getARouteHandlerArg())
  )
select rh,
  "A `RouteHandlerCandidate` that did not get promoted to `RouteHandler`, and it is not used in a `RouteSetupCandidate`."
