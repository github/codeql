lgtm,codescanning
* The query "Bad redirect check" (`go/bad-redirect-check`) now requires that the checked variable is actually used in a redirect as opposed to relying on a name-based heuristic. This eliminates some false positive results, and adds more true positive results.
