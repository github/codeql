---
category: minorAnalysis
---
* Added support for Angular's `@HostListener('window:message', ...)` and `@HostListener('document:message', ...)` decorators as `postMessage` event handlers. The decorated method's event parameter is now recognized as a client-side remote flow source, and is considered by the `js/missing-origin-check` query.
