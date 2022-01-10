lgtm,codescanning
* Several security queries have been refactored to make them easier to extend with additional
  sinks and/or taint steps. Sink definitions have generally been moved to importable libraries,
  which can then be extended in `Customizations.qll`.
