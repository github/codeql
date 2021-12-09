lgtm,codescanning
* new predicates extend `BufferWrite::getMaxData` and `FormatLiteral::etMaxConvertedLength` (and their `Limited` variants)
  with an estimation reason, that can be `typeBoundsAnalysis()` or `valueFlowAnalysis()`