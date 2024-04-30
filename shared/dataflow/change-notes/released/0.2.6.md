## 0.2.6

### Major Analysis Improvements

* The data flow library performs heuristic filtering of code paths that have a high degree of control-flow uncertainty for improved performance in cases that are deemed unlikely to yield true positive flow paths. This filtering can be controlled with the `fieldFlowBranchLimit` predicate in configurations. Two bugs have been fixed in relation to this: Some cases of high uncertainty were not being correctly identified. This fix improves performance in certain scenarios. Another group of cases of low uncertainty were also being misidentified, which led to false negatives. Taken together, we generally expect some additional query results with more true positives and fewer false positives.
