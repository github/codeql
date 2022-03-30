lgtm,codescanning
* Query `java/concatenated-sql-query` has been downgraded to medium precision in view of its heuristic nature, which is inherently prone to false positives. This means its alerts will not be visible by default on lgtm.com. Code Scanning will also no longer run the query by default. 
