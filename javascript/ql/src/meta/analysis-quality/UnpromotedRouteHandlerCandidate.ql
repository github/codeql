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

from Http::RouteHandlerCandidate rh
where
  not rh instanceof Http::RouteHandler and
  not exists(Http::RouteSetupCandidate setup |
    track(rh, DataFlow::TypeTracker::end()).flowsTo(setup.getARouteHandlerArg())
  )
select rh,
  "A `RouteHandlerCandidate` that did not get promoted to `RouteHandler`, and it is not used in a `RouteSetupCandidate`."
