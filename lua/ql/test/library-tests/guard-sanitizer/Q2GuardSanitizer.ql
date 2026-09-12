import codeql.lua.RulesSanitizerReport

from string capability, string evidence
where
  capability = "guard-sanitizer.classification" and
  sanitizerClassification("input.luac", "root@pc8:r2", "input.luac", "root@pc16:r4", "input.luac",
    "root@pc11", "tonumber", "true", "true", "sanitized") and
  evidence = "root@pc8:r2 -> root@pc16:r4 via root@pc11:tonumber"
  or
  capability = "guard-sanitizer.report" and
  reportClassification("input.luac", "root@pc8:r2", "input.luac", "root@pc16:r4", "sanitized",
    "sanitized path suppressed") and
  evidence = "root@pc8:r2 -> root@pc16:r4 sanitized"
select capability, evidence
