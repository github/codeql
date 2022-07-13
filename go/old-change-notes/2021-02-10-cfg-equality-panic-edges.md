lgtm,codescanning
* Improved the Go control-flow graph to exclude more edges representing panics due to comparisons when the types of the compared values indicate a panic is impossible (for example, comparing integers cannot panic). This may reduce false-positives or false-negatives for any query for which control-flow is relevant.
