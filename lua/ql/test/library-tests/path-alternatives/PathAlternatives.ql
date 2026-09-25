import codeql.lua.RulesSanitizerReport

private predicate scenarioModules(string scenario, string sourceModule, string sinkModule) {
  scenario = "active-only" and
  sourceModule = "active_controller.luac" and
  sinkModule = "active_sink.luac"
  or
  scenario = "mixed" and
  sourceModule = "mixed_controller.luac" and
  sinkModule = "mixed_sink.luac"
  or
  scenario = "same-route-mixed" and
  sourceModule = "same_route_controller.luac" and
  sinkModule = "same_route_sink.luac"
  or
  scenario = "sibling-return-active-only" and
  sourceModule = "sibling_return_controller.luac" and
  sinkModule = "sibling_return_sink.luac"
  or
  scenario = "merged" and
  sourceModule = "merged_controller.luac" and
  sinkModule = "merged_sink.luac"
  or
  scenario = "guard-overwritten" and
  sourceModule = "overwrite_controller.luac" and
  sinkModule = "overwrite_sink.luac"
  or
  scenario = "sanitizer-only" and
  sourceModule = "sanitized_controller.luac" and
  sinkModule = "sanitized_sink.luac"
}

from string scenario, string classification
where
  exists(string sourceModule, string sourceRef, string sinkModule, string sinkRef, string reason |
    scenarioModules(scenario, sourceModule, sinkModule) and
    reportClassification(sourceModule, sourceRef, sinkModule, sinkRef, classification, reason)
  )
select scenario, classification
