---
category: minorAnalysis
---
* The .NET standard libraries APIs for accessing command line arguments and environment variables have been modeled using the `commandargs` and `environment` threat models.
* The `cs/assembly-path-injection` query has been modified so that it's sources rely on `ThreatModelFlowSource`. In order to restore results from command line arguments, you should enable the `commandargs` threat model.
