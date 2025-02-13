---
category: fix
---
* Fixed a recently-introduced bug that prevented taint tracking through `URLSearchParams` objects.
  The original behaviour has been restored and taint should once again be tracked through such objects.
