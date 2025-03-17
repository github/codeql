---
category: fix
---
* Fixed a recently-introduced bug that caused `js/server-side-unvalidated-url-redirection` to ignore
  valid hostname checks and report spurious alerts after such a check. The original behaviour has been restored.
