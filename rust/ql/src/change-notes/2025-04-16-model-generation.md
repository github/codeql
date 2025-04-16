---
category: minorAnalysis
---
* Changes to the MaD model generation infrastructure: Changed the query `rust/utils/modelgenerator/summary-models` to use the implementation from `rust/utils/modelgenerator/mixed-summary-models`. Removed the now-redundant `rust/utils/modelgenerator/mixed-summary-models` query. Similar replacement was made for `rust/utils/modelgenerator/neutral-models`. That is, if `GenerateFlowModel.py` is provided with `--with-summaries` combined/mixed models are now generated instead of heuristic models (and similar for `--with-neutrals`).