---
category: fix
---
* Fixed a spurious parse error when `await` is used as a property name inside an `async` function, or `yield` as a property name inside a generator. For example, `await pool.await()` is now extracted correctly.
