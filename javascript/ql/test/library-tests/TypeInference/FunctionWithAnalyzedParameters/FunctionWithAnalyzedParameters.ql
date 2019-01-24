import javascript

from FunctionWithAnalyzedParameters f, string incompleteness
where if f.isIncomplete(_) then f.isIncomplete(incompleteness) else incompleteness = "complete"
select f, incompleteness
