---
category: fix
---
* Fixed an issue where taint sources from `window.onmessage` event handlers could lead to server-side
  request forgery alerts. Such alerts are now reported as client-side request forgery instead.
