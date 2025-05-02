---
category: minorAnalysis
---
* Changes to the MaD model generation infrastructure:
  * The `csharp/ql/src/utils/modelgenerator/GenerateFlowModel.py` script has
    been removed. The `/misc/scripts/models-as-data/generate_mad.py` script now
    supports being called directly and should be used instead. The script
    requires a `--language` argument but otherwise functions identically.
