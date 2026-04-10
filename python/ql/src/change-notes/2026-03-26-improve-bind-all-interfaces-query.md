---
category: minorAnalysis
---

- The `py/bind-socket-all-network-interfaces` query now uses the global data-flow library, leading to better precision and more results. Also, wrappers of `socket.socket` in the `eventlet` and `gevent` libraries are now also recognized as socket binding operations.
