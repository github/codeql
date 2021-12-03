lgtm,codescanning
* An equality comparison with a constant value now sanitizes the other value. This was already the case in XSS queries, but it now applies in all queries involving tainted data flow. This should lead to fewer false positive results.
