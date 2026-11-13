---
category: minorAnalysis
---
* The `cs/log-forging` query now uses a conservative, database-wide heuristic to recognize
  supported code-configured Serilog and .NET JSON-only logging setups. This reduces false-positive
  results for standard logging calls when all visible logging configuration in the database is
  safe and understood.