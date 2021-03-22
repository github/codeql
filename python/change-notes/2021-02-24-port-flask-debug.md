lgtm,codescanning
* Updated _Flask app is run in debug mode_ (`py/flask-debug`) query to use the new type-tracking approach instead of points-to analysis. You may see differences in the results found by the query, but overall this change should result in a more robust and accurate analysis.
