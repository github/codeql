---
category: deprecated
---
* The three queries `java/insufficient-key-size`, `java/server-side-template-injection`, and `java/android/implicit-pendingintents` had accidentally general extension points allowing arbitrary string-based flow state. This has been fixed and the old extension points have been deprecated where possible, and otherwise updated.
