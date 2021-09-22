lgtm,codescanning
* Updated _Modification of parameter with default_ (`py/modification-of-default-value`) query to use the new data flow library instead of the old taint tracking library and to remove the use of points-to analysis. You may see differences in the results found by the query, but overall this change should result in a more robust and accurate analysis.
