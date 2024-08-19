private import codeql.threatmodels.ThreatModels

from string kind
where
  knownThreatModel(kind) and
  currentThreatModel(kind)
select kind
