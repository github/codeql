import javascript
private import semmle.javascript.heuristics.AdditionalSinks

select any(HeuristicSink s | s.getFile().getBaseName() = "sinks.js")
