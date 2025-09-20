---
category: majorAnalysis
---
* Previously, data flow used def-use flow and a node's post-update node was either its definition or the node itself. This caused some problems with false positives caused by steps backwards from a node to its definition. Now, data flow has been changed to use-use flow with proper post-update nodes. This should improve accuracy and reduce false positives in the analysis. The main effect on queries is that sanitization works differently - if you sanitize a node then flow will not reach any uses after the sanitized node. Where this is not desired it maybe be necessary to add an additional flow step to propagate the flow forward.
