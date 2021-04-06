lgtm,codescanning
* Updated _Information exposure through an exception_ (`py/stack-trace-exposure`) query to use the new data-flow library and type-tracking approach instead of points-to analysis. You may see differences in the results found by the query, but overall this change should result in a more robust and accurate analysis.
