lgtm,codescanning
* A new `cpp/very-likely-overruning-write` query has been added for C/C++, which reports results formerly flagged by `cpp/overruning-write` where a non-trivial range analysis shows a higher likelyhood of an actual problem. As a consequence, the new query is tagged with high precision.
