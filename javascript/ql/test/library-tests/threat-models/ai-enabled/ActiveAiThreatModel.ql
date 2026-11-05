private import codeql.threatmodels.ThreatModels

where
  knownThreatModel("ai") and
  currentThreatModel("ai")
select "ai"
