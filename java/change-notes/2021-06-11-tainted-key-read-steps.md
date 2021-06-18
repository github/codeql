lgtm,codescanning
* Data flow now propagates taint from tainted Maps to read steps of their keys (e.g. `tainted.keySet()`).
